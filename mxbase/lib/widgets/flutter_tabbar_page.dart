library flutter_tabbar_page;

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TabBarPage extends StatelessWidget {
  final List<PageTabItemModel> pages;
  final bool isSwipable;
  final double tabHeight;
  final bool? distributeTabEvenly;
  final Color? tabBackgroundColor;
  final Alignment tabAlignment;
  final bool isTabPositionCenter;
  final double tabPositionPaddingLeft;
  final double tabWidth;
  final IndexedWidgetBuilder tabitemBuilder;
  final TabPageController controller;
  final bool canScroll;

  const TabBarPage(
      {Key? key,
      required this.pages,
      required this.tabitemBuilder,
      required this.controller,
      this.isSwipable = false,
      this.isTabPositionCenter = true,
      this.tabHeight = 50,
      this.tabWidth = double.infinity,
      this.tabPositionPaddingLeft = 0.0,
      this.distributeTabEvenly = true,
      this.canScroll = false,
      this.tabBackgroundColor = Colors.white,
      this.tabAlignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: this.isTabPositionCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          color: tabBackgroundColor,
          height: tabHeight,
          width: tabWidth,
          padding: EdgeInsets.only(left: this.tabPositionPaddingLeft),
          child: ValueListenableBuilder(
              valueListenable: controller.tabIndexChanged,
              builder: (context, chils, value) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    if (!distributeTabEvenly!) ...[
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
              }),
        ),
        ValueListenableBuilder(
            valueListenable: controller.tabIndexChanged,
            builder: (context, child, value) {
              return Flexible(
                child: PageView.builder(
                    itemCount: pages.length,
                    physics: isSwipable
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.tabIndexChanged.value = index;
                      controller.updateIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return pages[index].page!;
                    }),
              );
            })
      ],
    );
  }
}

class PageTabItemModel {
  String? title;
  dynamic moreInfo;
  Widget? page;

  PageTabItemModel({this.title, this.moreInfo, this.page});
}

class TabPageController extends ChangeNotifier {
  int _currentTabIndex = 0;
  ValueNotifier<int> tabIndexChanged = ValueNotifier(0);
  final PageController _pageController = PageController();

  TabPageController();

  void onTabTap(int index) {
    _currentTabIndex = index;
    tabIndexChanged.value = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  void updateIndex(int index) {
    _currentTabIndex = index;
  }

  PageController get pageController => _pageController;

  int get currentIndex => _currentTabIndex;
}
