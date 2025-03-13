import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class LessonPage extends StatelessWidget {
  final String subjectId;
  final String lessonId;

  LessonPage({
    super.key,
    required this.subjectId,
    required this.lessonId,
  });

  TopicList data = TopicList(
    topicModelList: List.generate(6, (tp) {
      if (tp < 4) {
        return TopicModel(
          id: tp,
          icon: "",
          title: "Bài học ${tp + 1}",
        );
      }
      return TopicModel(
        id: tp,
        icon: "",
        title: tp == 4 ? "Tập nói" : "Kiểm tra",
      );
    }),
    title: "Hòi chảo",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  Row(
                    spacing: 10,
                    children: [
                      Image.asset(
                        "assets/icons/user_information/score.png",
                        height: 20,
                      ),
                      Text(
                        "1",
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  )
                ],
              ),
              Row(children: [
                Text(
                  "Giới thiệu",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ]),
              PercentageProgressBar(
                percentage: 0.3,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: data.topicModelList.length,
        itemBuilder: (context, indexLevel) {
          return Row(
            children: [
              VerticalLineWithCircle(
                end: indexLevel == data.topicModelList.length - 1,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.0, left: 15),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    spacing: 20,
                    children: [
                      indexLevel < 4
                          ? Image.asset(
                              "assets/icons/lessons/$indexLevel.png",
                              height: 50,
                            )
                          : indexLevel == 4
                              ? Icon(Icons.mic, size: 50)
                              : Icon(Icons.book, size: 50),
                      Text(
                        data.topicModelList[indexLevel].title,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopicModel {
  final int id;
  final String icon;
  final String title;

  TopicModel({required this.id, required this.icon, required this.title});
}

class TopicList {
  final List<TopicModel> topicModelList;
  final String title;

  TopicList({required this.topicModelList, required this.title});
}

class VerticalLineWithCircle extends StatelessWidget {
  final double height;
  final double circleDiameter;
  final Color lineColor;
  final Color circleColor;
  final bool end;

  const VerticalLineWithCircle({
    super.key,
    this.height = 90,
    this.circleDiameter = 15.0,
    this.lineColor = const Color.fromARGB(255, 209, 209, 209),
    this.circleColor = AppColor.surface,
    this.end = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
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
          ),
        ],
      ),
    );
  }
}
