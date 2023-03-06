

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Location extends StatefulWidget {
  String latitude,longitude;
Location(this.latitude,this.longitude);


  _Location createState() => _Location();
}
class _Location extends State<Location> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: WebviewScaffold(
            url: "https://www.google.com/maps/?q="+widget.latitude.toString()+','+widget.longitude.toString(),
            appBar: new AppBar(
              title: new Text(''),
            ),
            withZoom: true,
            withLocalStorage: true,
          )
      ),
    );
  }
}