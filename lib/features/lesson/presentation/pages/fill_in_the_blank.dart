import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class FillInTheBlankScreen extends StatefulWidget {
  final void Function(bool)? onLessonCompleted;
  final Exercise exercise;
  const FillInTheBlankScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<FillInTheBlankScreen> createState() => _FillInTheBlankScreenState();
}

class _FillInTheBlankScreenState extends State<FillInTheBlankScreen> {
  final List<String> wordOptions = [
    'phụ',
    'tôi',
    'là',
    'nhật',
    'trung',
    'một',
    'quốc',
    'người',
    'nữ',
    'mỹ',
    'tiếng'
  ];

  final List<String> selectedWords = [];
  final int maxSelectedWords = 5; // Maximum number of words in the answer

  // Câu trả lời đúng (thứ tự các từ)
  final List<String> correctAnswer = ['tôi', 'là', 'một', 'người', 'phụ', 'nữ'];

  // Kiểm tra câu trả lời
  void _checkAnswer() {
    // Chỉ kiểm tra khi đã chọn đủ số từ
    if (selectedWords.length >= 5) {
      // Thực tế cần kiểm tra câu trả lời đúng một cách cụ thể hơn
      // Đây chỉ là mô phỏng
      bool isCorrect = true;

      // Thông báo hoàn thành nếu có callback
      if (widget.onLessonCompleted != null) {
        // Đợi một chút để hiển thị hiệu ứng
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onLessonCompleted!(isCorrect);
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
  Widget build(BuildContext context) {
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
                    widget.exercise.data["sentence"]["englishText"] ?? "ERROR",
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
              children: wordOptions.map((word) {
                final isSelected = selectedWords.contains(word);
                return GestureDetector(
                  onTap: () {
                    _selectWord(word);
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
                      word,
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
