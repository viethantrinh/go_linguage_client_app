import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:go_linguage/features/dialog/presentation/bloc/dialog_bloc.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  bool _isRecording = false;
  bool _isExpanded = false;
  double _dragStartY = 0;
  int currentStep = 0;
  List<DialogListResopnseModel> dialogModel = [];

  @override
  void initState() {
    super.initState();
    // Show bottom sheet after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DialogBloc>().add(ViewData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogBloc, DialogState>(
      builder: (context, state) {
        if (state is LoadingData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is LoadedData) {
          final dialogModel = state.dialogModel;
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
                        height: MediaQuery.of(context).size.height * 0.7,
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
                                percentage: 0.2,
                                height: 10,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildTitle(),
                            Expanded(
                                child: SizedBox(
                              height: 500,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                padding: const EdgeInsets.only(bottom: 100),
                                children: [
                                  const SizedBox(height: 20),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: false,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMessage(
                                    englishText: "Hello!",
                                    vietnameseText: "Xin chào!",
                                    avatarUrl: "assets/images/img_logo.png",
                                    isSpeaker: true,
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Animated bottom sheet
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  _buildAnswerOption(
                                    "Hello!",
                                    "Xin chào!",
                                    isSelected: true,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good afternoon!",
                                    "Chào chị!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sáng, thưa ông!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sáng!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sáng!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sáng!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sáng!",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAnswerOption(
                                    "Good morning!",
                                    "Chào buổi sángzzzz!",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // Fixed bottom buttons
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
                                    _isRecording = !_isRecording;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Icon(
                                  Icons.mic_none_outlined,
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
                                onPressed: () {},
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
    required String avatarUrl,
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
              child: Image.asset(
                avatarUrl,
                width: 30,
                height: 30,
              ),
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
                    Text(
                      englishText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSpeaker ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vietnameseText,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSpeaker ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    if (audioUrl != null) ...[
                      const SizedBox(height: 8),
                      Icon(
                        Icons.volume_up,
                        size: 20,
                        color: isSpeaker ? Colors.white70 : Colors.grey[600],
                      ),
                    ],
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

  Widget _buildAnswerOption(String englishText, String vietnameseText,
      {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(
          color: isSelected ? AppColor.primary500 : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            Icon(
              Icons.volume_up,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}
