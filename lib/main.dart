import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Video',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          SizedBox(
            height: 200,
          ),
          TextField(
            autofocus: false,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPage()),
              );
            },
            child: Text('Click'),
          ),
        ])),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoId = "OXGznpKZ_sA"; // Extract the video ID from the URL

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
        hideThumbnail: true,
        hideControls: false,
        enableCaption: false,
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
