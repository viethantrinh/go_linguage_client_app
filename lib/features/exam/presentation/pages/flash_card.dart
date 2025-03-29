import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/common/widgets/cache_audio_player.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/lesson/presentation/widgets/learn_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class FlashCardPage extends StatefulWidget {
  final FlashCard flashCard;

  const FlashCardPage({
    super.key,
    required this.flashCard,
  });

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;
  bool _isFlipping = false;
  int currentPage = 0;
  String? _currentAudioUrl;
  final _audioCacheManager = AudioCacheManager();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // Play or stop audio
  Future<void> _playAudio(String url) async {
    try {
      _audioPlayer.stop();
      // Get cached file
      final audioFile = await _audioCacheManager.getAudioFile(url);
      // Set up and play
      await _audioPlayer.setFilePath(audioFile.path);
      await _audioPlayer.play();
    } catch (e) {
      print('Audio player error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: pi / 2, end: pi)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _animation.addListener(() {
      setState(() {
        if (_animation.value > pi / 2 && _isFrontVisible) {
          _isFrontVisible = false;
          // Phát âm thanh khi lật sang mặt sau
          _currentAudioUrl = widget.flashCard.data[currentPage].audioUrl;
        } else if (_animation.value < pi / 2 && !_isFrontVisible) {
          _isFrontVisible = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipping) return;
    _isFlipping = true;

    if (_controller.status == AnimationStatus.dismissed) {
      _playAudio(widget.flashCard.data[currentPage].audioUrl);
      _controller.forward().then((_) {
        _isFlipping = false;
      });
    } else {
      _controller.reverse().then((_) {
        _isFlipping = false;
      });
    }
  }

  // Reset card to front face
  Future<void> _resetCard() async {
    if (_controller.status != AnimationStatus.dismissed) {
      await _controller.reverse();
    }
    setState(() {
      _isFrontVisible = true;
      _currentAudioUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        CustomBackButton(
                          icon: Icons.close,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PercentageProgressBar(
                      percentage: 0,
                      height: 10,
                    ),
                  ),
                ],
              )),
        ),
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.flashCard.data.length,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
              _currentAudioUrl = null; // Reset audio URL khi chuyển trang
            });
          },
          itemBuilder: (context, index) {
            return Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('How do you say this in Tiếng Anh?',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 40),
                CacheAudioPlayer(
                  url: _currentAudioUrl,
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mặt trước
                            Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_animation.value),
                              alignment: Alignment.center,
                              child: _animation.value <= pi / 2
                                  ? _buildCard(true,
                                      widget.flashCard.data[index].imageUrl!)
                                  : Container(),
                            ),
                            // Mặt sau
                            Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_animation.value - pi),
                              alignment: Alignment.center,
                              child: _animation.value > pi / 2
                                  ? _buildCard(false,
                                      widget.flashCard.data[index].imageUrl!)
                                  : Container(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Text('Tap to flip',
                    style: Theme.of(context).textTheme.bodyLarge),
                Expanded(
                  child: Container(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_pageController.page! <
                                widget.flashCard.data.length - 1) {
                              _resetCard().then((_) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              });
                            } else {
                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Tiếp theo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _buildCard(bool isFront, String imageUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.line, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isFront) ...[
            Image.network(
              imageUrl,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            Text(
              widget.flashCard.data[currentPage].englishText,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const Icon(
              Icons.volume_up,
              size: 40,
              color: Colors.black54,
            ),
            const SizedBox(height: 20),
            Text(
              widget.flashCard.data[currentPage].vietnameseText,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
