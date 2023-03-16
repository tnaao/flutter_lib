import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mxbase/model/app_holder.dart';
import 'package:mxbase/mxbase.dart';
import 'package:mxnet/entity/resp.dart';
import 'package:mxbase/ext/common.dart';
import 'package:mxnet/services/network_service_model.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:logger/logger.dart';
import 'dart:developer' as developer;

class AppRestClient extends RestClient {
  final bool debug;

  AppRestClient({this.debug = true}) {
    if (debug) {
      (dioInstance.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return HttpClient.findProxyFromEnvironment(uri, environment: {
            "http_proxy": AppHolder.instance.DEBUGHOST,
            "https_proxy": AppHolder.instance.DEBUGHOST,
          });
        };
        if (AppHolder.HOST.startsWith('https'))
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
      };
    }
    this.dioInstance.interceptors.add(ApiDioInterceptor());
  }
}

abstract class NetworkService {
  RestClient rest;

  NetworkService(this.rest);
}

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      developer.log('$line');
    }
  }
}

extension MxLogExt on String {
  static final logger = Logger(output: ConsoleOutput());

  void printXNetLog() {
    var msg = 'NetLog,$this';
    msg.logMx();
  }
}

class ApiDioInterceptor extends dio.Interceptor {
  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    options.headers = options.headers
      ..addAll({
        "token": MxBaseUserInfo.instance.getToken().mxText,
      });
    'ApiDioInterceptor request:${options.method},${options.uri.path},${options.data}'
        .logMx();
    super.onRequest(options, handler);
  }

  @override
  Future onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    return Future.value(true);
  }

  @override
  Future onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (!((response.statusCode! < 200) ||
        (response.statusCode! >= 300) ||
        (response.data == null))) {
      var jsonResult = response.data;
      if (response.statusCode == 200) {
        if (jsonResult == null || jsonResult.length == 0) {
          jsonResult = {"code": 1, "message": "成功"};
        }
        response.data = jsonResult;
      }
    } else {
      response.data['code'] = response.statusCode;
      "errorResponse:${response.realUri.path},${response.data}".printXNetLog();
    }

    return Future.value(true);
  }
}

abstract class RestClient {
  final bool isDio = true;
  static const ApiAppKey = 'ec_relatives_app';
  static const ApiAppSecret = 'ec_ylgj20220419_secret';
  static const tenant = 'MDAwMA==';
  static const timeout = Duration(seconds: 5);

  late dio.Dio dioInstance = dio.Dio();

  Map<String, String> headers() {
    var header = {
      "Content-Type": 'application/json',
      "Accept": 'application/json',
      "x-system-env": MxBaseUserInfo.instance.systemEnv.mxText,
      "Authorization": 'Basic ZWNfZG9jdG9yX2FwcDplY19md3p4MjAyMjExMjhfc2VjcmV0',
      "tenant": MxBaseUserInfo.instance.tenantCode.isTextEmpty
          ? tenant
          : MxBaseUserInfo.instance.tenantCode.mxText,
      "token": MxBaseUserInfo.instance.getToken().mxText.isEmpty
          ? ''
          : 'Bearer ' + '${MxBaseUserInfo.instance.getToken()}',
    };
    return header;
  }

  String authorizationGenerate(String appkey, String appSecret) {
    return 'Basic ' + "${appkey}:${appSecret}".mxBase64;
  }

  Map<String, String?> formHeaders() {
    var headersForm = headers();
    headersForm['Content-Type'] = 'application/x-www-form-urlencoded';
    return headersForm;
  }

  dio.Options get optionsJson => dio.Options(
      headers: headers(),
      validateStatus: (status) {
        return status == 200;
      });

  dio.Options get optionsEmpty => dio.Options(
          headers: {
            "Content-Type": 'application/json',
          },
          validateStatus: (status) {
            return status == 200;
          });

  dio.Options get optionsForm => dio.Options(
      headers: formHeaders(),
      validateStatus: (status) {
        return status == 200;
      });

  dio.Options get optionsRaw => dio.Options(
      headers: headers(),
      validateStatus: (status) {
        return status == 200;
      });

  Future<MappedNetworkServiceResponse<T>> getAsync<T>(String path,
      {bool hasHeader = true}) async {
    path.printXNetLog();
    '${headers()}'.printXNetLog();

    try {
      var dioRes = await dioInstance.get(
        path,
        options: hasHeader ? this.optionsJson : optionsEmpty,
      );
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:${err.message}');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> postAsync<T>(String path, dynamic req,
      {bool hasHeaders = true}) async {
    var jsonTmp = json.encoder.convert(req);
    final Map<String, dynamic>? reqMap = jsonDecode(jsonTmp);
    'path:$path,req:$reqMap'.printXNetLog();
    '${headers()}'.printXNetLog();
    final content = json.encoder.convert(reqMap);
    content.printXNetLog();

    try {
      var dioRes = await dioInstance.post(path,
          data: reqMap,
          options: hasHeaders ? this.optionsJson : this.optionsEmpty);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:${err.message}');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> uploadFileAsync<T>(
      String path, List<int> fileBytes,
      {String? fileName, bool hasHeaders = true}) async {
    path.printXNetLog();
    '${headers()}'.printXNetLog();
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    try {
      var dioRes = await dioInstance.post(path,
          data: formData,
          options: hasHeaders ? this.optionsForm : this.optionsEmpty);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:$err');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> putAsync<T>(
      String path, dynamic data) async {
    var jsonTmp = json.encoder.convert(data);
    final Map<String, dynamic>? reqMap = jsonDecode(jsonTmp);
//    reqMap['token'] = UserInfo.instance.getToken();
    path.printXNetLog();
    '${headers()}'.printXNetLog();
    final content = json.encoder.convert(reqMap);
    content.printXNetLog();

    try {
      var dioRes =
          await dioInstance.put(path, data: reqMap, options: this.optionsJson);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:${err.message}');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> deleteAsync<T>(String path) async {
    final Map<String, Object?>? reqMap = {};
//    reqMap['token'] = UserInfo.instance.getToken();
    path.printXNetLog();
    '${headers()}'.printXNetLog();
    final content = json.encoder.convert(reqMap);
    content.printXNetLog();

    try {
      var dioRes = await dioInstance.delete(path,
          data: reqMap, options: this.optionsJson);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:${err.message}');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> postRawStrAsync<T>(
      String path, dynamic data) async {
    var jsonTmp = json.encoder.convert(data);
    final Map<String, dynamic> reqMap = jsonDecode(jsonTmp);
//    reqMap['token'] = UserInfo.instance.getToken();
    path.printXNetLog();
    '${headers()}'.printXNetLog();
    final content = json.encoder.convert(reqMap);
    content.printXNetLog();

    try {
      var dioRes =
          await dioInstance.post(path, data: content, options: this.optionsRaw);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:$err');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> postFormNoSessionAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);

    final Map<String, dynamic> reqMap = jsonDecode(content);

    reqMap.removeWhere((k, v) {
      return reqMap[k] == null;
    });

    try {
      var dioRes = await dioInstance.post(path,
          data: dio.FormData.fromMap(reqMap), options: this.optionsForm);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:$err');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>> postFormAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    final Map<String, dynamic> reqMap = jsonDecode(content);

    reqMap.removeWhere((k, v) {
      return reqMap[k] == null;
    });

    'path:$path,reqMap:$reqMap'.printXNetLog();

    try {
      var dioRes = await dioInstance.post(path,
          queryParameters: reqMap,
          data: dio.FormData.fromMap(reqMap),
          options: this.optionsForm);
      return _processDIOResponse(dioRes);
    } on dio.DioError catch (err) {
      print('dioError:$err');
      return _processDIOResponse(err.response);
    }
  }

  Future<MappedNetworkServiceResponse<T>?> postFormMultiAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    final Map<String, dynamic> rawMap = jsonDecode(content);

    rawMap.removeWhere((k, v) {
      return rawMap[k] == null;
    });

    final Map<String, String> reqMap = new Map();
    rawMap.keys.forEach((ak) {
      reqMap[ak] = rawMap[ak].toString();
    });

    var request = new http.MultipartRequest("POST", Uri.parse(path));
    request.fields.addAll(reqMap);

    request.fields['token'] = MxBaseUserInfo.instance.getToken()!;

    var resp;

    await request.send().then((response) async {
      if (!((response.statusCode < 200) || (response.statusCode >= 300))) {
        String jsonResult = '';
        await response.stream.toStringStream().listen((json) {
          jsonResult = json;
        });
        Map? resultClass = jsonDecode(jsonResult);

        resp = new MappedNetworkServiceResponse<T>(
            mappedResult: resultClass,
            networkServiceResponse:
                new NetworkServiceResponse<T>(success: true));
      } else {
        var jsonResult = response.stream.toString();
        dynamic resultClass = {"succeed": false};
        resp = new MappedNetworkServiceResponse<T>(
            mappedResult: resultClass,
            networkServiceResponse:
                new NetworkServiceResponse<T>(success: false));
      }
    });
    return resp;
  }

  Future<Map<String, Object>> uploadFile<T>(
      {required String resourcePath,
      required dynamic data,
      Function? onRes}) async {
    var request = new http.MultipartRequest("POST", Uri.parse(resourcePath));
    Map dataMap = data;
    for (var aKey in dataMap.keys) {
      if (dataMap[aKey] == null) continue;
      if (dataMap[aKey] is File) {
        File file = dataMap[aKey];
        request.files.add(await http.MultipartFile.fromPath(aKey, file.path));
        continue;
      }

      if (dataMap[aKey] is http.MultipartFile) {
        http.MultipartFile file = dataMap[aKey];
        request.files.add(file);
        continue;
      }

      '$aKey:${dataMap[aKey]}'.printXNetLog();
      request.fields[aKey] = dataMap[aKey];
    }
    formHeaders().forEach((key, value) {
      request.headers[key] = value!;
    });
    resourcePath.printXNetLog();
    var resFuture = await request.send().then((response) async {
      if (!((response.statusCode < 200) || (response.statusCode >= 300))) {
        return await response.stream.toStringStream().listen((jsonResult) {
          Map<String, dynamic>? resultClass = jsonDecode(jsonResult);
          var result = {"succeed": true, "data": resultClass};
          if (onRes != null) onRes(result);
          return;
        });
      } else {
        var jsonResult = response.stream.toString();
        jsonResult.printXNetLog();
        var resultClass = {"succeed": false, "data": null};
        if (onRes != null) onRes(resultClass);
        return resultClass;
      }
    });
    return Map<String, Object>();
  }

  MappedNetworkServiceResponse<T> _processDIOResponse<T>(
      dio.Response? response) {
    if (response == null) {
      return new MappedNetworkServiceResponse<T>(
          mappedResult: {"code": 404, "message": "服务端开小差了~"},
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false, message: "服务端开小差了~"));
    }

    "status:${response.statusCode}".printXNetLog();

    if (!((response.statusCode! < 200) ||
        (response.statusCode! >= 300) ||
        (response.data == null))) {
      var jsonResult = response.data;
      jsonEncode(jsonResult).printXNetLog();

      if (jsonResult == null || jsonResult.length == 0) {
        jsonResult = {"code": 1, "message": "成功"};
      }
      Map resultClass = jsonResult;
      if (resultClass['code'] == null) {
        resultClass['code'] = 1;
      }

      return new MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: new NetworkServiceResponse<T>(success: true));
    } else {
      var errorResponse = response.data;
      errorResponse['code'] = response.statusCode;
      var responseWrapper = MappedNetworkServiceResponse<T>(
          mappedResult: errorResponse,
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
      "errorResponse:${errorResponse['path']},${responseWrapper.mappedResult}"
          .printXNetLog();
      return responseWrapper;
    }
  }
}
