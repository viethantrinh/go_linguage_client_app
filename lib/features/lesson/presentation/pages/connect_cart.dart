import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class ConnectCardScreen extends StatefulWidget {
  final void Function(bool)? onLessonCompleted;
  final Exercise exercise;
  const ConnectCardScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<ConnectCardScreen> createState() => _ConnectCardScreenState();
}

class _ConnectCardScreenState extends State<ConnectCardScreen> {
  // Define the card data
  final List<CardItem> englishCards = [
    CardItem(id: 1, text: 'A man', type: CardType.english),
    CardItem(id: 2, text: 'A girl', type: CardType.english),
    CardItem(id: 3, text: 'A woman', type: CardType.english),
  ];

  final List<CardItem> vietnameseCards = [
    CardItem(
        id: 1,
        text: 'đàn ông',
        type: CardType.vietnamese,
        image: 'assets/images/man_avatar.png'),
    CardItem(
        id: 2,
        text: 'bé gái',
        type: CardType.vietnamese,
        image: 'assets/images/girl_avatar.png'),
    CardItem(
        id: 3,
        text: 'phụ nữ',
        type: CardType.vietnamese,
        image: 'assets/images/woman_avatar.png'),
  ];

  // Track selected cards
  CardItem? selectedEnglishCard;
  CardItem? selectedVietnameseCard;

  // Track matched pairs
  final Set<int> matchedPairs = {};

  // Kiểm tra nếu tất cả các cặp đã được kết nối
  bool get allPairsMatched => matchedPairs.length == englishCards.length;

  void _checkMatch() {
    if (selectedEnglishCard != null && selectedVietnameseCard != null) {
      if (selectedEnglishCard!.id == selectedVietnameseCard!.id) {
        // Match found
        setState(() {
          matchedPairs.add(selectedEnglishCard!.id);
        });

        // Kiểm tra xem tất cả các cặp đã được kết nối chưa
        if (allPairsMatched && widget.onLessonCompleted != null) {
          // Delay một chút để hiển thị trạng thái match cuối cùng
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onLessonCompleted!(true);
          });
        }
      }

      // Reset selections after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedEnglishCard = null;
          selectedVietnameseCard = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Nối những thẻ này',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 10),

          // Cards grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // English cards (left column)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: 6, // Total number of cards (3 pairs x 2)
                      itemBuilder: (context, index) {
                        // First 3 items are English cards
                        if (index < 3) {
                          final card = englishCards[index];
                          final isMatched = matchedPairs.contains(card.id);
                          final isSelected = selectedEnglishCard?.id == card.id;

                          return GestureDetector(
                            onTap: isMatched
                                ? null
                                : () {
                                    setState(() {
                                      selectedEnglishCard = card;
                                      _checkMatch();
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isMatched
                                    ? Colors.grey.shade100
                                    : isSelected
                                        ? Colors.blue.shade50
                                        : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  card.text,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: isMatched
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        // Next 3 items are Vietnamese cards
                        else {
                          final card = vietnameseCards[index - 3];
                          final isMatched = matchedPairs.contains(card.id);
                          final isSelected =
                              selectedVietnameseCard?.id == card.id;

                          return GestureDetector(
                            onTap: isMatched
                                ? null
                                : () {
                                    setState(() {
                                      selectedVietnameseCard = card;
                                      _checkMatch();
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isMatched
                                    ? Colors.grey.shade100
                                    : isSelected
                                        ? Colors.blue.shade50
                                        : Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (card.image != null)
                                    Image.asset(
                                      card.image!,
                                      width: 60,
                                      height: 60,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Fallback avatars based on the card id
                                        IconData iconData = Icons.person;
                                        Color iconColor = Colors.blue;

                                        if (card.id == 1) {
                                          // man
                                          iconData = Icons.face;
                                          iconColor = Colors.orange;
                                        } else if (card.id == 2) {
                                          // girl
                                          iconData = Icons.face_3;
                                          iconColor = Colors.pink;
                                        } else if (card.id == 3) {
                                          // woman
                                          iconData = Icons.face_2;
                                          iconColor = Colors.purple;
                                        }

                                        return Icon(
                                          iconData,
                                          size: 50,
                                          color: iconColor,
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    card.text,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: isMatched
                                          ? Colors.grey
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Card data model
class CardItem {
  final int id;
  final String text;
  final CardType type;
  final String? image;

  CardItem({
    required this.id,
    required this.text,
    required this.type,
    this.image,
  });
}

enum CardType {
  english,
  vietnamese,
}
