import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class CartCountHolder extends StatefulWidget {
  final int count;
  final Function upCount;
  final double size;
  final String iconPlus;
  final String iconMinus;

  @override
  _CartCountHolderState createState() {
    return _CartCountHolderState();
  }

  CartCountHolder(this.count, this.upCount,
      {this.size = 25.0, this.iconMinus, this.iconPlus});
}

class _CartCountHolderState extends State<CartCountHolder> {
  int count;
  Function upCount;
  bool editing = false;
  double _size;

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
              if (count > 0)
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
                    width: _size * 0.37,
                    heigh: _size * 0.37,
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
              width: _size * 2,
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
          ),
          GestureDetector(
            onTap: () {
              ++count;
              upCount(count);
              setState(() {
                editing = !editing;
              });
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
                      width: _size * 0.37,
                      heigh: _size * 0.37,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
