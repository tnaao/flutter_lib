import 'package:flutter/material.dart';

extension mxWidget on StatefulWidget {
  String route() {
    return this.runtimeType.toString();
  }

  void go(BuildContext context, {WidgetBuilder? wb, bool replace = false}) {}
}

extension MxScrollExt on ScrollView {
  Widget scrollOverModeHide() {
    if (this is NotificationListener) {
      return this;
    }
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: this,
    );
  }
}
