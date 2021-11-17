import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String y = "Traitor";
  bool playing = false;
  IconData playBtn = Icons.play_arrow_rounded;

  AudioPlayer player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Slider(
        activeColor: Colors.green[400],
        inactiveColor: Colors.blueGrey,
        value: position.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) {
          seekTOsec(value.toInt());
        });
  }

  void seekTOsec(int sec) {
    Duration newPos = Duration(seconds: sec);
    player.seek(newPos);
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);

    player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };
    player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };

    cache.load("traitor.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(200, 255, 204, 255),
            Color.fromARGB(200, 255, 204, 255)
          ],
        )),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Track Player",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "listen to your favourite music",
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Expanded(
                      child: Container(
                        width: 300,
                        height: 400,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              image: AssetImage("assets/olivia.jpg"),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Center(
                    child: Text(
                      y,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 28),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "${position.inMinutes}: ${position.inSeconds.remainder(60)}"),
                              slider(),
                              Text(
                                  "${musicLength.inMinutes}: ${musicLength.inSeconds.remainder(60)}"),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 45,
                              color: Colors.purpleAccent[700],
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_previous_rounded,
                              ),
                            ),
                            IconButton(
                              iconSize: 45,
                              color: Colors.redAccent[700],
                              onPressed: () {
                                if (!playing) {
                                  cache.play("traitor.mp3");
                                  setState(() {
                                    playBtn = Icons.pause_circle_filled_rounded;
                                    playing = true;
                                  });
                                } else {
                                  player.pause();
                                  setState(() {
                                    playBtn = Icons.play_circle_fill;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(
                                playBtn,
                              ),
                            ),
                            IconButton(
                              iconSize: 45,
                              color: Colors.purpleAccent[700],
                              onPressed: () {
                                cache.play("deja.mp3");
                                setState(() {
                                  y = "deja vu";
                                });
                              },
                              icon: Icon(
                                Icons.skip_next_rounded,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ))
                ]),
          ),
        ),
      ),
    );
  }
}
