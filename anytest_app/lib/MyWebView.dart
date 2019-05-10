import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  @override
  void dispose() {
    // TODO: implement dispose
    _onDestroy.cancel();

    if (flutterWebViewPlugin != null) {
      flutterWebViewPlugin.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterWebViewPlugin.close();

    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WebviewScaffold(
      url: "https://www.google.com",
//      clearCache: true,
//      clearCookies: true,
//      withZoom: true,
      appBar: new AppBar(
        title: new Text("WebView Test"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.white,
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              color: Colors.white,
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}
