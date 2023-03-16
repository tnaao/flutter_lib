library mx_net_lib;

import 'dart:async';
import 'dart:convert';
import 'package:mxnet/services/abstract/i_otp_service.dart';
import 'package:mxnet/services/dependency_injection.dart';
import 'package:flutter/services.dart';
import 'package:mxbase/model/app_holder.dart';

export 'package:mxnet/services/network_service_model.dart';
export 'package:mxnet/services/rest_client.dart';
export 'package:mxnet/services/dependency_injection.dart';

class Mxnet {
  static const MethodChannel _channel = const MethodChannel('mxnet');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class CommonBloc {
  IOTPService? otpRepo = new Injector().otpService;
}

extension MxNetConvert on String? {
  static final HOST = AppHolder.HOST;

  String addUrlArgs(String url, List args) {
    String temp = url;

    for (int i = 0; i < args.length; i++) {
      String item = args[i] == null ? '' : args[i].toString();
      temp = temp.replaceFirst('{' + (i + 1).toString() + '}', item);
    }
    return temp;
  }

  String entry2URL() {
    if (this == null) return '';
    var entry = this!;
    if (entry.contains(HOST) || entry.startsWith('http')) return entry;
    if (entry.substring(0, 1) == '/') entry = entry.substring(1);
    return HOST + '/' + entry;
  }

  String wxMiniEntry2URL() {
    if (this == null) return '';
    var entry = this!;
    if (entry.contains(AppHolder.instance.WxMiniHost) ||
        entry.startsWith('http')) return entry;
    if (entry.substring(0, 1) == '/') entry = entry.substring(1);
    return AppHolder.instance.WxMiniHost + '/' + entry;
  }

  String mxRoute() {
    if (this == null) return '';

    var url = '$this';
    if (url.contains('?')) {
      return Uri.encodeFull(url.split('?').first);
    }

    return Uri.encodeFull('$url');
  }

  String mxUri() {
    if (this == null) return '';

    var url = '$this';
    if (!url.contains('isApp')) {
      url += url.contains('?') ? '&isApp=true' : '/?isApp=true';
    }
    if (!url.contains('playsinline')) {
      url += url.contains('?') ? '&playsinline=1' : '/?playsinline=1';
    }

    return Uri.encodeFull('$url');
  }

  String getConvert(dynamic req) {
    String temp = this.entry2URL() + '?';
    Map<String, dynamic> map = jsonDecode(jsonEncode(req));
    print('req' + map.toString());

    map.keys.forEach((aKey) {
      if (map[aKey] == null) return;
      temp += aKey + '=' + map[aKey].toString() + '&';
    });
    return temp;
  }
}
