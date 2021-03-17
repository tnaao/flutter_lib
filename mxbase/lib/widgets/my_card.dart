import 'package:flutter/material.dart';

class MyBaseCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final double elevation;

  MyBaseCard({Key key, this.child, this.radius = 5.0, this.elevation = 0.25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(this.radius)),
      elevation: this.elevation,
      shadowColor: Color(0xff888888),
      clipBehavior: Clip.hardEdge,
      child: this.child,
    );
  }
}
