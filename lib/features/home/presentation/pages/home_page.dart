import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/loading_indicator.dart';
import 'package:go_linguage/core/common/widgets/progress_bar.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/home/presentation/bloc/home_bloc.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> items = List.generate(100, (index) {
    return ItemData(icon: Icons.home, description: "Trang chủ $index");
  });
  List<TopicList> listData = List.generate(3, (index) {
    return TopicList(
      topicModelList: List.generate(5, (tp) {
        return TopicModel(
          id: tp,
          icon: "",
          title: "Đây là đài tiếng nói việt nam",
        );
      }),
      title: "Cơ bản",
    );
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await Future.delayed(Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      context.read<HomeBloc>().add(ViewData());
    });

    // Ví dụ: Cập nhật MainBloc state khi có sự kiện nào đó
    void updateMainState(int newIndex) {
      context.read<MainBloc>().add(UpdateMainState(newIndex));
    }

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
        }
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100), // Chiều cao AppBar
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutePath.user);
                        },
                        child: Icon(Icons.circle, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Khoảng cách giữa hai hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.circle, color: Colors.green),
                      Row(
                        spacing: 5,
                        children: [
                          Image.asset(
                            "assets/icons/user_information/score.png",
                            height: 16,
                          ),
                          Text(
                            (state.props[0] as HomeResponseModel)
                                .goPoints
                                .toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Image.asset(
                            "assets/icons/user_information/streak.png",
                            height: 15,
                          ),
                          Text(
                              (state.props[0] as HomeResponseModel)
                                  .streakPoints
                                  .toString(),
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      Icon(Icons.search, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemCount: (state.props[0] as HomeResponseModel).levels.length,
            itemBuilder: (context, indexLevel) {
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
                          (state.props[0] as HomeResponseModel)
                              .levels[indexLevel]
                              .name,
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
                    percentage: (state.props[0] as HomeResponseModel)
                            .levels[indexLevel]
                            .totalUserXPPoints /
                        180,
                  ),
                  SizedBox(height: 10),
                  ...List.generate(
                    (state.props[0] as HomeResponseModel)
                        .levels[indexLevel]
                        .topics
                        .length,
                    (indexTopic) {
                      return GestureDetector(
                          onTap: () {
                            if ((state.props[0] as HomeResponseModel)
                                .levels[indexLevel]
                                .topics[indexTopic]
                                .premium) {
                              context.push(AppRoutePath.subscription);
                              return;
                            }
                            context.push(AppRoutePath.lesson);
                          },
                          child: Opacity(
                            opacity: (state.props[0] as HomeResponseModel)
                                    .levels[indexLevel]
                                    .topics[indexTopic]
                                    .premium
                                ? 0.5
                                : 1,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 20,
                                children: [
                                  Image.network(
                                    (state.props[0] as HomeResponseModel)
                                        .levels[indexLevel]
                                        .topics[indexTopic]
                                        .imageUrl,
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
                                            if ((state.props[0]
                                                        as HomeResponseModel)
                                                    .levels[indexLevel]
                                                    .topics[indexTopic]
                                                    .totalUserXPPoints >
                                                0) ...[
                                              Image.asset(
                                                "assets/icons/user_information/proficient.png",
                                                height: 12,
                                              ),
                                              Text(
                                                "${(state.props[0] as HomeResponseModel).levels[indexLevel].topics[indexTopic].totalUserXPPoints}/18",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              )
                                            ],
                                          ],
                                        ),
                                        Text(
                                            (state.props[0]
                                                    as HomeResponseModel)
                                                .levels[indexLevel]
                                                .topics[indexTopic]
                                                .name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        if ((state.props[0]
                                                    as HomeResponseModel)
                                                .levels[indexLevel]
                                                .topics[indexTopic]
                                                .totalUserXPPoints >
                                            0) ...[
                                          SizedBox(height: 10),
                                          PercentageProgressBar(
                                            percentage: (state.props[0]
                                                        as HomeResponseModel)
                                                    .levels[indexLevel]
                                                    .topics[indexTopic]
                                                    .totalUserXPPoints /
                                                18,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if ((state.props[0] as HomeResponseModel)
                                      .levels[indexLevel]
                                      .topics[indexTopic]
                                      .premium)
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
          ),
        );
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
