import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:go_linguage/features/dialog/presentation/bloc/dialog_bloc.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class DialogPage extends StatefulWidget {
  final int conversationId;

  const DialogPage({super.key, required this.conversationId});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  bool _isRecording = false;
  bool _isExpanded = false;
  double _dragStartY = 0;
  int currentStep = 0;
  List<DialogListResopnseModel> dialogModelList = [];
  List<Widget> chatSent = [];
  String answerOptionSelected = "";
  ScrollController scrollController = ScrollController();
  final _audioRecorder = AudioRecorder();
  String? _recordedFilePath;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Show bottom sheet after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DialogBloc>()
          .add(ViewData(conversationId: widget.conversationId));
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Thêm hàm scrollToBottom để cuộn xuống dưới cùng
  void scrollToBottom() {
    // Chờ 100ms để đảm bảo UI đã được cập nhật
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> showNextBotMessage() async {
    if (currentStep >= dialogModelList.length) return;
    if (dialogModelList[currentStep].isChangeSpeaker) {
      setState(() {
        chatSent.add(_buildMessage(
          englishText: dialogModelList[currentStep].systemEnglishText!,
          vietnameseText: dialogModelList[currentStep].systemVietnameseText!,
          isSpeaker: !dialogModelList[currentStep].isChangeSpeaker,
          audioUrl: dialogModelList[currentStep].systemAudioUrl!,
        ));
        _playMessageAudio(dialogModelList[currentStep].systemAudioUrl!).then(
          (value) {
            showNextBotMessage();
          },
        );
        currentStep++;
      });

      // Cuộn xuống dưới cùng sau khi thêm tin nhắn
      scrollToBottom();
    } else {
      if (!dialogModelList[currentStep].isChangeSpeaker) {
        // Không lưu widget trong list nữa, chỉ lưu data
        setState(() {});
      }
    }
  }

  Future<void> showNextUserMessage(
      String englishText, String vietnameseText, String audioUrl) async {
    if (currentStep < dialogModelList.length &&
        !dialogModelList[currentStep].isChangeSpeaker) {
      setState(() {
        chatSent.add(_buildMessage(
          englishText: englishText,
          vietnameseText: vietnameseText,
          isSpeaker: true,
          audioUrl: audioUrl,
        ));

        currentStep++;
      });

      // Cuộn xuống dưới cùng sau khi thêm tin nhắn
      scrollToBottom();

      await _playMessageAudio(audioUrl);
      showNextBotMessage();
    }
  }

  // Play message audio and wait for completion
  Future<void> _playMessageAudio(String audioUrl) async {
    // Create a player instance
    final AudioPlayer player = AudioPlayer();
    final completer = Completer<void>();

    try {
      // Get cached file
      final audioFile = await AudioCacheManager().getAudioFile(audioUrl);

      // Set up player completion listener
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          // Chờ thêm 500ms sau khi audio phát xong
          Future.delayed(const Duration(milliseconds: 500), () {
            player.dispose();
            if (!completer.isCompleted) {
              completer.complete();
            }
          });
        }
      });

      // Handle errors
      player.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace st) {
        if (!completer.isCompleted) {
          completer.complete(); // Complete anyway to not block the UI
        }
      });

      // Play the audio
      await player.setFilePath(audioFile.path);
      await player.play();

      // Return a future that completes when the audio completes
      return completer.future;
    } catch (e) {
      print('Error playing message audio: $e');
      player.dispose();
      if (!completer.isCompleted) {
        completer.complete(); // Complete anyway to continue the flow
      }
    }
  }

  // Bắt đầu ghi âm
  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/dialog_recording.m4a';

      // Cấu hình và bắt đầu ghi âm với AAC (định dạng phổ biến và được hỗ trợ tốt trên Android)
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // AAC LC là mặc định trên Android
          bitRate: 128000, // Bitrate tiêu chuẩn cho voice
          sampleRate: 44100, // Sample rate tiêu chuẩn
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _recordedFilePath = filePath;
      });
    } catch (e) {
      print('Lỗi bắt đầu ghi âm: $e');
    }
  }

  // Dừng ghi âm
  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      // Kiểm tra file âm thanh
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          _recordedFilePath = path;
          final ogaPath = await convertToOga(path);
          print("OGA path: $ogaPath");

          if (ogaPath == null) {
            _showNoAudioDetectedDialog();
            return;
          }

          if (mounted) {
            context.read<DialogBloc>().add(SendToServer(
                ogaPath, dialogModelList[currentStep].id.toString()));
          }
        } else {
          _showNoAudioDetectedDialog();
        }
      } else {
        _showNoAudioDetectedDialog();
      }
    } catch (e) {
      print('Lỗi dừng ghi âm: $e');
      _showNoAudioDetectedDialog();
    }
  }

  Future<String?> convertToOga(String inputPath) async {
    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String ogaPath = '${directory.path}/dialog_recording.ogg';

      // Kiểm tra và xóa file cũ nếu tồn tại
      final File ogaFile = File(ogaPath);
      if (await ogaFile.exists()) {
        await ogaFile.delete();
        print("Đã xóa file OGG cũ: $ogaPath");
      }

      print("Converting to OGA: $ogaPath");

      // Sử dụng FFmpeg để chuyển đổi từ PCM sang OGA (Opus)
      final session = await FFmpegKit.execute(
          '-y -i $inputPath -c:a opus -b:a 128k -strict -2 $ogaPath');

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        print("Conversion successful");
        return ogaPath;
      } else {
        final logs = await session.getLogs();
        for (var l in logs) {
          print("FFmpeg conversion failed: ${l.getMessage()}");
        }
        return null;
      }
    } catch (e) {
      print("Error in conversion: $e");
      return null;
    }
  }

  // Hiển thị thông báo không nghe thấy người dùng nói
  void _showNoAudioDetectedDialog() {
    setState(() {
      _isProcessing = false;
      _isRecording = false;
    });
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColor.critical,
              ),
              const SizedBox(height: 16),
              Text(
                "Chúng tôi không nghe thấy bạn nói gì",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Hãy đảm bảo rằng microphone của bạn đang hoạt động và thử lại.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DialogBloc, DialogState>(
      listener: (context, state) {
        if (state is LoadedData) {
          final dialogModel = state.dialogModel;
          dialogModelList = dialogModel;
          showNextBotMessage();
        }
        if (state is CheckPronounState) {
          print("CheckPronounState: ${state.message}");
          String? rs = state.message;
          if (rs == null) {
            _showNoAudioDetectedDialog();
          } else {
            bool finded = false;
            dialogModelList[currentStep].options!.forEach((element) {
              if (element.englishText == rs) {
                setState(() {
                  _isProcessing = false;
                  _isRecording = false;
                });
                answerOptionSelected = element.englishText;
                showNextUserMessage(element.englishText, element.vietnameseText,
                    element.audioUrl);
                finded = true;
              }
            });
            if (!finded) {
              _showNoAudioDetectedDialog();
            }
          }
        }
      },
      builder: (context, state) {
        if (state is LoadingData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is LoadedData || state is CheckPronounState) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  // Chat messages
                  Positioned(
                    top: 0,
                    child: Opacity(
                      opacity: _isExpanded ? 0.1 : 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CustomBackButton(icon: Icons.close)
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: PercentageProgressBar(
                                percentage:
                                    currentStep / dialogModelList.length,
                                height: 10,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildTitle(),
                            Expanded(
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width: MediaQuery.of(context).size.width,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          top: 20),
                                      child: Column(
                                        spacing: 10,
                                        children: [
                                          ...chatSent,
                                        ],
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Animated bottom sheet
                  if (currentStep < dialogModelList.length)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: MediaQuery.of(context).size.height * 0.1,
                      child: GestureDetector(
                        onVerticalDragStart: (details) {
                          _dragStartY = details.globalPosition.dy;
                        },
                        onVerticalDragUpdate: (details) {
                          if (details.globalPosition.dy < _dragStartY - 50 &&
                              !_isExpanded) {
                            setState(() => _isExpanded = true);
                          } else if (details.globalPosition.dy >
                                  _dragStartY + 50 &&
                              _isExpanded) {
                            setState(() => _isExpanded = false);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isExpanded
                              ? MediaQuery.of(context).size.height * 0.7
                              : MediaQuery.of(context).size.height * 0.25,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 251, 251, 251),
                            border: Border(
                              top: BorderSide(
                                color: AppColor.line,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Drag handle
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Chọn câu trả lời của bạn",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  "Nhấn để chọn hoặc ghi âm giọng nói của bạn.",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    if (currentStep < dialogModelList.length &&
                                        !dialogModelList[currentStep]
                                            .isChangeSpeaker &&
                                        dialogModelList[currentStep].options !=
                                            null)
                                      ...dialogModelList[currentStep]
                                          .options!
                                          .map((option) => _buildAnswerOption(
                                                option.englishText,
                                                option.vietnameseText,
                                                option.audioUrl,
                                              ))
                                          .toList(),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ), // Fixed bottom buttons
                  if (currentStep < dialogModelList.length)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 251, 251),
                          border: Border(
                            top: BorderSide(
                              color: AppColor.line,
                              width: 1,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_isRecording) {
                                        _stopRecording();
                                      } else {
                                        _startRecording();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isRecording
                                        ? AppColor.critical
                                        : AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isProcessing
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.grey[700],
                                          ),
                                        )
                                      : Icon(
                                          _isRecording
                                              ? Icons.stop
                                              : Icons.mic_none_outlined,
                                          color: _isRecording
                                              ? Colors.white
                                              : Colors.grey[700],
                                          size: 28,
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Nếu đã chọn câu trả lời có sẵn
                                    if (answerOptionSelected.isNotEmpty) {
                                      String eng = "";
                                      String vi = "";
                                      String aurl = "";
                                      dialogModelList[currentStep]
                                          .options!
                                          .forEach((e) {
                                        if (e.englishText ==
                                            answerOptionSelected) {
                                          eng = e.englishText!;
                                          vi = e.vietnameseText!;
                                          aurl = e.audioUrl!;
                                        }
                                      });
                                      setState(() {
                                        _isExpanded = false;
                                      });
                                      showNextUserMessage(eng, vi, aurl);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary500,
                                    foregroundColor: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    'Gửi',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (currentStep >= dialogModelList.length)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 251, 251),
                          border: Border(
                            top: BorderSide(
                              color: AppColor.line,
                              width: 1,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.pushReplacement(AppRoutePath.submit,
                                        extra: SubmitRequestModel(
                                            xpPoints: 0,
                                            goPoints: 200,
                                            type: SubmitType.dialog,
                                            id: widget.conversationId));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary500,
                                    foregroundColor: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    'Hoàn thành',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ));
        } else {
          return Center(child: Text(state.props[0].toString()));
        }
      },
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Lời chào hỏi',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String englishText,
    required String vietnameseText,
    required bool isSpeaker,
    String? audioUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSpeaker ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSpeaker) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.bolt_sharp),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSpeaker ? AppColor.primary500 : Colors.blue[50],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isSpeaker ? 16 : 4),
                    bottomRight: Radius.circular(isSpeaker ? 4 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        Text(
                          englishText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSpeaker ? Colors.white : Colors.black,
                          ),
                        ),
                        if (audioUrl != null) ...[
                          const SizedBox(height: 8),
                          CacheAudioPlayer(
                            url: audioUrl,
                            child: Icon(
                              Icons.volume_up,
                              size: 20,
                              color:
                                  isSpeaker ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vietnameseText,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSpeaker ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSpeaker) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerOption(
      String englishText, String vietnameseText, String audioUrl) {
    return GestureDetector(
        onTap: () {
          setState(() {
            answerOptionSelected = englishText;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(
              color: answerOptionSelected == englishText
                  ? AppColor.primary500
                  : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              englishText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              vietnameseText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CacheAudioPlayer(
                  url: audioUrl,
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    //isSelected ? "Chính thức" : "Giọng đực",
                    "Nam",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
