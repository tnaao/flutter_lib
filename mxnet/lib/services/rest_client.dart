import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:mxnet/services/network_service_model.dart';
import 'package:requests/requests.dart';

abstract class NetworkService {
  RestClient rest;

  NetworkService(this.rest);
}

class RestClient {
  static const timeout = Duration(seconds: 5);

  static Map<String, String> headers() => {
        "Content-Type": 'application/json',
        "ACCEPT": 'application/json',
        "token": UserTokenInfo.instance.getToken(),
      };

  static Map<String, String> formHeaders() => {
        "Content-Type": "application/x-www-form-urlencoded",
        "ACCEPT": 'application/json',
        "token": UserTokenInfo.instance.getToken(),
      };

  Future<MappedNetworkServiceResponse<T>> getAsync<T>(String path) async {
    print(path);
    print(headers());
    var response = await Requests.get(path).timeout(timeout);
    return processSessionResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postAsync<T>(
      String path, dynamic data) async {
    var jsonTmp = json.encoder.convert(data);
    final Map<String, Object> reqMap = jsonDecode(jsonTmp);
    reqMap['token'] = UserTokenInfo.instance.getToken();
    print(path);
    print(headers());
    final content = json.encoder.convert(reqMap);
    print(content);
    var response = await Requests.post(path,
            body: content,
            bodyEncoding: RequestBodyEncoding.JSON,
            headers: headers())
        .timeout(timeout);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postFormNoSessionAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    print(path);
    print(formHeaders());
    final Map<String, Object> reqMap = jsonDecode(content);

    reqMap.removeWhere((k, v) {
      return reqMap[k] == null;
    });
    print(reqMap);

    var response =
        await Requests.post(path, body: reqMap, headers: formHeaders())
            .timeout(timeout);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postFormAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    print(path);
    print(formHeaders());
    final Map<String, Object> reqMap = jsonDecode(content);

    reqMap.removeWhere((k, v) {
      return reqMap[k] == null;
    });
    reqMap["token"] = UserTokenInfo.instance.getToken();

    print(reqMap);
    var response =
        await Requests.post(path, body: reqMap, headers: formHeaders())
            .timeout(timeout);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postFormMultiAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    print(path);
    print(formHeaders());
    final Map<String, Object> rawMap = jsonDecode(content);

    rawMap.removeWhere((k, v) {
      return rawMap[k] == null;
    });

    final Map<String, String> reqMap = new Map();
    rawMap.keys.forEach((ak) {
      reqMap[ak] = rawMap[ak].toString();
    });

    print(reqMap);

    var request = new http.MultipartRequest("POST", Uri.parse(path));
    request.fields.addAll(reqMap);

    request.fields['token'] = UserTokenInfo.instance.getToken();

    var resp;

    await request.send().then((response) async {
      if (!((response.statusCode < 200) || (response.statusCode >= 300))) {
        String jsonResult = '';
        await response.stream.toStringStream().listen((json) {
          jsonResult = json;
        });
        print('Result:');
        print(jsonResult);
        Map resultClass = jsonDecode(jsonResult);

        resp = new MappedNetworkServiceResponse<T>(
            mappedResult: resultClass,
            networkServiceResponse:
                new NetworkServiceResponse<T>(success: true));
      } else {
        var jsonResult = response.stream.toString();
        print('Result:');
        print(jsonResult);
        dynamic resultClass = {"succeed": false};
        resp = new MappedNetworkServiceResponse<T>(
            mappedResult: resultClass,
            networkServiceResponse:
                new NetworkServiceResponse<T>(success: false));
      }
    });
    return resp;
  }

  Future<MappedNetworkServiceResponse<T>> putAsync<T>(
      String path, dynamic data) async {
    var content = json.encoder.convert(data);
    print(path);
    print(headers());
    print(content);
    var response = await Requests.put(path,
            body: data,
            headers: headers(),
            bodyEncoding: RequestBodyEncoding.JSON)
        .timeout(timeout);
    return processResponse<T>(response);
  }

  Future uploadFile<T>(
      {@required String resourcePath,
      @required dynamic data,
      @required Function onRes}) async {
    var request = new http.MultipartRequest("POST", Uri.parse(resourcePath));
    Map dataMap = data;
    for (var aKey in dataMap.keys) {
      if (dataMap[aKey] == null) continue;
      if (dataMap[aKey].runtimeType == File('').runtimeType) {
        print('file:$aKey');
        File file = dataMap[aKey];
        var bytes = await file.readAsBytes();
        print(bytes.length);
        request.files.add(await http.MultipartFile.fromPath(aKey, file.path));
        continue;
      }

      print('$aKey:${dataMap[aKey]}');
      request.fields[aKey] = dataMap[aKey];
    }
    request.fields['token'] = UserTokenInfo.instance.getToken();
    request.headers.putIfAbsent("token", () {
      return UserTokenInfo.instance.getToken();
    });
    print(resourcePath);
    await request.send().then((response) {
      if (!((response.statusCode < 200) || (response.statusCode >= 300))) {
        response.stream.toStringStream().listen((jsonResult) {
          print('Result:');
          print(jsonResult);
          Map resultClass = jsonDecode(jsonResult);
          onRes({"succeed": true, "data": resultClass['data']});
        });
      } else {
        var jsonResult = response.stream.toString();
        print('Result:');
        print(jsonResult);
        dynamic resultClass = {"succeed": false};
        onRes(resultClass);
      }
    });
    return Future.value();
  }

  MappedNetworkServiceResponse<T> processJson<T>(String jsonResult) {
    Map resultClass = jsonDecode(jsonResult);
    if (resultClass['code'] == null) {
      resultClass['code'] = 1;
    }

    return new MappedNetworkServiceResponse<T>(
        mappedResult: resultClass,
        networkServiceResponse: new NetworkServiceResponse<T>(success: true));
  }

  MappedNetworkServiceResponse<T> processResponse<T>(Response response) {
    print("status:${response.statusCode}");

    if (!((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.content() == null))) {
      var jsonResult = response.content();
      print('Result:');
      print(jsonResult);

      if (jsonResult == null || jsonResult.length == 0) {
        jsonResult = '{"code":1, "message": "成功" }';
      }
      Map resultClass = jsonDecode(jsonResult);
      if (resultClass['code'] == null) {
        resultClass['code'] = 1;
      }

      return MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: new NetworkServiceResponse<T>(success: true));
    } else {
      var errorResponse = response.content();
      return new MappedNetworkServiceResponse<T>(
          mappedResult: {
            "code": response.statusCode,
            "message": "server_status:${response.statusCode}"
          },
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
    }
  }

  MappedNetworkServiceResponse<T> processSessionResponse<T>(Response response) {
    print("status:${response.statusCode}");

    if (!((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.content() == null))) {
      var jsonResult = response.content();
      print('Result:');
      print(jsonResult);

      if (jsonResult == null || jsonResult.length == 0) {
        jsonResult = '{"code":1, "message": "成功" }';
      }
      Map resultClass = jsonDecode(jsonResult);
      if (resultClass['code'] == null) {
        resultClass['code'] = 1;
      }

      return new MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: new NetworkServiceResponse<T>(success: true));
    } else {
      var errorResponse = response.content();
      return new MappedNetworkServiceResponse<T>(
          mappedResult: {
            "code": response.statusCode,
            "message": "server_status:${response.statusCode}"
          },
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
    }
  }
}
