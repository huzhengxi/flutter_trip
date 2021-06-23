import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com', 'm.ctrip.com/html5/', 'm.ctrip.com.html5', 'https://m.ctrip.com/', 'https://m.ctrip.com/webapp/hotel/forcelogin/'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  const WebView(
      {key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final FlutterWebviewPlugin webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onWebViewStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    webviewReference.close(); //防止页面重新打开
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {});
    _onWebViewStateChanged =
        webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          // TODO: Handle this case.
          break;
        case WebViewState.startLoad:
          print('url: ${state.url}');
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              webviewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
        default:
          break;
      }
    });

    _onHttpError = webviewReference.onHttpError.listen((error) {
      print(error.toString());
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onWebViewStateChanged.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: [
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
              child: WebviewScaffold(
            url: widget.url,
          ))
        ],
      ),
    );
  }

  _appBar(Color backgroudColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroudColor,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
        height: 30,
      );
    }
    return Container(
      color: backgroudColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      height: 30,
      child: FractionallySizedBox(
        widthFactor: 1,
        //让元素横向或者纵向填满
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    widget.title ?? '',
                    style: TextStyle(fontSize: 20, color: backButtonColor),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  bool _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }
}
