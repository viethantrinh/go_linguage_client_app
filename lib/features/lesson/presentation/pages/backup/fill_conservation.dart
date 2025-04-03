import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'dart:convert';

class FillConversationScreen extends StatefulWidget {
  final void Function(bool, bool, String)? onLessonCompleted;
  final Exercise exercise;
  const FillConversationScreen(
      {super.key, this.onLessonCompleted, required this.exercise});

  @override
  State<FillConversationScreen> createState() => _FillConversationScreenState();
}

// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  bool isChangeSpeaker;
  String englishText;
  String vietnameseText;
  String audioUrl;
  int displayOrder;
  String? blankWord;

  ChatModel({
    required this.isChangeSpeaker,
    required this.englishText,
    required this.vietnameseText,
    required this.audioUrl,
    required this.displayOrder,
    required this.blankWord,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        isChangeSpeaker: json["isChangeSpeaker"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        audioUrl: json["audioUrl"],
        displayOrder: json["displayOrder"],
        blankWord: json["blankWord"],
      );

  Map<String, dynamic> toJson() => {
        "isChangeSpeaker": isChangeSpeaker,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "audioUrl": audioUrl,
        "displayOrder": displayOrder,
        "blankWord": blankWord,
      };

  // Helper property to check if this message has a blank
  bool get hasBlank => englishText.contains("[]") && blankWord != null;
}

class _FillConversationScreenState extends State<FillConversationScreen> {
  final List<String> wordOptions = [];
  List<ChatModel> chatModel = [];

  // Track selected words for each blank
  Map<int, String> selectedWords = {};

  // Tìm các tin nhắn có ô trống
  List<ChatModel> get _blankMessages =>
      chatModel.where((message) => message.hasBlank).toList();

  // Kiểm tra nếu tất cả các ô trống đã được điền và đúng
  bool get _allBlanksFilledCorrectly {
    if (_blankMessages.length != selectedWords.length) {
      return false;
    }

    for (int i = 0; i < _blankMessages.length; i++) {
      var message = _blankMessages[i];
      if (!selectedWords.containsKey(i) ||
          selectedWords[i] != message.blankWord) {
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

    // Kiểm tra nếu hoàn thành
    if (_allBlanksFilled) {
      // Thông báo hoàn thành nếu đúng tất cả
      if (_allBlanksFilledCorrectly && widget.onLessonCompleted != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onLessonCompleted!(true, true, "OKKK");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Load data from exercise
    for (var i = 0;
        i < widget.exercise.data["dialogueExerciseLines"].length;
        i++) {
      chatModel.add(ChatModel(
        isChangeSpeaker: widget.exercise.data["dialogueExerciseLines"][i]
            ["isChangeSpeaker"],
        englishText: widget.exercise.data["dialogueExerciseLines"][i]
            ["englishText"],
        vietnameseText: widget.exercise.data["dialogueExerciseLines"][i]
            ["vietnameseText"],
        audioUrl:
            widget.exercise.data["dialogueExerciseLines"][i]["audioUrl"] ?? "",
        displayOrder: widget.exercise.data["dialogueExerciseLines"][i]
            ["displayOrder"],
        blankWord:
            widget.exercise.data["dialogueExerciseLines"][i]["blankWord"] ?? "",
      ));

      if (widget.exercise.data["dialogueExerciseLines"][i]["blankWord"] !=
              null &&
          widget.exercise.data["dialogueExerciseLines"][i]["blankWord"]
              .toString()
              .isNotEmpty) {
        wordOptions
            .add(widget.exercise.data["dialogueExerciseLines"][i]["blankWord"]);
      }
    }

    // Sort the chat model by display order
    chatModel.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
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
            if (widget.exercise.instruction != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.exercise.instruction ?? "ERROR",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

            // Conversation
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: chatModel.length,
                itemBuilder: (context, index) {
                  final message = chatModel[index];

                  return _buildMessageItem(
                      message, index, message.isChangeSpeaker);
                },
              ),
            ),

            // Word options
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                            for (int i = 0; i < _blankMessages.length; i++) {
                              if (!selectedWords.containsKey(i)) {
                                _selectWord(word, i);
                                break;
                              }
                            }
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 7,
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
  Widget _buildMessageItem(ChatModel message, int index, bool isFirstSpeaker) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isFirstSpeaker ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          // Avatar for first speaker (left side only)
          if (isFirstSpeaker)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orange.shade100,
              child: Icon(
                Icons.face,
                color: Colors.orange,
              ),
            ),

          if (isFirstSpeaker) const SizedBox(width: 12),

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
              color:
                  isFirstSpeaker ? Colors.orange.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Audio player on the left for second speaker
                if (!isFirstSpeaker && message.audioUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CacheAudioPlayer(
                      url: message.audioUrl,
                      child: const Icon(Icons.volume_up, size: 18),
                    ),
                  ),

                // Message text
                if (message.hasBlank)
                  Flexible(child: _buildMessageWithBlank(message))
                else
                  Flexible(
                    child: Text(
                      message.englishText,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                // Audio player on the right for first speaker
                if (isFirstSpeaker && message.audioUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CacheAudioPlayer(
                      url: message.audioUrl,
                      child: const Icon(Icons.volume_up, size: 18),
                    ),
                  ),
              ],
            ),
          ),

          if (!isFirstSpeaker) const SizedBox(width: 12),

          // Avatar for second speaker (right side only)
          if (!isFirstSpeaker)
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
  Widget _buildMessageWithBlank(ChatModel message) {
    // Find the index of this message in the blank messages list
    int blankIndex = _blankMessages.indexOf(message);

    // Replace blank marker [] with ___
    String textWithBlank = message.englishText.replaceAll("[]", "___");
    List<String> parts = textWithBlank.split('___');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          parts[0],
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),

        // Blank
        if (selectedWords.containsKey(blankIndex))
          // Filled blank
          GestureDetector(
            onTap: () {
              setState(() {
                selectedWords.remove(blankIndex);
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
                selectedWords[blankIndex]!,
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

        if (parts.length > 1)
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
