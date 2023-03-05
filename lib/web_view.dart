import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(Get.arguments)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("WebView"),
            leading: IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: () async {
                bool canNavigate = await controller.canGoBack();
                if (canNavigate) {
                  controller.goBack();
                } else {
                  print(Get.previousRoute);
                }
              },
            ),
          ),
          body: WebViewWidget(controller: controller),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final cookies = await controller.runJavaScriptReturningResult(
                'document.cookie',
              );
              final currentUrl = await controller.currentUrl();

              if (kDebugMode) {
                print("КУКИ " + cookies.toString());
              }
              if (kDebugMode) {
                print("Текущий линк " + currentUrl.toString());
              }

              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * .4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "КУКИ " + cookies.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Текущий линк " + currentUrl.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                      ),
                    );
                  });
            },
            child: const Icon(Icons.web_outlined),
          ),
        ),
      ),
    );
  }
}
