import 'package:mxbase/model/app_holder.dart';
import 'package:mxbase/model/uidata.dart';

extension mxStr on String {
  String imgAddHost() {
    if (this == null || this.length < 4) return '';
    if (this.contains(AppHolder.instance.HOST)) return this;
    return AppHolder.instance.HOST + '/' + this;
  }

  String assetPath() {
    if (this == null || this.isEmpty) return '';
    if (this.contains('file://')) return this;
    if (this.contains(UIData.imageDir)) return this;
    return "${UIData.imageDir}/${this}";
  }
}
