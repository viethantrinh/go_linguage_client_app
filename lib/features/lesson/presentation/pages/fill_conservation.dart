import 'package:flutter/material.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class FillConversationScreen extends StatefulWidget {
  final void Function(bool)? onLessonCompleted;
  final Exercise exercise;
  const FillConversationScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<FillConversationScreen> createState() => _FillConversationScreenState();
}

class _FillConversationScreenState extends State<FillConversationScreen> {
  final List<String> wordOptions = ['See', 'are', 'am'];

  // Track selected words for each blank
  Map<int, String> selectedWords = {};

  // Define the conversation messages
  final List<ConversationMessage> conversation = [
    ConversationMessage(
      text: 'Good afternoon!',
      sender: MessageSender.monkey,
      hasAudio: true,
      isBlank: false,
    ),
    ConversationMessage(
      text: 'Good afternoon!',
      sender: MessageSender.earth,
      hasAudio: true,
      isBlank: false,
    ),
    ConversationMessage(
      text: 'How ___ you?',
      sender: MessageSender.monkey,
      hasAudio: true,
      isBlank: true,
      blankWord: 'are',
      blankIndex: 0,
    ),
    ConversationMessage(
      text: 'I\'m fine.',
      sender: MessageSender.earth,
      hasAudio: true,
      isBlank: false,
    ),
    ConversationMessage(
      text: 'And you?',
      sender: MessageSender.earth,
      hasAudio: true,
      isBlank: false,
    ),
    ConversationMessage(
      text: 'I ___ fine.',
      sender: MessageSender.monkey,
      hasAudio: true,
      isBlank: true,
      blankWord: 'am',
      blankIndex: 1,
    ),
  ];

  // Tìm các tin nhắn có ô trống
  List<ConversationMessage> get _blankMessages =>
      conversation.where((message) => message.isBlank).toList();

  // Kiểm tra nếu tất cả các ô trống đã được điền và đúng
  bool get _allBlanksFilledCorrectly {
    if (_blankMessages.length != selectedWords.length) {
      return false;
    }

    for (var message in _blankMessages) {
      if (!selectedWords.containsKey(message.blankIndex) ||
          selectedWords[message.blankIndex] != message.blankWord) {
        return false;
      }
    }

    return true;
  }

  // Kiểm tra nếu tất cả các ô trống đã được điền
  bool get _allBlanksFilled => _blankMessages.length == selectedWords.length;

  // Xử lý khi chọn từ cho một ô trống
  void _selectWord(String word, int blankIndex) {
    setState(() {
      selectedWords[blankIndex] = word;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onLessonCompleted!(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Điền vào chỗ trống',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // Conversation
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: conversation.length,
                itemBuilder: (context, index) {
                  final message = conversation[index];
                  return _buildMessageItem(message);
                },
              ),
            ),

            // Word options
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: wordOptions.map((word) {
                  final bool isUsed = selectedWords.values.contains(word);

                  return GestureDetector(
                    onTap: isUsed
                        ? null
                        : () {
                            // Find the first unfilled blank
                            for (var message in _blankMessages) {
                              if (!selectedWords
                                  .containsKey(message.blankIndex)) {
                                _selectWord(word, message.blankIndex);
                                break;
                              }
                            }
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUsed ? Colors.grey.shade200 : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isUsed
                              ? Colors.grey.shade300
                              : Colors.blue.shade200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 18,
                          color: isUsed ? Colors.grey : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a message item
  Widget _buildMessageItem(ConversationMessage message) {
    final bool isMonkey = message.sender == MessageSender.monkey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMonkey ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          // Avatar for monkey (left side only)
          if (isMonkey)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orange.shade100,
              child: Icon(
                Icons.face,
                color: Colors.orange,
              ),
            ),

          if (isMonkey) const SizedBox(width: 12),

          // Message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isMonkey ? Colors.orange.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message text
                if (message.isBlank)
                  _buildMessageWithBlank(message)
                else
                  Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),

                if (message.hasAudio)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up, size: 18),
                      color: Colors.grey,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {},
                    ),
                  ),
              ],
            ),
          ),

          if (!isMonkey) const SizedBox(width: 12),

          // Avatar for earth (right side only)
          if (!isMonkey)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.shade100,
              child: Icon(
                Icons.public,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  // Build message with blank
  Widget _buildMessageWithBlank(ConversationMessage message) {
    List<String> parts = message.text.split('___');

    return Row(
      children: [
        Text(
          parts[0],
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),

        // Blank
        if (selectedWords.containsKey(message.blankIndex))
          // Filled blank
          GestureDetector(
            onTap: () {
              setState(() {
                selectedWords.remove(message.blankIndex);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                selectedWords[message.blankIndex]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        else
          // Empty blank
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 50,
            height: 25,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 2,
                ),
              ),
            ),
          ),

        Text(
          parts[1],
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Message data model
class ConversationMessage {
  final String text;
  final MessageSender sender;
  final bool hasAudio;
  final bool isBlank;
  final String? blankWord;
  final int blankIndex;

  ConversationMessage({
    required this.text,
    required this.sender,
    required this.hasAudio,
    required this.isBlank,
    this.blankWord,
    this.blankIndex = -1,
  });
}

enum MessageSender {
  monkey,
  earth,
}
