import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:velocity_x/velocity_x.dart';

class InputTouchContainer extends StatelessWidget {
  final Widget child;
  @override
  const InputTouchContainer(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child.box.color(UIData.clickColor()).make(),
    );
  }
}

extension mxWidget on Widget {
  String routeName() {
    return runtimeType.toString();
  }

  InputTouchContainer xInputContainer() {
    return InputTouchContainer(this);
  }

  Widget xOnTap(Function onTap,
      {bool enable = true, bool withContainer = false, int cd = 800}) {
    if (withContainer) {
      return box.color(UIData.clickColor()).make()._tap(() {
        if (enable) {
          onTap();
        }
      });
    }
    return _tap(() {
      if (enable) {
        onTap();
      }
    }, cd: cd);
  }

  Widget _tap(VoidCallback? onTap,
      {Key? key,
      int cd = 800,
      HitTestBehavior hitTestBehavior = HitTestBehavior.deferToChild}) {
    return TapDebouncer(
      key: key,
      builder: (ctx, fn) {
        return MouseRegion(
          key: key,
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: hitTestBehavior,
            onTap: () {
              fn?.call();
            },
            child: this,
          ),
        );
      },
      onTap: () async {
        onTap?.call();
      },
      cooldown: Duration(milliseconds: cd),
    );
  }

  Widget xVisible(bool b) {
    return Visibility(visible: b, child: this);
  }

  Widget xLoadingContainer(bool b, {required Widget loadingView}) {
    return ZStack(
      [
        this,
        VStack([loadingView.xVisible(b).centered()])
      ],
      alignment: Alignment.topCenter,
    );
  }

  Widget xSafeContainer(bool enable) {
    return enable ? safeArea() : this;
  }

  Widget xGestureTouchContainer(bool enable,
      {GestureTapCallback? onTap, GestureCancelCallback? onLongTap}) {
    return enable
        ? GestureDetector(
            onTap: onTap,
            onLongPress: onLongTap,
            child: this,
          )
        : this;
  }

  Widget xNoneTouchContainer(bool enable) {
    return IgnorePointer(
      ignoring: enable,
      child: this,
    );
  }

  Widget xAppBarMake(double h) {
    return preferredSize(Size.fromHeight(h));
  }

  Widget xOnPopWrapper(bool canPop,
      {required void Function(bool didPop, dynamic data)? onPop}) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, t) {
        onPop?.call(didPop, t);
      },
      child: this,
    );
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
