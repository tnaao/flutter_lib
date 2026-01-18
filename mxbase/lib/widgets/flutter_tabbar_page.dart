library flutter_tabbar_page;

import 'package:flutter/material.dart';
import 'package:mxbase/ext/divider.dart';
import 'package:mxbase/ext/widget.dart';
import 'package:velocity_x/velocity_x.dart';

class TabBarPage extends StatelessWidget {
  final List<PageTabItemModel> pages;
  final num paddingTop;
  final bool isSwipable;
  final bool isStack;
  final bool isStackStill;
  final double tabHeight;
  final bool isTabVisible;
  final bool distributeTabEvenly;
  final Color tabBackgroundColor;
  final Color tabContentBackgroundColor;
  final Alignment tabAlignment;
  final bool isTabPositionCenter;
  final double tabPositionPaddingLeft;
  final double tabTopRoundedRadius;
  final double tabWidth;
  final IndexedWidgetBuilder tabitemBuilder;
  final TabPageController controller;
  final bool canScroll;
  final Key? contentKey;

  const TabBarPage(
      {Key? key,
      this.pages = const [],
      this.contentKey,
      required this.tabitemBuilder,
      required this.controller,
      this.paddingTop = 0.0,
      this.isSwipable = false,
      this.isStack = false,
      this.isStackStill = false,
      this.isTabVisible = true,
      this.isTabPositionCenter = true,
      this.tabHeight = 50,
      this.tabWidth = double.infinity,
      this.tabPositionPaddingLeft = 0.0,
      this.tabTopRoundedRadius = 0.0,
      this.distributeTabEvenly = false,
      this.canScroll = false,
      this.tabBackgroundColor = Colors.white,
      this.tabContentBackgroundColor = Colors.transparent,
      this.tabAlignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: this.isTabPositionCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        paddingTop.vSpacer(),
        ValueListenableBuilder(
                valueListenable: controller.tabIndexChanged,
                builder: (context, chils, value) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (!distributeTabEvenly) ...[
                        Align(
                          alignment: tabAlignment,
                          child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemCount: pages.length,
                                  physics: this.canScroll
                                      ? const BouncingScrollPhysics()
                                      : const NeverScrollableScrollPhysics(),
                                  itemBuilder: tabitemBuilder)
                              .box
                              .height(tabHeight)
                              .make(),
                        ),
                      ] else ...[
                        ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                physics: this.canScroll
                                    ? const BouncingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                itemCount: pages.length,
                                itemBuilder: tabitemBuilder)
                            .box
                            .height(tabHeight)
                            .make()
                      ]
                    ],
                  );
                })
            .box
            .color(tabBackgroundColor)
            .padding(EdgeInsets.only(left: tabPositionPaddingLeft))
            .width(tabWidth)
            .height(tabHeight)
            .topRounded(value: tabTopRoundedRadius)
            .make()
            .xVisible(isTabVisible),
        ValueListenableBuilder(
            key: contentKey,
            valueListenable: controller.tabIndexChanged,
            builder: (context, int value, child) {
              if (isStack) {
                return IndexedStack(
                  index: value,
                  children: pages
                      .mapIndexed((e, i) => Visibility(
                            child: e.page,
                            visible: isStackStill || value == i,
                          ))
                      .toList(),
                )
                    .color(tabContentBackgroundColor)
                    .w(context.screenWidth)
                    .flexible();
              }
              return PageView.builder(
                  itemCount: pages.length,
                  physics: isSwipable
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.updateIndex(index);
                  },
                  itemBuilder: (context, index) {
                    return pages[index].page;
                  }).color(tabContentBackgroundColor).flexible();
            })
      ],
    );
  }
}

class PageTabItemModel {
  String title;
  dynamic moreInfo;
  Widget page;

  PageTabItemModel({this.title = 'Title', this.moreInfo, required this.page});
}

class TabPageController extends ChangeNotifier {
  int _currentTabIndex = 0;
  final bool isStack;
  ValueNotifier<int> tabIndexChanged = ValueNotifier(0);
  final PageController _pageController = PageController();
  final Function(int index)? onPageChanged;
  TabPageController({this.isStack = false, this.onPageChanged});

  void onTabTap(int index) {
    _currentTabIndex = index;
    tabIndexChanged.value = index;
    if (!isStack) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
  }

  void updateIndex(int index) {
    _currentTabIndex = index;
    tabIndexChanged.value = index;
    onPageChanged?.call(index);
  }

  PageController get pageController => _pageController;

  int get currentIndex => _currentTabIndex;
}

Widget tabViewMaker(String title, double width,
    {bool isCurrent = false,
    double? titleSize,
    double? titleHiSize,
    double? height,
    double? indicatorW,
    double? indicatorH,
    bool isTitleBold = false,
    bool isBottomLine = false,
    Color? hiTitleColor,
    Color lineColor = const Color(0xff8BD9FE),
    Color normalColor = const Color(0xff676869),
    Color hiColor = Colors.cyan}) {
  var iH = indicatorH ?? 2.vsp;
  var textColor = ((isCurrent)
      ? hiTitleColor != null
          ? hiTitleColor
          : !isTitleBold
              ? hiColor
              : hiColor
      : normalColor);
  return VStack(
    [
      Flexible(
          child: Text(
        title,
        style: TextStyle(
            color: textColor,
            fontSize: (isCurrent ? titleHiSize : titleSize) ?? 18.fsp,
            fontWeight: isTitleBold
                ? (isCurrent ? FontWeight.w600 : FontWeight.normal)
                : FontWeight.normal),
      ).centered()),
      Container(
        height: indicatorH ?? 2.vsp,
        decoration: ShapeDecoration(
            color: isCurrent ? hiColor : Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(iH)))),
        width: indicatorW ?? 120.hsp,
      ),
      isBottomLine
          ? Container(
              color: lineColor,
              height: 0.5.vsp,
              width: width,
            )
          : SizedBox(
              height: 0.5.vsp,
            ),
    ],
    crossAlignment: CrossAxisAlignment.center,
  )
      .box
      .size(width, height ?? 40.vsp)
      .make()
      .animatedBox
      .milliSeconds(milliSec: 300)
      .easeIn
      .make();
}
