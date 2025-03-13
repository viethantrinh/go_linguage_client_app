import 'package:flutter/material.dart';
import 'package:go_linguage/core/theme/app_color.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
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
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 17.5,
                  ),
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
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          children: [
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thay đổi ngôn ngữ",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(spacing: 10, children: [
                    Icon(Icons.circle),
                    Text(
                      "Tiếng việt",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ]),
                )
              ],
            ),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cài đặt",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(spacing: 10, children: [
                    Icon(Icons.circle),
                    Text(
                      "Tiếng việt",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ]),
                )
              ],
            ),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kết nối",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(spacing: 10, children: [
                    Icon(Icons.circle),
                    Text(
                      "Tiếng việt",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ]),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Golinguage",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        4,
                        (index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColor.surface,
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.5,
                                  color: index < 3
                                      ? AppColor.line
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            child: Row(spacing: 10, children: [
                              Icon(Icons.circle),
                              Text(
                                "Tiếng việt",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Expanded(child: Container()),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              )
                            ]),
                          );
                        },
                      )),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
