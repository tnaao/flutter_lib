import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/user_info.dart';

class MyMainBtn extends StatelessWidget {
  final marginL;
  final marginTop;
  final title;
  final Function tap;
  final double radius;
  final double paddingV;
  final double fontSize;
  final Color color;
  final double height;

  MyMainBtn(this.title, this.tap,
      {this.marginL = 0.0,
      this.marginTop = 0.0,
      this.radius = 2.0,
      this.paddingV = 5.0,
      this.fontSize = 16.0,
      this.color,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.fromLTRB(marginL, marginTop, marginL, 0.0),
        width: UserInfo.instance.deviceSize.width,
        height: this.height,
        child: ElevatedButton(
          onPressed: this.tap,
          style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              padding:
                  EdgeInsets.fromLTRB(0.0, this.paddingV, 0.0, this.paddingV),
              primary: this.color != null ? this.color : UIData.mainBtnColor()),
          clipBehavior: Clip.hardEdge,
          child: Text(
            title,
            style: TextStyle(fontSize: this.fontSize, color: Colors.white),
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
  final Function onTap;
  final double width;
  final double height;
  final double radius;
  final bool zeroPadding;
  final bool touchable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      onTap: !this.touchable ? null : this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        margin: this.zeroPadding
            ? EdgeInsets.all(0.0)
            : EdgeInsets.fromLTRB(0.0, 0, 0, 0),
        padding: this.zeroPadding
            ? EdgeInsets.all(0.0)
            : EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: color),
            borderRadius: BorderRadius.all(Radius.circular(this.radius))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: this.fontSize < 9 ? 9 : this.fontSize, color: color),
          ),
        ),
      ),
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
  });
}

class MyFlatRoundedConcreteBtn extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final Color titleColor;
  final Function onTap;
  final double width;
  final double height;
  final double radius;
  final Color borderColor;
  final bool touchable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      onTap: !this.touchable ? null : this.onTap,
      child: Container(
        width: this.width,
        height: this.height,
        padding: this.height != null
            ? EdgeInsets.all(0.0)
            : EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            border: Border.all(
                color: this.borderColor != null ? this.borderColor : color),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        child: Center(
          child: Text(
            title,
            maxLines: 2,
            style: TextStyle(
                fontSize: this.fontSize < 9 ? 9 : this.fontSize,
                color: titleColor != null ? titleColor : UIData.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
      this.touchable = true});
}
