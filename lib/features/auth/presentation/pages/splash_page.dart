import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/loading_indicator.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use a post-frame callback to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 2));
      // Now you can safely access the bloc
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AuthStatusCheck());
    });
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSucess) {
          // User is authenticated, navigate to home page
          context.go(AppRoutePath.home);
        } else if (state is AuthFailure) {
          // Auth failed, navigate to onboarding
          context.go(AppRoutePath.onBoard);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingIndicator();
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/img_logo.png'),
                const SizedBox(height: 18),
                Text(
                  'GoLinguage',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColor.primary600,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
