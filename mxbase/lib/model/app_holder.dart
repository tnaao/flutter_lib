import 'package:event_bus/event_bus.dart';
import 'package:mxbase/event/mx_event.dart';

extension MxEventExtension on MxEvent {
  void send() {
    AppHolder.eventBus.fire(this);
  }
}

class AppHolder {
  static final AppHolder _instance = AppHolder._privateConstructor();

  static AppHolder get instance {
    return _instance;
  }

  AppHolder._privateConstructor();

  static final EventBus _bus = EventBus();

  static EventBus get eventBus {
    return _bus;
  }

  static const String _OD = 'http://192.168.60.200';
  static const String _OT = 'http://fwzx.admin.alarmtech.com.cn';
  static const String _ONLINE = 'https://api.syedu.vip/';
  static String _ONLINEJS = 'http://fwzx.admin.hzyl.cn:8040';
  static String _ONLINEHN = 'http://fwzx.hnsmz.hzyl.cn:8090';
  static String _ONLINEWC = 'https://wcorg.hzyl.cn:5443';
  static String _GRAY = 'http://grayylgj.alarmtech.com.cn:8090';

  static const String HOST = true ? _ONLINE : _ONLINE;

  String get WxMiniHost => HOST.contains(_OT) ? _WxOT : _WxONLINE;

  String get H5Host => HOST.contains(_OT) ? _H5OT : _H5ONLINE;

  static String _H5OT = 'http://h5t.zihaiguo.com:8081';
  static String _H5ONLINE = 'https://h5.zihaiguo.com';

  static String _WxOT = 'https://mallft.zihaiguo.com';
  static String _WxONLINE = 'https://mallf.zihaiguo.com';

  final String _DEBUGHOSTWork = "192.168.101.44:8888";
  final String _DEBUGHOSTHome = "192.168.0.105:8888";

  String get DEBUGHOST => _DEBUGHOSTWork;
  final bool DEBUG = true;
  final String H5PrivacyURL = 'http://ylgj.support.alarmtech.com.cn:8090/#/';
}
