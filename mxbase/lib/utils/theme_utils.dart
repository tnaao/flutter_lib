import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';

class ThemeUtils {
  // 默认主题色
  static Color get defaultColor => UIData.pureWhite;

  // 可选的主题色
  static List<Color> get supportColors => [
        defaultColor,
        Colors.purple,
        Colors.orange,
        Colors.deepPurpleAccent,
        Colors.redAccent,
        Colors.blue,
        Colors.amber,
        Colors.green,
        Colors.lime,
        Colors.indigo,
        Colors.cyan,
        Colors.teal
      ];

  // 当前的主题色
  static Color currentColorTheme = UIData.pureWhite;
}
