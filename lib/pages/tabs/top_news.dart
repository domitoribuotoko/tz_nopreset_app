import 'package:flutter/material.dart';
class TopNews extends StatefulWidget {
  const TopNews({super.key});

  @override
  State<TopNews> createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
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
              15,
              (index) => Text('item ${index + 1}'),
            ),
          ),
        ),
      ],
    );
  }
}