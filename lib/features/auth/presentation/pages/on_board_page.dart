import 'package:flutter/material.dart';
import 'package:go_linguage/core/routes/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_router/go_router.dart';

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Positioned(
            top:
                -MediaQuery.of(context).size.height *
                0.16, // Adjust this value to position the circle
            child: Container(
              width: MediaQuery.of(context).size.width * 1.5,
              height: MediaQuery.of(context).size.width * 1.5,
              decoration: BoxDecoration(
                color: Color(0xFFE0F7FA), // Light blue color
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: 132),
              Text(
                'Chào mừng đến với',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 32),
              Text(
                'GoLinguage',
                style: Theme.of(
                  context,
                ).textTheme.displayLarge!.copyWith(color: AppColor.primary600),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AuthButton(
                  buttonText: 'Bắt đầu!',
                  onPressFn: () {
                    context.push(AppRoutePath.signUpOption);
                  },
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                child: Text(
                  'Tôi đã có tài khoản',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onTap: () {
                  context.push(AppRoutePath.signInOption);
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
