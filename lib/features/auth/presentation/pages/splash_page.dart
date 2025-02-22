import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';
import 'package:go_linguage/core/routes/app_route_path.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      // TODO: check auth status here to decide route to home or onBoard
      if (mounted) {
        context.go(AppRoutePath.onBoard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/img_logo.png'),
            const SizedBox(height: 18),
            Text(
              'GoLinguage',
              style: Theme.of(
                context,
              ).textTheme.displaySmall!.copyWith(color: AppColor.primary600),
            ),
          ],
        ),
      ),
    );
  }
}
