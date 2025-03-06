import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text('Subject ${index + 1}'),
            subtitle: Text('Tap to see lessons'),
            onTap: () {
              // Navigate to the subject page
              context.go('/home/subject/${index + 1}');
              // context.go('/subject/${index + 1}');
            },
          );
        },
      ),
    );
  }
}
