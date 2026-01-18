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

  static const String _OD = 'https://site.sailforce.online/fake.json';
  static const String HOST = _OD;

  final String _DEBUGHOSTWork = "192.168.112.192:8888";
  final String _DEBUGHOSTHome = "192.168.124.181:8888";

  String get DEBUGHOST => _DEBUGHOSTHome;
  final bool DEBUG = true;
}
