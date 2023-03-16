import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:xrandom/xrandom.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/model/app_holder.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

export 'package:shared_preferences/shared_preferences.dart';

typedef MxOnValue<T> = void Function(T value);

extension mxMoneyFmt on num? {
  String mx_moneyFmt({int digits = 2, bool hasPlus = false}) {
    var splitText = (digits > 0 ? '.' : '');
    if (this == null) return '0' + splitText + '0' * digits;
    var result = "${this!.toDouble().toStringAsFixed(digits)}";
    if (digits == 2) {
      if (this.toString().isInteger || result.endsWith('00')) {
        return this?.toInt().mxText ?? '0';
      }
      result = "${this!.toDouble().toStringAsFixed(digits + 1)}";
      return result.substring(0, result.length - 1);
    }
    if (hasPlus) return "${this! > 0 ? '+' : '-'}${result.replaceAll('-', '')}";
    return result;
  }

  int get mxRandom => Xrandom().nextInt(this!.toInt());
}

extension MxDirExt on Directory {
  bool get isExist => this.existsSync();

  Directory subdir(String dirName) {
    var subF = Directory('${this.path}/$dirName');
    if (!subF.isExist) {
      subF.createSync(recursive: true);
    }
    return subF;
  }
}

extension MxListExt<T> on List<T> {
  T? get pickerFirst => this.isEmpty ? null : this.first;
}

extension mxTextExt on dynamic {
  String get mxText =>
      this == null || '$this'.startsWith('null') ? '' : '${this}';

  T? as<T>() => this is T ? this as T : null;
}

extension mxStr on String? {
  String get rmbPreText => this == null
      ? ''
      : '$this'.contains('¥')
          ? '$this'
          : '¥$this';

  String get mxMd5 => md5.convert(utf8.encode('${this}')).toString();

  String get mxBase64 => base64.encode(utf8.encode('${this}'));

  bool get isInteger => RegExp(r'^\d+$').allMatches('$this').isNotEmpty;

  String xMatchBeanTypeFromRuntime() {
    var str = this.mxText;
    final regGeneric = r'\w+<\w+>';
    if (RegExp(regGeneric).allMatches(str).isNotEmpty) {
      final String clsType = RegExp(r'<\w+>')
          .allMatches(str)
          .map((e) => str.substring(e.start + 1, e.end - 1))
          .first;
      return clsType;
    }
    if (RegExp(r'\w+').allMatches(str).isNotEmpty) {
      return str;
    }
    return '';
  }

  bool get isTextEmpty => this.textEmpty();

  String get xCommunicateElderRelativePrefix => this.isTextEmpty
      ? ''
      : '${this}'.startsWith("fwzx-")
          ? '${this}'
          : 'fwzx-${this}';

  String get xGoSubRoute => this.isTextEmpty
      ? ''
      : '${this}'.startsWith('/')
          ? '${this}'.substring(1)
          : '${this}';

  String get xCommunicateRemovePrefix => this.isTextEmpty
      ? ''
      : '${this}'.startsWith("fwzx-")
          ? '${this}'.replaceFirst("fwzx-", "")
          : '${this}';

  String starMixText({bool isPhone = false}) {
    var origin = '$this';
    if (origin.length <= 4) return origin.mxText;
    var startIdx = isPhone ? 3 : ((origin.length - 4) * 1 / 2).toInt();
    var suffix =
        (origin.length > startIdx + 4) ? origin.substring(startIdx + 4) : '';
    return origin.substring(0, startIdx) + '*' * 4 + suffix;
  }

  String starMixName() {
    var origin = '$this';
    return origin.isTextEmpty ? '' : '*' + origin.substring(1, origin.length);
  }

  String starMixIdCard() {
    var origin = '$this';
    return origin.isTextEmpty
        ? ''
        : origin.substring(0, 6) + '********' + origin.substring(14, 18);
  }

  bool xHas(String? text) => this.toString().contains(text?.toString() ?? '');

  double textHeight(
    double textWidth, {
    TextStyle? style,
  }) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 20,
        textDirection: UIData.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    final countLines = (textPainter.size.width / textWidth).ceil();
    final height = countLines * textPainter.size.height;
    return height;
  }

  double textWidth({
    TextStyle? style,
  }) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 1,
        textDirection: UIData.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  int textLines(
    double textWidth, {
    TextStyle? style,
  }) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 20,
        textDirection: UIData.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    final countLines = (textPainter.size.width / textWidth).ceil();
    return countLines;
  }

  String imgAddHost() {
    if (this == null || this!.length < 4) return '';
    if (this!.contains(AppHolder.HOST) || this!.startsWith('http'))
      return this!;
    return AppHolder.HOST + '/' + this!;
  }

  String moneyFmt({int digits = 2}) {
    var splitText = (digits > 0 ? '.' : '');
    if (this.textEmpty()) return '0' + splitText + ('0' * digits);
    var numTmp = double.tryParse(this!);
    return numTmp == null
        ? '0' + splitText + ('0' * digits)
        : numTmp.mx_moneyFmt(digits: digits);
  }

  Future<bool> copyToClipBoard() async {
    if (this.textEmpty()) return true;
    await FlutterClipboard.copy('$this').then((value) {
      '复制成功'.toast();
    }).catchError((err) {
      print('copyToClipBoard:$err');
    });

    return true;
  }

  bool phoneValid() {
    if (this == null) return false;

    RegExp exp = RegExp(r'^((1[0-9][0-9]))\d{8}$');
    return exp.hasMatch(this!);
  }

  bool inputPhoneValid() {
    if (!this.phoneValid()) {
      '请输入正确的手机号码'.toast();
    }
    return true;
  }

  bool inputPasswordValid() {
    if (this.isTextEmpty) {
      '请输入密码'.toast();
      return false;
    }
    if (this!.length < 8 || this!.length > 20) {
      '请设置8-20位的新密码'.toast();
      return false;
    }
    return true;
  }

  bool inputTextValid({String? msg = '请检查输入'}) {
    if (this.isTextEmpty) {
      msg.toast();
      return false;
    }
    return true;
  }

  bool idCardValid() {
    if (this == null) return false;
    RegExp exp = RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$');
    return exp.hasMatch(this!);
  }

  bool textEmpty() {
    if (this == null ||
        this.mxText.startsWith('null') ||
        this.mxText.replaceAll(RegExp("[ \n\t\r\f]"), "").isEmpty) return true;
    return this!.isEmpty;
  }

  Color hexColor() {
    if (this == null) return Colors.transparent;
    if (this!.length < 9)
      return Color(int.parse('FF' + this!.replaceFirst('#', ''), radix: 16));
    return Color(int.parse(this!.replaceFirst('#', ''), radix: 16));
  }

  DateTime standardDate() {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.parse(this!);
    } catch (e) {
      print('${e}');
      return DateTime.now();
    }
  }

  String assetPath() {
    if (this == null || this!.isEmpty) return '';
    if (this!.contains('file://')) return this!;
    if (this!.contains(UIData.imageDir)) return this!;
    String path = "${UIData.imageDir}/${this}";
    if (path.contains('.')) return path;
    return '$path.png';
  }

  List<String> picListFromHtml() {
    List<String> _detailImages = [];
    UIData.picExp()
        .allMatches('$this')
        .map((it) {
          var el = '$this'.substring(it.start, it.end);
          _detailImages.add(el);
          return el.imgAddHost();
        })
        .toList()
        .where((it) {
          return !_detailImages.contains(it);
        })
        .toList();
    return _detailImages;
  }

  int extractId() {
    if (this == null) return 0;
    var numberMatch = new RegExp(r'[0-9]+').firstMatch('$this');
    if (numberMatch == null) return 0;
    return int.parse('$this'.substring(numberMatch.start, numberMatch.end));
  }

  int extractNumber() {
    if (this == null) return 0;
    var numberMatch = new RegExp(r'([0-9]|\.)+').firstMatch('$this')!;
    return int.parse('$this'
        .substring(numberMatch.start, numberMatch.end)
        .replaceAll('.', ''));
  }

  static final logger = Logger();

  void logMx() {
    logger.d('XxApp|\n' + "$this");
  }

  void apiMessageShow() {
    MxApiToast(this).send();
  }

  void toast({isToastAll = false}) {
    if (this == null || this.textEmpty()) return;

    if (!isToastAll && UIData.toastExcludeList.indexOf('${this}') >= 0) {
      return;
    }

    if (this == "登录成功") {
      Fluttertoast.showToast(
          msg: "${this}",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    Fluttertoast.showToast(
        msg: "${this}",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void snackBar(BuildContext context) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        content: Row(
          children: [
            Text(
              '$this',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

extension mxTime on DateTime {
  String text() {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  bool hasLessThreeDays() {
    if (this == null) return false;
    return this.isAfter(DateTime.now()) &&
        DateTime.now().add(Duration(days: 3)).isAfter(this);
  }

  String textPointDate() {
    try {
      final DateFormat formatter = DateFormat('yyyy.MM.dd');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  String textDashDate() {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  String textPhoneDate() {
    try {
      final DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  DateTime lastMonth() {
    if (this == null) return Jiffy().subtract(months: 1).dateTime;
    return Jiffy(this.text(), 'yyyy-MM-dd HH:mm:ss')
        .subtract(months: 1)
        .dateTime;
  }

  String textDashMonth() {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  String textLiterMonthAndTimeMin() {
    try {
      final DateFormat formatter = DateFormat('MM月dd日 HH:mm');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  String textPointDateAndTimeMin() {
    try {
      final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
      final String formatted = formatter.format(this);
      return formatted;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  int mxDay(DateTime other) {
    var millisMinus =
        this.millisecondsSinceEpoch - other.millisecondsSinceEpoch;
    if (millisMinus < 0) millisMinus = 0;
    return ((millisMinus).abs() * 1.0 / 1000 / 86400).floor();
  }

  int mxHour(DateTime other) {
    var millisMinus =
        this.millisecondsSinceEpoch - other.millisecondsSinceEpoch;
    if (millisMinus < 0) millisMinus = 0;
    return (((millisMinus).abs().abs() * 1.0 / 1000 -
                this.mxDay(other) * 86400) *
            1.0 /
            3600)
        .floor();
  }

  int mxMinute(DateTime other) {
    var millisMinus =
        this.millisecondsSinceEpoch - other.millisecondsSinceEpoch;
    if (millisMinus < 0) millisMinus = 0;
    return (((millisMinus).abs() * 1.0 / 1000 -
                this.mxDay(other) * 86400 -
                this.mxHour(other) * 3600) *
            1.0 /
            60)
        .floor();
  }

  int mxSecond(DateTime other) {
    var millisMinus =
        this.millisecondsSinceEpoch - other.millisecondsSinceEpoch;
    if (millisMinus < 0) millisMinus = 0;
    return ((millisMinus).abs() * 1.0 / 1000 -
            this.mxDay(other) * 86400 -
            this.mxHour(other) * 3600 -
            this.mxMinute(other) * 60)
        .toInt();
  }
}
