import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/widgets/index.dart';

import 'mx_theme_config.dart';

class UISystemUIEvent extends MxEvent {
  final Color naviColor;
  final bool isLight;
  final Color? statusColor;

  UISystemUIEvent(
      {Color? naviColor,
      this.isLight = true,
      this.statusColor = Colors.transparent})
      : naviColor = naviColor ?? UIData.windowBg;
}

class UIData {
  static MxThemeConfig get config => MxBaseUserInfo.instance.themeConfig;

  static Color get bgPay => config.bgPay.hexColor();

  static Color get moneyRed => config.moneyRed.hexColor();

  UIData._();

  static const toastExcludeList = [
    "商品未评价",
    "请登录",
    "用户未登录",
    "令牌不能为空",
    "return data is null",
    "ruturn data is null",
    "该用户不存在",
    "用户不存在",
    "信息不存在",
    "找不到相关记录",
    "操作失败"
  ];

  static var ltr = TextDirection.rtl;

  static Color get alertWindowColor => config.alertWindowColor.hexColor();

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
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
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

  static const String icPayAli = 'ic_paymethod_ali.png';
  static const String icPayWechat = 'ic_paymethod_wechat.png';

  //strings
  static const String appName = "";
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
  static String imageDir = "images_systu";
  static String get icRect => "$imageDir/rect.png";
  static String get icOval => "$imageDir/oval.png";
  static String icAvatarDefault = "$imageDir/avatar_default.png";

  //gneric
  static const String error = "Error";
  static const String success = "成功";
  static const String ok = "OK";
  static const String noMoreData = '没有更多内容了';
  static const String RouteAppHome = "/Home";
  static const String Rlogin = "/Login";
  static const String Rregister = "/Register";

  static String testJsface() => 'http://site.sailforce.online/hello.html';

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

  static Color get pink => config.pink.hexColor();
  static Color get text333 => config.text333.hexColor();
  static Color get text666 => config.text666.hexColor();
  static Color get text999 => config.text999.hexColor();

  static Color get ui_kit_color => config.uiKitColor.hexColor();
  static Color get white => config.white.hexColor();
  static Color get pureWhite => config.pureWhite.hexColor();
  static Color get placeColor => config.placeColor.hexColor();
  static Color get blue => config.blue.hexColor();
  static Color get textBlue => config.textBlue.hexColor();
  static Color get textRed => config.textRed.hexColor();
  static Color get green => config.green.hexColor();

  static String heartImg(bool isHigh) {
    return isHigh ? 'ic_heart_h.png' : 'ic_heart_n.png';
  }

  static String foldImg(bool hideDetail) {
    return hideDetail ? 'ic_detail_unfold.png' : 'ic_detail_fold.png';
  }

  static Color dividerColor() => config.dividerColor.hexColor();

  static Color orderRed() => config.orderRed.hexColor();

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

  static Color clickColor() => config.clickColor.hexColor();

  static Color btnSelFillColor() => config.btnSelFillColor.hexColor();

  static Color tabBlue() => config.tabBlue.hexColor();

  static Color inputBg() => config.inputBg.hexColor();

  static Color get imgBlack => config.imgBlack.hexColor();
  static Color get bgF3 => config.bgF3.hexColor();
  static Color get bgF3Sel => config.bgF3Sel.hexColor();
  static Color get black => config.black.hexColor();
  static Color get red => config.red.hexColor();
  static Color get blockYellow => config.blockYellow.hexColor();
  static const double textActionSize = 15.0;
  static Color get textBN => config.textBN.hexColor();
  static Color get textGL => config.textGL.hexColor();
  static Color get textGN => config.textGN.hexColor();
  static Color get textGD => config.textGD.hexColor();
  static Color get textHelpRed => config.textHelpRed.hexColor();
  static Color get textGca => config.textGca.hexColor();
  static Color get textB37 => config.textB37.hexColor();
  static Color get textTitleGD => config.textTitleGD.hexColor();
  static Color get windowBg => config.windowBg.hexColor();
  static Color get lineBg => config.lineBg.hexColor();
  static Color get btnBgN => config.btnBgN.hexColor();
  static const double lineH = 0.5;
  static const num menuH = 55;
  static const num menuRadius = 7;
  static const num menuSpacerVertical = 15;
  static const double lineHB = 1.2;
  static const double dividerH = 10.0;
  static Color get fansYellow => config.fansYellow.hexColor();
  static Color get icBackColor => config.icBackColor.hexColor();

  static TextStyle get tsSGLTag =>
      TextStyle(color: UIData.textGL, fontSize: 12);
  static TextStyle get tsSGNTag =>
      TextStyle(color: UIData.textGL, fontSize: 12);

  static TextStyle get tsSGNTitle =>
      TextStyle(color: UIData.textGN, fontSize: 14);
  static TextStyle get tsBTitleNormal =>
      TextStyle(color: Colors.black, fontSize: 14);

  static TextStyle get tsSGNTitleBigger =>
      TextStyle(color: UIData.textGN, fontSize: 16);

  static TextStyle get tsRaiseTitleN =>
      TextStyle(fontSize: 16, color: UIData.white);
  static const double raiseHN = 33.0;

//colors
  static List<Color> get kitGradients =>
      config.kitGradients.map((e) => e.hexColor()).toList();
  static List<Color> get kitGradients2 =>
      config.kitGradients2.map((e) => e.hexColor()).toList();

  static Color defBtnMainColor() {
    return config.defBtnMainColor.hexColor();
  }

  static Gradient defaultBtnGradient() => LinearGradient(
      colors: config.defaultBtnGradient.map((e) => e.hexColor()).toList(),
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static Gradient cartActivityTagGradient() => LinearGradient(
      colors: config.cartActivityTagGradient.map((e) => e.hexColor()).toList(),
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static Gradient homeSearchGradient() => LinearGradient(
      colors: config.homeSearchGradient.map((e) => e.hexColor()).toList(),
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static Color get primaryColor => config.primaryColor.hexColor();
  static Color get accentColor => config.accentColor.hexColor();

  //randomcolor
  static final Random _random = new Random();

  static String get key_guide => "key_guide";

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }

  static Color normalBtnGray() => config.normalBtnGray.hexColor();

  static Color normalBtnRed() => config.normalBtnRed.hexColor();
}
