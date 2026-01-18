import 'package:flutter/material.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_loading_view.dart';
import 'package:mxbase/widgets/my_refresh_header.dart' show MyRefreshHeader;
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class MyPullToRefreshHeaderState extends State<MyRefreshHeader> {
  bool _isDisposed = false;

  final bool _isNoMore = false;

  @override
  void initState() {
    super.initState();

    _isDisposed = false;
    initListener();
  }

  void initListener() async {
    AppHolder.eventBus.on<MyRefreshHeaderEvent>().listen((v) {
      if (_isDisposed) return;

      if (v.key != null && widget.key != v.key) return;

      if (v.isNoMore) {
        _controller.loadNoData();
      }
      if (v.doRefresh) _controller.requestRefresh();
      if (v.refreshComplete) {
        _controller.refreshCompleted();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  late final RefreshController _controller = widget.pullToRefreshController ??
      RefreshController(initialRefresh: widget.isRefreshOnStart);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      key: widget.key,
      enablePullDown: widget.onRefresh != null,
      enablePullUp: widget.loadMore != null,
      scrollController: widget.scrollController,
      physics: BouncingScrollPhysics(),
      header: CustomHeader(
        height: 50.vsp,
        builder: (context, mode) {
          final loadingText = mode == RefreshStatus.completed
              ? widget.processingText.last
              : widget.processingText.first;
          return HStack(
            [
              StarRefreshingIndicator(
                color: widget.textColor,
                size: 18,
              ).box.height(18.vsp).make(),
              7.hsp.widthBox,
              Text(loadingText,
                  style: TextStyle(color: widget.textColor, fontSize: 16.fsp))
            ],
            alignment: MainAxisAlignment.center,
          ).h(50.vsp);
        },
      ),
      footer: CustomFooter(
        height: 60.vsp,
        loadStyle: LoadStyle.ShowWhenLoading,
        builder: (context, mode) {
          final loadingText = mode == LoadStatus.noMore
              ? widget.loadingText.last
              : widget.loadingText.first;
          return HStack(
            [
              StarRefreshingIndicator(
                color: widget.textColor,
                size: 18,
              ).box.height(18.vsp).make(),
              7.hsp.widthBox,
              Text(loadingText,
                  style: TextStyle(color: widget.textColor, fontSize: 16.fsp))
            ],
            alignment: MainAxisAlignment.center,
          ).h(60.vsp);
        },
      ),
      controller: _controller,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              widget.onRefresh?.call();
              if (widget.isRefreshAutoFinish) {
                // _controller.resetFooter();
                1500.delay(() {
                  _controller.refreshCompleted();
                });
              }
            },
      onLoading: widget.loadMore == null
          ? null
          : () async {
              widget.loadMore?.call();
              if (widget.isRefreshAutoFinish) {
                1500.delay(() {
                  _controller.loadComplete();
                });
              }
            },
      child: widget.child,
    );
  }
}
