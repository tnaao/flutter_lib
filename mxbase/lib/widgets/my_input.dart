import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MyRoundedSearchInput extends StatelessWidget {
  final hint;
  final String searchIcon;
  final double iconSize;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onComplete;
  final double height;
  final double width;
  final double fontSize;
  final double radius;

  const MyRoundedSearchInput(
      {Key key,
      this.hint,
      this.searchIcon,
      this.onChange,
      this.onComplete,
      this.height = 30.0,
      this.fontSize,
      this.width,
      this.radius,
      this.iconSize = 15.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.transparent),
        color: UIData.windowBg,
        borderRadius: BorderRadius.all(
            Radius.circular(this.radius != null ? this.radius : height / 2)),
      ),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          this.searchIcon == null || this.searchIcon.length < 1
              ? Icon(
                  Icons.search,
                  color: UIData.textGN,
                  size: this.iconSize,
                )
              : MyAssetImageView(
                  this.searchIcon,
                  heigh: this.iconSize,
                  fit: BoxFit.fitHeight,
                ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
              child: TextField(
                  onSubmitted: this.onComplete,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  onChanged: this.onChange,
                  keyboardType: TextInputType.text,
                  style:
                      TextStyle(fontSize: this.fontSize, color: UIData.black),
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontSize: this.fontSize, color: UIData.textGN),
                    border: InputBorder.none,
                  )))
        ],
      ),
    );
  }
}

class BoxInputUserInfo extends StatelessWidget {
  final label;
  final hint;
  final hasLabel;
  final bool hasDivider;
  final ValueChanged<String> onChange;
  final icon;
  final double iconWidth;
  final double paddignL;
  final rightIcon;
  final bool isPhone;
  final bool isSecure;
  final onTap;
  final String initText;

  BoxInputUserInfo(this.label, this.hint, this.onChange,
      {this.initText = '',
      this.paddignL = 0.0,
      this.hasLabel = true,
      this.hasDivider = true,
      this.onTap,
      this.icon,
      this.rightIcon,
      this.iconWidth = 0.0,
      this.isPhone = false,
      this.isSecure = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 8, 15, 8.0),
        decoration: BoxDecoration(
            color: UIData.white,
            border: !this.hasDivider
                ? null
                : Border(
                    bottom:
                        BorderSide(color: UIData.lineBg, width: UIData.lineH))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "$label",
              style: UIData.tsSGNTitleBigger,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 180,
                  child: TextField(
                      controller: initText == null
                          ? null
                          : TextEditingController.fromValue(TextEditingValue(
                              text: initText == null ? "" : initText,
                              selection: TextSelection.fromPosition(
                                  TextPosition(
                                      affinity: TextAffinity.downstream,
                                      offset: initText == null
                                          ? 0
                                          : initText.length)))),
                      enabled: this.onTap == null,
                      textAlign: TextAlign.end,
                      onChanged: this.onChange,
                      keyboardType:
                          !isPhone ? TextInputType.text : TextInputType.phone,
                      obscureText: this.isSecure,
                      style: UIData.tsBTitleNormal,
                      decoration: new InputDecoration(
                        hintText: hint,
                        hintStyle: UIData.tsSGNTitle,
                        border: InputBorder.none,
                      )),
                ),
                SizedBox(
                  width: 11.0,
                ),
                this.rightIcon != null ? this.rightIcon : SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BoxField extends StatelessWidget {
  final hint;
  final double w;
  final double h;
  final int maxLines;
  final ValueChanged<String> onChange;
  final double paddignL;
  final bool isPhone;
  final bool isSecure;
  final String initText;
  final double fontSize;
  final TextAlign align;
  final Decoration decoration;
  final bool isCenter;

  const BoxField(
      {Key key,
      this.hint,
      this.onChange,
      this.paddignL,
      this.isPhone = false,
      this.isSecure = false,
      this.initText,
      this.fontSize = 14.0,
      this.w,
      this.align = TextAlign.start,
      this.decoration,
      this.h,
      this.maxLines = 1,
      this.isCenter = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fieldWidget = TextField(
        controller: initText == null
            ? null
            : TextEditingController.fromValue(TextEditingValue(
                text: initText == null ? "" : initText,
                selection: TextSelection.fromPosition(TextPosition(
                    affinity: TextAffinity.downstream,
                    offset: initText == null ? 0 : initText.length)))),
        textAlign: this.align,
        onChanged: this.onChange,
        maxLines: this.maxLines,
        keyboardType: !isPhone ? TextInputType.text : TextInputType.phone,
        obscureText: this.isSecure,
        style: TextStyle(fontSize: this.fontSize, color: UIData.black),
        decoration: hint == null
            ? null
            : InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(fontSize: this.fontSize, color: UIData.textGN),
                border: InputBorder.none,
              ));

    return Container(
        height: this.h,
        width: this.w,
        decoration: this.decoration,
        child: Container(
          child: !this.isCenter
              ? fieldWidget
              : Center(
                  child: fieldWidget,
                ),
        ));
  }
}

class BoxInput extends StatelessWidget {
  final String label;
  final double labelFontSize;
  final hint;
  final hasLabel;
  final double height;
  final ValueChanged<String> onChange;
  final icon;
  final double iconWidth;
  final double paddignL;
  final bool hasDivider;
  final rightIcon;
  final bool isPhone;
  final bool isSecure;
  final onTap;
  final String initText;

  BoxInput(this.label, this.hint, this.onChange,
      {this.initText = '',
      this.paddignL = 0.0,
      this.hasLabel = true,
      this.onTap,
      this.icon,
      this.rightIcon,
      this.iconWidth = 0.0,
      this.isPhone = false,
      this.isSecure = false,
      this.hasDivider = true,
      this.height,
      this.labelFontSize = 14.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(this.paddignL, 5.0, 0.0, 0.0),
      height: this.height,
      decoration: BoxDecoration(
          border: !this.hasDivider
              ? Border()
              : Border(
                  bottom:
                      BorderSide(color: UIData.lineBg, width: UIData.lineH))),
      child: GestureDetector(
        onTap: this.onTap,
        child: Stack(
          alignment: Alignment(-1.0, 0.0),
          children: <Widget>[
            hasLabel
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0.0, 0, 0),
                    child: Text(label,
                        style: TextStyle(
                            fontSize: this.labelFontSize,
                            color: UIData.textTitleGD)),
                  )
                : this.icon != null
                    ? this.icon
                    : SizedBox(),
            Container(
              height: 40.0,
              margin: EdgeInsets.fromLTRB(
                  hasLabel
                      ? 18 * this.label.length + 10.0
                      : this.icon != null
                          ? this.iconWidth + 5.0
                          : 0.0,
                  0.0,
                  0.0,
                  0.0),
              child: TextField(
                  controller: initText == null
                      ? null
                      : TextEditingController.fromValue(TextEditingValue(
                          text: initText == null ? "" : initText,
                          selection: TextSelection.fromPosition(TextPosition(
                              affinity: TextAffinity.downstream,
                              offset:
                                  initText == null ? 0 : initText.length)))),
                  enabled: this.onTap == null,
                  textAlign: TextAlign.left,
                  onChanged: this.onChange,
                  keyboardType:
                      !isPhone ? TextInputType.text : TextInputType.phone,
                  obscureText: this.isSecure,
                  style: UIData.tsBTitleNormal,
                  decoration: new InputDecoration(
                    hintText: hint,
                    hintStyle: UIData.tsSGNTitle,
                    border: InputBorder.none,
                  )),
            ),
            Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 1.0,
                    ),
                    this.rightIcon != null ? this.rightIcon : SizedBox()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
