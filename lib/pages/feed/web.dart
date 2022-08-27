import 'package:flutter/material.dart';
import 'package:palhetas/widgets/main_widgets.dart';
import 'package:web_browser/web_browser.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return MainWidgets.defaultScaffold(
      pageTitle: "Palhetas na Foz",
      centerTitle: true,
      allowBack: true,
      body: WebBrowser(
        initialUrl: widget.url,
        javascriptEnabled: true,
        userAgent: "PalhetasNaFozMobile",
        interactionSettings: const WebBrowserInteractionSettings(
          topBar: null,
          bottomBar: null,
        ),
      ),
    );
  }
}
