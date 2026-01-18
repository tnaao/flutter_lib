import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mxbase/mxbase.dart';
import 'package:velocity_x/velocity_x.dart';

class MyLoadingIndicator extends StatelessWidget {
  final Function? onTap;
  final double topPadding;
  final String? message;

  const MyLoadingIndicator(
      {super.key, this.onTap, this.message, this.topPadding = 0.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: message.isTextEmpty
                  ? SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.hsp,
                    )
                  : VStack(
                      [
                        SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.hsp,
                        ),
                        12.vSpacer(),
                        MyCustomText(message, UIData.pureWhite),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCustomLoadingIndicator extends StatelessWidget {
  final Widget? loadingView;

  const MyCustomLoadingIndicator({Key? key, this.loadingView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: loadingView != null
                ? SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: loadingView,
                  )
                : SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.hsp,
                  ),
          )
        ],
      ),
    );
  }
}

class StarRefreshingIndicator extends StatelessWidget {
  final num size;
  final Color? color;
  const StarRefreshingIndicator({super.key, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(color: color ?? Colors.white, size: size.fsp);
  }
}
