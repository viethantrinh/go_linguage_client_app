import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  CustomBackButton(
                    icon: Icons.clear,
                  ),
                  Text("Hồ sơ")
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutePath.setting);
                },
                child: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header có thể tùy biến

            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1.5, color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(Icons.circle, size: 70),
                      Text("Nguyễn Văn A"),
                      Text("nguyenvana@gmail.com"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          context.push(AppRoutePath.userInformationUpdate);
                        },
                        child: Icon(Icons.edit),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [Text("Số liệu thống kê")]),
            ),

            GridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2,
              ),
              children: [
                _buildGridItem(
                  "assets/icons/user_information/score.png",
                  "Tổng số điểm",
                ),
                _buildGridItem(
                  "assets/icons/user_information/proficient.png",
                  "Thành thạo",
                ),
                _buildGridItem(
                  "assets/icons/user_information/streak.png",
                  "Chuỗi học",
                ),
                _buildGridItem(
                  "assets/icons/user_information/rank.png",
                  "Thứ tự hạng",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [Text("Thành tích")]),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                //color: Colors.amber,
                border: Border.all(width: 1.5, color: Colors.grey[300]!),
              ),
              child: Column(
                children: List.generate(6, (index) {
                  return Row(
                    spacing: 20,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          padding: EdgeInsets.all(
                            4,
                          ), // Để viền không đè lên ảnh
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/icons/user_information/complete_ (${index + 1}).png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover, // Đảm bảo ảnh không méo
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bắt đầu cuộc chơi"),
                            Text("Bắt đầu cuộc chơi"),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: 10,
                                    ), // Tạo khoảng cách với text
                                    child: PercentageProgressBar(
                                      percentage: index / (index + 1),
                                    ),
                                  ),
                                ),
                                Text("0/7"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String icon, String text) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(width: 1.5, color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 15,
        children: [
          Image.asset(icon, width: 25, height: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(color: Colors.black, fontSize: 14)),
              Text(text, style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class PercentageProgressBar extends StatelessWidget {
  final double percentage;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const PercentageProgressBar({
    Key? key,
    required this.percentage,
    this.height = 5,
    this.backgroundColor = AppColor.line,
    this.progressColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
