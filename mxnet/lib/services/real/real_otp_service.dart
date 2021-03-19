import 'dart:async';
import 'package:mxnet/entity/entity.dart';

import 'package:mxnet/services/abstract/i_otp_service.dart';
import 'package:mxnet/services/rest_client.dart';

class OTPService extends NetworkService implements IOTPService {
  OTPService(RestClient rest) : super(rest);

  @override
  Future<Resp<String>> smsCode(String phone) async {
    final url = '';
    var result = await rest.getAsync<Map<String, dynamic>>(url);
    return Resp<String>.fromJson(result.mappedResult);
  }
}
