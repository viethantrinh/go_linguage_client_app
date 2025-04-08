import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';
import 'package:go_linguage/features/submit/presentation/bloc/submit_bloc.dart';
import 'package:go_router/go_router.dart';

class SubmitCompletedScreen extends StatefulWidget {
  const SubmitCompletedScreen({
    super.key,
    required this.request,
  });

  final SubmitRequestModel request;

  @override
  State<SubmitCompletedScreen> createState() => _SubmitCompletedScreenState();
}

class _SubmitCompletedScreenState extends State<SubmitCompletedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubmitBloc>().add(SubmitData(widget.request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmitBloc, SubmitState>(
      listener: (context, state) {
        if (state is SubmitFailure) {}
      },
      builder: (context, state) {
        if (state is Submitting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is Submitted) {
          final SubmitResopnseModel submitResopnseModel = state.submitModel;
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header text
                    Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        'Bài học đã hoàn thành',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Image.asset(
                      'assets/icons/lessons/result.png',
                      width: 300,
                      height: 300,
                    ),

                    // Points earned
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppColor.line, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/user_information/score.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Bạn đạt được',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '+${widget.request.goPoints}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 40),
                    //   child: Row(
                    //     spacing: 30,
                    //     mainAxisSize: MainAxisSize.min,
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       _buildCircleButton(icon: Icons.refresh, onTap: () {}),
                    //     ],
                    //   ),
                    // ),
                    Expanded(child: Container()),

                    // Continue button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary500,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Hoàn thành',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 28,
        ),
      ),
    );
  }
}
