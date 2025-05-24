import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_linguage/features/setting/presentation/pages/notification_page.dart';
import 'package:go_linguage/features/setting/presentation/widgets/delete_account.dart';
import 'package:go_linguage/features/setting/presentation/widgets/setting_item.dart';
import 'package:go_linguage/features/setting/presentation/widgets/setting_section.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Cài đặt",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 20,
            children: [
              SettingSection(
                title: "Thay đổi ngôn ngữ",
                isGrouped: true,
                items: [
                  SettingItem(
                    title: "Tiếng việt",
                    leadingIcon: Icons.language,
                    showBorder: false,
                  ),
                ],
              ),
              SettingSection(
                title: "Cài đặt",
                isGrouped: true,
                items: [
                  SettingItem(
                    title: "Thông báo",
                    leadingIcon: Icons.notifications_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    title: "Âm thanh",
                    leadingIcon: Icons.volume_up_outlined,
                    showBorder: false,
                  ),
                ],
              ),
              SettingSection(
                title: "Kết nối",
                isGrouped: true,
                items: [
                  SettingItem(
                    title: "Facebook",
                    leadingIcon: Icons.facebook,
                  ),
                  SettingItem(
                    title: "Google",
                    leadingIcon: Icons.g_mobiledata,
                    showBorder: false,
                  ),
                ],
              ),
              SettingSection(title: "", isGrouped: true, items: [
                SettingItem(
                  title: "Đăng xuất",
                  leadingIcon: Icons.logout,
                  showBorder: false,
                  onTap: () {
                    // Hiển thị hộp thoại xác nhận
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Xác nhận'),
                        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Hủy'),
                          ),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        context
                                            .read<AuthBloc>()
                                            .add(AuthSignOut());

                                        // Hiển thị loading indicator
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              BlocBuilder<AuthBloc, AuthState>(
                                            builder: (context, state) {
                                              if (state is AuthSignedOut) {
                                                // Tự động đóng dialog khi đã đăng xuất
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  context
                                                      .go(AppRoutePath.onBoard);
                                                });
                                              }
                                              return AlertDialog(
                                                content: Row(
                                                  children: [
                                                    CircularProgressIndicator(),
                                                    SizedBox(width: 20),
                                                    Text('Đang đăng xuất...'),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                child: isLoading
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : Text('Đăng xuất'),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
              SettingSection(
                title: "Golinguage",
                isGrouped: true,
                items: [
                  SettingItem(
                    title: "Về chúng tôi",
                    leadingIcon: Icons.info_outline,
                  ),
                  SettingItem(
                    title: "Đánh giá",
                    leadingIcon: Icons.star_outline,
                  ),
                  SettingItem(
                    title: "Liên lạc",
                    leadingIcon: Icons.contact_mail_outlined,
                  ),
                  SettingItem(
                    title: "Khôi phục dịch vụ mua hàng",
                    leadingIcon: Icons.restore,
                  ),
                  SettingItem(
                    title: "Xóa tài khoản",
                    leadingIcon: Icons.delete_forever_outlined,
                    showBorder: false,
                    onTap: () {
                      DeleteAccountBottomSheet.show(
                        context,
                        onConfirm: () {
                          print('Xóa tài khoản');
                        },
                        onCancel: () {
                          print('Hủy xóa tài khoản');
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
