import 'package:mxbase/ext/common.dart';

class JsonExt {
  JsonExt._();

  static String? dynamicToString(dynamic object) {
    return object.toString().mxText;
  }

  static int? dynamicToInt(dynamic object) {
    return object == null
        ? null
        : int.tryParse(object.toString().mxText.split('.').first);
  }

  static double? dynamicToDouble(dynamic object) {
    return object == null
        ? null
        : double.tryParse((object.toString().mxText.isInteger
            ? int.parse(object.toString().mxText).toDouble().toString()
            : object.toString().mxText));
  }

  static bool dynamicToBool(dynamic object) {
    return object == null ? false : object.toString().mxText == 'true';
  }

  static num? dynamicToNum(dynamic object) {
    if (object == null) return null;
    String numText = object.toString().mxText;
    if (numText.contains('.')) {
      return double.tryParse(numText);
    } else {
      return int.tryParse(numText);
    }
  }
}
