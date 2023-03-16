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

  final Color? bgColor;

  MyDropDownMenu(
      {Key? key,
      this.initIdx = 0,
      this.list,
      this.onIdxChange,
      this.textStyle,
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
    // TODO: implement build
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
              iconSize: 12.0,
              hint: Text(
                '${widget.list!.isEmpty ? '' : widget.list![_currentIdx]}',
                style: widget.textStyle?.copyWith(color: UIData.textGN),
              ),
              value: widget.list!.isEmpty ? '' : widget.list![_currentIdx],
              style: widget.textStyle,
              onChanged: (newVal) {
                var idx = widget.list!.indexOf(newVal);
                setState(() {
                  this._currentIdx = idx;
                });
                if (widget.onIdxChange != null) widget.onIdxChange!(idx);
              })
          .box
          .height(20.0)
          .padding(EdgeInsets.only(left: 5.0, right: 5.0))
          .make(),
      radius: 10.0,
    );
  }
}
