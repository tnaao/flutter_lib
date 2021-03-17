import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mxbase/event/mx_event.dart';

class MyRefreshHeader extends StatefulWidget {
  MyRefreshHeader({Key key, this.child, this.onRefresh, this.loadMore})
      : super(key: key);

  final Widget child;
  final Function onRefresh;
  final Function loadMore;

  @override
  _MyRefreshHeaderState createState() {
    return _MyRefreshHeaderState();
  }
}

class _MyRefreshHeaderState extends State<MyRefreshHeader> {
  @override
  void initState() {
    super.initState();
    initListener();
  }

  void initListener() async {
    AppHolder.eventBus.on<MyRefreshHeaderEvent>().listen((v) {
      if (v.isNoMore) _controller.finishLoad(success: true, noMore: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  EasyRefreshController _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
      key: UniqueKey(),
      controller: _controller,
      header: BallPulseHeader(),
      footer: BallPulseFooter(),
      onRefresh: widget.onRefresh == null
          ? null
          : () async {
              if (widget.onRefresh != null) {
                widget.onRefresh();
              }
              _controller.resetLoadState();
            },
      onLoad: widget.loadMore == null
          ? null
          : () async {
              if (widget.loadMore != null) {
                widget.loadMore();
              }
              _controller.finishRefresh(success: true, noMore: false);
            },
      child: widget.child,
    ));
  }
}
