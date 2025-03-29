import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/lesson/presentation/pages/fill_conservation.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class MyDialogPage extends StatefulWidget {
  final List<Dialogue> dialogues;

  const MyDialogPage({super.key, required this.dialogues});

  @override
  State<MyDialogPage> createState() => _MyDialogPageState();
}

class _MyDialogPageState extends State<MyDialogPage> {
  int currentPage = 0;
  int lessonIndex = 0;
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.5, color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage == 0
                    ? Text(
                        "Hội thoại đã học",
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : GestureDetector(
                        onTap: () {
                          pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(Icons.arrow_back_ios_rounded),
                      )
              ],
            ),
          ),
        ),
        body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.dialogues.length, (index) {
                        return GestureDetector(
                            onTap: () {
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppColor.line, width: 2),
                              ),
                              child: ListTile(
                                title: Text(
                                  widget.dialogues[index].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ));
                      })),
                ),
              ),
              FillConversationScreen(
                  exercise: exerciseWrapper(widget.dialogues[lessonIndex]))
            ]));
  }
}

Exercise exerciseWrapper(Dialogue dialogue) {
  return Exercise(
    id: dialogue.id,
    data: dialogue.data[0],
  );
}
