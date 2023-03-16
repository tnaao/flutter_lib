import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/widgets/my_text.dart';
import 'package:mxbase/widgets/my_card.dart';
import 'alert_input_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class CartCountHolderFourthCubit extends StateNotifier<int> {
  CartCountHolderFourthCubit({int num = 1}) : super(num);

  void upCount(int num) => this.state = num;

  void minus() {
    if (state > 1) {
      upCount(state - 1);
    }
  }

  void plus(int maxCount) {
    if (maxCount >= 0 && state + 1 > maxCount) {
      UIData.cartMaxCountLimit.toast();
      return;
    }
    upCount(state + 1);
  }
}


class CartCountHolderFourth extends ConsumerWidget {
  final int count;
  final int maxCount;
  final Color color;
  final Color borderColor;
  final Function upCount;
  final double size;
  final double radius;
  final String? iconPlus;
  final String? iconMinus;
  late StateNotifierProvider<CartCountHolderFourthCubit,
      int> _countProvider;

  CartCountHolderFourth(this.count, this.upCount,
      {Key? key,
        this.maxCount = -1,
        this.color = UIData.pureWhite,
        this.borderColor = UIData.textGD,
        this.size = 25.0,
        this.radius = 5.0,
        this.iconPlus,
        this.iconMinus})
      : super(key: key) {
    _countProvider = StateNotifierProvider<CartCountHolderFourthCubit,
        int>((ref) =>
        CartCountHolderFourthCubit(num: count));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyBaseCard(
      radius: 0.0,
      elevation: 0.0,
      child: Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                ref.read(_countProvider.notifier).minus();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: this.color,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius)),
                ),
                child: SizedBox(
                  width: size,
                  height: size,
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
                color: color,
                border: Border(
                    top: BorderSide(color: borderColor),
                    bottom: BorderSide(color: borderColor)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: SizedBox(
                  height: size,
                  width: size * 2,
                  child: Center(
                    child: Text(
                      ref.watch(_countProvider).toString(),
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
                      maxCount: maxCount,
                      onCancel: () {
                        context.back();
                      },
                      onConfirm: (text) {
                        context.back();
                        if (!text.isEmptyOrNull) {
                          var count = int.parse(text);
                          ref.read(_countProvider.notifier).upCount(count);
                        }
                      },
                    );
                  });
            }),
            GestureDetector(
              onTap: () {
                ref.read(_countProvider.notifier).plus(maxCount);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                child: SizedBox(
                    width: size,
                    height: size,
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
