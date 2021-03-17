import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MenuTextSetting extends StatelessWidget {
  final title;
  final double titleSize;
  final Widget center;
  final Widget rightAction1;
  final Function() onTap;
  final hasDivider;
  final rightBtn;
  final double paddingV;
  final double h;

  MenuTextSetting(this.title, this.onTap,
      {this.hasDivider = true,
      this.rightBtn,
      this.paddingV = 14.0,
      this.h,
      this.center,
      this.titleSize = 15.0,
      this.rightAction1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
          height: this.h,
          padding:
              EdgeInsets.fromLTRB(12.0, this.paddingV, 22.0, this.paddingV),
          decoration: hasDivider
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: UIData.lineBg, width: UIData.lineH)),
                  color: UIData.white)
              : BoxDecoration(color: UIData.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: this.titleSize, color: UIData.black),
              ),
              SizedBox(
                width: 10.0,
              ),
              this.center != null ? this.center : SizedBox(),
              Expanded(
                child: Text(''),
              ),
              this.rightAction1 == null ? SizedBox() : this.rightAction1,
              this.rightBtn != null
                  ? this.rightBtn
                  : Image.asset(
                      UIData.icNext,
                      width: 12.0,
                      height: 20.0,
                    )
            ],
          )),
    );
  }
}

class MenuSetting extends StatelessWidget {
  var iconPath;
  var title;
  Color titleColor;
  final Function() onTap;
  var hasDivider;
  final rightBtn;
  final Widget rightText;
  final Widget action1;
  final double paddingV;
  final double fontSize;
  final double h;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
          height: this.h,
          padding:
              EdgeInsets.fromLTRB(22.0, this.paddingV, 22.0, this.paddingV),
          decoration: hasDivider
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: UIData.lineBg, width: UIData.lineH)),
                  color: UIData.white,
                )
              : BoxDecoration(color: UIData.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MyAssetImageView(
                    iconPath,
                    width: 22.0,
                    heigh: 22.0,
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: this.fontSize,
                        color: this.titleColor != null
                            ? this.titleColor
                            : UIData.black),
                  ),
                  this.action1 == null ? SizedBox() : this.action1,
                ],
              ),
              Expanded(
                child: Text(''),
              ),
              this.rightText != null ? this.rightText : SizedBox(),
              SizedBox(
                width: 5.0,
              ),
              this.rightBtn != null
                  ? this.rightBtn
                  : Image.asset(
                      UIData.icNext,
                      width: 12.0,
                      height: 20.0,
                    )
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
      this.h,
      this.action1,
      this.fontSize = 15.0});
}
