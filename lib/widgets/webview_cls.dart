import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class Webview_class extends StatefulWidget {
  const Webview_class({super.key});

  @override
  State<Webview_class> createState() => _Webview_classState();
}

class _Webview_classState extends State<Webview_class> {
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: WebView(
            onWebResourceError: (WebResourceError webviews) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Check internet connection")));
            },
            javascriptMode: JavascriptMode.unrestricted,
            // onWebViewCreated: (controller) {
            //   setState(() {
            //     this.controller = controller;

            //   });
            // },

            initialUrl: 'https://github.com/Rayhan-pro-dev',
            onPageFinished: (finish) {
              setState(() {
                isloading = false;
              });
            },
          ),
        ),
        Visibility(
            visible: isloading,
            child: const Center(
              child: CircularProgressIndicator(),
            ))
      ],
    );
  }
}
