import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:get/get.dart';

class WebViewPro extends StatefulWidget {
  const WebViewPro({Key? key}) : super(key: key);

  @override
  State<WebViewPro> createState() => _WebViewProState();
}

class _WebViewProState extends State<WebViewPro> {
  dynamic _controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("WebView"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            bool canNavigate = await _controller.canGoBack();
            if (canNavigate) {
              _controller.goBack();
            } else {
              print(Get.previousRoute);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              bool canNavigate = await _controller.canGoForward();
              if (canNavigate) {
                _controller.goForward();
              } else {
                print(Get.previousRoute);
              }
            },
          ),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: Get.arguments.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController _webViewController) {
            setState(() {
              _controller = _webViewController;
            });
            // webViewController.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },

          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith(Get.arguments.toString())) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          geolocationEnabled: false, //support geolocation or not
        );
      }),
    );
  }
}
