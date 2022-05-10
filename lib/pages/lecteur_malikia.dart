import 'dart:async';
import 'dart:convert';



import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:labeltv/network/model/alauneByGroup.dart';
import 'package:labeltv/network/model/api_list_by_groupe.dart';
import 'package:labeltv/network/model/api_malikia.dart';
import 'package:labeltv/network/model/api_video_url.dart';
import 'package:labeltv/network/model/direct_api.dart';
import 'package:labeltv/network/model/list_android.dart';
import 'package:labeltv/network/model/live_api.dart';
import 'package:labeltv/pages/replayPage.dart';
import 'package:labeltv/pages/replay_page.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../constant.dart';
import 'chaine_page.dart';
import 'drawers.dart';
import 'emisions_page.dart';
import 'lecteur_emisions.dart';
import 'lecteur_malikia.dart';

final String menu = 'assets/images/menu.svg';
final String lecteur = 'assets/images/lecteur.svg';
Color gren = const Color(0xFF00722f);
Color wite = const Color(0xFFf8fbf8);
Color bg = const Color(0xFFEBEBEB);

class LecteurMalikiaPage extends StatefulWidget {
  var logger = Logger();
  ApiLabel apiLabel;
  Direct direct;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;

  LecteurMalikiaPage({Key key, this.logger, this.apiLabel, this.direct,this.lien,this.test,this.listChannelsbygroup})
      : super(key: key);

  @override
  _LecteurMalikiaPageState createState() => _LecteurMalikiaPageState();
}

class _LecteurMalikiaPageState extends State<LecteurMalikiaPage> {
  ListAndroid listAndroid;
  var betterPlayerConfiguration = BetterPlayerConfiguration(

    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    //autoDispose: true,
    controlsConfiguration: BetterPlayerControlsConfiguration(
      iconsColor: colorSecondary,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: colorSecondary,
      enableSkips: false,
      overflowMenuIconsColor: gren,
    ),
  );
  BetterPlayerController _betterPlayerController;
  VideoPlayerController playerController;
  ChewieController _chewieController;
  bool isVideoLoading = true;
  LiveApi liveApi;
  ListChannelsbygroup listChannelsbygroup;
  List<AlauneByGroup> sliderList = [];
  var logger = Logger();
  String url, time,test,lien,logo,videoId, title, titre;
  GlobalKey _betterPlayerKey = GlobalKey();
  String api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  StreamController<bool> _playController = StreamController.broadcast();
  Direct direct;
  AlauneByGroup alauneByGroup;
  Future<AlauneByGroup> fetchAlaune() async {
    var postListUrl =
    Uri.parse("https://tveapi.acan.group/myapiv2/alauneByGroup/walfvod/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);


      //logger.w(listChannelsbygroup);
      return AlauneByGroup.fromJson(jsonDecode(response.body));


      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<LiveApi> fetchListAndroid() async {
    try {
      var postListUrl = Uri.parse(widget.direct.allitems[0].feedUrl);
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data);
        setState(() {
          liveApi = LiveApi.fromJson(jsonDecode(response.body));
          //print(leral);
        });

        BetterPlayerDataSource dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            liveApi.directUrl,
            liveStream: true,

            notificationConfiguration: BetterPlayerNotificationConfiguration(
              showNotification: true,

              //notificationChannelName: "7TV Direct",
              //activityName: "7TV Direct",
              title: "Vous suivez LABEL TV en direct",

              imageUrl:
              "https://adweknow.com/wp-content/uploads/2018/02/labeltv.jpg",
            )
        );

        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);


        /*playerController = VideoPlayerController.network(liveApi.directUrl);
        await playerController.initialize().then((value) {
          setState(() {
            isVideoLoading = false;
          });
        });
        _chewieController = ChewieController(
          videoPlayerController: playerController,
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: true,
          isLive: true,
          allowedScreenSleep: false,
          autoInitialize: true,
          errorBuilder: (context, String message) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message = "Erreur de connexion",
                  style: TextStyle(color: Color(0xFF00722f), fontSize: 18),
                ),
              ),
            );
          },
          //fullScreenByDefault: true
        );

        _chewieController.addListener(() {
          if (!_chewieController.isFullScreen) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitDown]);
          }
        });
        playerController.setLooping(true);*/
      }
    } catch (error, stacktrace) {
      liveApi =LiveApi.withError("Data not found / Connection issue");

    }
  }

  Future<ApiLabel> fetchList() async {
    try {
      var postListUrl =
      Uri.parse("https://acanvod.acan.group/myapiv2/appdetails/walfvod");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data,"test");

        ApiLabel.fromJson(jsonDecode(response.body));
        //print(leral);

      }
    } catch (error, stacktrace) {
      return ApiLabel.withError("Data not found / Connection issue");
    }


  }


  Future<ListChannelsbygroup> fetchReplay() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/listChannelsByChaine/walfvod/33/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl = Uri.parse(
        "https://acanvod.acan.group/myapiv2/listChannelsbygroup/walfvod/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      logger.w(data);

      //logger.w(listChannelsbygroup);
      return AlauneByGroup.fromJson(jsonDecode(response.body));

      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  Future<void> testUrl() async {
    String url =
        "https://live1.acangroup.org:1929/publiclive/rts1.stream/playlist.m3u8?wmsAuthSign=c2VydmVyX3RpbWU9MTEvMTUvMjAyMSAxMjo0Mjo0NSBQTSZoYXNoX3ZhbHVlPXd5VHlDVkhZWUtQTFYwR2poQ1A2Znc9PSZ2YWxpZG1pbnV0ZXM9MTA=";
    final response = await http.get(url);
    print(response.body);

    VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        liveApi.directUrl,
        liveStream: true,

        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,

          //notificationChannelName: "7TV Direct",
          //activityName: "7TV Direct",
            title: "Vous suivez LABEL TV en direct",

            imageUrl:
            "https://adweknow.com/wp-content/uploads/2018/02/labeltv.jpg",
        )
    );

    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);


  }

  @override
  void initState() {
    betterPlayerConfiguration;

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _playController.add(false);
      }
    });
    fetchListAndroid();
    //fetchList();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }
  Widget _buildPlaceholder() {
    return StreamBuilder<bool>(
      stream: _playController.stream,
      builder: (context, snapshot) {
        bool showPlaceholder = snapshot.data ?? true;
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: showPlaceholder ? 1.0 : 0.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Text(
              "Impossible de lire la vidéo\n",
              style: TextStyle(color: colorSecondary, fontSize: 18),
            ),
          ),
        );
      },
    );
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          playerController.play();
          break;
        case AppLifecycleState.inactive:
        // widget is inactive
          break;
        case AppLifecycleState.paused:
        // widget is paused

          break;
        case AppLifecycleState.detached:
        // widget is detached
          break;
      }
    });
  }
  @override
  void dispose() {

    if (_betterPlayerController !=null) {
      _betterPlayerController.dispose();
      _betterPlayerController=null;
    }
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: whiteColor,),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Container(
                width: 160,
                height: 65,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Groupe.png"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              ),
              SizedBox(width: 20,),
              Flexible(
                  child: Container(
                    width: 160,
                    height: 65,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/Groupe.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  )
              ),
            ],
          ),
        ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //height: double.infinity,
          color: colorSecondary,
          child: Column(
            children: <Widget>[

              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black,
                child: AspectRatio(
                  aspectRatio: 16 / 9,

                  child: BetterPlayer(controller: _betterPlayerController),
                  key: _betterPlayerKey,
                ),
                //child: playerVideo(),
              ),
              Container(
                width: double.infinity,
                height: 40,
                color: whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.tv,
                        color: colorSecondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        "Vous suivez LABEL TV en direct",
                        style: TextStyle(
                          color: colorSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "helvetica",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Wrap(
                        spacing: 2,
                        children: [
                          dernierVideo(),
                          carousel(),
                          dernierEmision(),
                          makeItemEmissions()
                        ],
                      ),
                    ),
                  ))

            ],
          ),
        ),
      ),
      drawer: DrawerPage(
        betterPlayerController: _betterPlayerController,
      ),
    );
  }

  Widget dernierVideo() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.symmetric(horizontal: 10.2),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Dernières Vidéos",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "helvetica",
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.playlist_add,
                      color: whiteColor,
                      size: 30,
                    ),

                    onPressed: () {
                      if (_betterPlayerController != null)_betterPlayerController.pause();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return PlusPage();
                        }),
                      );
                    }
                ),

              )

            ],
          ),
        ],
      ),
    );
  }
  Widget item() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        //margin: const EdgeInsets.symmetric(horizontal: 10.2),

        height: 200.0,
        child: Container(
          child: FutureBuilder(
              future: fetchAlauneByGroupe(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ),
                  );
                } else
                  return Container(
                    child: ListView.builder(
                        itemCount: snapshot.data.allitems.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Container(
                            margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        offset: Offset(0, 0),
                                        color: Colors.grey.withOpacity(0.2)),
                                  ]),
                              child: Container(
                                //padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        width: 140,
                                        //padding: EdgeInsets.all(7),
                                        child: GestureDetector(
                                          child: FadeAnimation(
                                              0.5,
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(0),
                                                child: Container(
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data.allitems[i].logo,
                                                    width: 200,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        Image.asset(
                                                          "assets/images/malikiaError.png",
                                                          width: 200,
                                                          height: 100,
                                                          fit: BoxFit.contain,
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Image.asset(
                                                          "assets/images/malikiaError.png",
                                                          width: 200,
                                                          height: 100,
                                                          fit: BoxFit.contain,
                                                        ),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 100,
                                                ),
                                              )),

                                        ),
                                      ),),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      flex: 1,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: TextStyle(color: whiteColor),
                                            text:
                                            "${snapshot.data.allitems[i].title}"),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(

                                        child: Icon(Icons.play_arrow,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(), primary: whiteColor),
                                      ),
                                      alignment: Alignment.bottomRight,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
              }),
        ));
  }

  Widget carousel() {
    return FutureBuilder(
        future: fetchAlaune(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            );
          } else
            return CarouselSlider(
              options: CarouselOptions(
                // height: 240.0,
                //aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,

                scrollDirection: Axis.horizontal,
              ),

              items: [1,2,3,4,5,6,7].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              shadowColor: Colors.black26,

                              child: Column(
                                children:<Widget> [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                              color: Colors.grey.withOpacity(0.2)),
                                        ]
                                    ),
                                    height: 140,
                                    width: double.infinity,
                                    child: Container(
                                      child: GestureDetector(
                                        child: FadeAnimation(
                                          0.5,
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(0),
                                            child: Container(
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot
                                                    .data.allitems[i].logo,
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,

                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                      "assets/images/labeltv.jpg",
                                                      width: 200,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                    Image.asset(
                                                      "assets/images/labeltv.jpg",
                                                      width: 200,
                                                      height: 100,
                                                      fit: BoxFit.cover,

                                                    ),
                                              ),

                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          if (_betterPlayerController != null)_betterPlayerController.pause();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return PlusPage();
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          strutStyle: StrutStyle(fontSize: 14.0),
                                          text: TextSpan(
                                              style: TextStyle(color: colorSecondary,fontWeight: FontWeight.bold,
                                                fontFamily: "helvetica",),
                                              text:
                                              "${snapshot.data.allitems[i].title}\n"),
                                        ),
                                      ),
                                      SizedBox(height: 33,),

                                    ],
                                  ),
                                ],
                              ),


                            ),
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(110, 30, 0, 0),
                                width: 60,
                                height: 60,

                                child: IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 70,

                                  ),
                                  onPressed: (){
                                    if (_betterPlayerController != null)_betterPlayerController.pause();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return PlusPage();
                                      }),
                                    );
                                  },
                                ),
                              ),
                            )

                          ],
                        ),

                      ],
                    );
                  },
                );
              }).toList(),
            );
        });
  }
  Widget dernierEmision() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.symmetric(horizontal: 10.2),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Emissions",
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
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.playlist_add,
                      color: colorSecondary,
                      size: 30,
                    ),
                    iconSize: 14,
                    onPressed: () {
                      if (_betterPlayerController != null)_betterPlayerController.pause();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ReplyerPage();
                        }),
                      );
                    }
                ),

              )

            ],
          ),
        ],
      ),
    );
  }
  Widget makeItemEmissions() {
    return Container(
      //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
      //margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 250,
      width: double.infinity,
      child: FutureBuilder(
        future: fetchReplay(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            );
          } else
            return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, position) {

                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,),
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
                                  Flexible(
                                    child: FadeAnimation(
                                        0.6,
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            snapshot.data.allitems[position].title,
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
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.playlist_play,
                                            size: 40,
                                            color: colorPrimary,
                                          ),

                                        ),
                                      ),
                                      onTap: () {
                                        if (_betterPlayerController != null)_betterPlayerController.pause();
                                        //logger.d(snapshot.data.allitems[index].video_url);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EmisionsPage(
                                                  lien: snapshot.data.allitems[position].feedUrl,
                                                  listChannelsbygroup: snapshot.data
                                              )
                                          ),
                                        );
                                        var  logger = Logger();
                                        //logger.d(snapshot.data.allitems[i].relatedItems);
                                      }
                                  ),
                                  ClipRRect(
                                    //borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data.allitems[position].logo,
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 110,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/images/labeltv.jpg",
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                "assets/images/labeltv.jpg",
                                              ),
                                        ),
                                        onTap: () {
                                          if (_betterPlayerController != null)_betterPlayerController.pause();
                                          //logger.d(snapshot.data.allitems[index].video_url);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => EmisionsPage(
                                                    lien: snapshot.data.allitems[position].feedUrl,
                                                    listChannelsbygroup: snapshot.data
                                                )
                                            ),
                                          );
                                          var  logger = Logger();
                                          //logger.d(snapshot.data.allitems[i].relatedItems);
                                        }
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.allitems.length,
            );
        },
      ),
    );



  }


}
