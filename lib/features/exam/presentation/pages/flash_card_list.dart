import 'package:flutter/material.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_router/go_router.dart';

class MyFlashCardPage extends StatefulWidget {
  final List<FlashCard> flashCards;

  const MyFlashCardPage({super.key, required this.flashCards});

  @override
  State<MyFlashCardPage> createState() => _MyFlashCardPageState();
}

class _MyFlashCardPageState extends State<MyFlashCardPage> {
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
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.flashCards.length, (index) {
                return GestureDetector(
                    onTap: () {
                      context.push(AppRoutePath.flashCard,
                          extra: widget.flashCards[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.line, width: 2),
                      ),
                      child: ListTile(
                        title: Text(
                          widget.flashCards[index].name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ));
              })),
        ),
      ),
    );
  }
}
