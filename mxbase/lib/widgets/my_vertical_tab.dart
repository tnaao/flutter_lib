import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:velocity_x/velocity_x.dart';
import 'my_imageview.dart';

class MyVerticalTabs extends StatefulWidget {
  final Key? key;
  final double tabsWidth;
  final double itemExtent;
  final double indicatorWidth;
  final List<Tab> tabs;
  final List<Widget> contents;
  final TextDirection direction;
  final Color indicatorColor;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color selectedTabBackgroundColor;
  final Color unselectedTabBackgroundColor;
  final Color dividerColor;
  final Color? bgColor;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function? onSelectIdx;

  MyVerticalTabs(
      {this.key,
      required this.tabs,
      required this.contents,
      this.tabsWidth = 200,
      this.itemExtent = 50,
      this.onSelectIdx,
      this.indicatorWidth = 3,
      this.direction = TextDirection.ltr,
      this.indicatorColor = Colors.green,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.horizontal,
      this.selectedTabBackgroundColor = const Color(0x1100ff00),
      this.unselectedTabBackgroundColor = const Color(0xfff8f8f8),
      this.dividerColor = const Color(0xffe5e5e5),
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.tabsShadowColor = Colors.black54,
      this.tabsElevation = 2.0,
      this.bgColor})
      : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  static Tab myVTab(String title, bool isCurrent, BuildContext context,
      {Color indicatorColor = UIData.primaryColor,
      Color titleNColor = UIData.black,
      num indicatorH = 100,
      num indicatorW = 8}) {
    var isZhg = true;

    var textWidget = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 12.0,
          color: isZhg && isCurrent
              ? UIData.pureWhite
              : isCurrent
                  ? indicatorColor
                  : titleNColor),
    );

    return Tab(
      child: Stack(
        children: [
          !isCurrent
              ? SizedBox()
              : Row(
                  children: [
                    Expanded(
                        child: MyAssetImageView(
                      'ic_shop_cate_zhg_bg.png',
                      width: 86.hsp,
                      fit: BoxFit.fill,
                    )
                            .box
                            .color(Colors.transparent)
                            .padding(EdgeInsets.fromLTRB(2.0, .0, 2.0, 0.0))
                            .make())
                  ],
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isZhg && isCurrent
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                      decoration: isCurrent
                          ? BoxDecoration(color: indicatorColor)
                          : null,
                      width: indicatorW.toDouble(),
                      height: indicatorH.toDouble(),
                    ),
              Expanded(
                  child: Container(
                child: isZhg ? textWidget.centered() : textWidget,
              )),
            ],
          )
        ],
      ).box.height(isZhg && isCurrent ? 48.vsp : double.infinity).make(),
    );
  }

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<MyVerticalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool? _changePageByTapView;

  AnimationController? animationController;
  Animation<double>? animation;
  Animation<RelativeRect>? rectAnimation;

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }
    _selectTab(0);

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  child: Container(
                    width: widget.tabsWidth,
                    child: ListView.builder(
                      itemExtent: widget.itemExtent,
                      itemCount: widget.tabs.length,
                      itemBuilder: (context, index) {
                        Tab tab = widget.tabs[index];

                        Alignment alignment = Alignment.centerLeft;
                        if (widget.direction == TextDirection.rtl) {
                          alignment = Alignment.centerRight;
                        }

                        Widget? child;
                        if (tab.child != null) {
                          child = tab.child;
                        } else {
                          child = Row(
                            children: <Widget>[
                              (tab.icon != null)
                                  ? Row(
                                      children: <Widget>[
                                        tab.icon!,
                                        SizedBox(
                                          width: 0.0,
                                        )
                                      ],
                                    )
                                  : Container(),
                              (tab.text != null) ? Text(tab.text!) : Container(),
                            ],
                          );
                        }

                        Color itemBGColor = widget.unselectedTabBackgroundColor;
                        if (_selectedIndex == index)
                          itemBGColor = widget.selectedTabBackgroundColor;

                        return GestureDetector(
                          onTap: () {
                            _changePageByTapView = true;
                            setState(() {
                              _selectTab(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: itemBGColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ScaleTransition(
                                  child: Container(
                                    width: widget.indicatorWidth,
                                    height: widget.itemExtent,
                                    color: widget.indicatorColor,
                                  ),
                                  scale: Tween(begin: 0.0, end: 1.0).animate(
                                    new CurvedAnimation(
                                      parent: animationControllers[index],
                                      curve: Curves.elasticOut,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: alignment,
                                    padding: EdgeInsets.all(0.0),
                                    child: child,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  elevation: widget.tabsElevation,
                  shadowColor: widget.tabsShadowColor,
                  shape: BeveledRectangleBorder(),
                  color: widget.bgColor,
                ),
                Expanded(
                    child: IndexedStack(
                  children: widget.contents,
                  index: _selectedIndex >= widget.contents.length
                      ? 0
                      : _selectedIndex,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _selectTab(index) {
    _selectedIndex = index;

    if (widget.onSelectIdx != null) widget.onSelectIdx!(index);
  }
}
