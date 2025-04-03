import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/lesson/presentation/pages/learn_lesson.dart';
import 'package:go_linguage/features/lesson/presentation/widgets/learn_app_bar.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_router/go_router.dart';

class DoReviewExamPage extends StatefulWidget {
  final List<Exercise> exercises;
  const DoReviewExamPage({super.key, required this.exercises});

  @override
  State<DoReviewExamPage> createState() => _DoReviewExamPageState();
}

class _DoReviewExamPageState extends State<DoReviewExamPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _canProceed = false;
  bool _isCorrect = false;
  String _correctAnswer = "";

  void _handleLessonCompleted(
    bool isCompleted,
    bool isAcepted,
    String correctAnswer,
  ) {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _correctAnswer = correctAnswer;
        _isCorrect = isAcepted;
        _canProceed = isCompleted;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(List<Exercise> exercises) {
    if (!_canProceed) return;

    if (_currentPage < exercises.length - 1) {
      setState(() {
        _canProceed = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushReplacement('/complete-lesson/100');
    }
  }

  Future<void> _showCorrectAnswer(
      BuildContext context, String correctAnswer, List<Exercise> exercises,
      {bool isCorrect = false}) async {
    // Show modal bottom sheet with barrier that prevents closing by tapping outside
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          // Prevent back button from closing the sheet
          onWillPop: () async => false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCorrect ? "Chính xác" : "Không đúng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Câu trả lời chính xác:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    correctAnswer,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _nextPage(widget.exercises);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCorrect ? Colors.green : AppColor.critical,
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showExitConfirmation(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          icon: Icons.close,
                          onPressed: () {
                            showExitConfirmation(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings,
                              color: Colors.black54, size: 24),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: PercentageProgressBar(
                      percentage: (_currentPage + 1) / widget.exercises.length,
                      height: 10,
                    ),
                  ),
                ],
              )),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Ngăn vuốt ngang để chuyển trang
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _canProceed = false; // Reset when page changes
                    });
                  },
                  itemCount: widget.exercises.length,
                  itemBuilder: (context, indexExercise) {
                    // Trả về màn hình học tập tương ứng
                    return buildExerciseWidget(widget.exercises[indexExercise],
                        _handleLessonCompleted);
                  },
                ),
              ),

              // Nút Tiếp tục
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Opacity(
                    opacity: _canProceed ? 1.0 : 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_canProceed) {
                          if (widget.exercises[_pageController.page!.toInt()]
                                      .instruction ==
                                  "Từ mới! ấn để phát lại" ||
                              widget.exercises[_pageController.page!.toInt()]
                                      .instruction ==
                                  "Nối những thẻ này" ||
                              widget.exercises[_pageController.page!.toInt()]
                                      .instruction ==
                                  "Nghe đoạn hội thoại sau và làm bài") {
                            _nextPage(widget.exercises);
                            return;
                          }
                          if (_isCorrect) {
                            _showCorrectAnswer(
                                context, _correctAnswer, widget.exercises,
                                isCorrect: true);
                            ;
                          } else {
                            _showCorrectAnswer(
                                context, _correctAnswer, widget.exercises,
                                isCorrect: false);
                          }
                          //_nextPage(lessonData);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentPage < widget.exercises.length - 1
                            ? 'Tiếp tục'
                            : 'Hoàn thành',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
