import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/payment/presentation/bloc/subscription_bloc.dart';
import 'package:go_linguage/features/payment/presentation/widgets/subscription_button.dart';
import 'package:go_linguage/features/payment/presentation/widgets/subscription_feature.dart';
import 'package:go_linguage/features/payment/presentation/widgets/subscription_intro.dart';
import 'package:go_linguage/features/payment/presentation/widgets/subscription_option.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubsriptionPageState();
}

enum SubscriptionMonth {
  one(1),
  six(2),
  twelve(3),
  lifetime(4);

  const SubscriptionMonth(int id) : _id = id;
  final int _id;

  int getId() {
    return _id;
  }
}

class _SubsriptionPageState extends State<SubscriptionPage> {
  SubscriptionMonth selectedOption = SubscriptionMonth.one;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionCreateSuccessState) {
          context.go(AppRoutePath.home);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.surface,
          bottomNavigationBar: BottomAppBar(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 15),
            color: AppColor.white,
            child: SubscriptionButton(
              buttonText: 'Đăng ký dịch vụ',
              onSubscribe: () {
                context.read<SubscriptionBloc>().add(
                      SubscriptionPaymentRequestedEvent(
                        subscriptionMonth: selectedOption,
                      ),
                    );
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SubscriptionIntro(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        // Features section
                        Text(
                          'Nâng cấp trải nghiệm để:',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),

                        // Feature list items
                        SubscriptionFeature(feature: 'Học 400 từ mới tháng'),
                        SubscriptionFeature(
                          feature: 'Giao tiếp Tiếng Anh sau 3 tháng',
                        ),
                        SubscriptionFeature(feature: 'Phương pháp học nhanh'),
                        SubscriptionFeature(
                          feature: 'Trải nghiệm không quảng cáo',
                        ),

                        const SizedBox(height: 30),

                        const SizedBox(height: 16),

                        // Other subscription options
                        SubscriptionOption(
                          period: '12 tháng',
                          price: '2.399.000 VND',
                          perMonth: '120.000VNĐ/tháng',
                          isSelected:
                              selectedOption == SubscriptionMonth.twelve,
                          onTap: () {
                            setState(() {
                              selectedOption = SubscriptionMonth.twelve;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        SubscriptionOption(
                          period: '6 tháng',
                          price: '799.000 VND',
                          perMonth: '150.000VNĐ/tháng',
                          isSelected: selectedOption == SubscriptionMonth.six,
                          onTap: () {
                            setState(() {
                              selectedOption = SubscriptionMonth.six;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        SubscriptionOption(
                          period: '1 tháng',
                          price: '199.000 VND',
                          isSelected: selectedOption == SubscriptionMonth.one,
                          onTap: () {
                            setState(() {
                              selectedOption = SubscriptionMonth.one;
                            });
                          },
                          perMonth: '199.000VNĐ/tháng',
                        ),

                        const SizedBox(height: 12),

                        SubscriptionOption(
                          period: 'Trọn đời',
                          price: '4.999.000 VND',
                          perMonth: 'Thanh toán một lần',
                          isSelected:
                              selectedOption == SubscriptionMonth.lifetime,
                          onTap: () {
                            setState(() {
                              selectedOption = SubscriptionMonth.lifetime;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Terms link
                        Center(
                          child: Text(
                            'Điều khoản & Bảo mật',
                            style: theme.textTheme.labelLarge!.copyWith(
                              color: AppColor.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
