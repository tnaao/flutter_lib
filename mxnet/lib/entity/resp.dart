import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';

class ListResp<T> {
  final bool succeed;

  List<T> data = List();

  ListResp(this.succeed);
}

class ListDataWrapper<T> {
  List<T> data = List();
  int totalCount;
  int pageCount;

  ListDataWrapper(this.data, this.totalCount, this.pageCount);

  ListDataWrapper.fromJson(Map<String, dynamic> json) {
    this.data = List.from(json['data']);
    this.totalCount = json['total_count'];
    this.pageCount = json['page_count'];
  }
}

class RespList<T> {
  String message;
  String title;
  List<T> data;
  int code;

  bool valid() {
    return code == 1;
  }

  String showErr(BuildContext context) {
    if (valid()) return null;
    String msg = message == null ? "未知错误" : message;
    return msg;
  }

  RespList({this.message, this.title, this.data, this.code});

  RespList.fromJson(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    this.message = json['message'];
    this.title = json['title'];
    this.data = this.valid() ? json['data'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['title'] = this.title;
    data['data'] = this.data;
    return data;
  }
}

extension RespExt on Resp {
  bool valid() {
    return this.code == 0;
  }
}

extension RespMapExt on Map {
  bool jsonValid() {
    Map json = this;
    return json != null &&
        json['data'].toString().length > 0 &&
        json['code'].toString() == '0';
  }
}

class Resp<T> {
  String message;
  String title;
  T data;
  int code;

  String showErr(BuildContext context) {
    if (valid()) return null;
    String msg = message == null ? "未知错误" : message;
    return msg;
  }

  Resp({this.message, this.title, this.data, this.code});

  Resp.fromJson(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    this.message = json['message'];
    this.title = json['title'];
    this.data = this.valid() ? json['data'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['title'] = this.title;
    data['data'] = this.data;
    return data;
  }
}

class OpRes extends Resp<dynamic> {
  OpRes.fromJson(Map<String, dynamic> json) {
    this.code = json['code'].runtimeType == int
        ? json['code']
        : int.parse(json['code']);
    this.message = json['message'];
    this.title = json['title'];
    this.data = this.valid() ? json['data'] : null;
  }
}
