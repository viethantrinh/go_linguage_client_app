import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/features/lesson/presentation/pages/learn_lesson.dart';

PreferredSizeWidget learnAppBar(
    BuildContext context, int score, int currentExercise, int totalExercise,
    {bool? isExam}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(
                    icon: Icons.close,
                    onPressed: () {
                      showExitConfirmation(context);
                    },
                  ),
                  buildStar(score, totalExercise, isExam ?? false),
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.black54, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: PercentageProgressBar(
                percentage: (currentExercise + 1) / totalExercise,
                height: 10,
              ),
            ),
          ],
        )),
  );
}

Widget buildStar(int score, int totalExercise, bool isExam) {
  // Calculate stars based on percentage of correct answers
  // 0-33% = 1 star, 34-66% = 2 stars, 67-100% = 3 stars
  int stars = 0;

  if (totalExercise > 0) {
    double percentage = (score / totalExercise) * 100;
    if (percentage >= 100) {
      stars = 3;
    } else if (percentage >= 67) {
      stars = 2;
    } else if (percentage >= 34) {
      stars = 1;
    } else if (percentage > 0) {
      stars = 0;
    }
  }

  if (isExam == true) {
    if (score == totalExercise) {
      stars = 3;
    } else if (score >= totalExercise - 1) {
      stars = 2;
    } else if (score >= totalExercise - 2) {
      stars = 1;
    } else {
      stars = 0;
    }
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(stars >= 1 ? Icons.star : Icons.star_border,
          color: stars >= 1 ? Colors.amber : Colors.grey.shade200, size: 28),
      const SizedBox(width: 12),
      Icon(stars >= 2 ? Icons.star : Icons.star_border,
          color: stars >= 2 ? Colors.amber : Colors.grey.shade200, size: 28),
      const SizedBox(width: 12),
      Icon(stars >= 3 ? Icons.star : Icons.star_border,
          color: stars >= 3 ? Colors.amber : Colors.grey.shade200, size: 28),
    ],
  );
}

int getTotalStar(int score, int totalExercise) {
  if (totalExercise > 0) {
    double percentage = (score / totalExercise) * 100;
    if (percentage >= 100) {
      return 3;
    } else if (percentage >= 67) {
      return 2;
    } else if (percentage >= 34) {
      return 1;
    } else if (percentage > 0) {
      return 0;
    }
  }
  return 0;
}
