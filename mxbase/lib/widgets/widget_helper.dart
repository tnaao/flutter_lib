import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'my_btn.dart';
import 'my_text.dart';

class WidgetHelper {
  static void showAlert(BuildContext context,
      {String? title, String? content, Function? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          '$title',
          style: TextStyle(fontSize: 22.0, color: Colors.black),
        ),
        titleTextStyle: TextStyle(fontStyle: FontStyle.normal),
        content: Text(
          '$content',
          style: TextStyle(fontSize: 14.0),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('取消'),
            onPressed: () => Navigator.pop(context, 'Cancel'),
          ),
          TextButton(
            child: Text('确定'),
            onPressed: () => Navigator.pop(context, 'OK'),
          ),
        ],
      ),
    ).then<String>((returnVal) async {
      if (returnVal != null) {
        if (returnVal == 'OK') {
          if (onConfirm != null) onConfirm();
        }
      }
      return '';
    });
  }

  static void showAlertCustom(BuildContext context,
      {String? title,
      WidgetBuilder? builder,
      String? content,
      Function? onConfirm,
      String? textConfirm,
      bool isCancelable = true,
      Function? onCancel}) {
    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal),
        ),
        contentPadding: EdgeInsets.all(0.0),
        titleTextStyle: TextStyle(fontStyle: FontStyle.normal),
        content: Container(
          color: UIData.pureWhite,
          child: Padding(
            padding: UIData.fromLTRB(25.sp(), 0.0, 25.sp(), 0.sp()),
            child: VStack(
              [
                20.vSpacer(),
                builder != null ? builder(context) : MyBlackText('$content'),
                5.vSpacer(),
                20.vSpacer(),
                HStack(
                  [
                    Spacer(),
                    MyFlatRoundedConcreteBtn(
                      '取消',
                      UIData.clickColor(),
                      () {
                        Navigator.pop(context, 'Cancel');
                      },
                      titleColor: '#AAAAAA'.hexColor(),
                      width: 50.sp(),
                      height: 30.vsp,
                      radius: 15.vsp,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 20.sp())),
                    MyFlatRoundedConcreteBtn(
                      textConfirm!.textEmpty() ? '确定' : textConfirm,
                      UIData.clickColor(),
                      () {
                        Navigator.pop(context, 'OK');
                      },
                      titleColor: UIData.primaryColor,
                      width: 50.sp(),
                      height: 30.vsp,
                      radius: 15.vsp,
                    )
                  ],
                  alignment: MainAxisAlignment.end,
                ).h(30.vsp),
                15.vSpacer(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
          ),
        ).cornerRadius(UIData.defRadius),
        actions: <Widget>[],
      ),
    ).then<String>((returnVal) async {
      if (returnVal != null) {
        if (returnVal == 'OK') {
          if (onConfirm != null) onConfirm();
        } else {
          if (onCancel != null) onCancel();
        }
      }
      return '';
    });
  }

  static void showAlertCustomView(BuildContext context,
      {WidgetBuilder? builder, String? title}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: title == null
                  ? SizedBox()
                  : Center(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
              titlePadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
              contentPadding: EdgeInsets.all(0.0),
              children: <Widget>[builder!(context)],
            ));
  }
}
