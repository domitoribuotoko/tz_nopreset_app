import 'package:flutter/material.dart';
import 'package:tz_nopreset_app/base/app_constants.dart';
import 'package:tz_nopreset_app/pages/tabs/all_news.dart';
import 'package:tz_nopreset_app/pages/tabs/article_news.dart';
import 'package:tz_nopreset_app/pages/tabs/top_news.dart';

class MainController extends StatefulWidget {
  const MainController({super.key});

  @override
  State<MainController> createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<String> tabs = <String>['лента', 'важное', "статьи"];
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      // initialIndex: tabGraphPageIndex.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                toolbarHeight: 50,
                title:
                //  RichText(
                //   text:
                //    TextSpan(
                //     children: [
                //       const TextSpan(
                //         text: 'регион',
                //         style: TextStyle(fontSize: 25),
                //       ),
                //       TextSpan(
                //         text: '64',
                //         style: TextStyle(
                //           fontSize: 25,
                //           backgroundColor: appColors.pinkColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                 Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'регион',
                      style: TextStyle(fontSize: 25),
                    ),
                    Container(
                      color: appColors.pinkColor,
                      child: const Text(
                        '64',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                pinned: true,
                backgroundColor: appColors.mainColor,
                bottom: TabBar(
                  controller: tabController,
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  indicatorColor: Colors.white,
                  padding: const EdgeInsets.only(
                    bottom: 3,
                    left: 8,
                    right: 8,
                  ),
                  tabs: tabs
                      .map((String name) => Tab(
                            text: name,
                            height: 30,
                          ))
                      .toList(),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.info_outline, size: 30),
                  ),
                ],
              ),
            )
          ];
        },
        body: Builder(
          builder: (context) {
            return TabBarView(
              controller: tabController,
              children: const [
                AllNews(),
                TopNews(),
                ArticleNews(),
              ],
            );
          },
        ),
      ),
    );
  }
}
