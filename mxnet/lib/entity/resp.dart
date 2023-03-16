import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart' as dio;
import 'package:mxbase/event/mx_event.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/ext/common.dart';
import 'package:mxnet/entity/entity.dart';

class ListResp<T> {
  final bool succeed;

  List<T> data = [];

  ListResp(this.succeed);
}

class PagedItem {
  const PagedItem();

  PagedItem fromJson(PagedItem t, Map<String, dynamic> json) {
    return PagedItem();
  }

  Map<String, dynamic> toJson() => {};
}

class PagedDataWrapper<T extends PagedItem> {
  PagedDataWrapper({
    this.total,
    this.pages,
    this.limit,
    this.page,
    this.list,
  });

  int? total;

  int? pages;

  int? limit;

  int? page;

  List<T>? list;

  PagedDataWrapper.fromJson(Map<String, dynamic> json) {
    this.total = json["total"] == null ? null : json["total"];
    this.pages = json["pages"] == null ? null : json["pages"];
    this.limit = json["limit"] == null ? null : json["limit"];
    this.page = json["page"] == null ? null : json["page"];
    this.list =
        json["list"] == null ? null : List<T>.from(json["list"].map((x) => x));
  }

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "pages": pages == null ? null : pages,
        "limit": limit == null ? null : limit,
        "page": page == null ? null : page,
        "list": list == null
            ? null
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

abstract class RespList<T> {
  String? message;

  String? title;

  String? uuid;

  List<T>? list;

  List<T>? get data => this.list;

  int? code;

  int? total;

  int? errno = -1;

  RespList(
      {this.message, this.title, this.uuid, this.list, this.code, this.total});

  RespList.fromJson(Map<String, dynamic> json) {
    superFromJson(json);
    if (this.isDataVali()) {
      this.list = List<T>.from(json.data.map((x) => dataFromJson(x)));
    } else {
      this.list = [];
    }
  }

  T? dataFromJson(Map<String, dynamic> json) {
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['errno'] = this.errno;
    data['message'] = this.message;
    data['title'] = this.title;
    data['data'] = this.list;
    return data;
  }
}

extension RespExt on Resp {
  void superFromJson(Map<String, dynamic> json) {
    if (json.containsKey('code'))
      this.code = json['code'].runtimeType == int
          ? json['code']
          : int.parse(json['code']);
    if (json.containsKey('errno'))
      this.errno = json['errno'].runtimeType == int
          ? json['errno']
          : int.parse(json['errno']);
    this.message = json['message'];
    if (this.message == null || this.message!.isEmpty)
      this.message = json['msg']?.toString();
    if (this.message == null || this.message!.isEmpty)
      this.message = json['errorMsg']?.toString();
    if (this.message == null || this.message!.isEmpty)
      this.message = json['error']?.toString();
    this.title = json['title'];
    this.uuid = json['uuid'];
  }

  bool isDataVali() => this.code == 0 || this.code == 200;

  bool valid() {
    bool isValid = this.isDataVali();

    if ('${this.message}'.contains('认证失败') ||
        this.code == 401 ||
        this.code == 403) {
      this.message.apiMessageShow();
      AppHolder.eventBus.fire(MxGoLoginEvent(needClear: true));
      return false;
    }

    if (!isValid) {
      this.message.apiMessageShow();
    }

    return isValid;
  }

  bool validNotGoLogin() {
    bool isValid = this.isDataVali();

    if (!isValid && 401 != this.code) {
      this.message.apiMessageShow();
    }

    return isValid;
  }

  String? showErr(BuildContext context) {
    if (valid()) return null;
    String? msg = message == null ? "未知错误" : message;
    return msg;
  }
}

extension RespListExt on RespList {
  void superFromJson(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    if (json.containsKey('errno'))
      this.errno = json['errno'].runtimeType == int
          ? json['errno']
          : int.parse(json['errno']);
    this.message = json['message']?.toString();
    if (this.message == null || this.message!.isEmpty)
      this.message = json['msg']?.toString();
    if (this.message == null || this.message!.isEmpty)
      this.message = json['errorMsg'];
    if (this.message == null || this.message!.isEmpty)
      this.message = json['error'];
    this.title = json['title'];
    this.uuid = json['uuid'];
    this.total = json['total'];
  }

  bool isDataVali() => this.code == 0 || this.code == 200;

  bool valid() {
    bool isValid = this.isDataVali();

    if ('${this.message}'.contains('认证失败') ||
        this.code == 401 ||
        this.code == 403) {
      this.message.apiMessageShow();
      AppHolder.eventBus.fire(MxGoLoginEvent(needClear: true));
      return false;
    }

    if (!isValid) {
      this.message.apiMessageShow();
    }

    return isValid;
  }

  bool validNotGoLogin() {
    if (this == null) return false;
    bool isValid = this.isDataVali();

    if (!isValid && 401 != this.code) {
      this.message.apiMessageShow();
    }

    return isValid;
  }

  String? showErr() {
    if (isDataVali()) return null;
    String? msg = message == null ? "未知错误" : message;
    return msg;
  }
}

extension RespMapExt on Map {
  bool jsonValid() {
    Map json = this;
    return (json['code']?.toString() == 200.toString() ||
        json['errno']?.toString() == 0.toString());
  }

  dynamic get data => this.containsKey('data')
      ? this['data'] != null
          ? this['data']
          : null
      : this['rows'] != null
          ? this['rows']
          : null;

  dynamic get list => this.containsKey('rows')
      ? this['rows'] != null
          ? this['rows']
          : []
      : this['data'] != null
          ? this['data']
          : [];

  int intKey(String key) {
    return !this.containsKey(key) ? 0 : double.parse(this[key]).toInt();
  }
}

class Resp<T> {
  String? message;

  String? title;

  String? uuid;

  T? data;

  int? code;

  int? errno = -1;

  Resp({this.message, this.title, this.uuid, this.data, this.code});

  Resp.fromJson(Map<String, dynamic> json) {
    this.superFromJson(json);
    if (this.isDataVali()) {
      if (json['data'] is List) {
        this.data = json['data'].map((e) => dataFromJson(e)).toList();
      } else {
        this.data = dataFromJson(json.data);
      }
    }
  }

  T? dataFromJson(Map<String, dynamic> json) {
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['errno'] = this.errno;
    data['message'] = this.message;
    data['title'] = this.title;
    data['data'] = this.data;
    return data;
  }
}

class OpRes extends Resp<dynamic> {
  OpRes.fromJson(Map<String, dynamic> json) {
    this.superFromJson(json);
    this.data = this.isDataVali() ? json['data'] : null;
  }
}

class FileRes extends Resp<dynamic> {
  String? url;

  FileRes.fromJson(Map<String, dynamic> json) {
    this.superFromJson(json);
    this.url = this.isDataVali() ? json['url'] : null;
  }
}

extension DioFormExt on Map<String, dynamic> {
  dio.FormData get formData => dio.FormData.fromMap(this);
}
