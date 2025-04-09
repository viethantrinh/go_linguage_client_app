import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:go_linguage/features/lesson/presentation/pages/learn_lesson.dart';
import 'package:go_linguage/features/lesson/presentation/widgets/learn_app_bar.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// To parse this JSON data, do
//
//     final assessmentModel = assessmentModelFromJson(jsonString);

import 'dart:convert';

AssessmentModel assessmentModelFromJson(String str) =>
    AssessmentModel.fromJson(json.decode(str));

class AssessmentModel {
  double score;
  String transcribedText;
  String referenceText;
  List<String> feedback;
  Map<String, dynamic> wordScores;

  AssessmentModel({
    required this.score,
    required this.transcribedText,
    required this.referenceText,
    required this.feedback,
    required this.wordScores,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) =>
      AssessmentModel(
        score: json["score"]?.toDouble(),
        transcribedText: json["transcribedText"],
        referenceText: json["referenceText"],
        feedback: List<String>.from(json["feedback"].map((x) => x)),
        wordScores: json["wordScores"],
      );
}

class PronounAssessmentScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final int lessonId;
  // Tham số callback để báo hoàn thành

  const PronounAssessmentScreen({
    super.key,
    required this.exercises,
    required this.lessonId,
  });

  @override
  State<PronounAssessmentScreen> createState() =>
      _PronounAssessmentScreenState();
}

class _PronounAssessmentScreenState extends State<PronounAssessmentScreen> {
  int totalScore = 0;
  final _audioPlayer = AudioPlayer();
  final _audioRecorder = AudioRecorder();
  String? _recordedFilePath;
  bool _isRecording = false;
  bool _isProcessing = false;
  late PageController _pageController;
  int _currentPage = 0;
  List<bool> scores = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    scores = List.filled(widget.exercises.length, false);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  // Bắt đầu ghi âm
  Future<void> _startRecording() async {
    if (_isRecording) return;

    // Kiểm tra và yêu cầu quyền ghi âm
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      // Hiển thị dialog thông báo nếu quyền bị từ chối
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần cấp quyền ghi âm để sử dụng tính năng này'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/pronunciation_assessment.m4a';

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
      await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      final ogaPath = await convertToOga(_recordedFilePath!);
      print("OGA path: $ogaPath");

      if (mounted) {
        context.read<LessonBloc>().add(CheckPronounEvent(ogaPath!,
            widget.exercises[_pageController.page!.toInt()].englishText!));
      }

      // await sendToServer(ogaPath!,
      //     widget.exercises[_pageController.page!.toInt()].englishText!);
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      print('Lỗi dừng ghi âm: $e');
    }
  }

  int getTotalScore() {
    return scores.where((score) => score).length;
  }

  Future<String?> convertToOga(String inputPath) async {
    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String ogaPath = '${directory.path}/recorder.ogg';

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

  // Hiển thị kết quả đánh giá trong bottom sheet
  void _showAssessmentResult(AssessmentModel result) {
    final bool isCorrect = result.score >= 80;
    if (isCorrect) {
      setState(() {
        scores[_currentPage] = true;
      });
    }
    final int score = result.score.toInt();
    final String transcription = result.referenceText;
    List<String> words = result.referenceText.split(' ');

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: false,
      enableDrag: false,
      backgroundColor:
          isCorrect ? const Color(0xFFEAF7F0) : const Color(0xFFFDEDED),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề và icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            isCorrect
                                ? 'Tuyệt vời! Bạn phát âm như người bản địa!'
                                : 'Ồ! Hãy thử lại, bạn có thể làm được!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isCorrect
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCorrect ? Icons.check : Icons.close,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Kết quả đánh giá
                    Text(
                      'Kết quả đánh giá:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Phần trăm và từ
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$score%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                  children:
                                      List.generate(words.length, (index) {
                                return TextSpan(
                                  text: "${words[index]} ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: result.wordScores[words[index]] > 0.8
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              })),
                            ),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Nút thử lại
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              isCorrect ? Colors.green : Colors.red,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Thử lại',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nút tiếp tục
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isCorrect ? Colors.green : Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Tiếp tục',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonBloc, LessonState>(listener: (context, state) {
      if (state is CheckPronounState) {
        final result = state.result;
        final status = state.status;
        if (status == 1) {
          scores[_currentPage] = result!.score >= 80;
          _showAssessmentResult(result);
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: learnAppBar(
            context, getTotalScore(), _currentPage, widget.exercises.length),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Hãy thử phát âm từ này.',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.exercises.length,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sentence to translate
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                spacing: 20,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.exercises[index].englishText!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontSize: 23,
                                        ),
                                  ),
                                  Text(
                                    widget.exercises[index].vietnameseText!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 18,
                                        ),
                                  ),
                                ],
                              )),
                              Column(
                                children: [
                                  CacheAudioPlayer(
                                      url: widget.exercises[index].audioUrl!,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1),
                                        ),
                                        child: const Icon(Icons.volume_up,
                                            color: Colors.black54),
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.sync,
                                          color: Colors.black54),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap:
                                _isRecording ? _stopRecording : _startRecording,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? AppColor.critical
                                    : AppColor.primary500,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: (state is CheckPronounState &&
                                      state.status == 0)
                                  ? Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      _isRecording ? Icons.stop : Icons.mic,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                            ),
                          ),
                        ),

                        // Khu vực nút ghi âm

                        // Nhãn dưới nút ghi âm
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 40),
                            child: Text(
                              _isRecording
                                  ? 'Nhấn để dừng ghi âm.'
                                  : 'Nhấn nút để ghi lại.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _currentPage == widget.exercises.length - 1
                        ? AppColor.primary500
                        : AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (_currentPage == widget.exercises.length - 1) {
                        context.pushReplacement(AppRoutePath.submit,
                            extra: SubmitRequestModel(
                                xpPoints: getTotalStar(
                                    getTotalScore(), widget.exercises.length),
                                goPoints: 200,
                                type: SubmitType.lesson,
                                id: widget.lessonId));
                      } else {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: Center(
                      child: Text(
                        _currentPage == widget.exercises.length - 1
                            ? 'Hoàn thành'
                            : 'Bỏ qua',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _currentPage == widget.exercises.length - 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
