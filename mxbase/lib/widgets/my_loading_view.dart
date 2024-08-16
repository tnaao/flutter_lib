import 'package:flutter/material.dart';
import 'package:mxbase/mxbase.dart';
import 'package:velocity_x/velocity_x.dart';

class MyLoadingIndicator extends StatelessWidget {
  final Function? onTap;
  final double topPadding;
  final String? message;

  const MyLoadingIndicator(
      {Key? key, this.onTap, this.message, this.topPadding = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: message.isTextEmpty
                  ? CircularProgressIndicator()
                  : VStack(
                      [
                        CircularProgressIndicator(),
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
            child: this.loadingView != null
                ? SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: this.loadingView,
                  )
                : CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
