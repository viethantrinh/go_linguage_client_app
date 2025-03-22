import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:go_linguage/features/lesson/presentation/pages/word_learned.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_router/go_router.dart';
import 'learn_word.dart';
import 'choose_ans.dart';
import 'connect_cart.dart';
import 'pick_answer.dart';
import 'fill_in_the_blank.dart';
import 'fill_conservation.dart';
import 'result.dart';

class LearnLessonScreen extends StatefulWidget {
  final int lessonId;
  final int subjectId;
  const LearnLessonScreen(
      {super.key, required this.lessonId, required this.subjectId});

  @override
  State<LearnLessonScreen> createState() => _LearnLessonScreenState();
}

class _LearnLessonScreenState extends State<LearnLessonScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _canProceed = false;

  void _handleLessonCompleted(bool isCompleted) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _canProceed = isCompleted;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await Future.delayed(Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      context.read<LessonBloc>().add(ViewData(widget.lessonId));
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(LessonModel lessonData) {
    if (!_canProceed) return;

    if (_currentPage < lessonData.exercises.length - 1) {
      setState(() {
        _canProceed = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushReplacement(AppRoutePath.completeLesson);
    }
  }

  // Hiển thị bottom sheet cảnh báo khi thoát
  Future<bool> _showExitConfirmation() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Thoát Bài Học',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                          ),
                        ),
                      ],
                    ),

                    // Nội dung
                    Text(
                      'Bạn có chắc không?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'Bạn sẽ mất toàn bộ quá trình của bài học này.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Thoát
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary500,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Thoát',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Nút Huỷ
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Huỷ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );

    // Nếu người dùng nhấn Thoát hoặc result là null (nhấn ra ngoài), trả về true để thoát
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state is LoadedData) {
          final lessonData = state.props[0] as LessonModel;
          // Reset canProceed when new data is loaded
          // setState(() {
          //   _canProceed = false;
          // });
        } else if (state is LoadedFailure) {
          final snackBar = SnackBar(content: Text(state.message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is LoadedData) {
          final lessonData = state.props[0] as LessonModel;
          return WillPopScope(
            onWillPop: _showExitConfirmation,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          icon: Icons.close,
                          onPressed: _showExitConfirmation,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_border,
                                color: Colors.grey.shade200, size: 28),
                            const SizedBox(width: 12),
                            Icon(Icons.star_border,
                                color: Colors.grey.shade200, size: 28),
                            const SizedBox(width: 12),
                            Icon(Icons.star_border,
                                color: Colors.grey.shade200, size: 28),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings,
                              color: Colors.black54, size: 24),
                          onPressed: () {},
                        ),
                      ],
                    )),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: PercentageProgressBar(
                        percentage:
                            (_currentPage + 1) / lessonData.exercises.length,
                        height: 10,
                      ),
                    ),
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
                        itemCount: lessonData.exercises.length+1,
                        itemBuilder: (context, indexExercise) {
                          // Trả về màn hình học tập tương ứng
                          return buildExerciseWidget(
                              lessonData.exercises[indexExercise],
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
                                _nextPage(lessonData);
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
                              _currentPage < lessonData.exercises.length - 1
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
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget buildExerciseWidget(
    Exercise exercise, Function(bool) onLessonCompleted) {
  // Parse exercise type based on id or other properties
  switch (exercise.instruction) {
    case "Từ mới! ấn để phát lại": // LearnWord exercise
      return LearnWordScreen(
        exercise: exercise,
        onLessonCompleted: onLessonCompleted,
      );

    case "Lựa chọn câu trả lời đúng": // ChooseAnswer exercise
      return ChooseAnswerScreen(
        exercise: exercise,
        onLessonCompleted: onLessonCompleted,
      );

    case "Nối những thẻ này": // FillInTheBlank exercise
      return ConnectCardScreen(
        exercise: exercise,
        onLessonCompleted: onLessonCompleted,
      );

    case "Dịch câu này bằng cách sắp xếp": // FillInTheBlank exercise
      return FillInTheBlankScreen(
        exercise: exercise,
        onLessonCompleted: onLessonCompleted,
      );

    case "Nghe đoạn hội thoại sau và làm bài": // FillInTheBlank exercise
      return FillConversationScreen(
        exercise: exercise,
        onLessonCompleted: onLessonCompleted,
      );

    default:
      // Unknown exercise type or fallback
      return WordLearnedScreen();
  }
}
