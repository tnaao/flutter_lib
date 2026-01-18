import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:mxbase/mxbase.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart' as ptr;

extension RefreshExt1 on IndicatorMode {
  bool get isNormal {
    return this == IndicatorMode.inactive ||
        this == IndicatorMode.processed ||
        this == IndicatorMode.done;
  }
}

extension PullToRefreshExt2 on ptr.RefreshStatus {
  bool get isNormal {
    return this == ptr.RefreshStatus.idle ||
        this == ptr.RefreshStatus.completed ||
        this == ptr.RefreshStatus.failed;
  }
}

class MyListView<T> extends StatelessWidget {
  final List<T> data;
  final IndexedWidgetBuilder itemBuilder;
  final Function? onRefresh;
  final Function? loadMore;
  Function? endRefresh;
  final bool isRefreshAutoFinish;
  final Axis direction;
  final double spaceMain;
  final double? height;
  final Key? key;
  final Key? listKey;
  final Widget? placeWidget;
  final ScrollController? scrollController;
  final EasyRefreshController? refreshController;
  final bool pullWidget;
  final ptr.RefreshController? pullToRefreshController;

  final bool isRefreshOnStart;

  final List<String> processingText;
  final List<String> loadingText;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: MyRefreshHeader(
            onRefresh: this.onRefresh,
            key: this.key,
            pullWidget: this.pullWidget,
            processingText: this.processingText,
            loadingText: this.loadingText,
            refreshController: this.refreshController,
            pullToRefreshController: this.pullToRefreshController,
            isRefreshAutoFinish: this.isRefreshAutoFinish,
            isRefreshOnStart: this.isRefreshAutoFinish,
            loadMore: this.loadMore,
            child: placeWidget ??
                ListView.separated(
                  key: this.listKey,
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
                  padding: EdgeInsets.zero,
                )));
  }

  MyListView(this.data, this.itemBuilder,
      {this.onRefresh,
      this.loadMore,
      this.endRefresh,
      this.height,
      this.key,
      this.listKey,
      this.scrollController,
      this.refreshController,
      this.pullWidget = true,
      this.pullToRefreshController,
      this.placeWidget,
      this.isRefreshOnStart = false,
      this.isRefreshAutoFinish = true,
      this.processingText = const ['刷新中...', '刷新完成'],
      this.loadingText = const ['加载中...', '加载完成'],
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
  final Key? listKey;
  final ScrollController? scrollController;
  final IndexedWidgetBuilder itemBuilder;
  final double? height;
  final double? width;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data!.length,
      key: this.listKey,
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
      separatorBuilder: (ctx, it) => SizedBox(
        width: this.direction == Axis.horizontal ? spaceMain : 0.0,
        height: this.direction == Axis.vertical ? spaceMain : 0.0,
      ),
      scrollDirection: this.direction,
      shrinkWrap: this.shrinkWrap,
      controller: this.scrollController,
      physics: this.canScroll
          ? BouncingScrollPhysics()
          : NeverScrollableScrollPhysics(),
    );
  }

  MyStillListView(this.data, this.itemBuilder,
      {this.height,
      this.scrollController,
      this.canScroll = false,
      this.listKey,
      this.direction = Axis.vertical,
      this.bgColor = Colors.transparent,
      this.shrinkWrap = true,
      this.width,
      this.spaceMain = 10.0});
}
