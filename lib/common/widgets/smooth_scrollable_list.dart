import 'package:flutter/cupertino.dart';

class SmoothScrollableList extends StatefulWidget {
  SmoothScrollableList(
      {super.key,
      required this.scrollController,
      required this.itemCount,
      required this.itemBuilderWidget,
      required this.separatorBuilderWidget,
      required this.funcCheckForLoadingMore});

  ScrollController scrollController;
  int itemCount;
  Widget itemBuilderWidget;
  Widget separatorBuilderWidget;
  Function() funcCheckForLoadingMore;

  @override
  State<SmoothScrollableList> createState() =>
      _SmoothScrollableListState();
}

class _SmoothScrollableListState
    extends State<SmoothScrollableList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.scrollController
        ..addListener(() {
          if (widget.scrollController.position.pixels >
              widget.scrollController.position.maxScrollExtent) {
            widget.funcCheckForLoadingMore();
          }
        }),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (ctx, i) {
        return widget.itemBuilderWidget;
      },
      separatorBuilder: (ctx, i) {
        return widget.separatorBuilderWidget;
      },
      itemCount: widget.itemCount,
    );
  }
}
//Don't forget to wrap it inside an Expanded or a SizedBox with height specified
