import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant.dart';
import 'home_page.dart';





/// Homepage
class YtoubePlayerPage extends StatefulWidget {
  final String apiKey, channelId,videoId,texte,lien,url, title, img, date, related;
  final List<YT_API> ytResult ;
  YtoubePlayerPage({Key key, this.apiKey, this.channelId, this.videoId,this.ytResult,this.texte,this.lien, this.url, this.title, this.img, this.date, this.related, List videos}) : super(key: key);
  @override
  _YtoubePlayerPageState createState() => _YtoubePlayerPageState();
}

class _YtoubePlayerPageState extends State<YtoubePlayerPage> {
  YoutubePlayerController _controller=YoutubePlayerController(initialVideoId: "");
   TextEditingController _idController;
   TextEditingController _seekToController;
  String API_Key = 'AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';
  final logger=Logger();

   PlayerState _playerState;
   //YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  void initState() {
    super.initState();
    logger.i(widget.videoId.split("=")[1],'id video');
    /*_controller = YoutubePlayerController(
      initialVideoId: widget.videoId.replaceAll("https://www.youtube.com/watch?v=", ""),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);*/
    _controller = YoutubePlayerController(
        initialVideoId: widget.videoId.split("=")[1].toString(),
        //YoutubePlayer.convertUrlToId(widget.vodalauneitem.videoUrl.replaceAll(" ", "")),
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ));
  }


  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          onEnterFullScreen: (){
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
          },
          player: YoutubePlayer(
            controller: _controller,
            width: double.infinity,
          ),
          builder: (context, player) {
            return
              Scaffold(
        appBar: AppBar(
            title: Text('Dernières Vidéos',style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),),
            flexibleSpace: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: colorPrimary
              ),
            ),
            centerTitle: true,
            backgroundColor: whiteColor,
            iconTheme: IconThemeData(color: whiteColor,)
        ),
        body: Container(
          color: colorbg,
          width: double.infinity,
          child: Column(
              children: [
                player,
                description(),
                SizedBox(height: 10,),
                emissions(),
                Expanded(
                    child: GridView.count(
                  crossAxisCount: 2 ,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                  children: List.generate(widget.ytResult.length,(index){
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                                child:  Container(
                                  width: 150,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage('${widget.ytResult[index].thumbnail["medium"]["url"]}'),
                                        fit: BoxFit.cover
                                    ),

                                  ),
                                ),

                                onTap: () {

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              YtoubePlayerPage(
                                                  videoId: widget.ytResult[index].url,
                                                  title: widget.ytResult[index].title,
                                                  ytResult: widget.ytResult)));


                                }
                            ),
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(38, 10, 50, 0),
                                width: 60,
                                height: 60,

                                child: IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 70,

                                  ),
                                  onPressed: (){
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                YtoubePlayerPage(
                                                    videoId: widget.ytResult[index].url,
                                                    title: widget.ytResult[index].title,
                                                    ytResult: widget.ytResult)));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 10,),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text("${widget.ytResult[index].title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: whiteColor
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ))
              ],
          ),
        ),
    );
          });
  }
  Widget emissions() {
    return Container(

      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.2),
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Vidéos Similaires",
                      style: TextStyle(
                        color: colorSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "helvetica",
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
  Widget description(){
    return Container(
      //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      height: 50,
      color: whiteColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              textAlign: TextAlign.center,
                strutStyle: StrutStyle(fontSize: 14),
                text: TextSpan(
                  style: TextStyle(color: colorSecondary),
                  text:
                  "${widget.title}",),
              ),
            ),
          ),




        ],
      ),
    );
  }
  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}