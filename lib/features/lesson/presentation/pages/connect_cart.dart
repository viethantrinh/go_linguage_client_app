import 'package:flutter/material.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class ConnectCardScreen extends StatefulWidget {
  final void Function(bool, bool, String)? onLessonCompleted;
  final Exercise exercise;
  const ConnectCardScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<ConnectCardScreen> createState() => _ConnectCardScreenState();
}

class _ConnectCardScreenState extends State<ConnectCardScreen> {
  // Define the card data
  final List<CardItem> englishCards = [];
  final List<CardItem> vietnameseCards = [];

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
            widget.onLessonCompleted!(true, true, "");
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
  void initState() {
    super.initState();
    for (var i = 0; i < widget.exercise.data.length; i++) {
      englishCards.add(CardItem(
          id: i,
          text: widget.exercise.data[i]["englishText"],
          type: CardType.english));
      vietnameseCards.add(CardItem(
          id: i,
          text: widget.exercise.data[i]["vietnameseText"],
          type: CardType.vietnamese,
          image: widget.exercise.data[i]["imageUrl"]));
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
              widget.exercise.instruction ?? "ERROR",
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
                            child: Opacity(
                              opacity: isMatched ? 0.5 : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    card.text,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
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
                            child: Opacity(
                              opacity: isMatched ? 0.5 : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (card.image != null)
                                      Image.network(
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
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
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
