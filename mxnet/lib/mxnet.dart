
import 'dart:async';

import 'package:flutter/services.dart';

class Mxnet {
  static const MethodChannel _channel =
      const MethodChannel('mxnet');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
