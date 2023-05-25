import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/base/app_constants.dart';
import 'package:tz_nopreset_app/base/app_methods.dart';
import 'package:tz_nopreset_app/news_details_bloc/news_details_bloc_bloc.dart';
import 'package:tz_nopreset_app/repository/repo.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailedPage extends StatefulWidget {
  final String id;
  const NewsDetailedPage({
    required this.id,
    super.key,
  });

  @override
  State<NewsDetailedPage> createState() => _NewsDetailedPageState();
}

class _NewsDetailedPageState extends State<NewsDetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aa'),
        centerTitle: true,
        backgroundColor: appColors.mainColor,
        actions: const [
          Padding(
            padding: EdgeInsets.only(
              right: 15,
            ),
            child: Icon(
              Icons.share,
              size: 30,
            ),
          ),
        ],
      ),
      body: BlocProvider<NewsDetailsBlocBloc>(
        create: (context) => NewsDetailsBlocBloc(Repository())..add(GetNewsDetailesEvent(widget.id)),
        child: BlocBuilder<NewsDetailsBlocBloc, NewsDetailsBlocState>(
          builder: (context, state) {
            if (state is NewsDetailsBlocInitial) {
              return Container();
            }
            if (state is LoadedNewsDetailesState) {
              return pageBodyWidget(state.newsDetailes);
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
      ),
    );
  }

  Widget pageBodyWidget(Data newsDetailes) {
    ValueNotifier currentImage = ValueNotifier(1);
    return SingleChildScrollView(
      child: Column(
        children: [
          newsDetailes.img != null
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: metrix.screenwidth,
                    maxHeight: metrix.screenwidth / 1.7,
                    minHeight: metrix.screenwidth / 1.7,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                    ),
                    child: CachedNetworkImage(
                      // fadeInDuration: const Duration(milliseconds: 150),
                      imageUrl: newsDetailes.img!,
                      fit: BoxFit.cover,
                    ),
                    // Image.network(
                    //   newsDetailes.img!,
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.showTime(newsDetailes.date!),
                  style: TextStyle(
                    fontSize: 15,
                    color: appColors.pinkColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  newsDetailes.title!,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 30,
                  color: Colors.grey[350],
                ),
                Html(
                  onLinkTap: (url, attributes, element) async {
                    if (url!.contains('https://sarnovosti.ru/news/')) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return NewsDetailedPage(id: url.substring(27));
                          },
                        ),
                      );
                    } else {
                      final Uri link = Uri.parse(url);
                      if (!await launchUrl(
                        link,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw Exception('Could not launch $link');
                      }
                    }

                    // print(url.substring(27));
                  },
                  data: newsDetailes.text,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: EdgeInsets.zero,
                      fontSize: FontSize(19.0),
                      fontWeight: FontWeight.normal,
                    ),
                    "a": Style(
                      color: appColors.pinkColor,
                    ),
                  },
                ),
              ],
            ),
          ),
          newsDetailes.gallery != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    // top: 15,
                  ),
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: newsDetailes.gallery!.length,
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                          return CachedNetworkImage(
                            // fadeInDuration: const Duration(milliseconds: 150),
                            imageUrl: newsDetailes.gallery![itemIndex].smallImg!,
                            fit: BoxFit.fill,
                          );
                          //  Image.network(
                          //   newsDetailes.gallery![itemIndex].smallImg!,
                          //   width: metrix.screenwidth,
                          //   fit: BoxFit.fill,
                          // );
                        },
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            currentImage.value = index + 1;
                          },
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          autoPlay: false,
                          height: metrix.screenwidth / 1.7,
                          enlargeCenterPage: false,
                          // enlargeFactor: 0.3,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: currentImage,
                        builder: (context, value, _) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${currentImage.value} из ${newsDetailes.gallery!.length}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
