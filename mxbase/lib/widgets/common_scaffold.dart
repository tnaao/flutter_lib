import 'package:flutter/material.dart';
import 'package:mxbase/widgets/custom_float.dart';
import 'my_loading_view.dart';
import 'package:mxbase/model/uidata.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/widgets/common_drawer.dart';
import 'package:mxbase/utils/theme_utils.dart';

class CommonScaffold extends StatelessWidget {
  final appTitle;
  final centerTitle;
  final Widget bodyData;
  final double height;
  final showFAB;
  final showDrawer;
  final backGroundColor;
  final actionFirstIcon;
  final scaffoldKey;
  final actionButtons;
  final showBottomNav;
  final bottomNav;
  final floatingIcon;
  final centerDocked;
  final elevation;
  final appBar;
  final Color appColor;
  final Color titleColor;
  final bool hideAppbar;
  final bool noStatusBar;
  final bool statusBarPadding;
  final drawer;
  final endDrawer;
  bool isLoading;
  bool hasLeading;
  final Function onBack;
  final bool noLeadingBack;
  Color _appColor;
  Color _titleColor;

  CommonScaffold({
    this.appTitle,
    this.bodyData,
    this.centerTitle = true,
    this.showFAB = false,
    this.showDrawer = false,
    this.drawer,
    this.endDrawer,
    this.backGroundColor,
    this.actionFirstIcon = Icons.search,
    this.scaffoldKey,
    this.actionButtons,
    this.appBar,
    this.showBottomNav = false,
    this.bottomNav,
    this.centerDocked = false,
    this.floatingIcon,
    this.elevation = 1.0,
    this.isLoading = false,
    this.hasLeading = true,
    this.hideAppbar = false,
    this.noStatusBar = false,
    this.statusBarPadding = false,
    this.onBack,
    this.noLeadingBack = false,
    this.appColor,
    this.titleColor,
    this.height,
  });

  Widget get _pageToDisplay {
    return Container(
      height: hideAppbar && this.height != null
          ? this.height
          : UserInfo.instance.screenFullHeight,
      decoration: BoxDecoration(
          color: this.backGroundColor == null
              ? UIData.windowBg
              : this.backGroundColor),
      child: Stack(
        children: <Widget>[
          Container(
              width: UserInfo.instance.deviceSize.width,
              child: SafeArea(
                child: bodyData,
              )),
          Center(
            child: isLoading ? _loadingView : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget get _loadingView {
    return MyLoadingIndicator();
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

  Widget bottomNavBar() {
    if (showBottomNav && bottomNav != null) return bottomNav;
    if (showBottomNav) return myBottomBar();
    return null;
  }

  Widget leadingWidget(BuildContext context) {
    return this.noLeadingBack
        ? SizedBox()
        : IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: UIData.white,
            ),
            onPressed: this.onBack != null
                ? this.onBack
                : () {
                    Navigator.of(context).pop();
                  });
  }

  static AppBar bar(String title,
      {Color barColor, Color titleColor = UIData.icBackColor}) {
    return AppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: barColor,
        title: Text(
          title,
          style: TextStyle(fontSize: UIData.fsp(20.0), color: titleColor),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _appColor =
        this.appColor == null ? ThemeUtils.currentColorTheme : this.appColor;

    bool isLightTheme = UIData.isLightColor(_appColor);
    _titleColor = isLightTheme ? UIData.black : Colors.white;

    return hideAppbar && this.height != null
        ? this._pageToDisplay
        : Scaffold(
            key: scaffoldKey != null ? scaffoldKey : null,
            backgroundColor: backGroundColor != null ? backGroundColor : null,
            appBar: this.hideAppbar
                ? PreferredSize(
                    preferredSize: Size.fromHeight(this.noStatusBar
                        ? 0.0
                        : UserInfo.instance.statusHeight),
                    child: Container(
                      color: _appColor,
                    ),
                  )
                : appBar != null
                    ? appBar
                    : PreferredSize(
                        preferredSize: Size.fromHeight(this.statusBarPadding
                            ? UserInfo.instance.statusHeight + UIData.bSp(44.0)
                            : UIData.bSp(44.0)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              0.0,
                              this.statusBarPadding
                                  ? UserInfo.instance.statusHeight
                                  : 0.0,
                              0.0,
                              0.0),
                          // decoration: BoxDecoration(color: _appColor),
                          child: AppBar(
                              centerTitle: centerTitle,
                              elevation: elevation,
                              backgroundColor: _appColor,
                              brightness: isLightTheme
                                  ? Brightness.light
                                  : Brightness.dark,
                              title: Text(
                                appTitle,
                                style: TextStyle(
                                    fontSize: UIData.bSp(20.0),
                                    color: _titleColor),
                              ),
                              actions: actionButtons != null
                                  ? actionButtons
                                  : <Widget>[],
                              leading: !hasLeading
                                  ? null
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: UIData.fromLTRB(
                                            20.0, 0.0, 0.0, 0.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: _titleColor,
                                            size: UIData.bSp(24.0),
                                          ),
                                        ),
                                      ),
                                    )),
                        ),
                      ),
            drawer: this.drawer != null
                ? this.drawer
                : showDrawer
                    ? CommonDrawer()
                    : null,
            endDrawer: this.endDrawer != null ? this.endDrawer : null,
            body: _pageToDisplay,
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
