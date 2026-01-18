import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mxbase/ext/divider.dart';
import 'package:rxdart/subjects.dart';

typedef ItemCreator<S> = S Function();

final _getItBase = GetIt.instance;

mixin SharedExtension<T extends Object> {
  T vmCreate() {
    return _getItBase.get<T>();
  }
}

typedef LifecycleEventCallback = void Function(LifecycleEvent event);

mixin LifecycleMxHandleMixin on ChangeNotifier {
  LifecycleEvent _currentLifecycle = LifecycleEvent.push;
  LifecycleEvent get currentLifecycle => _currentLifecycle;
  final int lazyWt = 0;

  StreamSubscription? _eventSubscription;

  final BehaviorSubject<LifecycleEvent> _eventChannel = BehaviorSubject();
  set currentLifecycle(LifecycleEvent value) {
    _eventSubscription ??= _eventChannel.listen((e) {
      _currentLifecycle = e;
      lazyWt.after().then((_) {
        lazyTask?.call();
        lazyTask = null;
      });
      onLifecycleEvent?.call(e);
    });

    if (value == LifecycleEvent.pop) {
      _eventSubscription?.cancel();
      _eventSubscription = null;
      _currentLifecycle = value;
      onLifecycleEvent?.call(value);
    } else {
      _eventChannel.add(value);
    }
  }

  LifecycleEventCallback? onLifecycleEvent;
  bool isInitCall = false;
  void Function()? lazyTask;
  void lazyLoading(void Function() task) {
    if (!isInitCall) {
      lazyTask = task;
      isInitCall = true;
    }
  }

  @override
  void dispose() {
    _eventChannel.close();
    super.dispose();
  }
}

extension LifecycleEventMxExt on LifecycleEvent {
  bool get isVisible => this == LifecycleEvent.visible;
  bool get isPop => this == LifecycleEvent.pop;
  bool get isPush => this == LifecycleEvent.push;
}

typedef BaseConsumerWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T state,
  T vm,
  WidgetRef ref,
);

abstract class BaseConsumerPage<T extends ChangeNotifier>
    extends ConsumerStatefulWidget with SharedExtension<T> {
  BaseConsumerPage({super.key, this.provider});

  final bool isKeepAlive = false;
  final bool isAutoOrientation = false;
  final bool isScreenPortrait = true;
  final ChangeNotifierProvider<T>? provider;

  void onCreate(T vm, WidgetRef ref) {}

  Widget buildPage(BuildContext context, T state, T vm, WidgetRef ref);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _BaseConsumerState<T>(
      (BuildContext context, T state, T vm, WidgetRef ref) =>
          buildPage(context, state, vm, ref),
      onCreate: onCreate,
      isWantKeepAlive: isKeepAlive,
      isAutoOrientation: isAutoOrientation,
      isScreenPortrait: isScreenPortrait,
      initProvider: provider,
    );
  }
}

class _BaseConsumerState<S extends ChangeNotifier>
    extends ConsumerState<BaseConsumerPage<S>>
    with
        SharedExtension<S>,
        AutomaticKeepAliveClientMixin,
        LifecycleAware,
        LifecycleMixin {
  final void Function(S, WidgetRef ref)? onCreate;
  late ChangeNotifierProvider<S> provider;
  ChangeNotifierProvider<S>? initProvider;
  late S state;
  S? vm;
  late BaseConsumerWidgetBuilder<S> _pageBuilder;
  final bool isWantKeepAlive;
  final bool isAutoOrientation;
  final bool isScreenPortrait;

  _BaseConsumerState(
    BaseConsumerWidgetBuilder<S> pageBuilder, {
    this.onCreate,
    this.isWantKeepAlive = false,
    this.isAutoOrientation = false,
    this.isScreenPortrait = true,
    this.initProvider,
  }) : super() {
    this._pageBuilder = pageBuilder;
    provider = initProvider ??
        ChangeNotifierProvider((ref) {
          return vmCreate();
        });
  }

  @override
  void dispose() {
    super.dispose();
    if (!isScreenPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    if (initProvider == null) {
      vm?.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    vm = ref.read(provider);
    createFn() {
      onCreate?.call(vm!, ref);
    }

    createFn.call();
    if (isAutoOrientation) {
      if (isScreenPortrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]).then((_) {
          AutoOrientation.portraitUpMode().then((_) {});
        });
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]).then((_) {});
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm is LifecycleMxHandleMixin) {
        final vmLocal = vm as LifecycleMxHandleMixin;
        vmLocal.lazyWt.after().then((_) {
          vmLocal.lazyTask?.call();
          vmLocal.lazyTask = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    state = ref.watch(provider);
    return this._pageBuilder(context, state, vm!, ref);
  }

  @override
  bool get wantKeepAlive => isWantKeepAlive;

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.invisible) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (vm is LifecycleMxHandleMixin) {
      (vm as LifecycleMxHandleMixin).currentLifecycle = event;
    }
  }
}
