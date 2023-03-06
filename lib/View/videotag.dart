import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';




class Videotag extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Videotag> {
  int _counter = 0;
  var html = "<video width='320' height='240' src='http://fsstomsbiinnoculate.aparinnosys.com:9999/113001_LR' autoplay='true' controls></video>";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Html(
              data: html,
            ),
          ],
        ),
      ),
    );
  }
}