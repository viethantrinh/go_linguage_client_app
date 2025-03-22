import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:just_audio/just_audio.dart';

class LearnWordScreen extends StatefulWidget {
  final void Function(bool) onLessonCompleted;
  final Exercise exercise;

  const LearnWordScreen(
      {super.key, required this.onLessonCompleted, required this.exercise});

  @override
  State<LearnWordScreen> createState() => _LearnWordScreenState();
}

class _LearnWordScreenState extends State<LearnWordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onLessonCompleted(true);
    });
  }

  Future<void> _playAudio(String url) async {
    final player = AudioPlayer(); // Create a player
    final duration = await player.setUrl(// Load a URL
        url); // Schemes: (https: | file: | asset: )
    player.play(); // Play without waiting for completion
    // await player.play(); // Play while waiting for completion
    // await player.pause(); // Pause but remain ready to play
    // await player.seek(Duration(seconds: 10)); // Jump to the 10 second position
    // await player.setSpeed(2.0); // Twice as fast
    // await player.setVolume(0.5); // Half as loud
    // await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.exercise.instruction ?? "ERROR",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.flag_outlined,
                            color: Colors.black54),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Container(
                decoration: BoxDecoration(
                  //color: const Color(0xFFE6F4FF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                ),
                child: Column(
                  children: [
                    // Avatar image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Image.asset(
                            'assets/images/woman_avatar.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Custom avatar fallback
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    widget.exercise.data['imageUrl'],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 100,
                                        color: Colors.orange.shade300,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Word section
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFEEEEEE)),
                          bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.exercise.data['englishText'] ??
                                        "ERROR",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.exercise.data['vietnameseText'] ??
                                        "ERROR",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              spacing: 5,
                              children: [
                                CacheAudioPlayer(
                                  url: widget.exercise.data['audioUrl'],
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                    ),
                                    child: const Icon(Icons.volume_up,
                                        color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 20,
                                    icon: const Icon(Icons.sync,
                                        color: Colors.black54),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Example sentence section
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.exercise.data["sentence"]
                                            ['englishText'] ??
                                        "ERROR",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.exercise.data["sentence"]
                                            ['vietnameseText'] ??
                                        "ERROR",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              spacing: 5,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1),
                                  ),
                                  child: CacheAudioPlayer(
                                    url: widget.exercise.data['sentence']
                                        ['audioUrl'],
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1),
                                      ),
                                      child: const Icon(Icons.volume_up,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 20,
                                    icon: const Icon(Icons.sync,
                                        color: Colors.black54),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ));
  }
}
