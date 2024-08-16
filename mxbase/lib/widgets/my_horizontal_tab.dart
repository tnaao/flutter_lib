import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/widgets/my_imageview.dart';
import 'package:mxbase/event/mx_event.dart';

class MyHorizontalTabGoEvent {
  final Key? key;

  final int? idx;

  MyHorizontalTabGoEvent({this.key, this.idx});
}

class MyHorizontalTabs extends StatefulWidget {
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

  MyHorizontalTabs(
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
      double fontSize = 14.0,
      double indicatorH = 8.0,
      double topPadding = 15.0,
      double? indicatorW,
      double barWidth = 0.0,
      int titlesLen = 0,
      Color indicatorColor = UIData.accentColor,
      Color? titleColor,
      double? h,
      Color normalColor = UIData.textGN,
      Color highLightColor = UIData.accentColor,
      String? indicatorIcon,
      bool hasVDivider = false}) {
    double fSize = isCurrent ? fontSize + 1 : fontSize;
    double w =
        barWidth > 1 ? barWidth : MxBaseUserInfo.instance.deviceSize.width;
    tabWidth = titlesLen != 0
        ? w / titlesLen > 85
            ? w / titlesLen
            : '$title'.textWidth(style: TextStyle(fontSize: fSize))
        : '$title'.textWidth(style: TextStyle(fontSize: fSize));

    return Tab(
        key: UniqueKey(),
        height: h,
        iconMargin: EdgeInsets.zero,
        child: Container(
          padding: padding,
          width: tabWidth > 100
              ? tabWidth - 40.0
              : '${title}'.length * 25.toDouble(),
          decoration: hasVDivider
              ? BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: UIData.lineBg, width: UIData.lineH)))
              : null,
          child: Column(
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(
                    tabWidth > 100
                        ? tabWidth
                        : '${title}'.length * 35.toDouble(),
                    tabHeight > 12.0 ? tabHeight : 30.vsp),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: fSize,
                        fontWeight:
                            isCurrent ? FontWeight.w500 : FontWeight.normal,
                        color: titleColor != null
                            ? titleColor
                            : isCurrent
                                ? highLightColor
                                : normalColor),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                height: indicatorH,
                width: indicatorW,
                child: indicatorIcon.textEmpty()
                    ? MyAssetImageView(
                        '',
                        color: isCurrent ? indicatorColor : Colors.transparent,
                        width: indicatorW,
                        radius: indicatorH / 2,
                      )
                    : isCurrent
                        ? MyAssetImageView(
                            '$indicatorIcon',
                            width: indicatorW,
                            height: indicatorH,
                            fit: BoxFit.fill,
                          )
                        : SizedBox(),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ));
  }

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<MyHorizontalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  bool? _changePageByTapView;

  AnimationController? animationController;

  Animation<double>? animation;

  late PageController pageController;
  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.initialIdx);

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
    this.initListener();
  }

  void initListener() async {
    AppHolder.eventBus.on<MyHorizontalTabGoEvent>().listen((event) {
      if (event.key == widget.key) {
        if (event.idx! < widget.contents.length) {
          _changePageByTapView = true;
          setState(() {
            _selectTab(event.idx);
          });
          pageController.animateToPage(event.idx!,
              duration: widget.changePageDuration,
              curve: widget.changePageCurve);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox.fromSize(
                  child: Container(
                    color: widget.unselectedTabBackgroundColor,
                    child: Material(
                      child: Container(
                        height: widget.tabsHeight,
                        color: widget.unselectedTabBackgroundColor,
                        child: ListView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
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
                                pageController.animateToPage(index,
                                    duration: widget.changePageDuration,
                                    curve: widget.changePageCurve);
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
                      shadowColor: Colors.transparent,
                      shape: BeveledRectangleBorder(),
                    ),
                  ),
                  size: Size.fromHeight(widget.tabsHeight),
                ),
                Expanded(
                  child: PageView.builder(
                    scrollDirection: widget.contentScrollAxis,
                    physics: pageScrollPhysics,
                    onPageChanged: (index) {
                      if (_changePageByTapView == false ||
                          _changePageByTapView == null) {
                        _selectTab(index);
                      }
                      if (_selectedIndex == index) {
                        _changePageByTapView = null;
                      }
                      setState(() {});
                    },
                    controller: pageController,

                    // the number of pages
                    itemCount: widget.contents.length,

                    // building pages
                    itemBuilder: (BuildContext context, int index) {
                      return widget.contents[index];
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectTab(index, {bool noCallback = false}) {
    print('horizon tab select index ${index}');
    int selIndex = index >= widget.contents.length ? 0 : index;
    setState(() {
      _selectedIndex = selIndex;
    });

    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();

    if (noCallback) return;
    if (widget.onSelectIdx != null) widget.onSelectIdx!(index);
  }
}
