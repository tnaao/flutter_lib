import 'package:flutter/material.dart';

class WidgetHelper {
  static void showAlert(BuildContext context,
      {String title, String content, Function onConfirm}) {
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

  static void showAlertCustomView(BuildContext context,
      {WidgetBuilder builder, String title}) {
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
              children: <Widget>[builder(context)],
            ));
  }
}
