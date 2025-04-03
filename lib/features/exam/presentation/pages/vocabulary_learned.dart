import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';

class MyVocabularyPage extends StatefulWidget {
  final List<FlashCard> flashCards;

  const MyVocabularyPage({super.key, required this.flashCards});

  @override
  State<MyVocabularyPage> createState() => _MyVocabularyPageState();
}

class _MyVocabularyPageState extends State<MyVocabularyPage> {
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
                        "Từ vựng đã học",
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
                      children:
                          List.generate(widget.flashCards.length, (index) {
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
                                  widget.flashCards[index].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ));
                      })),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          widget.flashCards[lessonIndex].data.length, (index) {
                        return CacheAudioPlayer(
                            url: widget
                                .flashCards[lessonIndex].data[index].audioUrl,
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColor.line, width: 2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.flashCards[lessonIndex]
                                              .data[index].englishText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Icon(Icons.volume_up)
                                      ],
                                    ),
                                    Text(
                                      widget.flashCards[lessonIndex].data[index]
                                          .vietnameseText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                )));
                      })),
                ),
              ),
            ]));
  }
}
