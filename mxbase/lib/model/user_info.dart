// 用户信息
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/mx_theme_config.dart';
import 'dart:convert';

//abstract class SharedPreferences {
//  Object get(String key);
//
//  String getString(String key);
//
//  bool getBool(String key);
//
//  void setString(String key, String value);
//
//  void setBool(String key, bool value);
//
//  void setInt(String key, int value);
//}

class TokenInfoBean {
  TokenInfoBean({
    this.token,
  });

  String? token;

  factory TokenInfoBean.fromJson(Map<String, dynamic> json) => TokenInfoBean(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

class MxBaseUserInfo {
  static const SPKeyPrefix = "UserInfo";

  static const String SP_THEME_COLOR = '$SPKeyPrefix:THEME_COLOR';
  static const String SP_AC_TOKEN = "$SPKeyPrefix:accessToken";
  static const String SP_RE_TOKEN = "$SPKeyPrefix:refreshToken";
  static const String SP_UID = "$SPKeyPrefix:uid";
  static const String SP_IS_LOGIN = "$SPKeyPrefix:isLogin";
  static const String SP_EXPIRES_IN = "$SPKeyPrefix:expiresIn";
  static const String SP_TOKEN_TYPE = "$SPKeyPrefix:tokenType";

  static const String SP_USER_THEME = "theme.color.key";
  static const String SP_THEME_CONFIG = "theme.config.json";
  static const String SP_USER_TOKEN = "$SPKeyPrefix:token";
  static const String SP_ACCOUNT = "$SPKeyPrefix:account";
  static const String SP_PASSWORD = "$SPKeyPrefix:password";
  static const String SP_USER_TYPE = "$SPKeyPrefix:userType";
  static const String SP_USER_RONG_TOKEN = "$SPKeyPrefix:rong_token";
  static const String SP_USER_NAME = "$SPKeyPrefix:name";
  static const String SP_USER_GRADE_INFO = "$SPKeyPrefix:grade_info";
  static const String SP_USER_NICK = "$SPKeyPrefix:nick";
  static const String SP_USER_WEIXIN_ID = "$SPKeyPrefix:weixin_id";
  static const String SP_USER_DESC = "$SPKeyPrefix:desc";
  static const String _SP_USER_PHONE = "$SPKeyPrefix:phone";
  static const String SP_USER_PROMOTER_NAME = "$SPKeyPrefix:promoterName";
  static const String SP_USER_ID = "$SPKeyPrefix:id";
  static const String SP_USER_LOC = "$SPKeyPrefix:location";
  static const String SP_USER_GENDER = "$SPKeyPrefix:gender";
  static const String SP_Language = "$SPKeyPrefix:language";
  static const String SP_tenantName = "$SPKeyPrefix:tenantName";
  static const String SP_TENANT_CODE = "$SPKeyPrefix:tenantCode";
  static const String SP_USER_AVATAR = "$SPKeyPrefix:avatar";
  static const String _SP_ENV = "$SPKeyPrefix:env";
  static const String SP_USER_EMAIL = "$SPKeyPrefix:email";
  static const String SP_USER_URL = "$SPKeyPrefix:url";
  static const String SP_FIRST_RUN = "$SPKeyPrefix:firstRun";
  static const String SP_SEARCH_HISTORY_MAP = "$SPKeyPrefix:searchHistoryMap";

  Map collectNumMap = Map();
  Map cartNumMap = Map();

  bool isVip = true;

  String get systemEnv {
    return _env.isTextEmpty ? 'prod' : '$_env';
  }

  String? get rtcUserAccount => phone.xCommunicateElderRelativePrefix;

  MxBaseUserInfo._privateConstructor();

  static final MxBaseUserInfo _instance = MxBaseUserInfo._privateConstructor();

  static MxBaseUserInfo get instance {
    return _instance;
  }

  Map<String, dynamic> searchHistoryMap = Map();
  double statusHeight = 0.0;
  double appBarHeight = 60.0;
  double systemAppBarHeight = AppBar().preferredSize.height;
  double naviHeight = 0.0;

  bool get hasBottomNavi => naviHeight > double.minPositive;

  double bottomBarHeight = 46.0;
  String? gender = null;
  String? name = '';
  String address = '';
  String? _nickname = '';
  String? _tenantName = '';
  String? _userType = '';
  String? desc = '';
  String? _env = '';
  String? phone = '';
  String? conselor;
  String? grade;
  String? wxId;
  String? avatar;
  String? userId = "";
  String? tenantCode = "";
  String? account;
  String? password;

  String get displayId {
    return userId.isTextEmpty ? '' : '$userId';
  }

  String get tenantName {
    return _tenantName.isTextEmpty ? '' : '$_tenantName';
  }

  String get displayName {
    return _nickname.isTextEmpty ? '' : '$_nickname';
  }

  bool get isAppRelative {
    return _userType == 'RELATIVES';
  }

  String promoter = '';
  Color? themeColor;
  MxThemeConfig themeConfig = MxThemeConfig();
  int swipeSpeed = 10;
  bool autoPlay = false;

  String? email;
  String? url;
  Size deviceSize = Size.zero;
  double screenFullHeight = double.infinity;
  String? location;
  String? _token;
  String? rongToken;

  bool ipsPubHide = true;

  bool firstRun = true;

  int language = 0;

  bool get isBind {
    return this.phone != null && this.phone!.length > 10;
  }

  double dialogH({num min = 0, bool hasLimit = true, num minus = 0.0}) {
    if (!hasLimit) return double.infinity;
    var dialogMax = this.deviceSize.height * 0.75;
    return max(min, dialogMax).toDouble() - minus.hsp;
  }

  double get safeBottomH {
    return this.screenFullHeight!.natureVal -
        statusHeight.natureVal -
        this.deviceSize.height.natureVal;
  }

  void upFirst(bool value) {
    firstRun = value;
  }

  bool notLogin() {
    return _token == null || _token!.length < 1;
  }

  void checkLogin() {
    if (this.notLogin()) {}
  }

  Future<void> clearLogin() async {
    _token = "";
    userId = "";
    _nickname = "";
    account = "";
    password = "";
    phone = "";
    var sp = await SharedPreferences.getInstance();
    await save();
    return;
  }

  void upTheme() async {}

  Future<MxBaseUserInfo> parseLogin(dynamic model,
      {bool upToken = true}) async {
    if (model == null) return MxBaseUserInfo.instance;

    var infoBean = TokenInfoBean.fromJson(Map<String, dynamic>.from(model));

    if (upToken && infoBean.token != null) {
      _token = infoBean.token;
    }

    userId = model['userId']?.toString();
    this._nickname = model['nickname']?.toString();
    this.phone = model['phone'];
    if (!model['userType'].toString().isTextEmpty) {
      this._userType = model['userType'];
    }
    if (!model['env'].toString().isTextEmpty) {
      this._env = model['env'];
    }
    if (model['tenantCode'] != null) {
      this.tenantCode = model['tenantCode'];
    }
    if (model['tenantName'] != null) {
      this._tenantName = model['tenantName'];
    }
    if (model['pic'] != null) {
      this.avatar = model['pic'];
    }
    await save();
    return MxBaseUserInfo.instance;
  }

  Future updateInfo(
      {String? userId,
      String? phone,
      String? username,
      String? nickname}) async {
    this.userId = userId;
    this.name = username;
    this.phone = phone;
    this._nickname = nickname;
    this.save();
    return true;
  }

  String? getToken() {
    return _token == null ? "" : _token;
  }

  Future<bool> save() async {
    var sp = await SharedPreferences.getInstance();
    await doSave(sp);
    return true;
  }

  void saveSearchHis() async {}

  Future<Map<String, dynamic>> loadSearchHis() async {
    return searchHistoryMap;
  }

  Future<MxBaseUserInfo> load() async {
    var sp = await SharedPreferences.getInstance();
    _doLoad(sp);
    return MxBaseUserInfo.instance;
  }

  void updateThemeConfig(MxThemeConfig config) {
    themeConfig.copyFrom(config);
    save();
  }

  void _doLoad(SharedPreferences sp) {
    this.account = sp.getString(SP_ACCOUNT);
    this.password = sp.getString(SP_PASSWORD);
    this.language = sp.getInt(SP_Language) ?? 0;
    gender =
        sp.get(SP_USER_GENDER) != null ? sp.getString(SP_USER_GENDER) : "男";
    name = sp.get(SP_USER_NAME) != null ? sp.getString(SP_USER_NAME) : "";
    tenantCode =
        sp.get(SP_TENANT_CODE) != null ? sp.getString(SP_TENANT_CODE) : "";
    _tenantName =
        sp.get(SP_tenantName) != null ? sp.getString(SP_tenantName) : "";
    _nickname =
        sp.get(SP_USER_NICK) != null ? sp.getString(SP_USER_NICK) : _nickname;
    desc = sp.get(SP_USER_DESC) != null ? sp.getString(SP_USER_DESC) : desc;
    phone = sp.get(_SP_USER_PHONE) != null ? sp.getString(_SP_USER_PHONE) : "";
    wxId = sp.get(SP_USER_WEIXIN_ID) != null
        ? sp.getString(SP_USER_WEIXIN_ID)
        : "";
    promoter = sp.get(SP_USER_PROMOTER_NAME) != null
        ? sp.getString(SP_USER_PROMOTER_NAME)!
        : "";
    avatar = sp.get(SP_USER_AVATAR) != null ? sp.getString(SP_USER_AVATAR) : "";
    address = sp.get(SP_USER_LOC) != null ? sp.getString(SP_USER_LOC)! : "";
    userId = sp.get(SP_UID) != null ? sp.getString(SP_UID) : null;
    _token = sp.get(SP_USER_TOKEN) != null ? sp.getString(SP_USER_TOKEN) : "";
    _userType = sp.get(SP_USER_TYPE) != null ? sp.getString(SP_USER_TYPE) : "";
    _env = sp.get(_SP_ENV) != null ? sp.getString(_SP_ENV) : "";
    rongToken = sp.get(SP_USER_RONG_TOKEN) != null
        ? sp.getString(SP_USER_RONG_TOKEN)
        : "";
    firstRun = sp.get(SP_FIRST_RUN) != null ? sp.getBool(SP_FIRST_RUN)! : true;
    this.initData();
    String? configJson = sp.getString(SP_THEME_CONFIG);
    if (configJson != null && configJson.isNotEmpty) {
      try {
        themeConfig = MxThemeConfig.fromJson(jsonDecode(configJson));
      } catch (e) {
        print('Load ThemeConfig Error: $e');
      }
    }
  }

  void initData() {}

  Future<void> doSave(SharedPreferences sp) async {
    await sp.setString(SP_USER_GENDER, '$gender');
    await sp.setString(SP_USER_LOC, '$address');
    await sp.setString(_SP_ENV, '$_env');
    await sp.setString(SP_TENANT_CODE, '$tenantCode');
    await sp.setString(SP_tenantName, tenantName);
    await sp.setString(SP_USER_NAME, '$name');
    await sp.setInt(SP_Language, language);
    await sp.setString(SP_USER_NICK, '$_nickname');
    await sp.setString(SP_USER_DESC, '$desc');
    await sp.setString(_SP_USER_PHONE, '$phone');
    await sp.setString(SP_USER_WEIXIN_ID, '$wxId');
    await sp.setString(SP_USER_PROMOTER_NAME, '$promoter');
    await sp.setString(SP_USER_AVATAR, '$avatar');
    await sp.setString(SP_UID, '$userId');
    await sp.setString(SP_USER_TYPE, '${_userType.textEmpty() ? '' : _userType}');
    await sp.setString(SP_USER_TOKEN, '${_token.textEmpty() ? '' : _token}');
    await sp.setString(SP_USER_RONG_TOKEN, '$rongToken');
    await sp.setBool(SP_FIRST_RUN, firstRun);
    await sp.setString(SP_THEME_CONFIG, jsonEncode(themeConfig.toJson()));
//    await sp.setInt(SP_USER_THEME, themeColor.value);
  }

  Future<void> saveAccount(String account, {String? password}) async {
    this.account = account;
    this.password = password;
    var sp = await SharedPreferences.getInstance();
    await sp.setString(SP_ACCOUNT, account);
    await sp.setString(SP_PASSWORD, password.mxText);
  }

  @override
  String toString() {
    return 'MxBaseUserInfo{userId:$userId,phone:$phone,gender: $gender, name: $name, address: $address, _nickname: $_nickname, _tenantName: $_tenantName, _userType: $_userType, desc: $desc, _env: $_env, wxId: $wxId, promoter: $promoter, avatar: $avatar, tenantCode: $tenantCode, account: $account, password: $password, displayId: $displayId, tenantName: $tenantName, displayName: $displayName, isAppRelative: $isAppRelative, rongToken: $rongToken';
  }
}
