import 'package:flutter/material.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MySliderView extends StatefulWidget {
  final List<String> imgList;
  final double indicatorBottomPadding;
  final MxOnValue<int>? onTap;

  MySliderView(this.imgList, this.indicatorBottomPadding, {this.onTap});

  @override
  _MySliderViewState createState() {
    return _MySliderViewState();
  }
}

class _MySliderViewState extends State<MySliderView> {
  kPages() {
    List<Widget> images = [];
    for (int i = 0; i < widget.imgList.length; i++) {
      images.add(GestureDetector(
        onTap: () {
          if (widget.onTap != null) widget.onTap!(i);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: ClipRect(
            child: MyNetImageView(widget.imgList[i]),
            clipBehavior: Clip.hardEdge,
          ),
        ),
      ));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.imgList.length,
      child: Builder(
        builder: (BuildContext context) => Container(
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              alignment: AlignmentDirectional(0, -1),
              children: <Widget>[
                Container(
                  child: TabBarView(children: kPages()),
                ),
                widget.imgList.length > 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TabPageSelector(),
                          SizedBox(
                            height: widget.indicatorBottomPadding,
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            )),
      ),
    );
  }
}
