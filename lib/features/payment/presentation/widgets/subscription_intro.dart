import 'package:flutter/material.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class SubscriptionIntro extends StatelessWidget {
  const SubscriptionIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: AppColor.primary50, // Light cyan background
      child: Column(
        children: [
          // Top section with logo and close button
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 29),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutePath.home);
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColor.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/images/img_logo.png', // Replace with your logo asset
                      width: 35,
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GoLinguage',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: AppColor.primary600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 19),
                // Subtitle text
                Text(
                  'Cùng nhau khám phá những kiến thức mới',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: AppColor.secondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          // Wave section with illustration
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Custom painter for the wave
              CustomPaint(
                size: const Size(double.infinity, 200),
                painter: WavePainter(),
              ),
              // Person with laptop illustration
              Positioned(
                right: 0,
                bottom: 10,
                child: Image.asset(
                  'assets/images/img_subscription_intro.png', // Replace with your illustration
                  height: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for the wave effect
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint blackPaint = Paint()..color = AppColor.surface;
    Paint cyanPaint = Paint()..color = const Color(0xFF65D9EF);

    final path = Path();
    path.moveTo(0, size.height * 0.60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.40,
      size.width * 0.5,
      size.height * 0.50,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.60,
      size.width,
      size.height * 0.45,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, blackPaint);

    // Cyan circle behind the illustration
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.45),
      size.height * 0.35,
      cyanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
