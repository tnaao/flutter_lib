library mx_event_lib;

export 'package:mxbase/model/app_holder.dart';
export 'package:event_bus/event_bus.dart';

abstract class MxEvent {}

class MyRefreshHeaderEvent {
  final bool isNoMore;

  MyRefreshHeaderEvent({this.isNoMore = false});
}
