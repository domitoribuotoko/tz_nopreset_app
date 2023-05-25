import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/base/app_constants.dart';
import 'package:tz_nopreset_app/base/app_methods.dart';
import 'package:tz_nopreset_app/pages/news_detailed_page.dart';
import 'package:tz_nopreset_app/repository/repo.dart';

import '../news_list_bloc/news_bloc_bloc.dart';

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // pinnedHeaderSliverHeightBuilder: () {
        //   return 100;
        // },
        // onlyOneScrollInBody: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                toolbarHeight: 50,
                title: Row(
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
                // forceElevated: innerBoxIsScrolled,
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
                    child: Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            return BlocProvider<NewsBlocBloc>(
              create: (context) => NewsBlocBloc(Repository())..add(GetInitialNewEvent()),
              child: BlocBuilder<NewsBlocBloc, NewsBlocState>(
                builder: (context, state) {
                  if (state is NewsBlocInitialState) {
                    return Container();
                  }
                  if (state is LoadedInitialNewsState) {
                    return ExtendedTabBarView(
                      cacheExtent: 3,
                      controller: tabController,
                      children: [
                        _newsScrollView(context, tabs[0], state.initNews.all, state.initNews),
                        _newsScrollView(context, tabs[1], state.initNews.top, state.initNews),
                        _newsScrollView(context, tabs[2], state.initNews.articles, state.initNews),
                      ],
                    );
                  }
                  if (state is RefreshingState) {
                    return ExtendedTabBarView(
                      cacheExtent: 3,
                      controller: tabController,
                      children: [
                        _newsScrollView(context, tabs[0], state.initNews.all, state.initNews),
                        _newsScrollView(context, tabs[1], state.initNews.top, state.initNews),
                        _newsScrollView(context, tabs[2], state.initNews.articles, state.initNews),
                      ],
                    );
                  }
                  if (state is LoadingErrorState) {
                    return Center(
                      child: Text(
                        'Error ${state.error}',
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _newsScrollView(BuildContext context, String keyName, List<News> news, InitialNews currentNews) {
    double pagesCount = news.length / 20;
    double expectPages = pagesCount + 1;

    final ScrollController scrollController = ScrollController();
    return Builder(
      builder: (context) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (context.read<NewsBlocBloc>().state is RefreshingState) {
              return true;
            }
            if (context.read<NewsBlocBloc>().state is LoadedInitialNewsState) {
              if (notification.metrics.extentAfter < (scrollController.position.maxScrollExtent / 5) &&
                  scrollController.position.userScrollDirection.name == 'reverse') {
                if (expectPages - pagesCount == 1) {
                  pagesCount = pagesCount + 1;
                  context.read<NewsBlocBloc>().add(RefreshEvent(currentNews, keyName, 'add'));
                }
              }
            }

            return true;
          },
          child: RefreshIndicator(
            edgeOffset: 135,
            displacement: 30,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            color: appColors.pinkColor,
            onRefresh: () {
              context.read<NewsBlocBloc>().add(RefreshEvent(currentNews, keyName, 'refresh'));
              return Future<void>.delayed(const Duration(microseconds: 2000));
            },
            child: CustomScrollView(
              // cacheExtent: 20,
              controller: scrollController,
              key: PageStorageKey<String>(keyName),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList.separated(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    return _newsContainerWidget(news[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                        color: Colors.grey[200],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _newsContainerWidget(News news) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NewsDetailedPage(id: news.id!);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(
          maxWidth: metrix.screenwidth,
        ),
        // color: Colors.red,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text(
                        method.adaptiveShowTime(news.date!),
                        style: TextStyle(
                          color: appColors.pinkColor,
                        ),
                      ),
                    ),
                    Text(
                      news.title!,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: news.important == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            news.img == ''
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: metrix.screenwidth * 1 / 3.5,
                      minWidth: metrix.screenwidth * 1 / 3.5,
                      minHeight: metrix.screenwidth * 1 / 5,
                      maxHeight: metrix.screenwidth * 1 / 5,
                    ),
                    child: CachedNetworkImage(
                      cacheManager: CacheManager(
                        Config(
                          UniqueKey().toString(),
                          // maxNrOfCacheObjects: 50,
                          stalePeriod: const Duration(hours: 1),
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageUrl: news.img!,
                      fit: BoxFit.cover,
                    )
                    //  Image.network(
                    //   news.img!,
                    //   fit: BoxFit.cover,
                    // ),
                    ),
          ],
        ),
      ),
    );
  }
}
