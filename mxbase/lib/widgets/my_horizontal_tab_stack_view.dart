import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/widgets/my_imageview.dart';

class MyHorizontalTabStackView extends StatefulWidget {
  final Key? key;
  final double tabsHeight;
  final double tabsWidth;
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
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function? onSelectIdx;
  final int initialIdx;

  MyHorizontalTabStackView(
      {this.key,
      required this.tabs,
      required this.contents,
      this.tabsHeight = 80,
      this.tabsWidth = 200,
      this.onSelectIdx,
      this.indicatorWidth = 0.0,
      this.direction = TextDirection.ltr,
      this.indicatorColor = Colors.transparent,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.horizontal,
      this.selectedTabBackgroundColor = UIData.white,
      this.unselectedTabBackgroundColor = UIData.white,
      this.dividerColor = const Color(0xffe5e5e5),
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.tabsShadowColor = Colors.black54,
      this.initialIdx = 0,
      this.tabsElevation = 1.0})
      : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  static Tab myHTab(String title, bool isCurrent, BuildContext context,
      {double tabWidth = 0.0,
      double tabHeight = 0.0,
      EdgeInsets? padding,
      double fontSize = 12.0,
      double indicatorH = 8.0,
      double? indicatorW,
      int titlesLen = 0,
      Color indicatorColor = UIData.accentColor,
      Color normalColor = UIData.textGN,
      bool hasVDivider = false}) {
    if (titlesLen > 0) {
      double w = MxBaseUserInfo.instance.deviceSize.width;
      tabWidth = titlesLen == 0
          ? 55
          : w / titlesLen > 55.0
              ? w / titlesLen
              : 55.0 * titlesLen / 2;
    }
    return Tab(
        key: UniqueKey(),
        child: Container(
          padding: padding,
          width: tabWidth > 0 ? tabWidth : null,
          decoration: hasVDivider
              ? BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: UIData.lineBg, width: UIData.lineH)))
              : null,
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox.fromSize(
                  size: Size(tabWidth > 100 ? tabWidth - 40.0 : 60.0,
                      tabHeight > 12.0 ? tabHeight : 18.0),
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: isCurrent ? fontSize + 1.0 : fontSize,
                          color: isCurrent ? indicatorColor : normalColor),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      width: tabWidth > 0 ? tabWidth : 20,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    height: indicatorH,
                    width: indicatorW,
                    child: MyAssetImageView(
                      '',
                      color: isCurrent ? indicatorColor : Colors.transparent,
                      width: indicatorW,
                      radius: indicatorH / 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<MyHorizontalTabStackView>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool? _changePageByTapView;

  AnimationController? animationController;
  Animation<double>? animation;

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    _selectedIndex = widget.initialIdx;
    _selectTab(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
//    Border border = Border(
//        right: BorderSide(
//            width: 0.5, color: widget.dividerColor));
//    if (widget.direction == TextDirection.rtl) {
//      border = Border(
//          left: BorderSide(
//              width: 0.5, color: widget.dividerColor));
//    }

    return Directionality(
      textDirection: widget.direction,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox.fromSize(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Material(
                        child: Container(
                          height: widget.tabsHeight,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
//                      itemExtent: widget.tabsWidth,
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
                                child = Column(
                                  children: <Widget>[
                                    (tab.icon != null)
                                        ? Column(
                                            children: <Widget>[
                                              tab.icon!,
                                              SizedBox(
                                                height: 0.0,
                                              )
                                            ],
                                          )
                                        : Container(),
                                    (tab.text != null)
                                        ? Text(tab.text!)
                                        : Container(),
                                  ],
                                );
                              }

                              Color itemBGColor =
                                  widget.unselectedTabBackgroundColor;
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ScaleTransition(
                                        child: Container(
                                          height: widget.indicatorWidth,
//                                    width: widget.tabsWidth,
                                          color: widget.indicatorColor,
                                        ),
                                        scale:
                                            Tween(begin: 0.0, end: 1.0).animate(
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
                      ),
                    ),
                  ),
                  size: Size.fromHeight(widget.tabsHeight),
                ),
                Expanded(
                    child: IndexedStack(
                  index: _selectedIndex,
                  children: widget.contents,
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectTab(index) {
    print('horizon tab select index ${index}');
    int selIndex = index >= widget.contents.length ? 0 : index;
    setState(() {
      _selectedIndex = selIndex;
    });

    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();
    if (widget.onSelectIdx != null) widget.onSelectIdx!(index);
  }
}
