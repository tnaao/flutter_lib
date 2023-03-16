import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mxbase/widgets/my_loading_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

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

    return Container(
      width: this.width,
      height: this.height,
      child: this.isOval
          ? ClipOval(
              child: CachedNetworkImage(
                fit: this.fit,
                imageUrl: _imageURL!,
                placeholderFadeInDuration: Duration.zero,
                fadeInDuration: this.hasAnimation
                    ? Duration(milliseconds: 150)
                    : Duration.zero,
                colorBlendMode: BlendMode.clear,
                placeholder: (ctx, url) => this.placeWidget != null
                    ? this.placeWidget!
                    : this.hasAnimation
                        ? MyAssetImageView(
                            'ic_rect.png',
                            width: this.width,
                            height: this.height,
                            fit: this.fit,
                          )
                        : SizedBox(),
                errorWidget: (ctx, url, error) =>
                    this.errWidget ??
                    Icon(
                      Icons.now_wallpaper,
                      color: UIData.textGL,
                    ),
              ),
              clipBehavior: Clip.antiAlias,
            )
          : CachedNetworkImage(
              fit: this.fit != null ? this.fit! : BoxFit.cover,
              imageUrl: _imageURL!,
              placeholder: (ctx, url) => this.placeWidget != null
                  ? this.placeWidget!
                  : this.hasAnimation
                      ? MyAssetImageView(
                          'ic_rect.png',
                          width: this.width,
                          height: this.height,
                          fit: this.fit,
                        )
                      : SizedBox(),
              placeholderFadeInDuration: Duration.zero,
              fadeInDuration: this.hasAnimation
                  ? Duration(milliseconds: 150)
                  : Duration.zero,
              colorBlendMode: BlendMode.clear,
              errorWidget: (ctx, url, error) =>
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

  final Function? onLongTap;

  @override
  Widget build(BuildContext context) {
    bool isBlank = this.imgPath == null || this.imgPath!.length < 1;

    if (isBlank && this.color == null) {
      this.color = UIData.primaryColor;
    }

    var assetPath = this.imgPath.assetPath();

    if (this.imgPath != null && this.imgPath!.startsWith('file://')) {
      var imgFileWidget = GestureDetector(
        onTap: this.onTap as void Function()?,
        onLongPress: this.onLongTap as void Function()?,
        child: Container(
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
        ),
      );

      return isOval
          ? ClipOval(
              child: imgFileWidget,
            )
          : imgFileWidget;
    }

    if (this.imgPath != null && this.imgPath!.startsWith('http')) {
      return GestureDetector(
        onTap: this.onTap as void Function()?,
        onLongPress: this.onLongTap as void Function()?,
        child: MyNetImageView(
          this.imgPath,
          width: this.width,
          height: this.height,
          fit: this.fit,
          isOval: isOval,
        ),
      );
    }

    final isSvg = assetPath.endsWith('.svg');

    return GestureDetector(
      onTap: this.onTap as void Function()?,
      child: Container(
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(this.radius)),
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
      ),
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
      this.bgColor,
      this.svgColor,
      this.onLongTap});
}
