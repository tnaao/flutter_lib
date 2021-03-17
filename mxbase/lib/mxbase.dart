
import 'dart:async';

import 'package:flutter/services.dart';

class Mxbase {
  static const MethodChannel _channel =
      const MethodChannel('mxbase');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
