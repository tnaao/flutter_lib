library mx_base_library;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mxbase/model/uidata.dart';

export 'package:mxbase/ext/mx_ext_functions.dart';
export 'package:mxbase/model/uidata.dart';
export 'package:mxbase/model/user_info.dart';
export 'package:mxbase/widgets/index.dart';
export 'package:shared_preferences/shared_preferences.dart';

class Mxbase {
  static const MethodChannel _channel = const MethodChannel('mxbase');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> exitApp() async {
    await _channel.invokeMethod('exitApp');
  }

  static Future<void> blePermissionAlert() async {
    if (!UIData.isIOS()) {
      return;
    }
    await _channel.invokeMethod('blePermissionCheck');
  }
}
