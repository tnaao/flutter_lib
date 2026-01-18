import 'package:flutter/material.dart';

typedef void OnWidgetMSizeChange(Size size);

/// [MeasuredSizeWrapper] Calculated the size of it's child in runtime.
/// Simply wrap your widget with [MeasuredSizeWrapper] and listen to size changes with [onChange].
class MeasuredSizeWrapper extends StatefulWidget {
  /// Widget to calculate it's size.
  final Widget child;

  final OnWidgetMSizeChange onChange;

  const MeasuredSizeWrapper({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  _MeasuredSizeWrapperState createState() => _MeasuredSizeWrapperState();
}

class _MeasuredSizeWrapperState extends State<MeasuredSizeWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  GlobalKey widgetKey = GlobalKey();
  Size oldSize = Size.zero;

  void postFrameCallback(_) async {
    final renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.hasSize ? renderBox.size : Size.zero;
    Size newSize = size;
    if (newSize == Size.zero) return;
    if (oldSize == newSize) return;
    oldSize = newSize;
    widget.onChange(newSize);
  }
}
