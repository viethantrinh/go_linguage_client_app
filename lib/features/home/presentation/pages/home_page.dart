import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/common/widgets/cache_image.dart';
import 'package:go_linguage/core/common/widgets/loading_indicator.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/home/presentation/bloc/home_bloc.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_linguage/features/subject/model/subject_model.dart';
import 'package:go_linguage/features/user_info/presentation/bloc/user_bloc.dart'
    as user_bloc;
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeBloc>().add(ViewHomeData());
      context.read<user_bloc.UserBloc>().add(user_bloc.ViewUserProfile());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LoadedData) {
          final homeData = state.props[0] as HomeResponseModel;
          if (homeData.isSubscribed) {
            context.read<MainBloc>().add(UpdateProTabVisibility(false));
          } else {
            context.read<MainBloc>().add(UpdateProTabVisibility(true));
          }
        } else if (state is LoadedFailure) {
          final snackBar = SnackBar(content: Text(state.message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is LoadingData) {
          return const Center(child: LoadingIndicator());
        } else if (state is LoadedFailure) {
          return Center(child: Text(state.message));
        }

        // Tạo biến local để lưu trữ dữ liệu, tránh lặp lại biểu thức casting
        final HomeResponseModel homeData = state.props[0] as HomeResponseModel;

        return Scaffold(
            backgroundColor: AppColor.surface,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey[300]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Học",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        ValueListenableBuilder<int?>(
                            valueListenable: userAvatar,
                            builder: (context, avatar, child) {
                              return GestureDetector(
                                onTap: () {
                                  context.push(AppRoutePath.user);
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange.shade100,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      'assets/icons/user_avatar/a (${userAvatar.value}).png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                    const SizedBox(height: 10), // Khoảng cách giữa hai hàng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/icons/user_information/us.png",
                          height: 20,
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Image.asset(
                              "assets/icons/user_information/score.png",
                              height: 16,
                            ),
                            ValueListenableBuilder<int?>(
                                valueListenable: userGoPoint,
                                builder: (context, xpPoint, child) {
                                  return Text(
                                    //homeData.goPoints.toString(),
                                    userGoPoint.value.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  );
                                })
                          ],
                        ),
                        // Row(
                        //   spacing: 5,
                        //   children: [
                        //     Image.asset(
                        //       "assets/icons/user_information/streak.png",
                        //       height: 15,
                        //     ),
                        //     Text(homeData.streakPoints.toString(),
                        //         style: Theme.of(context).textTheme.titleMedium),
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutePath.search, extra: homeData);
                          },
                          child: Icon(Icons.search, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: ValueListenableBuilder<HomeResponseModel?>(
                valueListenable: homeDataGlobal,
                builder: (context, homeDataGL, child) {
                  if (homeDataGL == null) {
                    return const Center(child: LoadingIndicator());
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    itemCount: homeDataGL.levels.length,
                    itemBuilder: (context, indexLevel) {
                      // Lấy level hiện tại để code dễ đọc hơn
                      final currentLevel = homeDataGL.levels[indexLevel];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 3,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currentLevel.name,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  "Bài học ${(indexLevel * 10 + 1)}-${(indexLevel * 10 + 10)}",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          PercentageProgressBar(
                            percentage: currentLevel.totalUserXPPoints / 180,
                          ),
                          SizedBox(height: 10),
                          ...List.generate(
                            currentLevel.topics.length,
                            (indexTopic) {
                              // Lấy topic hiện tại để code dễ đọc hơn
                              final currentTopic =
                                  currentLevel.topics[indexTopic];

                              return GestureDetector(
                                  onTap: () {
                                    if (currentTopic.premium) {
                                      context.push(AppRoutePath.subscription);
                                      return;
                                    }
                                    context.push(AppRoutePath.subject,
                                        extra: SubjectModel(
                                            id: currentTopic.id,
                                            title: currentTopic.name,
                                            progress: currentTopic
                                                .totalUserXPPoints));
                                  },
                                  child: Opacity(
                                    opacity: currentTopic.premium ? 0.5 : 1,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 15,
                                      ),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 20,
                                        children: [
                                          CacheImage(
                                            imageUrl: currentTopic.imageUrl,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    if (currentTopic
                                                            .totalUserXPPoints >
                                                        0) ...[
                                                      Icon(
                                                        Icons.star,
                                                        size: 18,
                                                        color: AppColor.yellow,
                                                      ),
                                                      Text(
                                                        "${currentTopic.totalUserXPPoints}/18",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      )
                                                    ],
                                                  ],
                                                ),
                                                Text(currentTopic.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                                if (currentTopic
                                                        .totalUserXPPoints >
                                                    0) ...[
                                                  SizedBox(height: 10),
                                                  PercentageProgressBar(
                                                    percentage: currentTopic
                                                            .totalUserXPPoints /
                                                        18,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          if (currentTopic.premium)
                                            Icon(
                                              Icons.lock,
                                              size: 14,
                                            )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      );
                    },
                  );
                }));
      },
    );
  }
}

class ItemData {
  final IconData icon;
  final String description;

  ItemData({required this.icon, required this.description});
}

class TopicModel {
  final int id;
  final String icon;
  final String title;

  TopicModel({required this.id, required this.icon, required this.title});
}

class TopicList {
  final List<TopicModel> topicModelList;
  final String title;

  TopicList({required this.topicModelList, required this.title});
}
