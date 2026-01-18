import 'package:flutter/material.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';

import 'my_imageview.dart';

class MycheckboxStateless extends StatelessWidget {
  final bool initVal;
  final bool isDisabled;
  final num size;
  final num? height;
  final num innerPadding;
  final String? iconH;

  final String? iconN;

  final ValueChanged<bool>? onChange;

  MycheckboxStateless(
      {Key? key,
      this.initVal = true,
      this.onChange,
      this.isDisabled = false,
      this.size = 20,
      this.height,
      this.iconH = 'ic_check_box_h.png',
      this.iconN = 'ic_check_box_n.png',
      this.innerPadding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.hsp,
      height: (height ?? size).hsp,
      color: UIData.clickColor(),
      child: Padding(
        padding: EdgeInsets.all(this.innerPadding.hsp),
        child: this.isDisabled
            ? MyAssetImageView(
                'ic_gray_check_radio.png',
                width: (size - innerPadding).hsp,
                height: (size - innerPadding).hsp,
                fit: BoxFit.fill,
              )
            : MyAssetImageView(
                initVal ? this.iconH : this.iconN,
                fit: BoxFit.fill,
                width: (size - innerPadding).hsp,
                height: ((height ?? size) - innerPadding).hsp,
              ),
      ),
    ).xOnTap(() {
      if (this.onChange != null) this.onChange!(!this.initVal);
    });
  }
}

class MyCheckedBoxSecond extends StatefulWidget {
  final bool initVal;

  final ValueChanged<bool>? onChange;

  MyCheckedBoxSecond({Key? key, this.initVal = true, this.onChange})
      : super(key: key);

  @override
  _MyCheckedBoxSecondState createState() {
    return _MyCheckedBoxSecondState();
  }
}

class _MyCheckedBoxSecondState extends State<MyCheckedBoxSecond> {
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
    return GestureDetector(
      onTap: () {
        setState(() {
          this._checked = !_checked;
        });
        if (widget.onChange != null) widget.onChange!(this._checked);
      },
      child: Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: _checked
              ? MyAssetImageView(
                  'ic_check_box_h.png',
                  width: 18.hsp,
                  height: 18.hsp,
                )
              : MyAssetImageView(
                  'ic_check_box_n.png',
                  width: 18.hsp,
                  height: 18.hsp,
                ),
        ),
      ),
    );
  }
}
