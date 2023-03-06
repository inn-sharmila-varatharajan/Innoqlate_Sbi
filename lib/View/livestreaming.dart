
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:webview_flutter_plus/webview_flutter_plus.dart';



class WebViewLoad extends StatefulWidget {

    WebViewLoadUI createState() => WebViewLoadUI();

}

class WebViewLoadUI extends State<WebViewLoad>{
  WebViewPlusController webViewController;
    String htmlFilePath = 'assets/index.html';

    loadLocalHTML() async{
       String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
      /*  webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());*/

        webViewController.loadUrl("assets/index.html");
    }
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
    @override
    Widget build(BuildContext context) {
        return
        Scaffold(appBar: AppBar(title:Text('Live Video'),centerTitle: true,),
      body:

          WebViewPlus(


           javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                this.webViewController = controller;
                loadLocalHTML();
              },

               /* onWebViewCreated: (WebViewController tmp) {
                   webViewController = tmp;


                }*/

     ));}
   }
