import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'my_text.dart';
import 'package:velocity_x/velocity_x.dart';

class MySwitch extends StatefulWidget {
  final bool initVal;
  final String textOff;
  final String textOn;
  final double height;
  final double? width;
  final ValueChanged<bool>? onChange;

  MySwitch(
      {Key? key,
      this.initVal = true,
      this.onChange,
      this.textOff = 'off',
      this.textOn = 'on',
      this.height = 33.0,
      this.width})
      : super(key: key);

  @override
  _MySwitchState createState() {
    return _MySwitchState();
  }
}

class _MySwitchState extends State<MySwitch> {
  bool _checked = true;

  @override
  void initState() {
    super.initState();
    350.delay(() {
      if (widget.initVal != null)
        setState(() {
          this._checked = widget.initVal;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var radiusOuter = widget.height * 1.0 / 2;
    var radiusInner = radiusOuter - 2.hsp;
    return Container(
      padding: EdgeInsets.fromLTRB(2.hsp, 1.vsp, 2.hsp, 1.vsp),
      decoration: BoxDecoration(
          gradient: UIData.defaultBtnGradient(),
          borderRadius: BorderRadius.circular(radiusOuter)),
      width: widget.width,
      height: widget.height,
      child: HStack([
        Expanded(
            child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radiusInner)),
          child: Container(
            color: this._checked ? UIData.clickColor() : UIData.pureWhite,
            child: MyCustomText('${widget.textOff}',
                    !this._checked ? UIData.primaryColor : UIData.pureWhite)
                .box
                .makeCentered(),
          ).onTap(() {
            setState(() {
              this._checked = false;
            });
            if (widget.onChange != null) {
              widget.onChange!(this._checked);
            }
          }),
        )),
        Expanded(
            child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radiusInner)),
          child: Container(
            color: this._checked ? UIData.pureWhite : UIData.clickColor(),
            child: MyCustomText('${widget.textOn}',
                    this._checked ? UIData.primaryColor : UIData.pureWhite)
                .box
                .makeCentered(),
          ).onTap(() {
            setState(() {
              this._checked = true;
            });
            if (widget.onChange != null) {
              widget.onChange!(this._checked);
            }
          }),
        ))
      ]),
    );
  }
}
