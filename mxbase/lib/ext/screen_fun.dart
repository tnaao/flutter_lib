import 'package:flutter/material.dart';
import '../model/user_info.dart';

mixin MxScreen {
  Size get deviceSize => MxBaseUserInfo.instance.deviceSize;

  double get deviceWidth => deviceSize.width;

  double get deviceHeight => deviceSize.height;

  double get appBarHeight => MxBaseUserInfo.instance.appBarHeight;

  double get contentHeight => deviceHeight - appBarHeight;

  double get statusHeight => MxBaseUserInfo.instance.statusHeight;

  double get navigationHeight => MxBaseUserInfo.instance.naviHeight;

  double get systemAppBarHeight => MxBaseUserInfo.instance.systemAppBarHeight;
}
