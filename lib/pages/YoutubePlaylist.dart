import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api_v3/src/playListItem.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant.dart';
import 'home_page.dart';

class YoutubePlayerPlaylistPage extends StatefulWidget {
  final String apiKey, channelId,videoId,texte,title, url,related,image,lien,veux;
  final List<YT_API> ytResult ;
  List<PlayListItem> videos;
  List<YT_APIPlaylist> ytResultPlaylist;




  YoutubePlayerPlaylistPage({Key key, this.apiKey, this.channelId,this.lien,this.veux, this.videoId,this.ytResult,this.image,this.ytResultPlaylist,this.texte, this.title,this.videos ,this.related,this.url}) : super(key: key);

  @override
  _YoutubePlayerPlaylistPageState createState() => new _YoutubePlayerPlaylistPageState();
}

class _YoutubePlayerPlaylistPageState extends State<YoutubePlayerPlaylistPage>
    with AutomaticKeepAliveClientMixin<YoutubePlayerPlaylistPage> {
  @override
  bool get wantKeepAlive => true;
  //List<YT_API> ytResult = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  String API_Key = 'AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  bool _isPlayerReady;
  List<PlayListItem> videos = new List();
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  //bool _isPlayerReady = false;

  //String query = "JoyNews";



  @override
  void initState() {
    var logger = Logger();
    //logger.w(widget.url);
    //_isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.url.replaceAll("https://www.youtube.com/watch?v=", ""),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();

    //print(widget.url);
    //print('hello');
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
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
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*super.build(context);*/
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) =>
            Scaffold(
            appBar: AppBar(
                flexibleSpace: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [colorPrimary,colorPrimary,colorSecondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      )),
                ),
                backgroundColor: whiteColor,
                iconTheme: IconThemeData(color: whiteColor,)
            ),
            body: Container(
              width: double.infinity,
              //height: double.infinity,
              color: colorbg,
              child: Column(
                children: [
                  Container(
                    height: 240,
                    width: double.infinity,
                    color: whiteColor,
                    child: player,
                  ),
                  description(),
                  SizedBox(height: 10,),
                  emissions(),
                  SizedBox(height: 20,),
                  Expanded(
                      child: GridView.count(
                        crossAxisCount: 2 ,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 4,
                        children: List.generate(widget.videos.length,(index){
                          return Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  child:  Container(
                                    width: 150,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage('${widget.videos[index].snippet.thumbnails.medium.url}'),
                                          fit: BoxFit.cover
                                      ),

                                    ),
                                  ),

                                  onTap: () {
                                    var logger = Logger();
                                    logger.w("test",widget.image);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                YoutubePlayerPlaylistPage(
                                                  lien: widget.videos[index].snippet.thumbnails.medium.url,
                                                  url: widget.videos[index].snippet.resourceId.videoId,
                                                  title: widget.videos[index].snippet.title,
                                                  videos: widget.videos,
                                                )));


                                  }
                              ),

                              SizedBox(height: 10,),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text("${widget.title}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: colorSecondary
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      )
                  )
                ],
              ),
            )
        )
    );

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
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
      width: double.infinity,
      height: 50,
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: StrutStyle(fontSize: 14),
              text: TextSpan(
                  style: TextStyle(color: colorSecondary),
                  text:
                  "${widget.title}"),
            ),
          )



        ],
      ),
    );
  }

}
