import 'package:flutter/material.dart';
import 'package:mxbase/widgets/my_btn.dart';
import 'package:mxbase/model/uidata.dart';

class SemengChooser extends StatefulWidget {
  const SemengChooser(this.data,
      {Key key,
      this.onChoosed,
      this.itemLang = 48.0,
      this.width = 0.0,
      this.mainSpace = 0.0,
      this.isShowOnly = false,
      this.height = 20.0})
      : super(key: key);

  static String get route => 'RSemengChooser';

  final List<dynamic> data;
  final Function onChoosed;
  final double itemLang;
  final double width;
  final double height;
  final double mainSpace;
  final bool isShowOnly;

  @override
  _SemengChooserState createState() {
    return _SemengChooserState();
  }
}

class _SemengChooserState extends State<SemengChooser> {
  bool loading = false;

  void Loading(bool l) {
    setState(() {
      loading = l;
    });
  }

  int _currentIdx = 0;
  double _width = 0.0;

  void onItemChoosed(int idx) {
    if (widget.onChoosed != null) {
      widget.onChoosed(widget.data[idx]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int count = widget.data.length;
    this._width = widget.width > 1
        ? widget.width
        : widget.itemLang * count + widget.mainSpace * (count);

    this.onItemChoosed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: _width,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int idx) {
          bool isCurrent = _currentIdx == idx;

          if (widget.isShowOnly) {
            isCurrent = false;
          }

          return Row(
            children: <Widget>[
              MyFlatRoundedConcreteBtn(
                '${widget.data[idx]}',
                isCurrent ? UIData.black : UIData.white,
                () {
                  setState(() {
                    _currentIdx = idx;
                  });

                  this.onItemChoosed(idx);
                },
                height: widget.height,
                width: widget.itemLang,
                radius: 0.0,
                fontSize: 12.0,
                borderColor: isCurrent ? UIData.black : UIData.textGL,
                titleColor: isCurrent ? UIData.white : UIData.textGL,
              ),
              SizedBox(
                width: widget.mainSpace,
              ),
            ],
          );
        },
        itemCount: widget.data.length,
        itemExtent: widget.itemLang + widget.mainSpace,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
