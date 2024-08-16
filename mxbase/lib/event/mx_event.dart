library mx_event_lib;

import 'package:flutter/material.dart';
export 'package:mxbase/model/app_holder.dart';
export 'package:event_bus/event_bus.dart';

abstract class MxEvent {}

class MyRefreshHeaderEvent {
  final bool isNoMore;
  final bool doRefresh;
  final Key? key;

  MyRefreshHeaderEvent({
    this.isNoMore = false,
    this.doRefresh = false,
    this.key,
  });
}

class MyRoundedSearchInputClearEvent extends MxEvent {
  final Key key;

  MyRoundedSearchInputClearEvent(this.key);
}

class MxLoginCheckEvent {}

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

  MxGoPathEvent(this.path, {this.args});
}

class MxGoRouteEvent extends MxEvent {
  final Function(BuildContext) goRouteMethod;

  MxGoRouteEvent(this.goRouteMethod);
}

class MxApiToast extends MxEvent {
  final String? msg;

  MxApiToast(this.msg);
}

class MxRouteBackEvent extends MxEvent {}

class MxLoginEvent extends MxEvent {}

class MxBottomBarEvent extends MxEvent {
  final double height;

  MxBottomBarEvent(this.height);
}
