import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:go_router/go_router.dart';

typedef OnMxResult = void Function(Object? obj);

typedef MxReturn<T> = void Function(T obj);

extension MxContext on BuildContext? {
  void back() {
    if (this == null) return;
    if (this!.canPop()) {
      GoRouter.of(this!).pop();
    }
  }

  void alertPop(){
    Navigator.of(this!).pop();
  }

  void retHome() {
    GoRouter.of(this!).go(UIData.RouteAppHome);
  }

  Future<String> readAssetJson(String name) async {
    final String data =
        await DefaultAssetBundle.of(this!).loadString("assets/$name");
    return data;
  }

  void result<T extends Object>(T obj) {
    GoRouter.of(this!).pop();
  }

  void mxGeneralDialog(WidgetBuilder wb) {
    showGeneralDialog(
        context: this!,
        barrierLabel: '',
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (ctx, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return wb(ctx);
        });
  }

  void mxGo(WidgetBuilder wb,
      {String path = '',
      String backPath = '/',
      OnMxResult? onResult,
      bool replace = false,
      bool exclude = false}) {
    if (this == null) return;

    final Map<String, WidgetBuilder> routeMap = {
      "home": (BuildContext context) {
        return Text('Home');
      },
    };
    final builder = routeMap.containsKey(path)
        ? routeMap[path]
        : wb != null
            ? wb
            : routeMap['Home'];
    var goRoute = path.isEmpty
        ? UIData.isIOS()
            ? MyPageRouteThree(builder!, routeName: path)
            : MyPageRouteTwo(builder, routeName: path)
        : UIData.isIOS()
            ? MyPageRouteThree(builder!, routeName: path)
            : MyPageRouteTwo(builder, routeName: path);
    if (exclude) {
      var currentPath = ModalRoute.of(this!)?.settings.name;
      if (currentPath == path) return;

      Navigator.of(this!, rootNavigator: false).pushAndRemoveUntil(goRoute,
          (route) {
        return '/' == route.settings.name ||
            backPath == route.settings.name ||
            path == route.settings.name;
      }).then((value) {
        if (onResult != null) {
          onResult(value);
        }
      });
      return;
    }

    if (replace) {
      Navigator.of(this!, rootNavigator: false)
          .pushReplacement(goRoute)
          .then((value) {
        if (onResult != null) {
          onResult(value);
        }
      });
      return;
    }

    Navigator.of(this!, rootNavigator: false).push(goRoute).then((value) {
      if (onResult != null) {
        onResult(value);
      }
    });
  }
}

class MyPageRouteTwo<T> extends PageRouteBuilder<T> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  final WidgetBuilder? buildFn;

  final String? routeName;

  MyPageRouteTwo(this.buildFn, {this.routeName})
      : super(
            settings: routeName == null ? null : RouteSettings(name: routeName),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                buildFn!(context),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                VxAnimatedBox(child: child)
                    .elasticIn
                    .animDuration(Duration(milliseconds: 350))
                    .make());
}

class MyPageRouteThree<T> extends CupertinoPageRoute<T> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  final WidgetBuilder buildFn;
  final String? routeName;

  MyPageRouteThree(this.buildFn, {this.routeName})
      : super(
          builder: buildFn,
          settings: routeName == null ? null : RouteSettings(name: routeName),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return VxAnimatedBox(child: child)
        .elasticIn
        .animDuration(Duration(milliseconds: 350))
        .make();
  }
}
