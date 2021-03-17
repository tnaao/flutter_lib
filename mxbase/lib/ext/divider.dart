import 'package:flutter/material.dart';

extension mxDivider on num {
  Widget hLine() {
    return Divider(
      color: Colors.grey.shade300,
      height: this.toDouble(),
    );
  }

  Widget vLine() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: this.toDouble(),
    );
  }


}
