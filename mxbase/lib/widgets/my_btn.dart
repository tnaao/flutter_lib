import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

typedef TapDe = Future<void> Function();

class MyDebounceWrapper extends StatelessWidget {
  final Widget child;
  final TapDe? onTap;
  final int countDownMillisec;

  MyDebounceWrapper(this.child,
      {Key? key, this.onTap, this.countDownMillisec = 800})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapDebouncer(
      onTap: this.onTap,
      cooldown: Duration(milliseconds: this.countDownMillisec),
      builder: (ctx, onTap) {
        return InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          child: this.child,
        );
      },
    );
  }
}

typedef TapDebounceClick = Future<void> Function();

class MyMainBtn extends StatelessWidget {
  final marginL;
  final marginTop;
  final title;
  final Gradient? gradient;

  final TapDebounceClick tap;
  final double radius;
  final double paddingV;
  final double fontSize;
  final Color? color;

  final num height;

  MyMainBtn(this.title, this.tap,
      {this.marginL = 28.0,
      this.marginTop = 0.0,
      this.radius = 2.0,
      this.paddingV = 5.0,
      this.fontSize = 16.0,
      this.color,
      this.height = 50,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(marginL, marginTop, marginL, 0.0),
      width: MxBaseUserInfo.instance.deviceSize.width,
      height: this.height.vsp,
      child: TapDebouncer(
        onTap: this.tap as Future<void> Function()?,
        cooldown: const Duration(milliseconds: 1200),
        builder: (ctx, onTap) {
          return ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              elevation: 0.0,
              padding: EdgeInsets.all(0.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                  gradient: this.color != null
                      ? LinearGradient(colors: [this.color!, this.color!])
                      : this.gradient != null
                          ? this.gradient
                          : UIData.defaultBtnGradient()),
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(0.0, this.paddingV, 0.0, this.paddingV),
                alignment: Alignment.center,
                child: Text(
                  '${this.title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: this.fontSize, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyTextBtn extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final Function onTap;
  final double? width;

  final double? height;

  final bool touchable;

  const MyTextBtn(
    this.title,
    this.color,
    this.onTap, {
    Key? key,
    this.fontSize = 14.0,
    this.width,
    this.height,
    this.touchable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      height: this.height,
      child: TextButton(
        onPressed: this.onTap as void Function()?,
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.all(0.0)),
        ),
        child: Container(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: this.fontSize < 9 ? 9 : this.fontSize,
                  color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class MyFlatRoundedBtn extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final Color? titleColor;

  final Color bodyColor;
  final Function onTap;
  final double? width;

  final num lPadding;
  final num vPadding;
  final double? height;
  final int countDownMillis;
  final double radius;
  final bool zeroPadding;
  final bool touchable;

  @override
  Widget build(BuildContext context) {
    return this.title.textEmpty()
        ? SizedBox(
            width: this.width,
            height: this.height,
          )
        : MyDebounceWrapper(
            InkWell(
              splashColor: Colors.transparent,
              child: Container(
                width: this.width,
                height: this.height,
                margin: this.zeroPadding ||
                        (this.width != null && this.height != null)
                    ? EdgeInsets.all(0.0)
                    : EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                padding: this.zeroPadding
                    ? EdgeInsets.all(0.0)
                    : EdgeInsets.fromLTRB(this.lPadding.hsp, this.vPadding.vsp,
                        this.lPadding.hsp, this.vPadding.vsp),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: color),
                    color: this.bodyColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(this.radius))),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: this.fontSize < 9 ? 9 : this.fontSize,
                        color:
                            this.titleColor != null ? this.titleColor : color),
                  ),
                ),
              ),
            ),
            countDownMillisec: this.countDownMillis,
            onTap: () async {
              if (this.touchable) this.onTap.call();
            },
          );
  }

  MyFlatRoundedBtn(
    this.title,
    this.color,
    this.onTap, {
    this.fontSize = 14.0,
    this.width,
    this.height,
    this.radius = 4.0,
    this.zeroPadding = false,
    this.touchable = true,
    this.bodyColor = UIData.pureWhite,
    this.lPadding = 10,
    this.vPadding = 2,
    this.titleColor,
    this.countDownMillis = 800,
  });
}

class MyFlatMainBtn extends StatelessWidget {
  final String title;
  final num paddingH;
  final double fontSize;
  final Color color;
  final Color bodyColor;
  final Color? titleColor;

  final Function onTap;
  final double? width;

  final double height;
  final double radius;
  final Color? borderColor;

  final bool touchable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
            splashColor: Colors.transparent,
            onTap: !this.touchable ? null : this.onTap as void Function()?,
            child: Container(
              width: this.width,
              height: this.height,
              padding: this.height != null
                  ? EdgeInsets.all(0.0)
                  : EdgeInsets.fromLTRB(
                      this.paddingH.sp(), 2.sp(), this.paddingH.sp(), 2.sp()),
              decoration: BoxDecoration(
                  color: this.bodyColor,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color:
                          this.borderColor != null ? this.borderColor! : color),
                  borderRadius: BorderRadius.all(Radius.circular(radius))),
              child: Center(
                child: Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: this.fontSize < 9 ? 9 : this.fontSize,
                      color: titleColor != null ? titleColor : this.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ).capsule(gradient: UIData.defaultBtnGradient()))
        .box
        .height(40.vsp)
        .make();
  }

  MyFlatMainBtn(this.title, this.onTap,
      {this.fontSize = 14.0,
      this.width,
      this.color = UIData.primaryColor,
      this.titleColor,
      this.height = 40.0,
      this.radius = 4.0,
      this.borderColor,
      this.touchable = true,
      this.bodyColor = UIData.pureWhite,
      this.paddingH = 28});
}

class MyFlatRoundedConcreteBtn extends StatelessWidget {
  final String? title;

  final double fontSize;
  final Color color;
  final Color? titleColor;

  final Function? onTap;

  final double? width;

  final num paddingH;
  final num paddingV;
  final double? height;

  final double radius;
  final Color? borderColor;

  final Color tintColor;
  final bool isGradient;
  final bool touchable;
  final bool isTitleCenter;

  @override
  Widget build(BuildContext context) {
    var titleWidget = Text(
      title!,
      maxLines: 50,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: this.fontSize < 9 ? 9 : this.fontSize,
          color: titleColor != null ? titleColor : UIData.white),
      overflow: TextOverflow.ellipsis,
    );

    var showWidget = Ink(
      decoration: BoxDecoration(
          gradient: this.isGradient ? UIData.defaultBtnGradient() : null),
      child: Container(
        height: this.height,
        color: UIData.clickColor(),
        padding: this.height != null
            ? EdgeInsets.fromLTRB(
                this.paddingH.natureVal, 0.0, this.paddingH.natureVal, 0.0)
            : EdgeInsets.fromLTRB(
                this.paddingH.natureVal,
                this.paddingV.natureVal,
                this.paddingH.natureVal,
                this.paddingV.natureVal),
        child: this.isTitleCenter
            ? titleWidget.centered()
            : titleWidget.box.make(),
      ),
    );
    return Container(
      width: this.width,
      height: this.height,
      child: Material(
        color: this.color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        clipBehavior: Clip.antiAlias,
        child: this.touchable
            ? MyDebounceWrapper(showWidget, onTap: () async {
                this.onTap?.call();
              })
            : showWidget,
      ),
    );
  }

  MyFlatRoundedConcreteBtn(this.title, this.color, this.onTap,
      {this.fontSize = 14.0,
      this.width,
      this.titleColor,
      this.height,
      this.radius = 4.0,
      this.borderColor,
      this.touchable = true,
      this.tintColor = Colors.transparent,
      this.paddingH = 5,
      this.paddingV = 2,
      this.isGradient = false,
      this.isTitleCenter = true});
}
