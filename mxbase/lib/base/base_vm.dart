import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mxbase/base/BaseConsumerPage.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:rxdart/rxdart.dart';

class FakeViewModel extends BaseXViewModel with LifecycleMxHandleMixin {}

abstract class BaseXViewModel extends ChangeNotifier {
  int get seqGenFn => DateTime.now().microsecondsSinceEpoch;

  bool _mounted = true;
  bool get mounted => _mounted;
  late final BehaviorSubject<bool> _loadingEvent = BehaviorSubject();
  StreamSubscription? _loadingTask;
  bool _uiLoading = false;
  bool get loading {
    _loadingTask ??= _loadingEvent.doOnCancel(() {
      _uiLoading = false;
      _loadingEvent.close();
      _loadingTask = null;
    }).listen((event) {
      _uiLoading = event;
      notifyListeners();
    });
    return _uiLoading;
  }

  set loading(bool value) {
    if (value) {
      1477.after().then((_) {
        loading = false;
      });
    }
    _loadingEvent.add(value);
  }

  void notifyChange() {
    if (loading) {
      return;
    }
    if (_mounted && hasListeners) {
      notifyListeners();
    }
  }

  void logRunTime([dynamic data]) {
    final type = toString();
    'runtime:$type:$data'.logMx();
  }

  String get xHashIdentifier => identityHashCode(this).toString();

  @override
  void dispose() async {
    _mounted = false;
    _loadingTask?.cancel();
    _loadingTask = null;
    await onDispose();
    super.dispose();
  }

  Future<void> onDispose() async {}
}
