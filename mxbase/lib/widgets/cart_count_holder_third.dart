import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/my_text.dart';
import 'package:mxbase/widgets/my_card.dart';
import 'package:mxbase/widgets/my_imageview.dart';

import 'alert_input_view.dart';

class CartCountHolderThird extends StatefulWidget {
  final int count;
  final int maxCount;
  final Color color;
  final Function upCount;
  final double size;
  final String? iconPlus;
  final String? iconMinus;

  @override
  _CartCountHolderThirdState createState() {
    return _CartCountHolderThirdState();
  }

  CartCountHolderThird(this.count, this.upCount,
      {this.size = 25.0,
      this.iconMinus,
      this.iconPlus,
      this.color = UIData.btnBgN,
      this.maxCount = -1});
}

class _CartCountHolderThirdState extends State<CartCountHolderThird> {
  late int count;
  late Function upCount;
  bool editing = false;
  double? _size;

  @override
  void initState() {
    super.initState();
    count = widget.count;
    upCount = widget.upCount;
    this._size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return MyBaseCard(
      radius: 0.0,
      elevation: 0.0,
      child: Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (count > 1)
                  setState(() {
                    count = --count;
                  });
                upCount(count);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: '#FFB2E7'.hexColor())),
                child: SizedBox(
                  width: _size,
                  height: _size,
                  child: Center(
                    child: MyBlackText(
                      '-',
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: SizedBox(
                  height: _size,
                  width: _size! * 2,
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: UIData.black),
                    ),
                  ),
                ),
              ),
            ).onTap(() {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertInputView(
                      title: '请输入数量',
                      isNumber: true,
                      isUnsignedInteger: true,
                      maxCount: widget.maxCount,
                      onCancel: () {
                        context.back();
                      },
                      onConfirm: (text) {
                        context.back();
                        if (!text.isEmptyOrNull) {
                          setState(() {
                            count = int.parse(text);
                          });
                          this.upCount(count);
                        }
                      },
                    );
                  });
            }),
            GestureDetector(
              onTap: () {
                if (widget.maxCount >= 0 && count + 1 > widget.maxCount) {
                  UIData.cartMaxCountLimit.toast();
                  return;
                }
                setState(() {
                  ++count;
                  editing = !editing;
                });
                upCount(count);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: '#FFB2E7'.hexColor(),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: SizedBox(
                    width: _size,
                    height: _size,
                    child: Center(
                      child: MyBlackText(
                        '+',
                        size: 16,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
