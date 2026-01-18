library mx_event_lib;

import 'package:flutter/material.dart';

export 'package:event_bus/event_bus.dart';
export 'package:mxbase/model/app_holder.dart';

abstract class MxEvent {}

class MyRefreshHeaderEvent {
  final bool isNoMore;
  final bool doRefresh;
  final bool refreshComplete;
  final Key? key;

  MyRefreshHeaderEvent({
    this.isNoMore = false,
    this.doRefresh = false,
    this.refreshComplete = false,
    this.key,
  });
}

class MyRoundedSearchInputClearEvent extends MxEvent {
  final Key key;

  MyRoundedSearchInputClearEvent(this.key);
}

class MxLoginCheckEvent extends MxEvent {}

class MxKeyboardDismissEvent {
  final Key key;

  MxKeyboardDismissEvent(this.key);
}

class MxMineUpdateUserInfoEvent extends MxEvent {
  final bool notLogin;

  MxMineUpdateUserInfoEvent({this.notLogin = false});
}

class MxAlipayBindEvent extends MxEvent {}

class MxAlipayAuthEvent extends MxEvent {}

class MxWechatAuthEvent extends MxEvent {}

class MxGoLoginEvent extends MxEvent {
  final bool isGo;
  final bool needClear;
  final bool isToastAll;

  MxGoLoginEvent(
      {this.isGo = false, this.isToastAll = false, this.needClear = false});
}

class MxGoPathEvent extends MxEvent {
  final String path;
  final Object? args;
  final bool isGo;
  final void Function<T>(T?)? onBackData;
  MxGoPathEvent(this.path, {this.args, this.isGo = false, this.onBackData});
}

class MxBackAndGoEvent extends MxEvent {
  final String path;
  final Object? args;
  final void Function<T>(T?)? onBackData;
  MxBackAndGoEvent(this.path, {this.args, this.onBackData});
}

class MxGoRouteEvent extends MxEvent {
  final Widget Function(BuildContext) goRouteMethod;

  MxGoRouteEvent(this.goRouteMethod);
}

class MxApiToast extends MxEvent {
  final String? msg;

  MxApiToast(this.msg);
}

class MxRouteBackEvent extends MxEvent {
  final String? path;
  final int pageCount;
  MxRouteBackEvent({this.path, this.pageCount = 0});

  static MxRouteBackEvent get instance {
    return MxRouteBackEvent();
  }
}

class MxLoginEvent extends MxEvent {}

class MxBottomBarEvent extends MxEvent {
  final double height;

  MxBottomBarEvent(this.height);
}
