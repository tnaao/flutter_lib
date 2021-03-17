import 'package:flutter/material.dart';
import 'package:mxbase/widgets/my_loading_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MyCachedImageView extends StatelessWidget {
  final String imgURL;
  final double width;
  final double heigh;
  final BoxFit fit;
  final bool isOval;

  @override
  Widget build(BuildContext context) {
    if (this.imgURL == null || this.imgURL.length < 4) {
      return Container(
        color: UIData.windowBg,
        width: this.width,
        height: this.heigh,
        child: Center(
          child: Icon(
            Icons.wallpaper,
            size: this.width != null && this.width > 0 ? this.width / 4 : 35.0,
            color: UIData.textGL,
          ),
        ),
      );
    }

    String _imageURL =
        !this.imgURL.contains('http') ? this.imgURL.imgAddHost() : this.imgURL;

    return Container(
      width: this.width,
      height: this.heigh,
      child: this.isOval
          ? ClipOval(
              child: CachedNetworkImage(
                fit: this.fit != null ? this.fit : BoxFit.cover,
                imageUrl: _imageURL,
                placeholder: (ctx, url) => new MyLoadingIndicator(),
                errorWidget: (ctx, url, error) => new Icon(
                  Icons.wallpaper,
                  color: UIData.textGL,
                ),
              ),
            )
          : CachedNetworkImage(
              fit: this.fit != null ? this.fit : BoxFit.cover,
              imageUrl: _imageURL,
              placeholder: (ctx, url) => new MyLoadingIndicator(),
              errorWidget: (ctx, url, error) => Container(
                  width: this.width,
                  height: this.heigh,
                  decoration: BoxDecoration(color: UIData.windowBg),
                  child: Center(
                    child: Icon(
                      Icons.wallpaper,
                      color: UIData.textGL,
                    ),
                  )),
            ),
    );
  }

  MyCachedImageView(this.imgURL,
      {this.width, this.heigh, this.fit, this.isOval = false});
}
