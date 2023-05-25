import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tz_nopreset_app/base/app_classes.dart';
import 'package:tz_nopreset_app/base/app_constants.dart';
import 'package:tz_nopreset_app/base/app_methods.dart';
import 'package:tz_nopreset_app/news_details_bloc/news_details_bloc_bloc.dart';
import 'package:tz_nopreset_app/repository/repo.dart';

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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: metrix.screenwidth - 30,
              maxHeight: metrix.screenwidth / 1.83,
            ),
            child: Image.network(
              newsDetailes.img!,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              method.showTime(newsDetailes.date!),
              style: TextStyle(
                fontSize: 15,
                color: appColors.pinkColor,
              ),
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
          // Html(
          //   data: newsDetailes.text,
          // )
        ],
      ),
    );
  }
}
