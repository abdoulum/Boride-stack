import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String url;

  WebPage(this.url, {Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions", style:
        TextStyle(fontFamily: "Brand-Regular", fontSize: 18),),
        backgroundColor: Colors.black,
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
