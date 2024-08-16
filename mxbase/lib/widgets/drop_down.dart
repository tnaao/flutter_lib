import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/index.dart';

class MyDropDownMenu extends StatefulWidget {
  final int initIdx;

  final List<String?>? list;

  final ValueChanged<int>? onIdxChange;

  final TextStyle? textStyle;
  final double? height;
  final Color? bgColor;

  MyDropDownMenu(
      {Key? key,
      this.initIdx = 0,
      this.list,
      this.onIdxChange,
      this.textStyle,
      this.height,
      this.bgColor})
      : super(key: key);

  @override
  _MyDropDownMenuState createState() {
    return _MyDropDownMenuState();
  }
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  int _currentIdx = 0;

  @override
  void initState() {
    super.initState();
    200.delay(() {
      setState(() {
        this._currentIdx = widget.initIdx;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBaseCard(
      elevation: 0.0,
      color: widget.bgColor != null ? widget.bgColor! : '#F7F7F7'.hexColor(),
      child: DropdownButton<String>(
              items: widget.list!.map((String? val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(
                    val!,
                    style: widget.textStyle,
                  ),
                );
              }).toList(),
              underline: SizedBox(),
              iconSize: widget.textStyle?.fontSize ?? 12.fsp,
              hint: Text(
                '${widget.list!.isEmpty ? '' : widget.list![_currentIdx]}',
                style: widget.textStyle?.copyWith(color: UIData.textGN),
              ),
              value: widget.list!.isEmpty ? '' : widget.list![_currentIdx],
              style: widget.textStyle ??
                  TextStyle(fontSize: 12.fsp, color: UIData.text333),
              onChanged: (newVal) {
                var idx = widget.list!.indexOf(newVal);
                setState(() {
                  this._currentIdx = idx;
                });
                if (widget.onIdxChange != null) widget.onIdxChange!(idx);
              })
          .box
          .height(widget.height ?? 20.vsp)
          .padding(EdgeInsets.symmetric(horizontal: 5.hsp))
          .make(),
      radius: 10.fsp,
    );
  }
}
