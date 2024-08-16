library mx_base_library;

export 'package:mxbase/ext/mx_ext_functions.dart';
export 'package:mxbase/widgets/index.dart';
export 'package:mxbase/model/uidata.dart';
export 'package:mxbase/model/user_info.dart';
export 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:flutter/services.dart';

class Mxbase {
  static const MethodChannel _channel = const MethodChannel('mxbase');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
