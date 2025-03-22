import 'package:flutter/material.dart';

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
      home: const WordLearnedScreen(onLessonCompleted: null),
    ));
  }
}

class WordLearnedScreen extends StatefulWidget {
  final void Function(bool)? onLessonCompleted;

  const WordLearnedScreen({super.key, this.onLessonCompleted});

  @override
  State<WordLearnedScreen> createState() => _WordLearnedScreenState();
}

class _WordLearnedScreenState extends State<WordLearnedScreen> {
  // List of learned words with their translations and avatar images
  final List<LearnedWord> learnedWords = const [
    LearnedWord(
      english: 'A woman',
      vietnamese: 'phụ nữ',
      avatarAsset: 'assets/images/woman_avatar.png',
    ),
    LearnedWord(
      english: 'A man',
      vietnamese: 'đàn ông',
      avatarAsset: 'assets/images/man_avatar.png',
    ),
    LearnedWord(
      english: 'A girl',
      vietnamese: 'bé gái',
      avatarAsset: 'assets/images/girl_avatar.png',
    ),
    LearnedWord(
      english: 'A boy',
      vietnamese: 'bé trai',
      avatarAsset: 'assets/images/boy_avatar.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Báo hoàn thành bài học sau khi màn hình được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onLessonCompleted != null) {
        widget.onLessonCompleted!(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Congratulations illustration
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background with trees
                  Image.asset(
                    'assets/images/congrats_bg.png',
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey.shade200,
                      );
                    },
                  ),

                  // Checkmark circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CD964),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),

            // Congratulations text
            Text(
              'Bạn làm rất tốt!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy xem bạn đã học những gì',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // List of learned words
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: learnedWords.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final word = learnedWords[index];
                  return _buildWordCard(word);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a card for a learned word
  Widget _buildWordCard(LearnedWord word) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Word and translation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.english,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word.vietnamese,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Avatar image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                word.avatarAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar(word.english);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fallback tree for illustration
  Widget _buildTree() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        Container(
          width: 10,
          height: 30,
          color: Colors.brown.shade700,
        ),
      ],
    );
  }

  // Fallback avatar based on word
  Widget _buildFallbackAvatar(String word) {
    Color backgroundColor;
    IconData iconData;

    if (word.toLowerCase().contains('woman')) {
      backgroundColor = Colors.pink.shade100;
      iconData = Icons.face_2;
    } else if (word.toLowerCase().contains('man')) {
      backgroundColor = Colors.amber.shade100;
      iconData = Icons.face;
    } else if (word.toLowerCase().contains('girl')) {
      backgroundColor = Colors.purple.shade100;
      iconData = Icons.face_3;
    } else if (word.toLowerCase().contains('boy')) {
      backgroundColor = Colors.green.shade100;
      iconData = Icons.face_4;
    } else {
      backgroundColor = Colors.blue.shade100;
      iconData = Icons.person;
    }

    return Container(
      color: backgroundColor,
      child: Icon(
        iconData,
        size: 40,
        color: Colors.black54,
      ),
    );
  }
}

// Model for learned words
class LearnedWord {
  final String english;
  final String vietnamese;
  final String avatarAsset;

  const LearnedWord({
    required this.english,
    required this.vietnamese,
    required this.avatarAsset,
  });
}
