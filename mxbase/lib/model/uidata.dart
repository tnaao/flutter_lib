import 'dart:math';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/widgets/index.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mxbase/model/user_info.dart';

class UISystemUIEvent extends MxEvent {
  final Color naviColor;
  final bool isLight;
  final Color? statusColor;

  UISystemUIEvent(
      {this.naviColor = UIData.windowBg,
      this.isLight = true,
      this.statusColor = Colors.transparent});
}

class UIData {
  static final urlPre = 'http://score.syedu.vip';

  static final urlPres = 'https://score.syedu.vip';

//微课砍价链接
  static var urlHaggle = "$urlPre/#/pages/invite/invite/invite";
  static var urlHaggleDetail = "$urlPre/#/pages/invite/helpCut/helpCut";

//积分使用说明
  static var scoreDesc = "$urlPre/#/pages/single/illustrate/illustrate";

//分享到微信的链接
  static var shareUrl = "$urlPre/#/pages/shareVodDownload/index/index";

  static Color bgPay = '#45AAFF'.hexColor();

  static Color moneyRed = '#FF632A'.hexColor();

  UIData._();

  static const toastExcludeList = [
    "商品未评价",
    "请登录",
    "用户未登录",
    "return data is null",
    "ruturn data is null",
    "该用户不存在",
    "用户不存在",
    "信息不存在",
    "找不到相关记录",
    "操作失败"
  ];

  //routes
  static const String Rhome = "/home";
  static const String RuserDetail = "/RuserDetail";
  static const String Rfeedback = "/Rfeedback";
  static const String Rsettings = "/settings";
  static const String RthemeChange = "/RthemeChange";
  static const String Rregister = "/Rregister";
  static const String Rlogin = "/login";
  static const String RpasswordChange = "/RpasswordChange";
  static const String RpasswordReset = "/RpasswordReset";
  static const String RphoneBind = "/RphoneBind";
  static const String RphoneBindResult = "/RphoneBindResult";
  static const String RserviceReply = "/RserviceReply";
  static const String Rabout = "/Rabout";
  static const String RorderHome = "/RorderHome";

  static const int ACCOUNT_TYPE_wechat = 0; //0,微信 1,支付宝, 4.银行卡
  static const int ACCOUNT_TYPE_alipay = 1;
  static const int ACCOUNT_TYPE_bank = 4;

  static var ltr = TextDirection.rtl;

  static const String RVideoCallPage = "/VideoCallPage";
  static const String RCallHistoryPage = "/RCallHistoryPage";

  static String RtcVideoToVoiceCallMessage = 'VideoToVoice';

  static Color alertWindowColor = Colors.black.withAlpha(50);

  static String icLeading(bool isDark) {
    return isDark ? 'ic_back_btn_dark.png' : 'ic_back_btn.png';
  }

  static get icLogo => 'ic_launcher';

  static double get sharpRadius => 4.0;

  static double get defRadius => 6.0;

  static String get rmbText => '¥';

  static double get defAppBarH => UIData.bSp(40.0);

  static RegExp picExp() =>
      RegExp(r"(http|https):([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
  static const double CURTAIN_SHADE_PRICE = 65.0;
  static const double Lpading = 20.0;

  static const double sWidth = 768.0;
  static const double sHeight = 1024.0;

  static const double msWidth = 375.0;
  static const double msHeight = 812.0;

  static double doubleGet(dynamic it) {
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
    return s * 1.0 * MxBaseUserInfo.instance.deviceSize.width / sWidth;
  }

  static double mhSp(double s) {
    return s * 1.0 * MxBaseUserInfo.instance.deviceSize.width / msWidth;
  }

  static double fsp(num s) {
    return s.fsp;
  }

  static double vSp(double s) {
    return s * 1.0 * MxBaseUserInfo.instance.deviceSize.height / sHeight;
  }

  static double mvSp(double s) {
    return s * 1.0 * MxBaseUserInfo.instance.deviceSize.height / msHeight;
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

  static fromLTRB(num left, num top, num right, num bottom) {
    return EdgeInsets.fromLTRB(left.hsp, top.vsp, right.hsp, bottom.vsp);
  }

  static bool isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static String color2HexStr(Color color) {
    var str = '#${color.value.toRadixString(16).padLeft(6, '0')}';
    return str;
  }

  static bool limitTextWidth() {
    return MxBaseUserInfo.instance.deviceSize.width < 400;
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
        GoRouter.of(context).pop();
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
  static const String icNext = "$imageDir/back_right_next.png";
  static const String icNextRed = "$imageDir/ic_next_red.png";

  static const String icPayAli = 'ic_paymethod_ali.png';
  static const String icPayWechat = 'ic_paymethod_wechat.png';

  //strings
  static const String appName = "双英口语";
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
  static const String imageDir = "images_systu";
  static const String icRect = "$imageDir/rect.png";
  static const String icOval = "$imageDir/oval.png";
  static const String icAvatarDefault = "$imageDir/oval.png";

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
  static const String noMoreData = '没有更多内容了';
  static const String RouteAppHome = "/Home";
  static const String RouteShopHome = "ShopHome";
  static const String cartMaxCountLimit = "数量超限";
  static const String cartMinCountLimit = "数量不得小于最小值";
  static const String forgot_password = "忘记密码?";
  static const String something_went_wrong = "";
  static const String coming_soon = "开发中";

  static String testJsface() => 'http://site.leafabs.faith/hello.html';

  static String testImg() =>
      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F201512%2F12%2F20151212120317_ec2CV.thumb.1000_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1680673208&t=dff942104f4e7709c713799c0b4e1a73';

  static List<String> testListImg() => [
        'https://img1.baidu.com/it/u=1589914872,3919858087&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889',
        'https://img2.baidu.com/it/u=4075901265,1581553886&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800',
        'https://img0.baidu.com/it/u=675418658,3235480796&fm=253&fmt=auto&app=120&f=JPEG?w=640&h=1136'
      ];

  static List<int> testIntList({int count = 10}) {
    List<int> list = [];
    for (int i = 0; i < count; i++) {
      list.add(i);
    }
    return list;
  }

  static const Color pink = Color(0xFFFF00AE);
  static const Color text333 = Color(0xFF333333);
  static const Color text666 = Color(0xFF666666);
  static const Color text999 = Color(0xFF999999);

  static const MaterialColor ui_kit_color = Colors.grey;
  static const Color white = Colors.white;
  static const Color pureWhite = Colors.white;
  static const Color placeColor = Colors.blueGrey;
  static const Color blue = Color(0xff3884FB);
  static const Color textBlue = Color(0xff336E96);
  static const Color textRed = Color(0xffDE6D6C);
  static const Color green = Color(0xff54A40D);

  static String heartImg(bool isHigh) {
    return isHigh ? 'ic_heart_h.png' : 'ic_heart_n.png';
  }

  static String foldImg(bool hideDetail) {
    return hideDetail ? 'ic_detail_unfold.png' : 'ic_detail_fold.png';
  }

  static Color dividerColor() => '#F8F8F8'.hexColor();

  static Color orderRed() => '#FB3467'.hexColor();

  static Widget transferSendIcon() => Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          border: Border.all(color: UIData.textGL, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(11.0)),
        ),
        child: Center(
          child: MyCustomText(
            '发',
            UIData.textGL,
            size: 12,
          ),
        ),
      );

  static Widget transferReceiveIcon() => Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          gradient: defaultBtnGradient(),
          borderRadius: BorderRadius.all(Radius.circular(11.0)),
        ),
        child: Center(
          child: MyCustomText(
            '收',
            UIData.pureWhite,
            size: 12,
          ),
        ),
      );

  static Color clickColor() => '#01000000'.hexColor();

  static Color btnSelFillColor() => '#FFF1FB'.hexColor();

  static Color tabBlue() => '#423BD0'.hexColor();

  static Color inputBg() => '#F5F5F5'.hexColor();

  static const Color imgBlack = Color(0xff4F4F4F);
  static const Color bgF3 = Color(0xffF3F3F3);
  static const Color bgF3Sel = Color(0xffE9F1F8);
  static const Color black = Color(0xff363A44);
  static const Color red = Colors.red;
  static const Color blockYellow = Color(0xffFFF5CB);
  static const double textActionSize = 15.0;
  static const Color textBN = Color(0xff050505);
  static const Color textGL = Color(0xffa8a8a8);
  static const Color textGN = Color(0xff999999);
  static const Color textGD = Color(0xff686B73);
  static const Color textHelpRed = Color(0xffCB001C);
  static const Color textGca = Color(0xffCACACA);
  static const Color textB37 = Color(0xff373737);
  static const Color textTitleGD = Color(0xff444444);
  static const Color windowBg = Color(0xFFF2F6F9);
  static const Color lineBg = Color(0xFFE3E5E4);
  static const Color btnBgN = Color(0xffF7F7F7);
  static const double lineH = 0.5;
  static const num menuH = 55;
  static const num menuRadius = 7;
  static const num menuSpacerVertical = 15;
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

  static Color defBtnMainColor() {
    return '#428FFC'.hexColor();
  }

  static Gradient defaultBtnGradient() => LinearGradient(
      colors: ['#428FFC'.hexColor(), '#428FFC'.hexColor()],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static Gradient cartActivityTagGradient() => LinearGradient(
      colors: ['#33C8161D'.hexColor(), '#00EE784D'.hexColor()],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static Gradient homeSearchGradient() => LinearGradient(
      colors: ['#88838282'.hexColor(), '#88E9E8E8'.hexColor()],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static const Color primaryColor = Color(0xff3093ec);
  static const Color accentColor = Color(0xff5EB2FE);

  //randomcolor
  static final Random _random = new Random();

  static String get key_guide => "key_guide";

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }

  static Color normalBtnGray() => '#F7F7F7'.hexColor();

  static Color normalBtnRed() => '#FFE1F6'.hexColor();
}
