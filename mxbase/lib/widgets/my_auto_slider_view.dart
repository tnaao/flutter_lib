import 'package:flutter/material.dart';
import 'package:mxbase/widgets/my_imageview.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyAutoSliverView extends StatefulWidget {
  final IndexedWidgetBuilder? indicatorBuilder;
  final List<String> imgList;
  final double? width;
  final double indicatorBottomPadding;
  final Function? onTap;
  final ValueChanged<int>? onChange;
  final double indicatorSize;
  final double ratio;
  final bool hasAnimation;

  MyAutoSliverView(
    this.imgList,
    this.indicatorBottomPadding, {
    this.onTap,
    this.indicatorSize = 8.0,
    this.ratio = 2.0,
    this.onChange,
    this.indicatorBuilder,
    this.width,
    this.hasAnimation = true,
  });

  @override
  _MyAutoSliverViewState createState() {
    return _MyAutoSliverViewState();
  }
}

class _MyAutoSliverViewState extends State<MyAutoSliverView> {
  kPages() {
    List<Widget> images = [];
    for (int i = 0; i < widget.imgList.length; i++) {
      var aChild = GestureDetector(
        onTap: () {
          if (widget.onTap != null) widget.onTap!(i);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          width: widget.width,
          child: MyNetImageView(
            widget.imgList[i],
            hasAnimation: widget.hasAnimation,
            fit: BoxFit.cover,
          ),
        ),
      );
      images.add(aChild);
    }
    return images;
  }

  int _current = 0;

  List<Widget> indicatorViews() {
    List<Widget> children = [];

    for (int i = 0; i < widget.imgList.length; i++) {
      var aChild = Container(
        width: widget.indicatorSize,
        height: widget.indicatorSize,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _current == i ? Theme.of(context).primaryColor : UIData.textGL),
      );
      children.add(aChild);
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: widget.width,
        child: CarouselSlider(
          items: kPages(),
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              enableInfiniteScroll: widget.imgList.length > 1,
              autoPlayCurve: Curves.fastOutSlowIn,
              viewportFraction: 1.0,
              aspectRatio: widget.ratio,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Positioned(
          bottom: widget.indicatorBottomPadding,
          right: 0.0,
          left: 0.0,
          child: widget.indicatorBuilder != null
              ? widget.indicatorBuilder!(context, _current)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicatorViews(),
                ))
    ]);
  }
}
