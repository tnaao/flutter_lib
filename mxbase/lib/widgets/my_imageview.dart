import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:velocity_x/velocity_x.dart';

class MyNetImageView extends StatelessWidget {
  final String? imgURL;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final bool isOval;
  final bool hasAnimation;
  final Widget? placeWidget;
  final Widget? errWidget;

  @override
  Widget build(BuildContext context) {
    if (this.imgURL == null || this.imgURL!.length < 4) {
      return Container(
        color: Colors.transparent,
        width: this.width,
        height: this.height,
        child: Center(
          child: this.errWidget ??
              Icon(
                Icons.wallpaper,
                size: this.width != null && this.width! > 0
                    ? this.width! / 4
                    : 35.0,
                color: UIData.textGL,
              ),
        ),
      );
    }

    String? _imageURL = !this.imgURL!.contains('http')
        ? this.imgURL!.imgAddHost()
        : this.imgURL;

    bool isSvg = _imageURL.mxText.endsWith('svg');

    return Container(
      width: this.width,
      height: this.height,
      child: this.isOval
          ? ClipOval(
              child: isSvg
                  ? SvgPicture.network(
                      _imageURL.mxText,
                      fit: this.fit ?? BoxFit.cover,
                    )
                  : FadeInImage.memoryNetwork(
                      placeholder: Uint8List.fromList([]),
                      fit: this.fit != null ? this.fit! : BoxFit.cover,
                      fadeInDuration: this.hasAnimation
                          ? Duration(milliseconds: 150)
                          : Duration.zero,
                      placeholderErrorBuilder: (ctx, url, err) =>
                          this.placeWidget != null
                              ? this.placeWidget!
                              : this.hasAnimation
                                  ? MyAssetImageView(
                                      'ic_rect.png',
                                      width: this.width,
                                      height: this.height,
                                      fit: this.fit,
                                    )
                                  : SizedBox(),
                      image: _imageURL!,
                      imageErrorBuilder: (ctx, url, error) =>
                          this.errWidget ??
                          Center(
                            child: Icon(
                              Icons.now_wallpaper,
                              color: UIData.textGL,
                            ),
                          )
                              .box
                              .size(this.width ?? 0, this.height ?? 0)
                              .color(UIData.windowBg)
                              .make(),
                    ),
              clipBehavior: Clip.antiAlias,
            )
          : isSvg
              ? SvgPicture.network(
                  _imageURL.mxText,
                  fit: this.fit ?? BoxFit.cover,
                )
              : FadeInImage.memoryNetwork(
                  fit: this.fit != null ? this.fit! : BoxFit.cover,
                  image: _imageURL!,
                  placeholder: Uint8List.fromList([]),
                  placeholderColor: Color.fromARGB(20, 255, 255, 255),
                  placeholderErrorBuilder: (ctx, url, error) =>
                      this.placeWidget != null
                          ? this.placeWidget!
                          : this.hasAnimation
                              ? MyAssetImageView(
                                  'ic_rect.png',
                                  width: this.width,
                                  height: this.height,
                                  color: Colors.transparent,
                                  fit: this.fit,
                                )
                              : SizedBox(),
                  fadeInDuration: this.hasAnimation
                      ? Duration(milliseconds: 150)
                      : Duration.zero,
                  colorBlendMode: BlendMode.clear,
                  imageErrorBuilder: (ctx, url, error) =>
                      this.errWidget ??
                      Container(
                          width: this.width,
                          height: this.height,
                          decoration: BoxDecoration(color: UIData.windowBg),
                          child: Center(
                            child: Icon(
                              Icons.now_wallpaper,
                              color: UIData.textGL,
                            ),
                          )),
                ),
    );
  }

  MyNetImageView(this.imgURL,
      {this.width,
      this.height,
      this.placeWidget,
      this.fit = BoxFit.cover,
      this.isOval = false,
      Key? key,
      this.hasAnimation = true,
      this.errWidget})
      : super(key: key);
}

class MyAssetImageView extends StatelessWidget {
  final String? imgPath;

  Color? color;
  final Color? svgColor;

  final Color? bgColor;

  final double? width;

  final double? height;

  final BoxFit? fit;
  final bool isOval;
  final double radius;
  final Function? onTap;
  final bool? clickable;
  final Function? onLongTap;

  @override
  Widget build(BuildContext context) {
    bool isBlank = this.imgPath == null || this.imgPath!.length < 1;

    if (isBlank && this.color == null) {
      this.color = UIData.primaryColor;
    }

    var assetPath = this.imgPath.assetPath();

    if (this.imgPath != null && this.imgPath!.startsWith('file://')) {
      var imgFileWidget = Container(
        width: this.width,
        height: this.height,
        color: this.bgColor,
        child: this.isOval
            ? ClipOval(
                child: Image(
                  image: FileImage(File.fromUri(Uri.parse(this.imgPath!))),
                  fit: BoxFit.cover,
                ),
              )
            : Image(
                image: FileImage(File.fromUri(Uri.parse(this.imgPath!))),
                fit: this.fit,
              ),
      ).xGestureTouchContainer(
        clickable ?? onTap != null,
        onTap: () {
          onTap?.call();
        },
        onLongTap: () {
          onLongTap?.call();
        },
      );

      return isOval
          ? ClipOval(
              child: imgFileWidget,
            )
          : imgFileWidget;
    }

    if (this.imgPath != null && this.imgPath!.startsWith('http')) {
      return MyNetImageView(
        this.imgPath,
        width: this.width,
        height: this.height,
        fit: this.fit,
        isOval: isOval,
      ).xGestureTouchContainer(
        clickable ?? onTap != null,
        onTap: () {
          onTap?.call();
        },
        onLongTap: () {
          onLongTap?.call();
        },
      );
    }

    final isSvg = assetPath.endsWith('.svg');

    return Container(
      width: this.width,
      height: this.height,
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
                  borderRadius: BorderRadius.all(Radius.circular(this.radius)),
                  child: Container(
                    color: this.color,
                  ),
                )
          : this.isOval
              ? ClipOval(
                  child: isSvg
                      ? SvgPicture.asset(assetPath,
                          color: this.svgColor, semanticsLabel: '')
                      : isBlank
                          ? Icon(
                              Icons.error,
                              color: UIData.red,
                            )
                          : Image.asset(
                              assetPath,
                              fit: isBlank ? BoxFit.cover : this.fit,
                            ),
                )
              : this.radius < 2.0
                  ? isSvg
                      ? SvgPicture.asset(assetPath,
                          color: this.svgColor, semanticsLabel: '')
                      : isBlank
                          ? Icon(
                              Icons.error,
                              color: UIData.red,
                            )
                          : Image.asset(
                              assetPath,
                              fit: isBlank ? BoxFit.cover : this.fit,
                            )
                  : Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(this.radius),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: isSvg
                          ? SvgPicture.asset(assetPath,
                              color: this.svgColor, semanticsLabel: '')
                          : isBlank
                              ? Icon(
                                  Icons.error,
                                  color: UIData.red,
                                )
                              : Image.asset(
                                  assetPath,
                                  fit: isBlank ? BoxFit.cover : this.fit,
                                ),
                    ),
    ).xGestureTouchContainer(
      (clickable ?? onTap != null),
      onTap: () {
        onTap?.call();
      },
    );
  }

  MyAssetImageView(this.imgPath,
      {this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.isOval = false,
      this.color,
      this.radius = 0.0,
      this.onTap,
      this.clickable,
      this.bgColor,
      this.svgColor,
      this.onLongTap});
}
