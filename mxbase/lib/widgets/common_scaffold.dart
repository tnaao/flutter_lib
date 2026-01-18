import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mxbase/ext/mx_ext_functions.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/widgets/common_drawer.dart';
import 'package:mxbase/widgets/custom_float.dart';
import 'package:mxbase/widgets/my_imageview.dart';
import 'package:mxbase/widgets/my_loading_view.dart';
import 'package:mxbase/widgets/my_no_data_view.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLeadingBtn extends StatelessWidget {
  final Function? onBack;

  final String? icon;
  final num paddingR;
  final bool isDark;

  CommonLeadingBtn(
      {Key? key,
      this.onBack,
      this.paddingR = 15.0,
      this.isDark = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: MxBaseUserInfo.instance.appBarHeight,
      child: MyAssetImageView(
        icon.textEmpty() ? UIData.icLeading(isDark) : this.icon,
        width: 22.hsp,
        height: 22.hsp,
        fit: BoxFit.contain,
      ).centered(),
    )
        .box
        .padding(UIData.fromLTRB(20, 0, paddingR.toDouble(), 0))
        .color(UIData.clickColor())
        .make()
        .onTap(() {
      if (onBack != null) {
        onBack?.call();
        return;
      }
      context.back();
    });
  }
}

class CommonScaffold extends StatelessWidget with MxScreen {
  final String appTitle;
  final bool centerTitle;
  final Widget bodyData;
  final Decoration? bodyDecoration;
  final double? height;
  final num titleSize;
  final bool showFAB;
  final showDrawer;
  final Color? backGroundColor;
  final actionFirstIcon;
  final scaffoldKey;
  final actionButtons;
  final bool showBottomNav;
  final Widget? bottomNav;
  final floatingIcon;
  final centerDocked;
  final double elevation;
  final dynamic appBar;
  final Color? appColor;

  final Color? titleColor;
  final Widget? loadingView;
  final bool safeBody;
  final bool noAppBar;
  final bool hideAppbar;
  final bool noStatusBar;
  final bool statusBarPadding;
  final drawer;
  final endDrawer;
  bool isLoading;
  final bool? isBodyLoading;
  final bool isBackLoading;
  bool isEmpty;
  bool hasLeading;
  bool hasNoWrapper = false;
  bool drawBottom = false;
  final Color drawBottomColor;
  final Function? onBack;

  final Function? onBodyClick;

  final bool noLeadingBack;
  final bool isDarkLeading;

  Color? _appColor;

  Color? _titleColor;

  CommonScaffold({
    this.appTitle = '',
    required this.bodyData,
    this.bodyDecoration,
    this.centerTitle = true,
    this.titleSize = 18,
    this.showFAB = false,
    this.showDrawer = false,
    this.drawer,
    this.endDrawer,
    this.backGroundColor = UIData.windowBg,
    this.actionFirstIcon = Icons.search,
    this.scaffoldKey,
    this.actionButtons,
    this.appBar,
    this.showBottomNav = true,
    this.bottomNav,
    this.centerDocked = false,
    this.floatingIcon,
    this.elevation = 0.0,
    this.isLoading = false,
    this.isBackLoading = false,
    this.hasLeading = true,
    this.hideAppbar = false,
    this.safeBody = true,
    this.noAppBar = false,
    this.noStatusBar = false,
    this.statusBarPadding = false,
    this.onBack,
    this.noLeadingBack = false,
    this.hasNoWrapper = false,
    this.drawBottom = false,
    this.isEmpty = false,
    this.appColor = UIData.windowBg,
    this.titleColor = UIData.pureWhite,
    this.height,
    this.onBodyClick,
    this.drawBottomColor = UIData.windowBg,
    this.isDarkLeading = false,
    this.isBodyLoading,
    this.loadingView,
  });

  Widget get _pageToDisplay {
    return hasNoWrapper
        ? Container(
            color: this.backGroundColor ?? UIData.windowBg,
            child: Stack(
              children: <Widget>[
                Container(
                    width: MxBaseUserInfo.instance.deviceSize.width,
                    child: bodyData),
                Center(
                  child: isLoading
                      ? _loadingView
                      : isEmpty
                          ? MyNoDataView()
                          : SizedBox(),
                ),
                isLoading && isBackLoading ? CommonLeadingBtn() : SizedBox()
              ],
            ),
          ).xOnTap(() {
            onBodyClick?.call();
          })
        : Container(
            height: height ??
                (hideAppbar
                    ? deviceHeight + navigationHeight
                    : contentHeight + navigationHeight),
            color: bodyDecoration == null ? backGroundColor : null,
            decoration: bodyDecoration,
            child: ZStack(
              <Widget>[
                !drawBottom
                    ? SizedBox()
                    : Positioned(
                        bottom: 0.0,
                        child: Container(
                          width: deviceWidth,
                          height: navigationHeight,
                          color: drawBottomColor,
                        ),
                      ),
                SizedBox(
                  width: deviceWidth,
                  child: isBodyLoading == null
                      ? bodyData.xSafeContainer(safeBody)
                      : ZStack(
                          [
                            bodyData,
                            isBodyLoading == true ? _loadingView : SizedBox(),
                          ],
                          alignment: Alignment.topCenter,
                        ).xSafeContainer(safeBody),
                ),
                Center(
                  child: isLoading
                      ? _loadingView
                      : isEmpty
                          ? MyNoDataView()
                          : SizedBox(),
                ),
                isLoading && hideAppbar && isBackLoading
                    ? CommonLeadingBtn()
                    : SizedBox()
              ],
            ),
          ).xOnTap(() {
            onBodyClick?.call();
          });
  }

  Widget get _loadingView {
    return loadingView ??
        MyLoadingIndicator(
          topPadding: 55.0,
        );
  }

  Widget myBottomBar() => BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Ink(
          height: 50.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: UIData.kitGradients)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: InkWell(
                  radius: 10.0,
                  splashColor: Colors.yellow,
                  onTap: () {},
                  child: Center(
                    child: Text(
                      "ADD TO WISHLIST",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              SizedBox(
                height: double.infinity,
                child: InkWell(
                  onTap: () {},
                  radius: 10.0,
                  splashColor: Colors.yellow,
                  child: Center(
                    child: Text(
                      "ORDER PAGE",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget? bottomNavBar() {
    if (showBottomNav && bottomNav != null) return bottomNav;
    return null;
  }

  Widget leadingWidget(BuildContext context, {bool isDark = false}) {
    return this.noLeadingBack || !this.hasLeading
        ? SizedBox()
        : InkWell(
            splashColor: Colors.transparent,
            onTap: this.onBack != null
                ? this.onBack as void Function()?
                : () {
                    GoRouter.of(context).pop();
                  },
            child: SizedBox(
              height: MxBaseUserInfo.instance.appBarHeight,
              child: MyAssetImageView(
                UIData.icLeading(false),
                width: 22.hsp,
                height: 22.hsp,
                fit: BoxFit.fitHeight,
              ).centered(),
            ).box.padding(UIData.fromLTRB(20, 0, 20, 0)).make(),
          );
  }

  Widget defaultLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: UIData.white,
        ),
        onPressed: this.onBack != null
            ? this.onBack as void Function()?
            : () {
                GoRouter.of(context).pop();
              });
  }

  static Widget bar(String title,
      {Color barColor = UIData.primaryColor,
      Color titleColor = UIData.icBackColor,
      double titlesize = 18,
      List<Widget>? actions}) {
    return PreferredSize(
        preferredSize: Size.fromHeight(MxBaseUserInfo.instance.appBarHeight),
        child: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: barColor,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            title,
            style: TextStyle(
                fontSize: titlesize.fsp,
                fontWeight: FontWeight.w600,
                color: titleColor),
          ),
          actions: actions,
        ));
  }

  static Widget customBar(Widget leading, Widget title,
      {Color barColor = UIData.primaryColor,
      List<Widget>? actions,
      double elevation = 0.5}) {
    return PreferredSize(
        preferredSize: Size.fromHeight(MxBaseUserInfo.instance.appBarHeight),
        child: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          elevation: elevation,
          iconTheme: IconThemeData(
              color:
                  UIData.isLightColor(barColor) ? UIData.black : UIData.white),
          backgroundColor: barColor,
          title: title,
          leading: leading,
          actions: actions ?? [],
        ));
  }

  static Widget leadingNavDef() {
    return CommonLeadingBtn(
      paddingR: 0.0,
    );
  }

  static Widget leadingNav(BuildContext context,
      {Color titleColor = UIData.black,
      num paddingR = 0.0,
      bool isDark = false,
      String? icon,
      Function? onBack}) {
    return CommonLeadingBtn(
      paddingR: paddingR,
      isDark: isDark,
      icon: icon,
      onBack: () {
        if (onBack != null) {
          onBack();
        } else {
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _appColor = this.appColor == null ? UIData.pureWhite : this.appColor;

    bool isLightTheme = UIData.isLightColor(_appColor!);
    _titleColor = isLightTheme ? UIData.black : Colors.white;

    return hasNoWrapper
        ? _pageToDisplay
        : Scaffold(
            key: scaffoldKey,
            backgroundColor: backGroundColor,
            appBar: noAppBar
                ? null
                : hideAppbar
                    ? AppBar(
                        toolbarHeight: 0,
                        backgroundColor: appColor,
                      )
                    : appBar ??
                        PreferredSize(
                          preferredSize: Size.fromHeight(this.statusBarPadding
                              ? MxBaseUserInfo.instance.statusHeight +
                                  MxBaseUserInfo.instance.appBarHeight
                              : MxBaseUserInfo.instance.appBarHeight),
                          child: Container(
                            padding: EdgeInsets.only(
                              top: this.statusBarPadding
                                  ? MxBaseUserInfo.instance.statusHeight
                                  : 0.0,
                            ),
                            // decoration: BoxDecoration(color: _appColor),
                            child: AppBar(
                                centerTitle: centerTitle,
                                toolbarHeight: appBarHeight,
                                elevation: elevation,
                                surfaceTintColor: Colors.transparent,
                                iconTheme: IconThemeData(color: _titleColor),
                                backgroundColor: _appColor,
                                title: Text(
                                  appTitle,
                                  style: TextStyle(
                                      fontSize: titleSize.fsp,
                                      fontWeight: FontWeight.w600,
                                      color: _titleColor),
                                ),
                                actions: actionButtons ?? <Widget>[],
                                leading: this.leadingWidget(context,
                                    isDark: isLightTheme)),
                          ),
                        ),
            drawer: drawer ?? (showDrawer ? CommonDrawer() : null),
            endDrawer: endDrawer,
            body: statusBarPadding
                ? _pageToDisplay.box
                    .padding(EdgeInsets.only(top: statusHeight))
                    .make()
                : _pageToDisplay,
            floatingActionButton: showFAB
                ? CustomFloat(
                    builder: centerDocked
                        ? Text(
                            "5",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          )
                        : null,
                    icon: floatingIcon,
                    qrCallback: () {},
                  )
                : null,
            floatingActionButtonLocation: centerDocked
                ? FloatingActionButtonLocation.centerDocked
                : FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: bottomNavBar());
  }
}
