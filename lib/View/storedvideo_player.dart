
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:innlite_mobile/Common/api_url.dart';
import 'package:video_player/video_player.dart';

class FlickPlayer extends StatefulWidget {
  FlickPlayer({Key key}) : super(key: key);

  @override
  _FlickPlayer createState() => _FlickPlayer();
}

class _FlickPlayer extends State<FlickPlayer> {
  FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(Glob().pickkedvideo),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold( appBar: AppBar(
     title: Text("Video"),
   ),
       body:
       Container(
      padding: EdgeInsets.all(20.0),
      child: FlickVideoPlayer(
          flickManager: flickManager
      ),
    ));
  }
}

