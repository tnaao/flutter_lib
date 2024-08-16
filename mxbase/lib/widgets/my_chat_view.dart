import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:mxbase/ext/common.dart';

class MyChatView extends StatelessWidget {
  final String? content;
  final double fontSize;
  final bool isSender;
  final Color? bgColor;
  final Color? textColor;

  const MyChatView(
      {Key? key,
      this.content,
      this.fontSize = 14.0,
      this.isSender = true,
      this.bgColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      text: content.mxText,
      color: this.bgColor ?? Theme.of(context).primaryColor,
      tail: true,
      isSender: this.isSender,
      textStyle: TextStyle(
          color: this.textColor ?? Colors.white, fontSize: this.fontSize),
    );
  }
}
