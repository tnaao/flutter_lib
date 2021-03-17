import 'package:flutter/material.dart';

class SimpleSegmListChooser<T> extends StatefulWidget {
  const SimpleSegmListChooser(this.data,
      {Key key,
      this.onChoosed,
      this.itemLang = 48.0,
      this.width = 0.0,
      this.mainSpace = 0.0,
      this.height = 20.0,
      @required this.itemBuilder,
      this.itemCurrentBuilder,
      this.onIndexChoosed})
      : super(key: key);

  static String get route => 'RSegmListChooser';

  final List<T> data;
  final Function onChoosed;
  final Function onIndexChoosed;
  final double itemLang;
  final double width;
  final double height;
  final double mainSpace;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder itemCurrentBuilder;

  @override
  _SimpleSegmListChooserState createState() {
    return _SimpleSegmListChooserState();
  }
}

class _SimpleSegmListChooserState extends State<SimpleSegmListChooser> {
  bool loading = false;

  void Loading(bool l) {
    setState(() {
      loading = l;
    });
  }

  int _currentIdx = 0;

  void onItemChoosed(int idx) {
    if (widget.onChoosed != null) {
      widget.onChoosed(widget.data[idx]);
    }

    if (widget.onIndexChoosed != null) {
      widget.onIndexChoosed(idx);
    }
  }

  @override
  void initState() {
    super.initState();
    this.onItemChoosed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int idx) {
          bool isCurrent = _currentIdx == idx;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIdx = idx;
              });
              this.onItemChoosed(idx);
            },
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                isCurrent && widget.itemCurrentBuilder != null
                    ? widget.itemCurrentBuilder(context, idx)
                    : widget.itemBuilder(context, idx),
                SizedBox(
                  width: widget.mainSpace,
                ),
              ],
            ),
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
