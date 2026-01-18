import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/index.dart';
import 'package:mxbase/widgets/view/my_custom_header.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart' as ptr;
import 'package:velocity_x/velocity_x.dart';

import 'my_refresh_header.pull.dart';

class MyRefreshHeader extends StatefulWidget {
  MyRefreshHeader(
      {Key? key,
      this.child,
      this.onRefresh,
      this.loadMore,
      this.isRefreshAutoFinish = true,
      this.isRefreshOnStart = false,
      this.processingText = const ['刷新中...', '刷新完成'],
      this.loadingText = const ['加载中...', '加载完成'],
      this.textColor = const Color(0xffA6B0AC),
      this.triggerOffset = 35,
      this.maxOverOffset = 50,
      this.scrollController,
      this.pullWidget = true,
      this.pullToRefreshController,
      this.refreshController})
      : super(key: key);

  final Color textColor;
  final ScrollController? scrollController;
  final EasyRefreshController? refreshController;
  final ptr.RefreshController? pullToRefreshController;
  final Widget? child;
  final bool isRefreshAutoFinish;
  final bool isRefreshOnStart;
  final bool pullWidget;
  final Function? onRefresh;
  final Function? loadMore;
  final List<String> processingText;
  final List<String> loadingText;

  final num triggerOffset;
  final num maxOverOffset;

  @override
  State<MyRefreshHeader> createState() {
    // ignore: no_logic_in_create_state
    return pullWidget && defaultTargetPlatform != TargetPlatform.macOS
        ? MyPullToRefreshHeaderState()
        : _MyRefreshHeaderState();
  }
}

class _MyRefreshHeaderState extends State<MyRefreshHeader> {
  bool _isDisposed = false;

  bool _isNoMore = false;

  bool get _isRefreshAutoFinish =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      widget.isRefreshAutoFinish;

  @override
  void initState() {
    super.initState();

    _isDisposed = false;
    initListener();
    if (widget.isRefreshOnStart) {
      350.after().then((v) {
        _controller.callRefresh(overOffset: 45.vsp, force: false);
        3500.delay(() {
          _controller.resetHeader();
        });
      });
    }
  }

  void initListener() async {
    AppHolder.eventBus.on<MyRefreshHeaderEvent>().listen((v) {
      if (this._isDisposed) return;

      if (v.key != null && widget.key != v.key) return;

      if (v.refreshComplete) {
        _controller.finishRefresh(IndicatorResult.success);
      }
      if (v.isNoMore) {
        _controller.finishLoad(IndicatorResult.noMore);
      }
      if (v.doRefresh) _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    this._isDisposed = true;
    super.dispose();
  }

  late final EasyRefreshController _controller = widget.refreshController ??
      EasyRefreshController(
          controlFinishLoad: true, controlFinishRefresh: true);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      key: widget.key,
      refreshOnStart: false,
      header: StarCustomHeader(
        clamping: false,
        mainAxisAlignment: MainAxisAlignment.center,
        readyText: widget.processingText.first,
        dragText: widget.processingText.first,
        armedText: widget.processingText.first,
        processingText: widget.processingText.first,
        processedText: widget.processingText.last,
        showText: true,
        pullIconBuilder: (context, state, animation) => StarRefreshingIndicator(
          color: widget.textColor,
          size: 18,
        ).box.height(18.vsp).make(),
        spacing: 7.hsp,
        textStyle: TextStyle(color: widget.textColor, fontSize: 16.fsp),
        triggerOffset: widget.triggerOffset.vsp,
        maxOverOffset: widget.maxOverOffset.vsp,
      ),
      footer: ClassicFooter(
        position: IndicatorPosition.locator,
        infiniteOffset: null,
        showText: true,
        showMessage: false,
        readyText: widget.loadingText.first,
        dragText: widget.loadingText.first,
        armedText: widget.loadingText.first,
        processingText: widget.loadingText.first,
        processedText: widget.loadingText.last,
        pullIconBuilder: (context, state, animation) => StarRefreshingIndicator(
          color: widget.textColor,
          size: 18,
        ).box.height(18.vsp).make(),
        spacing: 7.hsp,
        textStyle: TextStyle(color: widget.textColor, fontSize: 16),
        triggerOffset: (widget.triggerOffset).vsp,
        maxOverOffset: (widget.maxOverOffset).vsp,
      ),
      controller: _controller,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              widget.onRefresh?.call();
              if (_isRefreshAutoFinish) {
                1500.delay(() {
                  _controller.finishRefresh(IndicatorResult.success, true);
                });
              }
              return IndicatorResult.success;
            },
      onLoad: widget.loadMore == null
          ? null
          : () async {
              widget.loadMore?.call();
              if (_isRefreshAutoFinish) {
                1500.delay(() {
                  _controller.finishLoad(IndicatorResult.success);
                });
              }
              return IndicatorResult.success;
            },
      child: widget.child,
    );
  }
}
