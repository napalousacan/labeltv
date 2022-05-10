import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant.dart';
import 'home_page.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String apiKey, channelId,videoId,texte,title;
  final List<YT_API> ytResult ;


  YoutubePlayerPage({Key key, this.apiKey, this.channelId, this.videoId,this.ytResult,this.texte, this.title}) : super(key: key);

  @override
  _YoutubePlayerPageState createState() => new _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage>
    with AutomaticKeepAliveClientMixin<YoutubePlayerPage> {
  @override
  bool get wantKeepAlive => true;
  //List<YT_API> ytResult = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  String API_Key = 'AIzaSyCE9X5ceITj4zsVL0J4vLu-JiR6rSRMBFE';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  //String query = "JoyNews";



  @override
  void initState() {
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId.replaceAll("https://www.youtube.com/watch?v=", ""),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        forceHD: true,

      ),
    )..addListener(() {
      if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
        //
      }
    });
    super.initState();

    print(widget.videoId);
    //print('hello');
  }
  @override
  void deactivate() {
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
    /*super.build(context);*/
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: colorPrimary
              ),
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
                child: YoutubePlayer(

                  controller: _controller,
                  aspectRatio: 16 / 9,

                ),
              ),
              description(),
              SizedBox(height: 10,),
              emissions(),
              SizedBox(height: 20,),
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
                                        YoutubePlayerPage(
                                            videoId: widget.ytResult[index].url,
                                            texte: widget.texte,
                                            ytResult: widget.ytResult)));


                          }
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
              )
              )
            ],
          ),
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
                  "${widget.texte}"),
            ),
          )



        ],
      ),
    );
  }

}
