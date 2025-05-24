import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/lesson/presentation/pages/pronoun_assessment.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/model/subject_model.dart';
import 'package:go_linguage/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_router/go_router.dart';

class SubjectPage extends StatefulWidget {
  final SubjectModel data;

  const SubjectPage({super.key, required this.data});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SubjectBloc>().add(ViewData(id: widget.data.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectBloc, SubjectState>(listener: (context, state) {
      if (state is LoadedData) {
        UserResopnseModel? user = userData.value;
        HomeResponseModel? home = homeDataGlobal.value;
        print(user?.totalGoPoints);
      } else if (state is LoadedFailure) {
        final snackBar = SnackBar(content: Text(state.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }, builder: (context, state) {
      if (state is LoadingData) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hình ảnh ở giữa
                Image.asset(
                  'assets/images/img_logo.png',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.hourglass_bottom,
                      size: 120,
                      color: AppColor.yellow,
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Thanh tiến trình
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: PercentageProgressBar(
                    percentage: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (state is LoadedData) {
        final subjectData = state.props[0] as List<LessonModel>;
        return ValueListenableBuilder<Map<int, int>>(
            valueListenable: scoreData,
            builder: (context, score, child) {
              int totalScore = 0;
              for (var item in subjectData) {
                if (score[item.id] != null) {
                  totalScore += score[item.id]!;
                }
              }
              return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 1.5, color: Colors.grey[300]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomBackButton(),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/user_information/score.png",
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.star, size: 20);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    totalScore.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(children: [
                            Text(
                              widget.data.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]),
                          const SizedBox(height: 10),
                          PercentageProgressBar(
                            percentage: totalScore / 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.grey[200],
                  body: ValueListenableBuilder<HomeResponseModel?>(
                      valueListenable: homeDataGlobal,
                      builder: (context, homeData, child) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: subjectData.length,
                          itemBuilder: (context, indexLevel) {
                            return Row(
                              children: [
                                VerticalLineWithCircle(
                                  end: indexLevel == subjectData.length - 1,
                                  isCompleted:
                                      (score[subjectData[indexLevel].id] ?? 0) >
                                          0,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (subjectData[indexLevel].lessonType ==
                                          2) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PronounAssessmentScreen(
                                                      exercises: subjectData[
                                                              indexLevel]
                                                          .exercises,
                                                      lessonId: subjectData[
                                                              indexLevel]
                                                          .id,
                                                    )));
                                        return;
                                      }

                                      if (subjectData[indexLevel].lessonType ==
                                          3) {
                                        context.push(
                                            '/home/subject/${subjectData[indexLevel].id}/lesson/${indexLevel + 1}/true');
                                        return;
                                      }
                                      // Navigate to standalone lesson route
                                      context.push(
                                          '/home/subject/${subjectData[indexLevel].id}/lesson/${indexLevel + 1}/false');
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 8.0, left: 15),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/lessons/$indexLevel.png",
                                            height: 50,
                                            width: 50,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.book_online,
                                                  size: 50);
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: List.generate(
                                                  score[subjectData[indexLevel]
                                                          .id] ??
                                                      0,
                                                  (index) {
                                                    return Icon(
                                                      Icons.star,
                                                      size: 18,
                                                      color: AppColor.yellow,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Text(
                                                subjectData[indexLevel].name,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }));
            });
      } else {
        return const Center(child: Text(""));
      }
    });
  }
}

class VerticalLineWithCircle extends StatelessWidget {
  final double height;
  final double circleDiameter;
  final Color lineColor;
  final Color circleColor;
  final bool end;
  final bool isCompleted;
  const VerticalLineWithCircle({
    super.key,
    this.height = 90,
    this.circleDiameter = 20.0,
    this.lineColor = const Color.fromARGB(255, 209, 209, 209),
    this.circleColor = Colors.white,
    this.end = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        textDirection: TextDirection.ltr,
        children: [
          // Đường line thẳng đứng (cắt nửa nếu end = true)
          Positioned(
            top: end ? 0 : null,
            bottom: end ? height / 2 : null,
            child: Container(
              width: 2,
              height: end ? height / 2 : height,
              color: lineColor,
            ),
          ),

          // Hình tròn ở giữa
          Container(
              width: circleDiameter,
              height: circleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
                border: Border.all(color: lineColor, width: 2),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: circleDiameter / 2,
                    )
                  : null),
        ],
      ),
    );
  }
}
