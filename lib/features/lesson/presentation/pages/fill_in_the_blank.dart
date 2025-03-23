import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class Word {
  final String text;
  final bool isDistractor;
  final int correctPosition;

  Word(
      {required this.text,
      required this.isDistractor,
      required this.correctPosition});
}

class FillInTheBlankScreen extends StatefulWidget {
  final void Function(bool, bool, String)? onLessonCompleted;
  final Exercise exercise;
  const FillInTheBlankScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<FillInTheBlankScreen> createState() => _FillInTheBlankScreenState();
}

class _FillInTheBlankScreenState extends State<FillInTheBlankScreen> {
  final List<Word> words = [];
  final List<String> selectedWords = [];

  // This will be dynamically set based on exercise data
  late int maxSelectedWords;

  // This will store the correct answer based on correctPosition
  late List<String> correctAnswer;

  // Kiểm tra câu trả lời
  void _checkAnswer() {
    // Chỉ kiểm tra khi đã chọn đủ số từ
    if (selectedWords.length == maxSelectedWords) {
      // Kiểm tra thứ tự các từ có đúng không
      bool isCorrect = true;

      // Tạo một map từ correctPosition --> text của từ không phải distractor
      Map<int, String> positionToWordMap = {};
      for (var word in words) {
        if (!word.isDistractor) {
          positionToWordMap[word.correctPosition] = word.text;
        }
      }

      // Tạo câu trả lời đúng từ positionToWordMap
      List<String> expectedOrder = [];
      for (int i = 0; i < maxSelectedWords; i++) {
        expectedOrder.add(positionToWordMap[i] ?? "");
      }

      // So sánh các từ đã chọn với thứ tự đúng
      for (int i = 0; i < selectedWords.length; i++) {
        if (i >= expectedOrder.length || selectedWords[i] != expectedOrder[i]) {
          isCorrect = false;
          break;
        }
      }

      // Thông báo hoàn thành nếu có callback
      if (widget.onLessonCompleted != null) {
        // Đợi một chút để hiển thị hiệu ứng
        Future.delayed(const Duration(milliseconds: 500), () {
          String cras = "";
          for (var i = 0; i < correctAnswer.length; i++) {
            cras += correctAnswer[i];
            cras += " ";
          }
          widget.onLessonCompleted!(true, isCorrect, cras);
        });
      }
    }
  }

  // Xử lý khi chọn từ
  void _selectWord(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else if (selectedWords.length < maxSelectedWords) {
        selectedWords.add(word);

        // Kiểm tra câu trả lời khi đã chọn đủ từ
        _checkAnswer();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Tạo danh sách words từ dữ liệu API
    for (final word in widget.exercise.data["words"]) {
      words.add(Word(
          text: word["text"],
          isDistractor: word["isDistractor"],
          correctPosition: word["correctPosition"]));
    }

    // Tính số lượng từ cần chọn (số từ không phải distractor)
    maxSelectedWords = words.where((word) => !word.isDistractor).length;

    // Tạo câu trả lời đúng dựa trên correctPosition
    correctAnswer = List.filled(maxSelectedWords, "");
    for (var word in words) {
      if (!word.isDistractor && word.correctPosition < maxSelectedWords) {
        correctAnswer[word.correctPosition] = word.text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //widget.onLessonCompleted!(true, true, "VPI");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.exercise.instruction ?? "ERROR",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 20),

          // Sentence to translate
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.exercise.data["sourceLanguage"] == "english"
                        ? widget.exercise.data["sentence"]["englishText"]
                        : widget.exercise.data["sentence"]["vietnameseText"],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: CacheAudioPlayer(
                          url: widget.exercise.data["sentence"]["audioUrl"] ??
                              "",
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
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sync, color: Colors.black54),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Selected words area
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Display selected words
                Expanded(
                  child: selectedWords.isEmpty
                      ? Row(
                          children: List.generate(
                            maxSelectedWords,
                            (index) => Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: DashedBorderDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                  dashWidth: 5,
                                  dashSpace: 3,
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedWords.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedWords.removeAt(index);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  selectedWords[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Word options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              children: words.map((word) {
                final isSelected = selectedWords.contains(word.text);
                return GestureDetector(
                  onTap: () {
                    _selectWord(word.text);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade200 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      word.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.grey : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom decoration for dashed border
class DashedBorderDecoration extends Decoration {
  final Color color;
  final BorderRadius borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const DashedBorderDecoration({
    required this.color,
    required this.borderRadius,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.strokeWidth = 1,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashedBorderPainter(
      color: color,
      borderRadius: borderRadius,
      dashWidth: dashWidth,
      dashSpace: dashSpace,
      strokeWidth: strokeWidth,
    );
  }
}

class _DashedBorderPainter extends BoxPainter {
  final Color color;
  final BorderRadius borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()..addRRect(borderRadius.toRRect(rect));
    final dashedPath = Path();

    for (final pathMetric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        final dashPath = pathMetric.extractPath(distance, distance + dashWidth);
        dashedPath.addPath(dashPath, Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }
}
