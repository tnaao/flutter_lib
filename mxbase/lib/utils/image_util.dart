import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;

class MxFileBytes {
  final List<int> bytes;
  final String? fileName;

  MxFileBytes(this.bytes, this.fileName);

  static MxFileBytes empty() => MxFileBytes([], '');
}

class ImageUtil {
  static void shareImage(File f) async {}

  static Future<http.MultipartFile?> resizeImage(File? imgSrc,
      {int w = 400, int h = 400, String fieldName = 'file'}) async {
    try {
      if (imgSrc == null) return null;
      Img.Image? image_temp = Img.decodeImage(imgSrc.readAsBytesSync());
      if (image_temp == null) return null;
      Img.Image resized_img = Img.copyResize(image_temp, width: w);
      var multipartFile = new http.MultipartFile.fromBytes(
        '$fieldName',
        Img.encodeJpg(resized_img),
        filename: '${imgSrc.path}'.replaceAll('/', '_') + '.jpg',
      );
      return multipartFile;
    } catch (e) {
      print('${e}');
      return null;
    }
  }

  static Future<MxFileBytes> resizeImageBytes(File? imgSrc,
      {int w = 400, int h = 400, String fieldName = 'file'}) async {
    try {
      if (imgSrc == null) return MxFileBytes.empty();
      Img.Image? image_temp = Img.decodeImage(imgSrc.readAsBytesSync());
      if (image_temp == null) return MxFileBytes.empty();
      Img.Image resized_img = Img.copyResize(image_temp, width: w);
      return MxFileBytes(Img.encodeJpg(resized_img),
          '${imgSrc.path}'.replaceAll('/', '_') + '.jpg');
    } catch (e) {
      print('${e}');
      return MxFileBytes.empty();
    }
  }
}
