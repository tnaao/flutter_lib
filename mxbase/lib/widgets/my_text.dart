import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/common.dart';
import 'package:mxbase/mxbase.dart';

class MyBlackText extends StatelessWidget {
  final String? text;

  final num size;
  final FontWeight? weight;

  final int darkLevel;
  final int maxLen;
  final int lines;

  const MyBlackText(this.text,
      {Key? key,
      this.size = 14,
      this.weight,
      this.darkLevel = 1,
      this.maxLen = 0,
      this.lines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = UIData.black;
    switch (this.darkLevel) {
      case 2:
        textColor = Color(0xff1A1A1A);
        break;
      case 3:
        textColor = Color(0xff010101);
        break;
      default:
    }

    var textShow = this.text;
    if (this.text != null &&
        this.maxLen > 0 &&
        this.text.mxText.length > this.maxLen) {
      textShow = this.text.mxText.substring(0, this.maxLen - 1);
    }

    return Text(textShow == null || textShow == 'null' ? '' : '$textShow',
        overflow: TextOverflow.ellipsis,
        maxLines: lines,
        style: TextStyle(
            fontSize: size.toDouble(),
            fontWeight: this.weight,
            color: textColor));
  }
}

class MyGrayText extends StatelessWidget {
  final String? text;

  final num size;
  final int grayLevel;
  final FontWeight? weight;
  final int lines;
  final int maxLen;
  final bool hasLineThrough;

  const MyGrayText(this.text,
      {Key? key,
      this.size = 14.0,
      this.grayLevel = 2,
      this.lines = 1,
      this.maxLen = 0,
      this.hasLineThrough = false,
      this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = UIData.textGN;
    switch (this.grayLevel) {
      case 1:
        textColor = UIData.textGD;
        break;
      case 2:
        textColor = Color(0xff818181);
        break;
      case 3:
        textColor = Color(0xFFB7B7B7);
        break;
    }

    var textShow = this.text;
    if (this.text != null &&
        this.maxLen > 0 &&
        this.text!.length > this.maxLen) {
      textShow = this.text!.substring(0, this.maxLen - 1);
    }

    return Text(textShow == null || textShow == 'null' ? '' : '$textShow',
        overflow: TextOverflow.ellipsis,
        maxLines: this.lines,
        style: TextStyle(
            fontSize: size.toDouble(),
            fontWeight: this.weight,
            color: textColor,
            decorationThickness: 2.0,
            decoration:
                !this.hasLineThrough ? null : TextDecoration.lineThrough));
  }
}

class MyCustomText extends StatelessWidget {
  final String? text;

  final num size;
  final String? fontFamily;
  final FontWeight? weight;

  final int grayLevel;
  final int maxLines;
  final Color textColor;
  final bool alignCenter;

  const MyCustomText(this.text, this.textColor,
      {Key? key,
      this.size = 14.0,
      this.weight,
      this.grayLevel = 1,
      this.maxLines = 1,
      this.alignCenter = false,
      this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text == null || text == 'null' ? '' : '$text',
        overflow: TextOverflow.ellipsis,
        maxLines: this.maxLines,
        textAlign: this.alignCenter ? TextAlign.center : TextAlign.justify,
        style: TextStyle(
            fontSize: size.toDouble(),
            fontFamily: this.fontFamily,
            fontWeight: weight,
            color: textColor));
  }
}
