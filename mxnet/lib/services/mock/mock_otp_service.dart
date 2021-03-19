import 'package:mxnet/services/abstract/i_otp_service.dart';

abstract class MockOTPService implements IOTPService {
  Future delay() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
