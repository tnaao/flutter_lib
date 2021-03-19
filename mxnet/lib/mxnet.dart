import 'dart:async';
import 'dart:convert';
import 'package:mxnet/services/abstract/i_otp_service.dart';
import 'package:mxnet/services/dependency_injection.dart';
import 'package:flutter/services.dart';

class Mxnet {
  static const MethodChannel _channel = const MethodChannel('mxnet');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class CommonBloc {
  IOTPService otpRepo = new Injector().otpService;
}

extension MxNetConvert on String {
  static final HOST = '';

  String entry2URL() {
    var entry = this;
    if (entry.substring(0, 1) == '/') entry = entry.substring(1);
    return HOST + '/' + entry;
  }

  String getConvert(dynamic req) {
    String temp = this.entry2URL() + '?';
    Map<String, dynamic> map = jsonDecode(jsonEncode(req));

    map.keys.forEach((aKey) {
      if (map[aKey] == null) return;
      temp += aKey + '=' + map[aKey].toString() + '&';
    });
    return temp;
  }
}
