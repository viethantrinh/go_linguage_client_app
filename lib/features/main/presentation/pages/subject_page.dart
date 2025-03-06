import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubjectPage extends StatelessWidget {
  final String subjectId;

  const SubjectPage({super.key, required this.subjectId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject $subjectId'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'), // Return to home with bottom nav
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Lesson ${index + 1}'),
            onTap: () {
              // Navigate to standalone lesson route
              context.push('/home/subject/$subjectId/lesson/${index + 1}');
            },
          );
        },
      ),
    );
  }
}
