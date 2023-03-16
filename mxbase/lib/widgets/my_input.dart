import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MyRoundedSearchButton extends StatelessWidget {
  final String? hint;

  final String? searchIcon;

  final double iconSize;
  final Color hintColor;

  final ValueChanged<String>? onChange;

  final ValueChanged<String>? onComplete;

  final double height;
  final double? width;

  final double fontSize;
  final double? radius;

  final String? initText;

  final Color bgColor;
  final bool isHomeGradient;

  MyRoundedSearchButton(
      {Key? key,
      this.hint,
      this.searchIcon,
      this.onChange,
      this.onComplete,
      this.height = 30.0,
      this.fontSize = 14.0,
      this.width,
      this.radius,
      this.iconSize = 15.0,
      this.initText,
      this.bgColor = UIData.windowBg,
      this.isHomeGradient = false,
      this.hintColor = UIData.textGN})
      : super(key: key);

  TextEditingController? _controller;

  void initListener(Function afterClear) async {
    AppHolder.eventBus.on<MyRoundedSearchInputClearEvent>().listen((event) {
      if (event.key == this.key) {
        _controller?.text = '';
        _controller?.clear();
        afterClear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initListener(() {
      FocusScope.of(context).unfocus();
    });

    _controller = TextEditingController.fromValue(TextEditingValue(
        text: initText == null ? "" : initText!,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: initText == null ? 0 : initText!.length))));

    return Container(
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.transparent),
        color: this.bgColor,
        gradient: this.isHomeGradient ? UIData.homeSearchGradient() : null,
        borderRadius: BorderRadius.all(
            Radius.circular(this.radius != null ? this.radius! : height / 2)),
      ),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          this.searchIcon == null || this.searchIcon!.length < 1
              ? Icon(
                  Icons.search,
                  color: this.hintColor,
                  size: this.iconSize,
                )
              : MyAssetImageView(
                  this.searchIcon,
                  height: this.iconSize,
                  fit: BoxFit.fitHeight,
                ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Center(
                child: Row(
              children: [
                Text(
                  '$hint',
                  style: TextStyle(
                      fontSize: this.fontSize - 2.0, color: this.hintColor),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            )),
          )
        ],
      ),
    ).onInkTap(() {
      if (this.onChange != null) {
        this.onChange!('');
      }
    });
  }
}

class MyRoundedSearchInput extends StatelessWidget {
  final String? hint;

  final String? searchIcon;

  final double iconSize;

  final ValueChanged<String>? onChange;

  final ValueChanged<String>? onComplete;

  final double height;
  final double? width;

  final double fontSize;
  final double? radius;

  final String? initText;
  final TextInputAction? imeAction;
  final bool editable;

  MyRoundedSearchInput(
      {Key? key,
      this.hint,
      this.imeAction,
      this.searchIcon,
      this.onChange,
      this.onComplete,
      this.height = 30.0,
      this.fontSize = 14.0,
      this.width,
      this.radius,
      this.iconSize = 15.0,
      this.initText,
      this.editable = true,
      this.controller})
      : super(key: key);
  final TextEditingController? controller;

  void initListener(Function afterClear) async {
    AppHolder.eventBus.on<MyRoundedSearchInputClearEvent>().listen((event) {
      if (event.key == this.key) {
        controller?.text = '';
        controller?.clear();
        afterClear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initListener(() {
      FocusScope.of(context).unfocus();
    });

    return Container(
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.transparent),
        color: UIData.windowBg,
        borderRadius: BorderRadius.all(
            Radius.circular(this.radius != null ? this.radius! : height / 2)),
      ),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          this.searchIcon == null || this.searchIcon!.length < 1
              ? Icon(
                  Icons.search,
                  color: UIData.textGN,
                  size: this.iconSize,
                )
              : MyAssetImageView(
                  this.searchIcon,
                  height: this.iconSize,
                  fit: BoxFit.fitHeight,
                ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
              child: Center(
            child: TextFormField(
                initialValue: this.controller != null ? null : this.initText,
                onFieldSubmitted: this.onComplete,
                controller: this.controller,
                maxLines: 1,
                enabled: this.editable,
                textInputAction: this.imeAction ?? TextInputAction.search,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                onChanged: this.onChange,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: this.fontSize, color: UIData.black),
                decoration: false
                    ? null
                    : new InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontSize: this.fontSize - 2.0,
                            color: UIData.textGN),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.search, color: Colors.transparent),
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 0.0, maxWidth: 0.0),
                        isCollapsed: true,
                      )),
          ))
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
    var controllerLocal = initText == null || initText.isEmptyOrNull
        ? null
        : TextEditingController.fromValue(TextEditingValue(
            text: initText == null ? "" : initText,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: initText == null ? 0 : initText.length))));
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
                  child: TextFormField(
                      initialValue: this.initText,
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
  final String? hint;

  final double? w;

  final double? h;

  final int maxLines;
  final int? maxLen;

  final ValueChanged<String>? onChange;

  final ValueChanged<String>? onComplete;

  final double? paddignL;

  final bool isPhone;
  final bool isNumber;
  final bool hasNext;
  final bool isUnsignedInteger;
  final bool isSecure;
  final String? initText;

  final double fontSize;
  final TextAlign align;
  final Decoration? decoration;
  final TextInputAction? imeAction;
  final bool isCenter;
  final Color hintColor;
  final Color textColor;
  final TextEditingController? controller;

  BoxField(
      {Key? key,
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
      this.isCenter = true,
      this.hintColor = UIData.textGN,
      this.onComplete,
      this.maxLen,
      this.isNumber = false,
      this.controller,
      this.textColor = UIData.black,
      this.isUnsignedInteger = false,
      this.imeAction,
      this.hasNext = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fieldWidget = TextField(
        controller: this.controller,
        textAlign: this.align,
        onChanged: this.onChange,
        maxLines: this.maxLines,
        textInputAction: hasNext ? TextInputAction.next : this.imeAction,
        keyboardType: isNumber
            ? TextInputType.number
            : !isPhone
                ? TextInputType.text
                : TextInputType.phone,
        obscureText: this.isSecure,
        onSubmitted: this.onComplete,
        style: TextStyle(fontSize: this.fontSize, color: this.textColor),
        decoration: hint == null
            ? null
            : InputDecoration(
                hintText: hint,
                prefixIcon: Icon(Icons.search, color: Colors.transparent),
                prefixIconConstraints:
                    BoxConstraints(maxHeight: 0.0, maxWidth: 0.0),
                isCollapsed: true,
                hintStyle:
                    TextStyle(fontSize: this.fontSize, color: this.hintColor),
                border: InputBorder.none,
              ));

    var formFieldWidget = TextFormField(
      initialValue: this.initText,
      controller: this.controller,
      textAlign: this.align,
      onChanged: this.onChange,
      maxLines: this.maxLines,
      textInputAction: this.imeAction,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: !this.isUnsignedInteger)
          : !isPhone
              ? TextInputType.text
              : TextInputType.phone,
      obscureText: this.isSecure,
      onFieldSubmitted: this.onComplete,
      maxLength: this.maxLen,
      style: TextStyle(fontSize: this.fontSize, color: this.textColor),
      decoration: InputDecoration(
        hintText: hint == null ? '' : hint,
        counter: SizedBox.shrink(),
        counterStyle: TextStyle(fontSize: 0.0),
        prefixIcon: Icon(Icons.search, color: Colors.transparent),
        prefixIconConstraints: BoxConstraints(maxHeight: 0.0, maxWidth: 0.0),
        isCollapsed: true,
        hintStyle: TextStyle(fontSize: this.fontSize, color: this.hintColor),
        border: InputBorder.none,
      ),
    );

    return Container(
      height: this.h,
      width: this.w,
      decoration: this.decoration,
      padding: EdgeInsets.only(
          left: this.paddignL == null ? 0.0 : this.paddignL!.natureVal),
      child: !this.isCenter
          ? formFieldWidget
          : Center(
              child: formFieldWidget,
            ),
    );
  }
}

class BoxInput extends StatelessWidget {
  final String label;
  final double labelFontSize;
  final hint;
  final hasLabel;
  final double? height;

  final ValueChanged<String> onChange;
  final icon;
  final double iconWidth;
  final double paddignL;
  final bool hasDivider;
  final rightIcon;
  final double rightIconWidth;
  final bool isPhone;
  final bool isNumber;
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
      this.labelFontSize = 14.0,
      this.isNumber = false,
      this.rightIconWidth = 0.0});

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
                    ? this.icon!
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
              child: TextFormField(
                  initialValue: this.initText,
                  enabled: this.onTap == null,
                  textAlign: TextAlign.left,
                  onChanged: this.onChange,
                  keyboardType: isNumber
                      ? TextInputType.numberWithOptions(decimal: true)
                      : !isPhone
                          ? TextInputType.text
                          : TextInputType.phone,
                  obscureText: this.isSecure,
                  style: UIData.tsBTitleNormal,
                  decoration: new InputDecoration(
                    hintText: hint,
                    hintStyle: UIData.tsSGNTitle,
                    border: InputBorder.none,
                  )),
            ).box.margin(EdgeInsets.only(right: this.rightIconWidth)).make(),
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
