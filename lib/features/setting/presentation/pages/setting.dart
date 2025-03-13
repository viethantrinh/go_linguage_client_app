import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/setting/presentation/widgets/setting_item.dart';
import 'package:go_linguage/features/setting/presentation/widgets/setting_section.dart';

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
                  title: "Thoát",
                  leadingIcon: Icons.logout,
                  showBorder: false,
                  onTap: () {
                    // Xử lý đăng xuất
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
                      // Xử lý xóa tài khoản
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
