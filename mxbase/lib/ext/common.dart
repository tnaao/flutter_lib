import 'package:mxbase/model/app_holder.dart';

extension mxStr on String {
  String imgAddHost() {
    if (this == null || this.length < 4) return '';
    return AppHolder.instance.HOST + '/' + this;
  }
}
