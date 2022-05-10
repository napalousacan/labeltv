import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:labeltv/pages/lecteur_malikia.dart';
import 'package:labeltv/pages/youtubePlayer.dart';
import 'package:labeltv/pages/ytoubeplayer.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/youtube_api.dart';
import '../constant.dart';
import 'AllPlayListScreen.dart';

import 'PlayListVideoScreen.dart';
import 'YoutubeVideoChannelScreen.dart';
import 'home_page.dart';

class YoutubeChannelScreens extends StatefulWidget {
  final String apiKey,channelId;

  YoutubeChannelScreens({Key key, this.apiKey, this.channelId}) : super(key: key);

  @override
  _YoutubeChannelState createState() => new _YoutubeChannelState();
}

class _YoutubeChannelState extends State<YoutubeChannelScreens> with AutomaticKeepAliveClientMixin<YoutubeChannelScreens> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  String title;
  final logger=Logger();
  //String query = "JoyNews";
  String API_Key = 'AIzaSyA6qu7Yw62GjwAsCyviSKnUsWZ3od9-6uk';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';

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
    super.build(context);
    return new Scaffold(
      backgroundColor: whiteColor,
      appBar: appBar(

      ),
      body: new Container(
        color: colorbg,
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: callAPI,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Nouveautés",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "CeraPro",
                                fontWeight: FontWeight.bold,
                                color: bg),
                          ),
                        ),
                        traitWidget(),
                        Container(
                            child: makeItemVideos()
                        ),
                        ytResultPlaylist.length>0?
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Stack(
                              children: [

                              ],
                            )
                        ):new Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    "Voir Plus...",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      color: bg
                                    ),
                                  )
                              ),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            YoutubeVideoChannelScreen(

                                              ytResult: ytResult,

                                              apikey: API_Key,)
                                    ),
                                        (Route<dynamic> route) => true);
                              },
                            )
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Nos Playlists",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "CeraPro",
                                fontWeight: FontWeight.bold,
                                color: bg),
                          ),
                        ),
                        traitWidget(),
                        Container(
                          child: isLoadingPlaylist
                              ? Center(
                            child: makeShimmerEmissions(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemEmissions(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    "Voir Plus...",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      color: bg
                                    ),
                                  )
                              ),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllPlayListScreen(ytResult: ytResultPlaylist,apikey:API_Key)),
                                        (Route<dynamic> route) => true);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    delegate: SliverChildListDelegate(
                      [
                        Container(

                          child: isLoadingPlaylist
                              ? Center(
                            child: makeShimmerEmissions(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemEmissions(),
                        ),
                      ]
                    ),
                  )*/
                ],
              ))),
    );
  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return FadeAnimation(
          0.5,
          GestureDetector(
            onTap: () {
              //logger.i('id youtube','123456');
              Navigator.of(context).push(MaterialPageRoute( builder: (context) => YtoubePlayerPage(
                videoId: ytResult[position].url,
                title: ytResult[position].title,

                ytResult: ytResult,
              )));
              /*Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => YtoubePlayerPage(
                        videoId: ytResult[position].url,
                        title: ytResult[position].title,

                        ytResult: ytResult,
                      )),
                      (Route<dynamic> route) => true);*/
            },
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: FadeAnimation(
                      0.5,
                      Column(
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
                                  "assets/images/labeltv.jpg",
                                  fit: BoxFit.contain,
                                  height: 120,
                                  width: 120,
                                  //color: colorPrimary,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/labeltv.jpg",
                                  fit: BoxFit.contain,
                                  height: 120,
                                  width: 120,
                                  //color: colorPrimary,
                                ),
                              ),

                            ],
                          ),
                          Container(
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
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: bg),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
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

                    ),
                  ),
                )

              ],
            ),
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
  }

  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {

        return FadeAnimation(
            0.5,
            Hero(
              tag: new Text(ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", "")),
              child: GestureDetector(
                onTap: () {

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PlayListVideoScreen(
                          title: ytResultPlaylist[position].id,apiKey: widget.apiKey,)),
                        (Route<dynamic> route) => true,);
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FadeAnimation(
                              0.5,
                              Container(
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
                                              "assets/images/malikiaError.png",
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              "assets/images/malikiaError.png",
                                            ),
                                      ),
                                    ),
                                    Flexible(
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
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => YoutubePlayerPage(
                                                title: ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", ""),apiKey: widget.apiKey,)),
                                              (Route<dynamic> route) => true,);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.playlist_play,
                                            size: 40,
                                            color: colorPrimary,
                                          ),
                                          onPressed: (){
                                            Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => PlayListVideoScreen(
                                                    title: ytResultPlaylist[position].id,apiKey: widget.apiKey,)),
                                                  (Route<dynamic> route) => true,);
                                          },
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
      itemCount: 5,
    );
  }

  Widget makeShimmerEmissions() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            Shimmer.fromColors(
                baseColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: 6);
  }
  Widget appBar() {
    return AppBar(
      title: Text('YouTube',style: TextStyle(
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
      iconTheme: IconThemeData(color: whiteColor,),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: whiteColor,
    );
  }
  traitWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: 3,
            width: 400,
            color: colorSecondary,
          ),
        ],
      ),
    );
  }
}
