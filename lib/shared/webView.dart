import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }


  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: "https://link.tink.com/1.0/account-check/connect?client_id=07c8453b9e594a7589db40aea3295f71&redirect_uri=https%3A%2F%2Fconsole.tink.com%2Fcallback&market=IT&locale=it_IT",
    );
  }
}