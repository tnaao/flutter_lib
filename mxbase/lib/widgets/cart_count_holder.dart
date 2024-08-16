import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/widgets/my_imageview.dart';
import 'package:velocity_x/velocity_x.dart';
import 'alert_input_view.dart';

class CartCountHolder extends StatefulWidget {
  final int count;
  final int maxCount;
  final Function upCount;
  final double size;
  final String? iconPlus;
  final String? iconMinus;

  @override
  _CartCountHolderState createState() {
    return _CartCountHolderState();
  }

  CartCountHolder(this.count, this.upCount,
      {this.size = 25.0, this.iconMinus, this.iconPlus, this.maxCount = 0});
}

class _CartCountHolderState extends State<CartCountHolder> {
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
    return Container(
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
              decoration:
                  BoxDecoration(border: Border.all(color: UIData.textGL)),
              child: SizedBox(
                width: _size,
                height: _size,
                child: Center(
                  child: MyAssetImageView(
                    widget.iconMinus,
                    width: _size! * 0.37,
                    height: _size! * 0.37,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: UIData.textGL),
                    bottom: BorderSide(color: UIData.textGL))),
            child: SizedBox(
              width: _size! * 2,
              height: _size,
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: UIData.black),
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
                      if (!text.isEmptyOrNull) {
                        this.upCount(int.parse(text));
                      }
                    },
                  );
                });
          }),
          GestureDetector(
            onTap: () {
              if (widget.maxCount > 0 && count + 1 > widget.maxCount) {
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
              decoration:
                  BoxDecoration(border: Border.all(color: UIData.textGL)),
              child: SizedBox(
                  width: _size,
                  height: _size,
                  child: Center(
                    child: MyAssetImageView(
                      widget.iconPlus,
                      width: _size! * 0.37,
                      height: _size! * 0.37,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
