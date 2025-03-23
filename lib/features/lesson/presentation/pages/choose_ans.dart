import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class ChooseAnswerScreen extends StatefulWidget {
  final void Function(bool, bool, String)? onLessonCompleted;
  final Exercise exercise;

  const ChooseAnswerScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<ChooseAnswerScreen> createState() => _ChooseAnswerScreenState();
}

class _ChooseAnswerScreenState extends State<ChooseAnswerScreen> {
  int? selectedAnswerIndex;
  final List<String> options = [];
  final List<bool> revealedAnswers = [];
  String correctAnswer = "";

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      if (index < revealedAnswers.length) {
        revealedAnswers[index] = true;
      }
    });

    // Thông báo hoàn thành sau khi chọn đáp án
    if (widget.onLessonCompleted != null) {
      widget.onLessonCompleted!(true,
          widget.exercise.data["options"][index]["isCorrect"], correctAnswer);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var option in widget.exercise.data["options"]) {
        options.add(
          widget.exercise.data["sourceLanguage"] == "english"
              ? option["englishText"]
              : option["vietnameseText"],
        );
        revealedAnswers.add(false);
        if (option["isCorrect"] == true) {
          correctAnswer = widget.exercise.data["sourceLanguage"] == "english"
              ? option["englishText"]
              : option["vietnameseText"];
        }
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.exercise.instruction ?? "ERROR",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Word with sound button
          if (widget.exercise.data["questionType"] == "word" ||
              widget.exercise.data["questionType"] == "sentence")
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.exercise.data["targetLanguage"] == "english"
                            ? widget.exercise.data["question"]["englishText"]
                            : widget.exercise.data["question"]
                                ["vietnameseText"],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    CacheAudioPlayer(
                        url: widget.exercise.data["question"]["audioUrl"],
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: const Icon(Icons.volume_up,
                              color: Colors.black54),
                        ))
                  ],
                ),
              ),
            ),
          if (widget.exercise.data["questionType"] == "audio")
            Center(
              child: CacheAudioPlayer(
                  url: widget.exercise.data["question"]["audioUrl"],
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: const Icon(Icons.volume_up, color: Colors.black54),
                  )),
            ),

          const SizedBox(height: 10),

          // Answer options grid
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: List.generate(
                options.length,
                (index) => GestureDetector(
                  onTap: () {
                    _selectAnswer(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAnswerIndex == index
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        revealedAnswers.length > index && revealedAnswers[index]
                            ? Image.network(
                                widget.exercise.data["options"][index]
                                        ["imageUrl"] ??
                                    "",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              )
                            : widget.exercise.data["options"][index]
                                        ["imageUrl"] !=
                                    null
                                ? Icon(
                                    Icons.help,
                                    size: 60,
                                    color: Colors.blue.shade400,
                                  )
                                : Container(),
                        const SizedBox(height: 10),
                        Text(
                          options[index],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
