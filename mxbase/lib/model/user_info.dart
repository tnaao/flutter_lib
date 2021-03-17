// 用户信息
import 'dart:ui';
import 'dart:convert';

abstract class SharedPreferences {
  Object get(String key);

  String getString(String key);

  bool getBool(String key);

  void setString(String key, String value);

  void setBool(String key, bool value);

  void setInt(String key, int value);
}

class UserInfo {
  static const SPKeyPrefix = "UserInfo";

  static const String SP_THEME_COLOR = '$SPKeyPrefix:THEME_COLOR';
  static const String SP_AC_TOKEN = "$SPKeyPrefix:accessToken";
  static const String SP_RE_TOKEN = "$SPKeyPrefix:refreshToken";
  static const String SP_UID = "$SPKeyPrefix:uid";
  static const String SP_IS_LOGIN = "$SPKeyPrefix:isLogin";
  static const String SP_EXPIRES_IN = "$SPKeyPrefix:expiresIn";
  static const String SP_TOKEN_TYPE = "$SPKeyPrefix:tokenType";

  static const String SP_USER_THEME = "theme.color.key";
  static const String SP_USER_TOKEN = "$SPKeyPrefix:token";
  static const String SP_USER_NAME = "$SPKeyPrefix:name";
  static const String SP_USER_GRADE_INFO = "$SPKeyPrefix:grade_info";
  static const String SP_USER_NICK = "$SPKeyPrefix:nick";
  static const String SP_USER_WEIXIN_ID = "$SPKeyPrefix:weixin_id";
  static const String SP_USER_DESC = "$SPKeyPrefix:desc";
  static const String SP_USER_PHONE = "$SPKeyPrefix:phone";
  static const String SP_USER_PROMOTER_NAME = "$SPKeyPrefix:promoterName";
  static const String SP_USER_ID = "$SPKeyPrefix:id";
  static const String SP_USER_LOC = "$SPKeyPrefix:location";
  static const String SP_USER_GENDER = "$SPKeyPrefix:gender";
  static const String SP_USER_AVATAR = "$SPKeyPrefix:avatar";
  static const String SP_USER_EMAIL = "$SPKeyPrefix:email";
  static const String SP_USER_URL = "$SPKeyPrefix:url";
  static const String SP_FIRST_RUN = "$SPKeyPrefix:firstRun";
  static const String SP_SEARCH_HISTORY_MAP = "$SPKeyPrefix:searchHistoryMap";

  Map collectNumMap = Map();
  Map cartNumMap = Map();

  UserInfo._privateConstructor();

  static final UserInfo _instance = UserInfo._privateConstructor();

  static UserInfo get instance {
    return _instance;
  }

  Map<String, dynamic> searchHistoryMap = Map();
  double statusHeight;
  String gender;
  String name = 'cus_0123';
  String address = '';
  String nickname = 'cus_0123';
  String desc = '史上最强的电影播放器!';
  String phone = '132xxxxxxxx';
  String conselor;
  String grade;
  String wxId;
  String avatar;
  String id = "";
  String promoter;
  Color themeColor;
  int swipeSpeed = 10;
  bool autoPlay = false;

  String email;
  String url;
  Size deviceSize;
  double screenFullHeight;
  String location;
  String _token;

  bool firstRun;

  get isBind {
    return this.phone != null && this.phone.length > 10;
  }

  void upFirst(bool value) {
    firstRun = value;
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

  void upTheme() async {}

  Future<UserInfo> parseLogin(dynamic model, {bool upToken = true}) {
    if (model == null) return Future.value();

    if (upToken && model.token != null) _token = model.token;
    _token = model.token;
    this.id = model.shopId.toString();
    this.name = model.shopName;
    this.nickname = model.nickName;
    this.phone = model.userTel;
    this.address = model.address;
    return Future.value(UserInfo.instance);
  }

  String getToken() {
    return _token == null ? "" : _token;
  }

  Future save() async {
    return Future.value(true);
  }

  void saveSearchHis() async {}

  Future<Map<String, dynamic>> loadSearchHis() async {
    return searchHistoryMap;
  }

  Future<UserInfo> load() async {
    return UserInfo.instance;
  }

  void doLoad(SharedPreferences sp) {
    gender =
        sp.get(SP_USER_GENDER) != null ? sp.getString(SP_USER_GENDER) : "男";
    name = sp.get(SP_USER_NAME) != null ? sp.getString(SP_USER_NAME) : "";
    nickname =
        sp.get(SP_USER_NICK) != null ? sp.getString(SP_USER_NICK) : nickname;
    desc = sp.get(SP_USER_DESC) != null ? sp.getString(SP_USER_DESC) : desc;
    phone = sp.get(SP_USER_PHONE) != null ? sp.getString(SP_USER_PHONE) : "";
    wxId = sp.get(SP_USER_WEIXIN_ID) != null
        ? sp.getString(SP_USER_WEIXIN_ID)
        : "";
    promoter = sp.get(SP_USER_PROMOTER_NAME) != null
        ? sp.getString(SP_USER_PROMOTER_NAME)
        : "";
    avatar = sp.get(SP_USER_AVATAR) != null ? sp.getString(SP_USER_AVATAR) : "";
    address = sp.get(SP_USER_LOC) != null ? sp.getString(SP_USER_LOC) : "";
    id = sp.get(SP_UID) != null ? sp.getString(SP_UID) : "";
    _token = sp.get(SP_USER_TOKEN) != null ? sp.getString(SP_USER_TOKEN) : "";
    firstRun = sp.get(SP_FIRST_RUN) != null ? sp.getBool(SP_FIRST_RUN) : false;
    this.initData();
  }

  void initData() {}

  void doSave(SharedPreferences sp) async {
    await sp.setString(SP_USER_GENDER, gender);
    await sp.setString(SP_USER_LOC, address);
    await sp.setString(SP_USER_NAME, name);
    await sp.setString(SP_USER_NICK, nickname);
    await sp.setString(SP_USER_DESC, desc);
    await sp.setString(SP_USER_PHONE, phone);
    await sp.setString(SP_USER_WEIXIN_ID, wxId);
    await sp.setString(SP_USER_PROMOTER_NAME, promoter);
    await sp.setString(SP_USER_AVATAR, avatar);
    await sp.setString(SP_UID, id);
    await sp.setString(SP_USER_TOKEN, _token);
    await sp.setBool(SP_FIRST_RUN, firstRun);
    await sp.setInt(SP_USER_THEME, themeColor.value);
  }
}
