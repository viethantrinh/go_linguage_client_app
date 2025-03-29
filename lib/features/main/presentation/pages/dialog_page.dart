import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  // Dữ liệu mẫu
  final List<Map<String, dynamic>> items = List.generate(
    10,
    (index) => {
      'imageUrl': 'https://picsum.photos/200/200?random=$index',
      'title': 'Bài học ${index + 1}',
      'isCompleted': index % 2 == 0, // Mẫu: các bài học chẵn sẽ hoàn thành
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hội thoại",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              // Xử lý khi tap vào item
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1.5,
                  color: Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['title'],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (item['isCompleted'])
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColor.primary500.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColor.primary500,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
