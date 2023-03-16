import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:http/http.dart' as http;
import 'package:mxbase/ext/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';

class MxFileBytes {
  final List<int> bytes;
  final String? fileName;

  MxFileBytes(this.bytes, this.fileName);

  static MxFileBytes empty() => MxFileBytes([], '');
}

class ImageUtil {
  static void downloadImage(String url,
      {MxReturn<File>? onSucceed, void Function()? onFail}) async {
    try {
      if (url.textEmpty()) {
        return;
      }
      var dir = await getDownloadsDirectory();
      var path = dir!.subdir('image').path +
          '/${DateTime.now().millisecondsSinceEpoch}.jpg';
      FileDownloader.downloadFile(
          url: url,
          savePath: path,
          onDownloadError: (error) {
            onFail?.call();
          },
          onDownloadCompleted: (path) {
            onSucceed?.call(File(path));
          });
    } catch (error) {
      print(error);
    }
  }

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
