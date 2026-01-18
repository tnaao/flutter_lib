import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/index.dart';
import 'package:velocity_x/velocity_x.dart';

ScreenUtil _screenUtil = ScreenUtil();

extension mxDivider on num {
  Widget hLine({color = UIData.lineBg, num mH = 0}) {
    final lineView = HStack([
      Container(
        color: color,
        height: UIData.lineH,
        width: hsp,
      ).expand()
    ]);
    return mH < 1
        ? lineView
        : lineView.box.margin(EdgeInsets.symmetric(horizontal: mH.hsp)).make();
  }

  Widget hSpacer({color = Colors.transparent}) {
    return Container(
      color: color,
      width: hsp,
    );
  }

  Widget vLine({Color color = UIData.lineBg}) {
    return Container(
      color: color,
      height: vsp,
      width: UIData.lineH,
    );
  }

  Widget vSpacer({color = Colors.transparent}) {
    return Container(
      height: this.vsp,
      color: color,
    );
  }

  double get natureVal =>
      this.toDouble() >= 0 ? this.toDouble().abs() : 0.0.abs();

  double get fsp => _screenUtil.setSp(this.abs());

  double get osp => this.toDouble().abs();

  String moneyFmt() {
    if (this == null) return '0.00';
    return this.toDouble().toStringAsFixed(2);
  }

  String secondsToTimePassedShow() {
    if (this == null) return '00:00';
    int seconds = this.toInt();
    int hour = seconds ~/ 3600;
    int minute = (seconds - hour * 3600) ~/ 60;
    int second = seconds - hour * 3600 - minute * 60;
    String hourStr = hour < 10 ? '0$hour' : '$hour';
    String minuteStr = minute < 10 ? '0$minute' : '$minute';
    String secondStr = second < 10 ? '0$second' : '$second';
    return '$minuteStr:$secondStr';
  }

  String secondsToHmFormat() {
    int totalSeconds = toInt();
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    }
    int minutes = totalSeconds ~/ 60; // 计算分钟数
    int seconds = totalSeconds % 60; // 计算剩余的秒数
    if (minutes < 60) {
      return '${minutes}m${seconds == 0 ? '' : '${seconds}s'}';
    }
    return minutes.minutesToHmFormat();
  }

  String minutesToHmFormat() {
    int totalMinutes = toInt();
    int hours = totalMinutes ~/ 60; // 计算小时数
    int minutes = totalMinutes % 60; // 计算剩余的分钟数
    if (hours < 1) {
      return '${minutes}m';
    }
    return '${hours}h${minutes == 0 ? '' : '${minutes}m'}';
  }

  String minutesToSimpleFormat({bool isEnglish = true}) {
    int totalMinutes = toInt();
    int days = totalMinutes ~/ (60 * 24); // 计算天数
    if (days < 1) {
      return minutesToHmFormat();
    }
    return '${days}day';
  }

  String minutesToHmHourValue() {
    int totalMinutes = toInt();
    int hours = totalMinutes ~/ 60; // 计算小时数
    int minutes = totalMinutes % 60; // 计算剩余的分钟数
    if (hours < 1) {
      return '$hours'.padLeft(2, '0');
    }
    return '$hours'.padLeft(2, '0');
  }

  String minutesToHmMinuteValue() {
    int totalMinutes = toInt();
    int hours = totalMinutes ~/ 60; // 计算小时数
    int minutes = totalMinutes % 60; // 计算剩余的分钟数
    if (hours < 1) {
      return '$minutes'.padLeft(2, '0');
    }
    return '$minutes'.padLeft(2, '0');
  }

  Future<void> delay(void Function() task) async {
    return Future.delayed(Duration(milliseconds: toDouble().toInt()))
        .then((value) {
      try {
        task();
      } catch (e) {
        print('delayTask:$e');
      }
    });
  }

  Future<Null> after() async {
    return Future.delayed(Duration(milliseconds: toInt()));
  }

  Widget radius(Widget child, {evaluation: double}) {
    return MyBaseCard(
      child: child,
      radius: this == null ? 0.0 : this.toDouble(),
      elevation: evaluation,
    );
  }

  double get hsp => this.w;

  double get vsp => this.h;

  double xScaleVal(double scale) => this * scale;
}
