import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'my_imageview.dart';
import 'my_text.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MyNoDataView extends StatelessWidget {
  final String title;

  const MyNoDataView({Key? key, this.title = '没有找到相关内容'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          VStack(
            [
              20.vSpacer(),
              MyAssetImageView(
                'ic_empty_search.png',
                fit: BoxFit.contain,
                width: 300.hsp,
              ).w(300.hsp),
              25.vSpacer(),
              MyCustomText('${this.title}', '#666666'.hexColor()),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          ),
        ],
      ),
    );
  }
}
