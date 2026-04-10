import 'package:flutter/material.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MxThemeConfig {
  String bgPay;
  String moneyRed;
  String alertWindowColor;
  String pink;
  String text333;
  String text666;
  String text999;
  String uiKitColor;
  String white;
  String pureWhite;
  String placeColor;
  String blue;
  String textBlue;
  String textRed;
  String green;
  String dividerColor;
  String orderRed;
  String clickColor;
  String btnSelFillColor;
  String tabBlue;
  String inputBg;
  String imgBlack;
  String bgF3;
  String bgF3Sel;
  String black;
  String red;
  String blockYellow;
  String textBN;
  String textGL;
  String textGN;
  String textGD;
  String textHelpRed;
  String textGca;
  String textB37;
  String textTitleGD;
  String windowBg;
  String lineBg;
  String btnBgN;
  String fansYellow;
  String icBackColor;
  String primaryColor;
  String accentColor;
  String normalBtnGray;
  String normalBtnRed;
  String defBtnMainColor;

  List<String> kitGradients;
  List<String> kitGradients2;
  List<String> defaultBtnGradient;
  List<String> cartActivityTagGradient;
  List<String> homeSearchGradient;

  MxThemeConfig({
    this.bgPay = '#45AAFF',
    this.moneyRed = '#FF632A',
    this.alertWindowColor = '#32000000',
    this.pink = '#FFFF00AE',
    this.text333 = '#FF333333',
    this.text666 = '#FF666666',
    this.text999 = '#FF999999',
    this.uiKitColor = '#FF9E9E9E',
    this.white = '#FFFFFFFF',
    this.pureWhite = '#FFFFFFFF',
    this.placeColor = '#FF607D8B',
    this.blue = '#FF3884FB',
    this.textBlue = '#FF336E96',
    this.textRed = '#FFDE6D6C',
    this.green = '#FF54A40D',
    this.dividerColor = '#F8F8F8',
    this.orderRed = '#FB3467',
    this.clickColor = '#01000000',
    this.btnSelFillColor = '#FFF1FB',
    this.tabBlue = '#423BD0',
    this.inputBg = '#F5F5F5',
    this.imgBlack = '#FF4F4F4F',
    this.bgF3 = '#FFF3F3F3',
    this.bgF3Sel = '#FFE9F1F8',
    this.black = '#FF363A44',
    this.red = '#FFF44336',
    this.blockYellow = '#FFFFF5CB',
    this.textBN = '#FF050505',
    this.textGL = '#FFA8A8A8',
    this.textGN = '#FF999999',
    this.textGD = '#FF757575',
    this.textHelpRed = '#FFCB001C',
    this.textGca = '#FFCACACA',
    this.textB37 = '#FF373737',
    this.textTitleGD = '#FF444444',
    this.windowBg = '#FF1F2122',
    this.lineBg = '#FFEBEBEB',
    this.btnBgN = '#FFF7F7F7',
    this.fansYellow = '#FFE4AC25',
    this.icBackColor = '#FF575756',
    this.primaryColor = '#FF04D382',
    this.accentColor = '#FF04D382',
    this.normalBtnGray = '#F7F7F7',
    this.normalBtnRed = '#FFE1F6',
    this.defBtnMainColor = '#04D382',
    this.kitGradients = const ['#FF37474F', '#FF607D8B'],
    this.kitGradients2 = const ['#FF00ACC1', '#FF0D47A1'],
    this.defaultBtnGradient = const ['#04D382', '#04D382'],
    this.cartActivityTagGradient = const ['#33C8161D', '#00EE784D'],
    this.homeSearchGradient = const ['#88838282', '#88E9E8E8'],
  });

  factory MxThemeConfig.fromJson(Map<String, dynamic> json) {
    return MxThemeConfig(
      bgPay: json['bgPay'] ?? '#45AAFF',
      moneyRed: json['moneyRed'] ?? '#FF632A',
      alertWindowColor: json['alertWindowColor'] ?? '#32000000',
      pink: json['pink'] ?? '#FFFF00AE',
      text333: json['text333'] ?? '#FF333333',
      text666: json['text666'] ?? '#FF666666',
      text999: json['text999'] ?? '#FF999999',
      uiKitColor: json['uiKitColor'] ?? '#FF9E9E9E',
      white: json['white'] ?? '#FFFFFFFF',
      pureWhite: json['pureWhite'] ?? '#FFFFFFFF',
      placeColor: json['placeColor'] ?? '#FF607D8B',
      blue: json['blue'] ?? '#FF3884FB',
      textBlue: json['textBlue'] ?? '#FF336E96',
      textRed: json['textRed'] ?? '#FFDE6D6C',
      green: json['green'] ?? '#FF54A40D',
      dividerColor: json['dividerColor'] ?? '#F8F8F8',
      orderRed: json['orderRed'] ?? '#FB3467',
      clickColor: json['clickColor'] ?? '#01000000',
      btnSelFillColor: json['btnSelFillColor'] ?? '#FFF1FB',
      tabBlue: json['tabBlue'] ?? '#423BD0',
      inputBg: json['inputBg'] ?? '#F5F5F5',
      imgBlack: json['imgBlack'] ?? '#FF4F4F4F',
      bgF3: json['bgF3'] ?? '#FFF3F3F3',
      bgF3Sel: json['bgF3Sel'] ?? '#FFE9F1F8',
      black: json['black'] ?? '#FF363A44',
      red: json['red'] ?? '#FFF44336',
      blockYellow: json['blockYellow'] ?? '#FFFFF5CB',
      textBN: json['textBN'] ?? '#FF050505',
      textGL: json['textGL'] ?? '#FFA8A8A8',
      textGN: json['textGN'] ?? '#FF999999',
      textGD: json['textGD'] ?? '#FF757575',
      textHelpRed: json['textHelpRed'] ?? '#FFCB001C',
      textGca: json['textGca'] ?? '#FFCACACA',
      textB37: json['textB37'] ?? '#FF373737',
      textTitleGD: json['textTitleGD'] ?? '#FF444444',
      windowBg: json['windowBg'] ?? '#FF1F2122',
      lineBg: json['lineBg'] ?? '#FFEBEBEB',
      btnBgN: json['btnBgN'] ?? '#FFF7F7F7',
      fansYellow: json['fansYellow'] ?? '#FFE4AC25',
      icBackColor: json['icBackColor'] ?? '#FF575756',
      primaryColor: json['primaryColor'] ?? '#FF04D382',
      accentColor: json['accentColor'] ?? '#FF04D382',
      normalBtnGray: json['normalBtnGray'] ?? '#F7F7F7',
      normalBtnRed: json['normalBtnRed'] ?? '#FFE1F6',
      defBtnMainColor: json['defBtnMainColor'] ?? '#04D382',
      kitGradients: List<String>.from(json['kitGradients'] ?? ['#FF37474F', '#FF607D8B']),
      kitGradients2: List<String>.from(json['kitGradients2'] ?? ['#FF00ACC1', '#FF0D47A1']),
      defaultBtnGradient: List<String>.from(json['defaultBtnGradient'] ?? ['#04D382', '#04D382']),
      cartActivityTagGradient: List<String>.from(json['cartActivityTagGradient'] ?? ['#33C8161D', '#00EE784D']),
      homeSearchGradient: List<String>.from(json['homeSearchGradient'] ?? ['#88838282', '#88E9E8E8']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bgPay': bgPay,
      'moneyRed': moneyRed,
      'alertWindowColor': alertWindowColor,
      'pink': pink,
      'text333': text333,
      'text666': text666,
      'text999': text999,
      'uiKitColor': uiKitColor,
      'white': white,
      'pureWhite': pureWhite,
      'placeColor': placeColor,
      'blue': blue,
      'textBlue': textBlue,
      'textRed': textRed,
      'green': green,
      'dividerColor': dividerColor,
      'orderRed': orderRed,
      'clickColor': clickColor,
      'btnSelFillColor': btnSelFillColor,
      'tabBlue': tabBlue,
      'inputBg': inputBg,
      'imgBlack': imgBlack,
      'bgF3': bgF3,
      'bgF3Sel': bgF3Sel,
      'black': black,
      'red': red,
      'blockYellow': blockYellow,
      'textBN': textBN,
      'textGL': textGL,
      'textGN': textGN,
      'textGD': textGD,
      'textHelpRed': textHelpRed,
      'textGca': textGca,
      'textB37': textB37,
      'textTitleGD': textTitleGD,
      'windowBg': windowBg,
      'lineBg': lineBg,
      'btnBgN': btnBgN,
      'fansYellow': fansYellow,
      'icBackColor': icBackColor,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'normalBtnGray': normalBtnGray,
      'normalBtnRed': normalBtnRed,
      'defBtnMainColor': defBtnMainColor,
      'kitGradients': kitGradients,
      'kitGradients2': kitGradients2,
      'defaultBtnGradient': defaultBtnGradient,
      'cartActivityTagGradient': cartActivityTagGradient,
      'homeSearchGradient': homeSearchGradient,
    };
  }

  void copyFrom(MxThemeConfig other) {
    bgPay = other.bgPay;
    moneyRed = other.moneyRed;
    alertWindowColor = other.alertWindowColor;
    pink = other.pink;
    text333 = other.text333;
    text666 = other.text666;
    text999 = other.text999;
    uiKitColor = other.uiKitColor;
    white = other.white;
    pureWhite = other.pureWhite;
    placeColor = other.placeColor;
    blue = other.blue;
    textBlue = other.textBlue;
    textRed = other.textRed;
    green = other.green;
    dividerColor = other.dividerColor;
    orderRed = other.orderRed;
    clickColor = other.clickColor;
    btnSelFillColor = other.btnSelFillColor;
    tabBlue = other.tabBlue;
    inputBg = other.inputBg;
    imgBlack = other.imgBlack;
    bgF3 = other.bgF3;
    bgF3Sel = other.bgF3Sel;
    black = other.black;
    red = other.red;
    blockYellow = other.blockYellow;
    textBN = other.textBN;
    textGL = other.textGL;
    textGN = other.textGN;
    textGD = other.textGD;
    textHelpRed = other.textHelpRed;
    textGca = other.textGca;
    textB37 = other.textB37;
    textTitleGD = other.textTitleGD;
    windowBg = other.windowBg;
    lineBg = other.lineBg;
    btnBgN = other.btnBgN;
    fansYellow = other.fansYellow;
    icBackColor = other.icBackColor;
    primaryColor = other.primaryColor;
    accentColor = other.accentColor;
    normalBtnGray = other.normalBtnGray;
    normalBtnRed = other.normalBtnRed;
    defBtnMainColor = other.defBtnMainColor;
    kitGradients = List.from(other.kitGradients);
    kitGradients2 = List.from(other.kitGradients2);
    defaultBtnGradient = List.from(other.defaultBtnGradient);
    cartActivityTagGradient = List.from(other.cartActivityTagGradient);
    homeSearchGradient = List.from(other.homeSearchGradient);
  }
}
