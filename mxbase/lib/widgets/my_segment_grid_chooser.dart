import 'package:flutter/material.dart';
import 'package:mxbase/delegate/grid_delegate.dart';

class MySegmGridChooser extends StatefulWidget {
  const MySegmGridChooser(this.data,
      {Key key,
      this.onChoosed,
      this.itemLang = 48.0,
      this.width,
      this.mainSpace = 2.0,
      this.height = 20.0,
      @required this.itemBuilder,
      this.itemCurrentBuilder,
      this.crossSpace = 5.0,
      this.span = 1})
      : super(key: key);

  static String get route => 'RSegmGridChooser';

  final List<String> data;
  final Function onChoosed;
  final int span;
  final double itemLang;
  final double width;
  final double height;
  final double mainSpace;
  final double crossSpace;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder itemCurrentBuilder;

  @override
  _MySegmGridChooserState createState() {
    return _MySegmGridChooserState();
  }
}

class _MySegmGridChooserState extends State<MySegmGridChooser> {
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
  }

  @override
  void initState() {
    super.initState();
    this.onItemChoosed(0);
  }

  @override
  Widget build(BuildContext context) {
    int rowsCount = (widget.data.length / widget.span).ceil().toInt();
    int spacerCount = rowsCount > 2 ? rowsCount - 1 : 0;
    return Container(
      height: widget.itemLang * rowsCount + widget.mainSpace * spacerCount,
      width: widget.width,
      child: GridView.builder(
          physics: ScrollPhysics(),
          gridDelegate: XSliverGridDelegate(
              smallCellExtent: widget.itemLang,
              bigCellExtent: widget.itemLang,
              mainAxisSpacing: widget.mainSpace,
              crossAxisSpacing: widget.crossSpace,
              crossAxisCount: widget.span),
          itemCount: widget.data.length,
          shrinkWrap: false,
          itemBuilder: (context, idx) {
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
          }),
    );
  }
}
