import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mxbase/base/BaseConsumerPage.dart';
import 'package:rxdart/rxdart.dart';

typedef BaseStateConsumerWidgetBuilder<T extends StateNotifier<O>, O> = Widget
    Function(
  BuildContext context,
  O state,
  T vm,
  WidgetRef ref,
);

abstract class BaseStateConsumerPage<T extends StateNotifier<O>, O>
    extends ConsumerStatefulWidget with SharedExtension<T> {
  BaseStateConsumerPage({super.key});

  final bool isKeepAlive = false;

  void onCreate(T vm, WidgetRef ref) {}

  abstract final StateNotifierProvider<T, O> provider;

  Widget buildPage(BuildContext context, O state, T vm, WidgetRef ref);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _BaseConsumerState<T, O>(
      (BuildContext context, O state, T vm, WidgetRef ref) =>
          buildPage(context, state, vm, ref),
      onCreate: onCreate,
      isWantKeepAlive: isKeepAlive,
      provider: provider,
    );
  }
}

class _BaseConsumerState<S extends StateNotifier<O>, O>
    extends ConsumerState<BaseStateConsumerPage<S, O>>
    with SharedExtension<S>, AutomaticKeepAliveClientMixin {
  final void Function(S, WidgetRef)? onCreate;
  final StateNotifierProvider<S, O> provider;
  late S vm;
  late ItemCreator<S> stateVmCreate;
  late BaseStateConsumerWidgetBuilder<S, O> _pageBuilder;
  final bool isWantKeepAlive;
  final PublishSubject<bool> _onCreateObj = PublishSubject();

  _BaseConsumerState(
    BaseStateConsumerWidgetBuilder<S, O> pageBuilder, {
    this.onCreate,
    this.isWantKeepAlive = false,
    required this.provider,
  }) : super() {
    this._pageBuilder = pageBuilder;
    _onCreateObj.listen((value) async {
      await _onCreateObj.close();
      onCreate?.call(vm, ref);
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    vm = ref.read(provider.notifier);
    _onCreateObj.add(true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var state = ref.watch(provider);
    return this._pageBuilder(context, state, vm, ref);
  }

  @override
  bool get wantKeepAlive => isWantKeepAlive;
}
