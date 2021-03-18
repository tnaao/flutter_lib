import 'package:shared_preferences/shared_preferences.dart';

class UserTokenInfo {
  static const SPKeyPrefix = "UserTokenInfo";
  static const String SP_AC_TOKEN = "$SPKeyPrefix:accessToken";
  String _token;

  UserTokenInfo._privateConstructor();

  static final UserTokenInfo _instance = UserTokenInfo._privateConstructor();

  static UserTokenInfo get instance {
    return _instance;
  }

  bool notLogin() {
    return _token == null || _token.length < 1;
  }

  void checkLogin() {
    if (this.notLogin()) {}
  }

  Future clearLogin() async {
    _token = "";
    await save();
    return;
  }

  String getToken() {
    return _token == null ? "" : _token;
  }

  Future save() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    doSave(sp);
    return Future.value(true);
  }

  Future<UserTokenInfo> load() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    doLoad(sp);
    return UserTokenInfo.instance;
  }

  void doLoad(SharedPreferences sp) {
    _token = sp.get(SP_AC_TOKEN) != null ? sp.getString(SP_AC_TOKEN) : "";
  }

  void doSave(SharedPreferences sp) async {
    await sp.setString(SP_AC_TOKEN, _token);
  }
}

class FetchDataException implements Exception {
  String message;

  FetchDataException(this.message);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class NetworkServiceResponse<T> {
  T content;
  bool success;
  String message;

  NetworkServiceResponse({this.content, this.success, this.message});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;

  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
