import 'package:flutter/material.dart';
import 'package:mxbase/widgets/my_refresh_header.dart';
import 'package:mxbase/delegate/grid_delegate.dart';

class MyGridView<T> extends StatelessWidget {
  final List<T> data;
  final int crossAxisCount;
  final double smallCellExtent;
  final double bigCellExtent;
  final EdgeInsets padding;
  final IndexedWidgetBuilder itemBuilder;
  final double spaceMain;
  final double spaceCross;
  final AxisDirection crossDirection;
  final Function onRefresh;
  final Function loadMore;
  final bool shrinkWrap;
  final double height;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: this.height,
        padding: this.padding,
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: MyRefreshHeader(
          onRefresh: this.onRefresh,
          loadMore: this.loadMore,
          child: GridView.builder(
              shrinkWrap: this.shrinkWrap,
              itemCount: data.length,
              gridDelegate: XSliverGridDelegate(
                crossAxisCount: crossAxisCount,
                smallCellExtent: smallCellExtent,
                bigCellExtent:
                    bigCellExtent < 1 ? smallCellExtent : bigCellExtent,
                mainAxisSpacing: spaceMain,
                crossAxisSpacing: spaceCross,
              ),
              itemBuilder: itemBuilder),
        ));
  }

  MyGridView(
      this.data, this.crossAxisCount, this.smallCellExtent, this.itemBuilder,
      {this.spaceMain = 0.0,
      this.spaceCross = 0.0,
      this.crossDirection,
      this.onRefresh,
      this.loadMore,
      this.bigCellExtent = 0.0,
      this.shrinkWrap = false,
      this.height,
      this.padding});
}

class MyGridViewNormal<T> extends StatelessWidget {
  final List<T> data;
  final int crossAxisCount;
  final double smallCellExtent;
  final double bigCellExtent;
  final IndexedWidgetBuilder itemBuilder;
  final double spaceMain;
  final double spaceCross;
  final AxisDirection crossDirection;
  final Function onRefresh;
  final Function loadMore;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final EdgeInsets padding;
  final double height;
  final canScroll;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: GridView.builder(
            shrinkWrap: this.shrinkWrap,
            physics: this.canScroll
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: data.length,
            scrollDirection: this.scrollDirection,
            gridDelegate: XSliverGridDelegate(
              crossAxisCount: crossAxisCount,
              smallCellExtent: smallCellExtent,
              bigCellExtent:
                  bigCellExtent < 1 ? smallCellExtent : bigCellExtent,
              mainAxisSpacing: spaceMain,
              crossAxisSpacing: spaceCross,
            ),
            itemBuilder: itemBuilder));
  }

  MyGridViewNormal(
      this.data, this.crossAxisCount, this.smallCellExtent, this.itemBuilder,
      {this.spaceMain = 0.0,
      this.spaceCross = 0.0,
      this.crossDirection,
      this.onRefresh,
      this.loadMore,
      this.bigCellExtent = 0.0,
      this.shrinkWrap = false,
      this.scrollDirection = Axis.vertical,
      this.padding,
      this.height,
      this.canScroll = false});
}
