import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class ExamFailScreen extends StatelessWidget {
  final int subjectId;
  final int lessonId;
  const ExamFailScreen({
    super.key,
    this.points = 0,
    this.onContinue,
    this.onRestart,
    required this.subjectId,
    required this.lessonId,
  });

  final int points;
  final VoidCallback? onContinue;
  final VoidCallback? onRestart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header text
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Text(
                'Kỳ thi thất bại',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),

            Image.asset(
              'assets/icons/lessons/result.png',
              width: 300,
              height: 300,
            ),

            Expanded(
                child: Container(
              child: Text(
                "Đau đấy , cố gắng lần sau nhé",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacement(
                        '/home/subject/$subjectId/lesson/$lessonId/true');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Text(
                'Để sau',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 28,
        ),
      ),
    );
  }
}
