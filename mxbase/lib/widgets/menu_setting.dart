import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MenuTextSetting extends StatelessWidget {
  final title;
  final double titleSize;
  final Widget? center;

  final Widget? rightAction1;

  final Function()? onTap;
  final bool hasDivider;
  final bool isTitleRequire;
  final Widget? rightBtn;

  final num paddingV;
  final num centerPaddingStart;
  final double height;
  final Color bgColor;

  static Widget get _defaultRightBtn => MyAssetImageView(
        UIData.icNext,
        width: 7.hsp,
        height: 11.vsp,
      );

  MenuTextSetting(this.title, this.onTap,
      {this.hasDivider = true,
      this.rightBtn,
      this.paddingV = 5.0,
      this.height = 55.0,
      this.center,
      this.titleSize = 15.0,
      this.rightAction1,
      this.centerPaddingStart = 10,
      this.bgColor = UIData.pureWhite,
      this.isTitleRequire = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        height: this.height,
        width: double.infinity,
        padding: UIData.fromLTRB(15, this.paddingV, 15.0, this.paddingV),
        decoration: hasDivider
            ? BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: UIData.lineBg, width: UIData.lineH)),
                color: this.bgColor)
            : BoxDecoration(color: this.bgColor),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                this.isTitleRequire
                    ? Text(
                        '*',
                        style: TextStyle(
                            fontSize: this.titleSize, color: UIData.red),
                      )
                    : SizedBox(),
                Text(
                  title,
                  style:
                      TextStyle(fontSize: this.titleSize, color: UIData.black),
                ),
              ],
            ).box.height(this.height).make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: this.centerPaddingStart.hsp,
                ),
                this.center != null ? this.center! : SizedBox(),
                Text('').expand(),
                this.rightAction1 == null ? SizedBox() : this.rightAction1!,
                5.hSpacer(),
                this.rightBtn != null ? this.rightBtn! : _defaultRightBtn
              ],
            ).box.height(this.height).make(),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class MenuSetting extends StatelessWidget {
  var iconPath;
  var title;

  Color? titleColor;

  final Function() onTap;
  var hasDivider;
  final rightBtn;
  final Widget? rightText;

  final Widget? action1;
  final num leadingSpace;
  final double paddingV;
  final num fontSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    bool hasIcon = this.iconPath != null && this.iconPath.toString().isNotEmpty;

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
          height: this.height,
          padding: EdgeInsets.fromLTRB(0.0, this.paddingV, 15.0, this.paddingV),
          decoration: hasDivider
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: UIData.lineBg, width: UIData.lineH)),
                  color: Colors.white,
                )
              : BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  this.leadingSpace.hSpacer(),
                  hasIcon
                      ? MyAssetImageView(
                          iconPath,
                          width: 42.sp(),
                          height: 42.sp(),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: hasIcon ? 15.hsp : 15.hsp,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: this.fontSize as double?,
                        color: this.titleColor != null
                            ? this.titleColor
                            : UIData.black),
                  ),
                  this.action1 == null ? SizedBox() : this.action1!,
                ],
              ),
              Expanded(
                child: Text(''),
              ),
              this.rightText != null ? this.rightText! : SizedBox(),
              SizedBox(
                width: 5.0,
              ),
              this.rightBtn != null
                  ? this.rightBtn
                  : MyAssetImageView(
                      UIData.icNext,
                      width: 15.sp(),
                      height: 15.sp(),
                    ),
            ],
          )),
    );
  }

  MenuSetting(this.iconPath, this.title, this.onTap,
      {this.hasDivider = true,
      this.rightBtn,
      this.titleColor,
      this.rightText,
      this.paddingV = 14.0,
      this.height,
      this.action1,
      this.fontSize = 15.0,
      this.leadingSpace = 15});
}
