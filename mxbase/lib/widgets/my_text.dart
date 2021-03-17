import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';

class MyBlackText extends StatelessWidget {
  final String text;
  final fontSize;
  final FontWeight weight;
  final int darkLevel;
  final int maxLen;
  final int lines;

  const MyBlackText(this.text,
      {Key key,
      this.fontSize = 14.0,
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
        textColor = Color(0xff4C4C4C);
        break;
      default:
    }

    var textShow = this.text;
    if (this.text != null &&
        this.maxLen > 0 &&
        this.text.length > this.maxLen &&
        this.lines < 2) {
      textShow = this.text.substring(0, this.maxLen - 1) + '..';
    }

    return Text(textShow == null ? '' : '$textShow',
        overflow: TextOverflow.ellipsis,
        maxLines: lines,
        style: TextStyle(
            fontSize: fontSize, fontWeight: this.weight, color: textColor));
  }
}

class MyGrayText extends StatelessWidget {
  final String text;
  final fontSize;
  final int grayLevel;
  final int maxLines;
  final int maxLen;
  final bool hasLineThrough;

  const MyGrayText(this.text,
      {Key key,
      this.fontSize = 14.0,
      this.grayLevel = 1,
      this.maxLines = 1,
      this.maxLen = 0,
      this.hasLineThrough = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = UIData.textGN;
    switch (this.grayLevel) {
      case 2:
        textColor = Color(0xff959595);
        break;
      case 3:
        textColor = Color(0xFFB7B7B7);
        break;
    }

    var textShow = this.text;
    if (this.text != null &&
        this.maxLen > 0 &&
        this.text.length > this.maxLen) {
      textShow = this.text.substring(0, this.maxLen - 1) + '..';
    }

    return Text(textShow == null || textShow == 'null' ? '' : '$textShow',
        overflow: TextOverflow.ellipsis,
        maxLines: this.maxLines,
        style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            decorationThickness: 2.0,
            decoration:
                !this.hasLineThrough ? null : TextDecoration.lineThrough));
  }
}

class MyCustomText extends StatelessWidget {
  final String text;
  final fontSize;
  final FontWeight weight;
  final int grayLevel;
  final int maxLines;
  final Color textColor;

  const MyCustomText(this.text, this.textColor,
      {Key key,
      this.fontSize = 14.0,
      this.weight,
      this.grayLevel = 1,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$text',
        overflow: TextOverflow.ellipsis,
        maxLines: this.maxLines,
        style: TextStyle(
            fontSize: fontSize, fontWeight: weight, color: textColor));
  }
}
