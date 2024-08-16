import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MyBaseCard extends StatelessWidget {
  final Widget? child;
  final num radius;
  final double elevation;
  final Color color;

  MyBaseCard(
      {Key? key,
      this.child,
      this.radius = 8.0,
      this.elevation = 0.25,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(this.radius.toDouble())),
      elevation: this.elevation,
      shadowColor: Color(0x0F000000),
      clipBehavior: Clip.antiAlias,
      color: this.color,
      child: this.child,
    ).cornerRadius(this.radius.toDouble());
  }
}

class MyTopRoundCard extends StatelessWidget {
  final Widget? child;
  final num radius;
  final double elevation;
  final Color color;

  MyTopRoundCard(
      {Key? key,
      this.child,
      this.radius = 8.0,
      this.elevation = 0.0,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this.radius.sp()),
          topRight: Radius.circular(this.radius.sp())),
      clipBehavior: Clip.hardEdge,
      child: this.child,
    );
  }
}

class MyBottomRoundCard extends StatelessWidget {
  final Widget? child;
  final num radius;
  final double elevation;
  final Color color;

  MyBottomRoundCard(
      {Key? key,
      this.child,
      this.radius = 8.0,
      this.elevation = 0.0,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(this.radius.sp()),
          bottomRight: Radius.circular(this.radius.sp())),
      clipBehavior: Clip.hardEdge,
      child: this.child,
    );
  }
}
