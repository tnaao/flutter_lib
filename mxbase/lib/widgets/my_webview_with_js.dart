import 'dart:async';
import 'dart:convert';
import 'package:mxbase/ext/divider.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mxbase/model/user_info.dart';
import 'package:mxbase/model/app_holder.dart';

class MyWebViewWithJS extends StatefulWidget {
  final num paddingH;
  final String? content;
  final String? url;
  final bool needEval;
  final double iniH;
  final void Function(double height)? upHeight;
  final void Function(WebViewController controller)? createCallback;
  final void Function(WebViewController? message)? loadedCallback;
  final void Function(String url)? onImageLongPress;
  final List<JavascriptChannel>? jsChannels;

  @override
  _MyWebViewWithJSState createState() {
    return _MyWebViewWithJSState();
  }

  const MyWebViewWithJS(
      {this.url,
      this.needEval = false,
      this.content = '',
      this.iniH = 0.0,
      this.jsChannels,
      this.createCallback,
      this.loadedCallback,
      this.onImageLongPress,
      this.upHeight,
      Key? key,
      this.paddingH = 0})
      : super(key: key);
}

class _MyWebViewWithJSState extends State<MyWebViewWithJS> {
  double _webviewH = MxBaseUserInfo.instance.deviceSize.height;
  bool _isURL = false;
  bool loading = true;
  WebViewController? _webController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  JavascriptChannel? divHeightChannel;

  void upWebHeight() async {
    if (_webController == null) return;

    setState(() {});

    var heightGetJs = 'var divH = document.body.offsetHeight;';
    heightGetJs +=
        'try{ divHeightChannel.postMessage(\'div-height:\' + divH); } catch(e){}';

    try {
      _webController!.evaluateJavascript(heightGetJs);
    } catch (e) {
      print('webEx:' + e.toString());
    }
  }

  Set<JavascriptChannel> jsChannels = Set();

  @override
  void initState() {
    super.initState();
    double h = MxBaseUserInfo.instance.deviceSize.height * 5.0;

    if (widget.iniH > 0.01) _webviewH = widget.iniH;
    _isURL = widget.url != null && widget.url!.trim().startsWith("http");

    var divHeightChannel = JavascriptChannel(
        name: "divHeightChannel",
        onMessageReceived: (channelMessage) {
          var message = channelMessage.message;
          if (message.startsWith('div-height')) {
            var tmpH = double.parse(message.split(':')[1]);
            if (tmpH > h) tmpH = h;
            if (widget.upHeight != null) {
              widget.upHeight!(tmpH);
            } else {
              setState(() {
                _webviewH = tmpH;
              });
            }
          }
        });
    jsChannels.add(divHeightChannel);
    if (widget.jsChannels != null) jsChannels.addAll(widget.jsChannels!);
  }

  @override
  void dispose() {
    super.dispose();
    this._webController = null;
  }

  @override
  Widget build(BuildContext context) {
    var content =
        '<body style="margin: 0 auto;width: 100%;">${widget.content}</body>';

    return Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.fromLTRB(
            widget.paddingH.hsp, 0.0, widget.paddingH.hsp, 0.0),
        // height: _webviewH,
        child: WebView(
          initialUrl: !this._isURL
              ? Uri.dataFromString(content,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString()
              : widget.url,
//          initialHost: this._isURL ? null : AppHolder.instance.HOST,
//          initialContent: this._isURL ? null : content,
          javascriptChannels: jsChannels,
          allowsInlineMediaPlayback: true,
          javascriptMode: JavascriptMode.unrestricted,
//          onImageLongPress: (url) {
//            if (widget.onImageLongPress != null) {
//              widget.onImageLongPress(url);
//            }
//          },
          onWebViewCreated: (controller) {
            _webController = controller;
            _controller.complete(controller);

            if (widget.createCallback != null) {
              widget.createCallback!(controller);
            }

            if (false && !this._isURL) {
              _webController!.loadUrl(Uri.dataFromString(content,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString());
            }
          },
          onPageFinished: (message) {
            debugPrint('console:${message}');

            if (widget.loadedCallback != null) {
              widget.loadedCallback!(this._webController);
            }

            if (widget.needEval && this._webController != null) {
              var evalJs = 'var divEl = document.body;';
              evalJs += 'try{divEl.innerHTML=\'${content}\'; } catch(e){}';
              this._webController!.evaluateJavascript(evalJs);
            }
            if (!this._isURL) {
              Future.delayed(Duration(milliseconds: 500)).then((v) {
                // this.upWebHeight();
              });
            }
          },
        ));
  }
}
