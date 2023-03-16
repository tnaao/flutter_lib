import 'package:flutter/material.dart';
import 'package:mxbase/mxbase.dart';
import 'package:mxbase/widgets/my_refresh_header.dart';
import 'package:velocity_x/velocity_x.dart';

class MyListView<T> extends StatelessWidget {
  final List<T> data;
  final IndexedWidgetBuilder itemBuilder;
  final Function? onRefresh;
  final Function? loadMore;
  Function? endRefresh;
  final Axis direction;
  final double spaceMain;
  final double? height;
  final Key? key;
  final Widget? placeWidget;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: MyRefreshHeader(
            onRefresh: this.onRefresh,
            key: this.key,
            scrollController: scrollController,
            loadMore: this.loadMore,
            child: placeWidget ??
                ListView.separated(
                  itemCount: data.length,
                  itemBuilder: itemBuilder,
                  controller: scrollController,
                  separatorBuilder: (ctx, it) => SizedBox(
                    width: this.direction == Axis.horizontal
                        ? this.spaceMain
                        : 0.0,
                    height:
                        this.direction == Axis.vertical ? this.spaceMain : 0.0,
                  ),
                  scrollDirection: this.direction,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                )));
  }

  MyListView(this.data, this.itemBuilder,
      {this.onRefresh,
      this.loadMore,
      this.endRefresh,
      this.height,
      this.key,
      this.scrollController,
      this.placeWidget,
      this.spaceMain = 10.0,
      this.direction = Axis.vertical})
      : super(key: key);
}

class MyStillListView<T> extends StatelessWidget {
  final List<T>? data;
  final double spaceMain;
  final bool canScroll;
  final bool shrinkWrap;
  final Color bgColor;
  final ScrollController? scrollController;
  final IndexedWidgetBuilder itemBuilder;
  final double? height;
  final double? width;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        width: this.width,
        color: this.bgColor,
        child: ListView.separated(
          itemCount: data!.length,
          itemBuilder: itemBuilder,
          separatorBuilder: (ctx, it) => SizedBox(
            width: this.direction == Axis.horizontal ? spaceMain : 0.0,
            height: this.direction == Axis.vertical ? spaceMain : 0.0,
          ),
          scrollDirection: this.direction,
          shrinkWrap: this.shrinkWrap,
          controller: this.scrollController,
          physics:
              this.canScroll ? ScrollPhysics() : NeverScrollableScrollPhysics(),
        ));
  }

  MyStillListView(this.data, this.itemBuilder,
      {this.height,
      this.scrollController,
      this.canScroll = false,
      this.direction = Axis.vertical,
      this.bgColor = Colors.transparent,
      this.shrinkWrap = true,
      this.width,
      this.spaceMain = 10.0});
}
