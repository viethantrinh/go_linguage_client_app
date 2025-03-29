import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/lesson/presentation/widgets/learn_app_bar.dart';

void main() {
  runApp(
    SafeArea(
      child: MaterialApp(
        home: FlashCardPage(
          flashCards: [
            FlashCard(
              id: 1,
              name: 'Hello',
              displayOrder: 1,
              data: [
                QuestionElement(
                  audioUrl: '',
                  englishText: 'Hello',
                  vietnameseText: 'Xin chào',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class FlashCardPage extends StatefulWidget {
  final List<FlashCard> flashCards;

  const FlashCardPage({
    super.key,
    required this.flashCards,
  });

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;
  bool _isFlipping = false;

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
      _controller.forward().then((_) {
        _isFlipping = false;
      });
    } else {
      _controller.reverse().then((_) {
        _isFlipping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: learnAppBar(context, 0, 0, 0),
      body: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('How do you say this in Tiếng Anh?',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 40),
          GestureDetector(
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
                          ? _buildCard(true)
                          : Container(),
                    ),
                    // Mặt sau
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value - pi),
                      alignment: Alignment.center,
                      child: _animation.value > pi / 2
                          ? _buildCard(false)
                          : Container(),
                    ),
                  ],
                );
              },
            ),
          ),
          Text('Tap to flip', style: Theme.of(context).textTheme.bodyLarge),
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
                    onPressed: () {},
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
      ),
    );
  }

  Widget _buildCard(bool isFront) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isFront) ...[
            Image.asset(
              'assets/images/img_logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            Text(
              widget.flashCards[0].data[0].englishText,
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
              widget.flashCards[0].data[0].vietnameseText,
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
