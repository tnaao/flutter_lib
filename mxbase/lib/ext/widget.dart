import 'package:flutter/material.dart';

extension mxWidget on StatefulWidget {
  String route() {
    return this.runtimeType.toString();
  }

  void go(BuildContext context, {WidgetBuilder? wb, bool replace = false}) {}
}
