
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:labeltv/network/model/direct_api.dart';
import 'package:labeltv/pages/ytoubeplayer.dart';



import 'package:youtube_api/youtube_api.dart';

import '../constant.dart';
import 'YoutubePlayer.dart';
import 'home_page.dart';



class YoutubeChannelScreen extends StatefulWidget {
  final String apiKey,channelId;

  YoutubeChannelScreen({Key key, this.apiKey, this.channelId}) : super(key: key);

  @override
  _YoutubeChannelState createState() => new _YoutubeChannelState();
}

class _YoutubeChannelState extends State<YoutubeChannelScreen> with AutomaticKeepAliveClientMixin<YoutubeChannelScreen> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  String lien;
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';
  //String query = "JoyNews";
  Direct direct;
  Color bg = const Color(0xFFEBEBEB);

  Future<void> callAPI() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi.channel(API_CHANEL);
    setState(() {
      print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }

  Future<void> callAPIPlaylist() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist.playlist(API_CHANEL);
    setState(() {
      print('UI Updated');
      print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    /*super.build(context);*/
    return  Scaffold(

        appBar: AppBar(
            flexibleSpace: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                      color: colorPrimary,
                  ),
            ),
          backgroundColor: Color(0xFFf8fbf8),

          iconTheme: IconThemeData(color: Color(0xFF00722f)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,

          ),
          /*onPressed: (){
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => Malikiatv_HomePage(
              direct: direct,
            )
            ));
         },*/
        ),
        ),
      body: Container(
          color: colorbg,
        child: Column(
          children: [
            Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 5,
                  children: List.generate(ytResult.length,(index){
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
                                    image: NetworkImage('${ytResult[index].thumbnail["medium"]["url"]}'),
                                    fit: BoxFit.cover
                                ),

                            ),
                            /*child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "${model.allitems[index].logo}",width: 250,height: 160,),
              ),*/
                          ),

                          /*onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => YoutubeVideoPlayer(
                            url: ytResult[index].url,
                            title: ytResult[index].title,
                            img: ytResult[index].thumbnail['medium']['url'],
                            related: "",
                            ytResult: ytResult,
                          )
                          )
                          ),*/
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => YtoubePlayerPage(
                                        videoId: ytResult[index].url,
                                        title: ytResult[index].title,

                                        related: "",
                                        ytResult: ytResult,
                                      )),
                                      (Route<dynamic> route) => true);
                            }
                        ),

                        SizedBox(height: 10,),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(17, 0, 10, 0),
                            child: Text("${ytResult[index].title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF00722f)
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
        )
      )

    );
  }

  /*Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return Container(
            //0.5,
           child: GestureDetector(
                onTap: () {
                  *//*Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => YoutubeVideoPlayer(
                                video: ytResult[position],
                               *//**//* title: ytResult[position].title,
                                img: ytResult[position].thumbnail['medium']
                                    ['url'],
                                date: Jiffy(ytResult[position].publishedAt,
                                        "yyyy-MM-ddTHH:mm:ssZ")
                                    .yMMMMEEEEdjm,*//**//*
                                related: "",
                                ytResult: ytResult,
                              )),
                          (Route<dynamic> route) => true);*//*
                },
                child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      //0.5,
                     child: Column(
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                height: 110,
                                width: MediaQuery.of(context).size.width,
                                imageUrl:  ytResult[position].thumbnail['medium']
                                ['url'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                  height: 120,
                                  width: 120,
                                  //color: colorPrimary,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                  height: 120,
                                  width: 120,
                                  //color: colorPrimary,
                                ),
                              ),
                              Container(
                                height: 25,
                                width: 30,
                                color: Colors.cyan,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          *//*Container(
                            child: Flexible(
                              child: Container(
                                child: FadeAnimation(
                                    0.6,
                                    Container(
                                      alignment: Alignment.center,
                                      //height: 70,
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        ytResult[position].title,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    )),
                              ),
                            ),
                          ),*//*
                        ],
                      ),
                    )),
              ),
            );
      },
      itemCount: ytResult.length>8?8:ytResult.length,
    );
  }

  Widget makeShimmerVideos() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return Container(
            //0.5,
            *//*Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.white,*//*
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )
          );
        },
        itemCount: 6);
  }

  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
     *//* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*//*
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return Container(
            //0.5,
           child: Hero(
              tag: new Text(ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", "")),
              child: GestureDetector(
                onTap: () {

                  *//*Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PlayListVideoScreen(
                                  title: ytResultPlaylist[position].id,apiKey: widget.apiKey,)),
                        (Route<dynamic> route) => true,);*//*
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 10,
                          offset: Offset(0, 10.0),
                        ),
                      ],
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              //0.5,
                           child:   Container(
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                //alignment: Alignment.center,
                                child: new Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      //borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 110,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/logo.png",
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              "assets/images/logo.png",
                                            ),
                                      ),
                                    ),
                                    *//*Flexible(
                                      child: FadeAnimation(
                                          0.6,
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              ytResultPlaylist[position].title,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          )),
                                    ),*//*
                                    GestureDetector(
                                      onTap: () {
                                        *//*Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => PlayListVideoScreen(
                                                title: ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", ""),apiKey: widget.apiKey,)),
                                              (Route<dynamic> route) => true,);*//*
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.playlist_play,
                                          size: 40,
                                          color: Colors.cyan,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )),
              ),
            ));
      },
      itemCount: 6,
    );
  }

  *//*Widget makeShimmerEmissions() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.white,
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: 6);
  }*//*
  Widget appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 80,
              height: 50,
              margin: EdgeInsets.only(right: 50),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png')))),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          *//*gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.cyan],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),*//*
          color: Colors.blue
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
  traitWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: 5,
            width: 120,
            color: Colors.grey,
          ),
          Container(
            height: 2,
            color: Colors.grey,
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );*/
  }

