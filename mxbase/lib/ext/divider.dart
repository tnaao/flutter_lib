import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';

extension mxDivider on num {
  Widget hLine({color = UIData.lineBg}) {
    return Divider(
      color: color,
      height: this.toDouble(),
    );
  }

  Widget vLine({color = UIData.lineBg}) {
    return Divider(
      color: color,
      thickness: this.toDouble(),
    );
  }
}
