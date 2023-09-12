import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Video',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoId = "PkZNo7MFNFg"; // Extract the video ID from the URL

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
        hideControls: false,
      ),
    )..addListener(_videoListener);
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final time = _prefs.getInt('video_time_${widget.videoId}') ?? 0;
    _controller.seekTo(Duration(seconds: time));
  }

  _videoListener() async {
    if (_controller.value.playerState == PlayerState.ended) {
      await _prefs.setInt(
        'video_time_${widget.videoId}',
        _controller.value.position.inSeconds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        child: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              // Your code here when the player is ready.
            },
            onEnded: (metaData) {
              // Video ended.
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
