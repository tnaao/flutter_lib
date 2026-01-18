import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mxbase/delegate/grid_delegate.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_refresh_header.dart';

class MyGridView<T> extends StatelessWidget {
  final List<T> data;
  final int crossAxisCount;
  final double smallCellExtent;
  final double bigCellExtent;
  final double childRatio;
  final EdgeInsets? padding;

  final IndexedWidgetBuilder itemBuilder;
  final double spaceMain;
  final double spaceCross;
  final AxisDirection? crossDirection;

  final Function? onRefresh;

  final Function? loadMore;

  final bool shrinkWrap;
  final double? height;

  final Color? bgColor;
  final ScrollController? scrollController;
  final List<String> processingText;
  final List<String> loadingText;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        padding: this.padding,
        decoration: BoxDecoration(
            color: this.bgColor ?? Theme.of(context).scaffoldBackgroundColor),
        child: MyRefreshHeader(
          key: key,
          onRefresh: this.onRefresh,
          loadMore: this.loadMore,
          pullWidget: true,
          processingText: this.processingText,
          loadingText: this.loadingText,
          child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: scrollController,
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

  const MyGridView(
      this.data, this.crossAxisCount, this.smallCellExtent, this.itemBuilder,
      {super.key,
      this.spaceMain = 0.0,
      this.spaceCross = 0.0,
      this.crossDirection,
      this.childRatio = 1.0,
      this.scrollController,
      this.onRefresh,
      this.loadMore,
      this.bigCellExtent = 0.0,
      this.shrinkWrap = false,
      this.processingText = const ['刷新中...', '刷新完成'],
      this.loadingText = const ['加载中...', '加载完成'],
      this.height,
      this.padding,
      this.bgColor = Colors.transparent});
}

class MyGridViewNormal<T> extends StatelessWidget {
  final List<T> data;
  final Color? bgColor;

  final int crossAxisCount;
  final double smallCellExtent;
  final double bigCellExtent;
  final double childRatio;
  final IndexedWidgetBuilder itemBuilder;
  final double spaceMain;
  final double spaceCross;
  final AxisDirection? crossDirection;

  final Function? onRefresh;

  final Function? loadMore;

  final bool shrinkWrap;
  final Axis scrollDirection;
  final EdgeInsets? padding;

  final double? height;

  final canScroll;

  @override
  Widget build(BuildContext context) {
    int rowCount = (data.length * 1.0 / crossAxisCount).ceil();
    return Container(
        height: this.scrollDirection == Axis.vertical
            ? this.height ??
                rowCount * smallCellExtent + spaceMain * (rowCount - 1)
            : this.height,
        color: this.bgColor,
        child: GridView.builder(
            shrinkWrap: this.shrinkWrap,
            physics: this.canScroll
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: data.length,
            padding: EdgeInsets.zero,
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
      this.childRatio = 1.0,
      this.shrinkWrap = false,
      this.scrollDirection = Axis.vertical,
      this.padding,
      this.height,
      this.canScroll = false,
      this.bgColor});
}

class MyStaggerGridNormal<T> extends StatelessWidget {
  final List<T> data;
  final int crossAxisCount;
  final double smallCellExtent;
  final double bigCellExtent;
  final IndexedWidgetBuilder itemBuilder;
  final double spaceMain;
  final double spaceCross;
  final AxisDirection? crossDirection;

  final Function? onRefresh;

  final Function? loadMore;

  final bool shrinkWrap;
  final Axis scrollDirection;
  final EdgeInsets? padding;

  final double? height;

  final canScroll;

  @override
  Widget build(BuildContext context) {
    if (true)
      return Container(
          height: this.height,
          child: AlignedGridView.count(
            crossAxisCount: crossAxisCount,
            itemCount: this.data.length,
            physics: this.canScroll
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            shrinkWrap: this.shrinkWrap,
            itemBuilder: this.itemBuilder,
          ));

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

  MyStaggerGridNormal(
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
