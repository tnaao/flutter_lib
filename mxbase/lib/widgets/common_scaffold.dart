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
        this.icon.textEmpty() ? UIData.icLeading(this.isDark) : this.icon,
        width: 10.0,
        height: 18.0,
      ).centered(),
    )
        .box
        .padding(UIData.fromLTRB(15, 0, this.paddingR.toDouble(), 0))
        .color(UIData.clickColor())
        .make()
        .onInkTap(() {
      if (this.onBack != null) {
        this.onBack!();
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

  final showFAB;
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

  final bool safeBody;
  final bool noAppBar;
  final bool hideAppbar;
  final bool noStatusBar;
  final bool statusBarPadding;
  final drawer;
  final endDrawer;
  bool isLoading;
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
    this.showFAB = false,
    this.showDrawer = false,
    this.drawer,
    this.endDrawer,
    this.backGroundColor = UIData.windowBg,
    this.actionFirstIcon = Icons.search,
    this.scaffoldKey,
    this.actionButtons,
    this.appBar,
    this.showBottomNav = false,
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
    this.appColor = UIData.pureWhite,
    this.titleColor,
    this.height,
    this.onBodyClick,
    this.drawBottomColor = UIData.windowBg,
    this.isDarkLeading = true,
  });

  Widget get _pageToDisplay {
    return this.hasNoWrapper
        ? Container(
            color: this.backGroundColor == null
                ? UIData.windowBg
                : this.backGroundColor,
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
          ).click(() {
            if (this.onBodyClick != null) this.onBodyClick!();
          }).make()
        : Container(
            height: this.height ??
                (hideAppbar
                    ? deviceHeight + navigationHeight
                    : contentHeight + navigationHeight),
            color: this.bodyDecoration == null ? this.backGroundColor : null,
            decoration: this.bodyDecoration,
            child: Stack(
              children: <Widget>[
                !this.drawBottom
                    ? SizedBox()
                    : Positioned(
                        child: Container(
                          width: deviceWidth,
                          height: navigationHeight,
                          color: this.drawBottomColor,
                        ),
                        bottom: 0.0,
                      ),
                Container(
                    width: deviceWidth,
                    child: !safeBody
                        ? bodyData
                        : SafeArea(
                            child: bodyData,
                          )),
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
          ).click(() {
            if (this.onBodyClick != null) this.onBodyClick!();
          }).make();
  }

  Widget get _loadingView {
    return MyLoadingIndicator(
      topPadding: 55.0,
    );
  }

  Widget myBottomBar() => BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Ink(
          height: 50.0,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: UIData.kitGradients)),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: new InkWell(
                  radius: 10.0,
                  splashColor: Colors.yellow,
                  onTap: () {},
                  child: Center(
                    child: new Text(
                      "ADD TO WISHLIST",
                      style: new TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              new SizedBox(
                width: 20.0,
              ),
              SizedBox(
                height: double.infinity,
                child: new InkWell(
                  onTap: () {},
                  radius: 10.0,
                  splashColor: Colors.yellow,
                  child: Center(
                    child: new Text(
                      "ORDER PAGE",
                      style: new TextStyle(
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
    if (true) return null;
    return BottomAppBar(
      color: UIData.pureWhite,
      child: SizedBox(
        height: 0.0,
      ),
    );
  }

  Widget leadingWidget(BuildContext context) {
    return this.noLeadingBack || !this.hasLeading
        ? SizedBox()
        : InkWell(
            child: SizedBox(
              width: 12,
              height: MxBaseUserInfo.instance.appBarHeight,
              child: MyAssetImageView(
                UIData.icLeading(true),
                width: 11.0,
                height: 18.0,
              ).centered(),
            ).box.padding(UIData.fromLTRB(8, 0, 10, 0)).make(),
            onTap: this.onBack != null
                ? this.onBack as void Function()?
                : () {
                    GoRouter.of(context).pop();
                  },
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
      List<Widget>? actions}) {
    return PreferredSize(
        child: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: barColor,
          shadowColor: Colors.transparent,
          title: Text(
            title,
            style: TextStyle(
                fontSize: 17.fsp,
                fontWeight: FontWeight.w600,
                color: titleColor),
          ),
          actions: actions,
        ),
        preferredSize: Size.fromHeight(MxBaseUserInfo.instance.appBarHeight));
  }

  static Widget customBar(Widget leading, Widget title,
      {Color barColor = UIData.primaryColor,
      List<Widget>? actions,
      double elevation = 0.5}) {
    return PreferredSize(
        child: AppBar(
          centerTitle: true,
          elevation: elevation,
          iconTheme: IconThemeData(
              color:
                  UIData.isLightColor(barColor) ? UIData.black : UIData.white),
          backgroundColor: barColor,
          title: title,
          leading: leading,
          actions: actions == null ? [] : actions,
        ),
        preferredSize: Size.fromHeight(MxBaseUserInfo.instance.appBarHeight));
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
        ? this._pageToDisplay
        : Scaffold(
            key: scaffoldKey != null ? scaffoldKey : null,
            backgroundColor: backGroundColor != null ? backGroundColor : null,
            appBar: this.noAppBar
                ? null
                : this.hideAppbar
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(0),
                        child:
                            CommonScaffold.bar('', barColor: this._appColor!),
                      )
                    : appBar != null
                        ? appBar
                        : PreferredSize(
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
                                  iconTheme: IconThemeData(color: _titleColor),
                                  backgroundColor: _appColor,
                                  title: Text(
                                    appTitle,
                                    style: TextStyle(
                                        fontSize: 17.fsp,
                                        fontWeight: FontWeight.w600,
                                        color: _titleColor),
                                  ),
                                  actions: actionButtons != null
                                      ? actionButtons
                                      : <Widget>[],
                                  leading: this.leadingWidget(context)),
                            ),
                          ),
            drawer: this.drawer != null
                ? this.drawer
                : showDrawer
                    ? CommonDrawer()
                    : null,
            endDrawer: this.endDrawer != null ? this.endDrawer : null,
            body: this.statusBarPadding
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
