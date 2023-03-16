import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

extension mxDivider on num {
  Widget hLine({color = UIData.lineBg}) {
    return HStack([
      Container(
        color: color,
        height: UIData.lineH,
        width: this.toDouble(),
      ).expand()
    ]);
  }

  Widget hSpacer({color = Colors.transparent}) {
    return Container(
      color: color,
      width: hsp,
    );
  }

  Widget vLine({color = UIData.lineBg}) {
    return Container(
      color: color,
      height: this.toDouble(),
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
      this != null && this.toDouble() >= 0 ? this.toDouble().abs() : 0.0.abs();

  double get fsp => this.toDouble().abs() * ScreenUtil().scaleWidth;

  double get osp => this.toDouble().abs();

  double sp() {
    return this == null ? 0.0 : this.natureVal.w;
  }

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

  void delay(Function task) async {
    await Future.delayed(Duration(milliseconds: this.toDouble().toInt()))
        .then((value) {
      try {
        task();
      } catch (e) {
        print('delayTask:$e');
      }
    });
  }

  Future<void> after() async {
    return await Future.delayed(Duration(milliseconds: this.toInt()));
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
