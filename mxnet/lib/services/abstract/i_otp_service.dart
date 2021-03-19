import 'package:mxnet/services/network_service_model.dart';
import 'package:mxnet/entity/entity.dart';

abstract class IOTPService {
  Future<Resp<String>> smsCode(String phone);
}
