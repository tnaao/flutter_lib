import 'package:flutter/material.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/app_holder.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:velocity_x/velocity_x.dart';
import 'my_listview.dart';
import 'my_imageview.dart';

class MyVerticalTwoDimensionBean {
  final String? title;
  int idx;
  final int? id;
  bool current;
  List<MyVerticalTwoDimensionBean>? children;

  MyVerticalTwoDimensionBean(
      {this.id, this.title, this.idx = 0, this.current = false, this.children});
}

class MyVerticalTwoDimensionEvent {
  final Key? key;
  final int? idx;

  MyVerticalTwoDimensionEvent({this.key, this.idx});
}

class MyVerticalTwoDimensionTab extends StatefulWidget {
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
  final List<MyVerticalTwoDimensionBean>? tabBeanList;

  MyVerticalTwoDimensionTab(
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
      this.bgColor,
      this.tabBeanList})
      : super(key: key);

  static Tab myVTab(
    String title,
    bool isCurrent,
    BuildContext context, {
    Color indicatorColor = UIData.primaryColor,
    Color titleNColor = UIData.black,
    num indicatorH = 100,
    num indicatorW = 8,
    Color unselectedTabBackgroundColor = UIData.pureWhite,
    Color selectedTabBackgroundColor = UIData.pureWhite,
    MyVerticalTwoDimensionBean? data,
    Function? selectPage,
  }) {
    var isZhg = true;

    var textWidget = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 12.0,
          color: isZhg
              ? UIData.pureWhite
              : isCurrent
                  ? indicatorColor
                  : titleNColor),
    ).box.padding(EdgeInsets.only(left: 5.0, right: 5.0)).make();

    return Tab(
      child: VStack([
        Stack(
          children: [
            Row(
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
                isZhg
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
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: isZhg ? textWidget.centered() : textWidget,
                )),
              ],
            ),
          ],
          alignment: AlignmentDirectional.center,
        ).box.height(48.vsp).make(),
        isCurrent
            ? MyStillListView(data!.children, (context, index) {
                var item = data.children![index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    isZhg && !item.current
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            decoration: null,
                            width: indicatorW.toDouble(),
                            height: indicatorH.toDouble(),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                            decoration: isCurrent
                                ? BoxDecoration(color: indicatorColor)
                                : null,
                            width: indicatorW.toDouble(),
                            height: indicatorH.toDouble(),
                          ),
                    Expanded(
                      child: Container(
                          child: Text(
                        item.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: isZhg
                                ? UIData.black
                                : isCurrent
                                    ? indicatorColor
                                    : titleNColor),
                      ).centered()),
                    ),
                  ],
                )
                    .box
                    .color(item.current
                        ? selectedTabBackgroundColor
                        : unselectedTabBackgroundColor)
                    .height(48.vsp)
                    .make()
                    .onInkTap(() {
                  if (selectPage != null) selectPage(item.idx);
                });
              })
            : SizedBox(),
      ])
          .box
          .height(
              isZhg && isCurrent ? 48.vsp * (data!.children!.length + 1) : 48.vsp)
          .make(),
    );
  }

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<MyVerticalTwoDimensionTab>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int? _selectedPageIndex = 0;
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
    _selectTab(0, 0);

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    super.initState();

    this.initListener();
  }

  void initListener() async {
    AppHolder.eventBus.on<MyVerticalTwoDimensionEvent>().listen((event) {
      if (event.key == widget.key) {
        _selectTab(_selectedTabIndex, event.idx);
      }
    });
  }

  Widget itemBuilder(int index) {
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
    if (_selectedTabIndex == index)
      itemBGColor = widget.selectedTabBackgroundColor;

    return GestureDetector(
      onTap: () {
        _changePageByTapView = true;
        var item = widget.tabBeanList![index];
        setState(() {
          _selectTab(index, item.idx);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: itemBGColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
  }

  List<Widget> tabList() {
    List<Widget> list = [];
    for (int i = 0; i < widget.tabs.length; i++) {
      list.add(this.itemBuilder(i));
    }
    return list;
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
                    child: VStack(tabList()).scrollVertical(),
                  ),
                  elevation: widget.tabsElevation,
                  shadowColor: widget.tabsShadowColor,
                  shape: BeveledRectangleBorder(),
                  color: widget.bgColor,
                ),
                Expanded(
                    child: IndexedStack(
                  children: widget.contents,
                  index: _selectedPageIndex! >= widget.contents.length
                      ? 0
                      : _selectedPageIndex,
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

  void _selectTab(index, page) {
    _selectedTabIndex = index;
    _selectedPageIndex = page;
    print('selIdx:${_selectedTabIndex}');
    if (widget.onSelectIdx != null) widget.onSelectIdx!(index, page);
  }
}
