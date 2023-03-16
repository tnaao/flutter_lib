import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/delegate/grid_delegate.dart';

class MySegmGridChooser extends StatefulWidget {
  const MySegmGridChooser(this.data,
      {Key? key,
      this.onChoosed,
      this.itemLang = 48.0,
      this.width,
      this.mainSpace = 2.0,
      this.height = 20.0,
      required this.itemBuilder,
      this.itemCurrentBuilder,
      this.crossSpace = 5.0,
      this.span = 1,
      this.canScroll = true,
      this.onChooseIndex,
      this.direction = Axis.vertical,
      this.lenCalulator})
      : super(key: key);

  static String get route => 'RSegmGridChooser';

  final List<String> data;
  final Function? lenCalulator;
  final Function? onChoosed;
  final Function? onChooseIndex;
  final int span;
  final bool canScroll;
  final double itemLang;
  final double? width;
  final double height;
  final double mainSpace;
  final double crossSpace;
  final Axis direction;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? itemCurrentBuilder;

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
      widget.onChoosed!(widget.data[idx]);
    }

    if (widget.onChooseIndex != null) {
      widget.onChooseIndex!(idx);
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
    if (widget.direction == Axis.horizontal) {
      return StaggeredGridView.builder(
        scrollDirection: widget.direction,
        itemCount: widget.data.length,
        physics:
            widget.canScroll ? ScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (context, idx) {
          bool isCurrent = _currentIdx == idx;

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentIdx = idx;
              });
              this.onItemChoosed(idx);
            },
            child: isCurrent && widget.itemCurrentBuilder != null
                ? widget
                    .itemCurrentBuilder!(context, idx)
                    .box
                    .padding(EdgeInsets.only(bottom: widget.crossSpace))
                    .make()
                : widget
                    .itemBuilder(context, idx)
                    .box
                    .padding(EdgeInsets.only(bottom: widget.crossSpace))
                    .make(),
          );
        },
        shrinkWrap: true,
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rowsCount,
          mainAxisSpacing: widget.mainSpace,
          staggeredTileBuilder: (int index) {
            var title = widget.data[index];
            int? len = title.length * 14 + 40;
            if (widget.lenCalulator != null) {
              len = widget.lenCalulator!(index);
            } else {
              return StaggeredTile.extent(1, len.sp());
            }
            return StaggeredTile.extent(1, len!.sp());
          },
          staggeredTileCount: widget.data.length,
        ),
      ).h(
        widget.height != null
            ? widget.height
            : (widget.itemLang * (rowsCount) + widget.mainSpace * spacerCount)
                .sp(),
      );
    }

    return Container(
//      height:
//          (widget.itemLang * (rowsCount) + widget.mainSpace * spacerCount).sp(),
//      width: widget.width,
      child: GridView.builder(
          physics: widget.canScroll
              ? ScrollPhysics()
              : NeverScrollableScrollPhysics(),
          gridDelegate: XSliverGridDelegate(
              smallCellExtent: widget.itemLang,
              bigCellExtent: widget.itemLang,
              mainAxisSpacing: widget.mainSpace,
              crossAxisSpacing: widget.crossSpace,
              crossAxisCount: widget.span),
          itemCount: widget.data.length,
          shrinkWrap: true,
          itemBuilder: (context, idx) {
            bool isCurrent = _currentIdx == idx;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIdx = idx;
                });
                this.onItemChoosed(idx);
              },
              child: isCurrent && widget.itemCurrentBuilder != null
                  ? widget.itemCurrentBuilder!(context, idx)
                  : widget.itemBuilder(context, idx),
            );
          }),
    );
  }
}
