import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class LessonCompletedScreen extends StatelessWidget {
  const LessonCompletedScreen({
    super.key,
    this.points = 0,
    this.onContinue,
    this.onRestart,
    this.onShare,
  });

  final int points;
  final VoidCallback? onContinue;
  final VoidCallback? onRestart;
  final VoidCallback? onShare;

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
                'Bài học đã hoàn thành',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),

            Image.asset(
              'assets/icons/lessons/result.png',
              width: 300,
              height: 300,
            ),

            // Points earned
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColor.line, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/coin.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB74D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Bạn đạt được',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '+$points',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                spacing: 30,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircleButton(
                    icon: Icons.refresh,
                    onTap: onRestart ?? () => Navigator.of(context).pop(),
                  ),
                  _buildCircleButton(
                    icon: Icons.share,
                    onTap: onShare ?? () {},
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onContinue ?? () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hoàn thành',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
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
