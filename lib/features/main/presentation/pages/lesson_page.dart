import 'package:flutter/material.dart';

class LessonPage extends StatelessWidget {
  final String subjectId;
  final String lessonId;

  const LessonPage({
    super.key,
    required this.subjectId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson $lessonId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Subject: $subjectId', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Lesson: $lessonId',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text('Lesson content goes here...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
