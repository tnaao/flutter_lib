import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'index.dart';

class AlertInputView extends StatefulWidget {
  final String title;
  final bool isNumber;
  final bool showCancel;
  final bool isUnsignedInteger;
  final int maxCount;
  final int minCount;
  final int? maxLen;
  final String hint;

  final ValueChanged<String>? onConfirm;

  final Function? onCancel;

  AlertInputView(
      {Key? key,
      this.title = '标题',
      this.onConfirm,
      this.onCancel,
      this.isNumber = false,
      this.maxCount = -1,
      this.minCount = 1,
      this.isUnsignedInteger = false,
      this.hint = '',
      this.showCancel = true,
      this.maxLen})
      : super(key: key);

  @override
  _AlertInputViewState createState() {
    return _AlertInputViewState();
  }
}

class _AlertInputViewState extends State<AlertInputView> {
  String _content = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        padding: UIData.fromLTRB(0.sp(), 0.sp(), 0.sp(), 0.sp()),
        child: MyBaseCard(
          radius: 0.sp(),
          elevation: 0.0,
          color: UIData.pureWhite,
          child: Padding(
            padding: UIData.fromLTRB(25.sp(), 0.0, 25.sp(), 0.sp()),
            child: VStack(
              [
                20.vSpacer(),
                MyBlackText(
                  widget.title,
                  size: 16,
                  lines: 5,
                ).w(200.hsp),
                20.vSpacer(),
                HStack([
                  Expanded(
                      child: BoxField(
                    fontSize: 14.0,
                    hint: widget.hint,
                    maxLen: widget.maxLen,
                    isNumber: widget.isNumber,
                    isUnsignedInteger: widget.isUnsignedInteger,
                    onChange: (text) {
                      if ((widget.isNumber || widget.isUnsignedInteger) &&
                          !text.textEmpty()) {
                        this._content = double.parse(text).toInt().toString();
                        return;
                      }

                      this._content = text;
                    },
                  )),
                ]),
                5.vSpacer(),
                1.hLine(color: UIData.primaryColor).w(200.hsp),
                25.vsp.vSpacer(),
                HStack(
                  [
                    Spacer(),
                    !widget.showCancel
                        ? SizedBox()
                        : MyFlatRoundedConcreteBtn(
                            '取消',
                            '#f2f2f2'.hexColor(),
                            widget.onCancel,
                            titleColor: '#616161'.hexColor(),
                            width: 80.sp(),
                            height: 30.vsp,
                            radius: 15.vsp,
                          ),
                    ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 10.sp())),
                    MyFlatRoundedConcreteBtn(
                      '确定',
                      UIData.primaryColor,
                      () {
                        if (widget.onConfirm != null) {
                          {
                            if (widget.maxCount >= 0 &&
                                (widget.isNumber || widget.isUnsignedInteger)) {
                              if (this._content != null &&
                                  double.parse(this._content) >
                                      widget.maxCount) {
                                UIData.cartMaxCountLimit.toast();
                                return;
                              }
                            }

                            if ((widget.isNumber || widget.isUnsignedInteger) &&
                                double.parse(this._content) < widget.minCount) {
                              UIData.cartMinCountLimit.toast();
                              return;
                            }

                            widget.onConfirm!(this._content);
                          }
                        }
                      },
                      titleColor: UIData.pureWhite,
                      width: 80.sp(),
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
        ),
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.sp()))),
      actions: [],
    );
  }
}
