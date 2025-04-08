import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/presentation/bloc/user_bloc.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    if (userData.value == null) {
      context.read<UserBloc>().add(ViewUserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if ((state is LoadedData || state is UpdateSuccess) &&
            userData.value != null) {
          return ValueListenableBuilder<UserResopnseModel?>(
              valueListenable: userData,
              builder: (context, user, child) {
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize:
                        const Size.fromHeight(100), // Chiều cao AppBar
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(width: 1.5, color: Colors.grey[300]!),
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
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1.5, color: Colors.grey[300]!),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.shade100,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        'assets/icons/user_avatar/a (${userAvatar.value}).png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    user!.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    user.email,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      context
                                          .push(AppRoutePath
                                              .userInformationUpdate)
                                          .then(
                                        (value) {
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: Icon(Icons.edit),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: [
                            Text(
                              "Số liệu thống kê",
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]),
                        ),
                        GridView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 cột
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 2,
                          ),
                          children: [
                            _buildGridItem(
                              "assets/icons/user_information/score.png",
                              "Tổng số điểm",
                              user.totalXpPoints.toString(),
                            ),

                            _buildGridItem(
                              "assets/icons/user_information/proficient.png",
                              "Thành thạo",
                              user.totalGoPoints.toString(),
                            )
                            // _buildGridItem(
                            //   "assets/icons/user_information/streak.png",
                            //   "Chuỗi học",
                            // ),
                            // _buildGridItem(
                            //   "assets/icons/user_information/rank.png",
                            //   "Thứ tự hạng",
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: [
                            Text(
                              "Thành tích",
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            //color: Colors.amber,
                            border: Border.all(
                                width: 1.5, color: Colors.grey[300]!),
                          ),
                          child: Column(
                            spacing: 20,
                            children: List.generate(user.achievements.length,
                                (index) {
                              return Row(
                                spacing: 20,
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      user.achievements[index].imageUrl,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "assets/icons/user_information/complete_ (${index + 1}).png",
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.achievements[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          user.achievements[index].description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        PercentageProgressBar(
                                          percentage: user.totalGoPoints /
                                              user.achievements[index].target,
                                          progressColor: AppColor.primary500,
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
              });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGridItem(String icon, String text, String value) {
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
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
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
