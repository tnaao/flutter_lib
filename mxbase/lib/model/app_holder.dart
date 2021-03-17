import 'package:event_bus/event_bus.dart';

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
}
