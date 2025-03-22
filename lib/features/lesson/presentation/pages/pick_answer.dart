import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';

void main() async {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PickAnswerScreen(onLessonCompleted: null),
    ));
  }
}

class PickAnswerScreen extends StatefulWidget {
  final void Function(bool)? onLessonCompleted;
  
  const PickAnswerScreen({super.key, this.onLessonCompleted});

  @override
  State<PickAnswerScreen> createState() => _PickAnswerScreenState();
}

class _PickAnswerScreenState extends State<PickAnswerScreen> {
  int? selectedAnswerIndex;

  final List<String> options = [
    'He is a boy.',
    'You are a man.',
    'She is a girl.',
    'I am a woman.',
  ];

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
    });
    
    // Thông báo hoàn thành sau khi chọn đáp án
    if (widget.onLessonCompleted != null) {
      // Đợi một chút để hiển thị hiệu ứng chọn
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onLessonCompleted!(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Chọn câu hỏi bạn nghe được',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 30),

          // Sound button
          GestureDetector(
            onTap: () {
              // Play sound logic here
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Answer options
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final isSelected = selectedAnswerIndex == index;

                return GestureDetector(
                  onTap: () {
                    _selectAnswer(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                    ),
                    child: Text(
                      options[index],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          ),

          // "Cannot hear now" text
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Không thể nghe bây giờ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
