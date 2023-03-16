import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'my_loading_view.dart';

class MyPhotoView extends StatefulWidget {
  final List<String>? imgList;
  final MxReturn<int>? onPageChange;

  MyPhotoView({Key? key, this.imgList, this.onPageChange}) : super(key: key);

  @override
  _MyPhotoViewState createState() {
    return _MyPhotoViewState();
  }
}

class _MyPhotoViewState extends State<MyPhotoView> {
  List<String>? _imgList = [];

  @override
  void initState() {
    super.initState();

    500.delay(() {
      setState(() {
        this._imgList = widget.imgList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        var imgItem = this._imgList![index];
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(imgItem),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(
              tag: "${index + 1}/${this._imgList!.length}"),
        );
      },
      itemCount: this._imgList!.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: MyLoadingIndicator(),
        ),
      ),
      backgroundDecoration: BoxDecoration(color: Colors.black45),
      onPageChanged: (int idx) {
        if (widget.onPageChange != null) {
          widget.onPageChange!(idx);
        }
      },
    ));
  }
}
