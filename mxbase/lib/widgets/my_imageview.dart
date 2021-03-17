import 'dart:io';

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

class MyAssetImageView extends StatelessWidget {
  final String imgPath;
  final Color color;
  final Color bgColor;
  final double width;
  final double heigh;
  final BoxFit fit;
  final bool isOval;
  final double radius;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    bool isBlank = this.imgPath == null || this.imgPath.length < 1;

    var assetPath = this.imgPath.assetPath();

    if (this.imgPath != null && this.imgPath.startsWith('file://')) {
      return GestureDetector(
        onTap: this.onTap,
        child: Container(
          width: this.width,
          height: this.heigh,
          color: this.bgColor,
          child: Image(
            image: FileImage(File.fromUri(Uri.parse(this.imgPath))),
            fit: this.fit,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.heigh,
        color: this.bgColor,
        child: this.color != null
            ? this.isOval
                ? ClipOval(
                    child: Material(
                      color: this.color,
                      clipBehavior: Clip.hardEdge,
                      borderRadius:
                          BorderRadius.all(Radius.circular(this.radius)),
                      child: Container(
                        color: this.color,
                      ),
                    ),
                  )
                : Material(
                    color: this.color,
                    clipBehavior: Clip.hardEdge,
                    borderRadius:
                        BorderRadius.all(Radius.circular(this.radius)),
                    child: Container(
                      color: this.color,
                    ),
                  )
            : this.isOval
                ? ClipOval(
                    child: Image.asset(
                      assetPath,
                      fit: isBlank ? BoxFit.cover : this.fit,
                    ),
                  )
                : this.radius < 2.0
                    ? Image.asset(
                        assetPath,
                        fit: isBlank ? BoxFit.cover : this.fit,
                      )
                    : Material(
                        borderRadius: BorderRadius.all(
                          Radius.circular(this.radius),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          assetPath,
                          fit: isBlank ? BoxFit.cover : this.fit,
                        ),
                      ),
      ),
    );
  }

  MyAssetImageView(this.imgPath,
      {this.width,
      this.heigh,
      this.fit = BoxFit.contain,
      this.isOval = false,
      this.color,
      this.radius = 0.0,
      this.onTap,
      this.bgColor});
}
