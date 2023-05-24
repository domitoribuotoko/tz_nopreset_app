import 'package:flutter/material.dart';

class ArticleNews extends StatefulWidget {
  const ArticleNews({super.key});

  @override
  State<ArticleNews> createState() => _ArticleNewsState();
}

class _ArticleNewsState extends State<ArticleNews> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: List<Widget>.generate(
              20,
              (index) => Text('item ${index + 1}'),
            ),
          ),
        ),
      ],
    );
  }
}