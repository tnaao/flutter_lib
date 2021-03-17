import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mxbase/model/user_info.dart';

class UIData {
  //routes
  static const String Rhome = "/home";
  static const String RuserDetail = "RuserDetail";
  static const String Rfeedback = "Rfeedback";
  static const String Rsettings = "Rsettings";
  static const String RthemeChange = "RthemeChange";
  static const String Rregister = "Rregister";
  static const String Rlogin = "Rlogin";
  static const String RpasswordChange = "RpasswordChange";
  static const String RpasswordReset = "RpasswordReset";
  static const String RphoneBind = "RphoneBind";
  static const String RphoneBindResult = "RphoneBindResult";
  static const String RserviceReply = "RserviceReply";
  static const String Rabout = "Rabout";
  static const String RorderHome = "RorderHome";

  static const int ACCOUNT_TYPE_wechat = 0; //0,微信 1,支付宝, 4.银行卡
  static const int ACCOUNT_TYPE_alipay = 1;
  static const int ACCOUNT_TYPE_bank = 4;

  static get icLogo => '';
  static const double CURTAIN_SHADE_PRICE = 65.0;
  static const double Lpading = 20.0;

  static const double sWidth = 768.0;
  static const double sHeight = 1024.0;

  static const double msWidth = 375.0;
  static const double msHeight = 812.0;

  static doubleGet(dynamic it) {
    switch (it.runtimeType) {
      case int:
        return it * 1.0;
      case double:
        return it;
      case String:
        return double.parse(it);
    }
    return 0.0;
  }

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  static bool isLightColor(Color color) {
    int red = hexToInt(color2HexStr(color).toString().substring(1, 3));
    int green = hexToInt(color2HexStr(color).toString().substring(3, 5));
    int blue = hexToInt(color2HexStr(color).toString().substring(5, 7));
    double darkness = 1 - (0.299 * red + 0.587 * green + 0.114 * blue) / 255;

    if (darkness < 0.5) {
      return true; // It's a light color
    } else {
      return false; // It's a dark color
    }
  }

  static double darknessColor(Color color) {
    int red = hexToInt(color2HexStr(color).toString().substring(1, 3));
    int green = hexToInt(color2HexStr(color).toString().substring(3, 5));
    int blue = hexToInt(color2HexStr(color).toString().substring(5, 7));
    double darkness = 1 - (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return darkness;
  }

  static Color mainBtnColor() {
    return UIData.darknessColor(primaryColor) < 0.01
        ? UIData.black
        : primaryColor;
  }

  static double hSp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.width / sWidth;
  }

  static double mhSp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.width / msWidth;
  }

  static double fsp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.width / sWidth;
  }

  static double mfsp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.width / msWidth;
  }

  static double vSp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.height / sHeight;
  }

  static double mvSp(double s) {
    return s * 1.0 * UserInfo.instance.deviceSize.height / msHeight;
  }

  static double bSp(double s) {
    return s * 1.0;
  }

  static sInsets(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(hSp(left), vSp(top), hSp(right), vSp(bottom));
  }

  static msInsets(double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
        mhSp(left), mvSp(top), mhSp(right), mvSp(bottom));
  }

  static fromLTRB(double left, double top, double right, double bottom) {
    return sInsets(left, top, right, bottom);
  }

  static mfromLTRB(double left, double top, double right, double bottom) {
    return msInsets(left, top, right, bottom);
  }

  static isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static color2HexStr(Color color) {
    return '#${color.value.toRadixString(16)}';
  }

  static bool limitTextWidth() {
    return UserInfo.instance.deviceSize.width < 400;
  }

  static num time2Seconds(String time) {
    var timeComponents = time.split(':');
    var hour = int.parse(timeComponents[0]);
    var min = int.parse(timeComponents[1]);
    var seconds = double.parse(timeComponents[2]);
    return hour * 3600 + min * 60 + seconds;
  }

  static Widget navBackWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: UIData.fromLTRB(20.0, 0.0, 0.0, 0.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back,
            color: UIData.icBackColor,
            size: UIData.bSp(24.0),
          ),
        ),
      ),
    );
  }

  static const String profileOneRoute = "/View Profile";
  static const String profileTwoRoute = "/Profile 2";
  static const String notFoundRoute = "/No Search Result";
  static const String timelineOneRoute = "/Feed";
  static const String timelineTwoRoute = "/Tweets";
  static const String settingsOneRoute = "/Device Settings";
  static const String shoppingOneRoute = "/Shopping List";
  static const String shoppingTwoRoute = "/Shopping Details";
  static const String shoppingThreeRoute = "/Product Details";
  static const String paymentOneRoute = "/Credit Card";
  static const String paymentTwoRoute = "/Payment Success";
  static const String loginOneRoute = "/Login With OTP";
  static const String loginTwoRoute = "/Login 2";
  static const String dashboardOneRoute = "/Dashboard 1";
  static const String dashboardTwoRoute = "/Dashboard 2";
  static const String icNext = "$imageDir/icon_next.png";

  //strings
  static const String appName = "淘居屋";
  static const int pageSize = 5;
  static const int accountChange_Charge = 1;
  static const int accountChange_Withdraw = 2;
  static const int accountChange_Invest = 3;

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";
  static const String icRect = "$imageDir/rect.png";
  static const String icOval = "$imageDir/oval.png";

  static const String pkImage = "$imageDir/pk.jpg";
  static const String profileImage = "$imageDir/profile.jpg";
  static const String blankImage = "$imageDir/blank.jpg";
  static const String dashboardImage = "$imageDir/dashboard.jpg";
  static const String loginImage = "$imageDir/login.jpg";
  static const String paymentImage = "$imageDir/payment.jpg";
  static const String settingsImage = "$imageDir/setting.jpeg";
  static const String shoppingImage = "$imageDir/shopping.jpeg";
  static const String timelineImage = "$imageDir/timeline.jpeg";
  static const String verifyImage = "$imageDir/verification.jpg";

  static const String placeholderImage = "http://47.111.73.27/qr_app.png";

  //login
  static const String enter_code_label = "手机号r";
  static const String enter_code_hint = "";
  static const String enter_otp_label = "验证码";
  static const String enter_otp_hint = "";
  static const String get_otp = "发送验证码";
  static const String resend_otp = "重新发送验证码";
  static const String login = "Login";
  static const String enter_valid_number = "请输入正确的手机号";
  static const String enter_valid_otp = "验证码错误";

  //gneric
  static const String error = "Error";
  static const String success = "成功";
  static const String ok = "OK";
  static const String forgot_password = "忘记密码?";
  static const String something_went_wrong = "";
  static const String coming_soon = "开发中";

  static const MaterialColor ui_kit_color = Colors.grey;
  static const Color white = Colors.white;
  static const Color blue = Color(0xff3884FB);
  static const Color textBlue = Color(0xff336E96);
  static const Color textRed = Color(0xffDE6D6C);
  static const Color green = Color(0xff54A40D);

  static const Color imgBlack = Color(0xff4F4F4F);
  static const Color bgF3 = Color(0xffF3F3F3);
  static const Color bgF3Sel = Color(0xffE9F1F8);
  static const Color black = Colors.black87;
  static const Color red = Colors.red;
  static const Color blockYellow = Color(0xffFFF5CB);
  static const double textActionSize = 15.0;
  static const Color textBN = Color(0xff050505);
  static const Color textGL = Color(0xffb9b9b9);
  static const Color textGN = Color(0xff717171);
  static const Color textGD = Color(0xff666666);
  static const Color textHelpRed = Color(0xffCB001C);
  static const Color textGca = Color(0xffCACACA);
  static const Color textB37 = Color(0xff373737);
  static const Color textTitleGD = Color(0xff444444);
  static const Color windowBg = Color(0xffF4F4F4);
  static const Color lineBg = Color(0xFFC7C8CB);
  static const double lineH = 0.5;
  static const double menuH = 50.0;
  static const double lineHB = 1.2;
  static const double dividerH = 10.0;
  static const Color fansYellow = Color(0xffE4AC25);
  static const Color icBackColor = Color(0xff575756);

  static const TextStyle tsSGLTag =
      TextStyle(color: UIData.textGL, fontSize: 12);
  static const TextStyle tsSGNTag =
      TextStyle(color: UIData.textGL, fontSize: 12);

  static const TextStyle tsSGNTitle =
      TextStyle(color: UIData.textGN, fontSize: 14);
  static const TextStyle tsBTitleNormal =
      TextStyle(color: Colors.black, fontSize: 14);

  static const TextStyle tsSGNTitleBigger =
      TextStyle(color: UIData.textGN, fontSize: 16);

  static const TextStyle tsRaiseTitleN =
      TextStyle(fontSize: 16, color: UIData.white);
  static const double raiseHN = 33.0;

//colors
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),

    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.blueGrey,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  static const Color primaryColor = Colors.orange;
  static const Color accentColor = Color(0xFF00ACC1);

  //randomcolor
  static final Random _random = new Random();

  static String get key_guide => "key_guide";

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
