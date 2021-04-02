
import 'dart:async';

import 'package:flutter/services.dart';

class Nati {
  static const MethodChannel _channel =
      const MethodChannel('nati');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
