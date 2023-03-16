import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MyRefreshHeader extends StatefulWidget {
  MyRefreshHeader(
      {Key? key,
      this.child,
      this.onRefresh,
      this.loadMore,
      this.isRefreshAutoFinish = true,
      this.scrollController})
      : super(key: key);

  final ScrollController? scrollController;
  final Widget? child;
  final bool isRefreshAutoFinish;
  final Function? onRefresh;
  final Function? loadMore;

  @override
  _MyRefreshHeaderState createState() {
    return _MyRefreshHeaderState();
  }
}

class _MyRefreshHeaderState extends State<MyRefreshHeader> {
  bool _isDisposed = false;

  bool _isNoMore = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    this._isDisposed = false;
    initListener();
  }

  void initListener() async {
    AppHolder.eventBus.on<MyRefreshHeaderEvent>().listen((v) {
      if (this._isDisposed) return;

      if (v.key != null && widget.key != v.key) return;

      if (v.isNoMore) {
        _controller.finishRefresh(noMore: v.isNoMore);
      }
      if (v.doRefresh) _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    this._isDisposed = true;
    super.dispose();
  }

  late EasyRefreshController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
      key: widget.key,
      controller: _controller,
      scrollController: widget.scrollController,
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
              _controller.resetLoadState();
              if (widget.isRefreshAutoFinish) {
                1500.delay(() {
                  _controller.finishRefresh();
                });
              }
            },
      onLoad: widget.loadMore == null
          ? null
          : () async {
              if (widget.loadMore != null) {
                widget.loadMore!();
              }
              if (widget.isRefreshAutoFinish) {
                1500.delay(() {
                  _controller.finishLoad(noMore: _isNoMore);
                });
              }
            },
      child: widget.child,
    ));
  }
}
