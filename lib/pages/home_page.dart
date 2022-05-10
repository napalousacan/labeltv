import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'package:better_player/better_player.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:labeltv/animation/fadeanimation.dart';
import 'package:labeltv/network/model/alauneByGroup.dart';
import 'package:labeltv/network/model/api_list_by_groupe.dart';
import 'package:labeltv/network/model/api_malikia.dart';
import 'package:labeltv/network/model/direct_api.dart';
import 'package:labeltv/network/model/list_android.dart';
import 'package:labeltv/network/model/live_api.dart';
import 'package:labeltv/pages/lecteur_malikia.dart';
import 'package:labeltv/pages/replayPage.dart';
import 'package:labeltv/pages/replay_page.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../constant.dart';
import 'drawers.dart';
import 'emisions_page.dart';
final String menu1 = 'assets/images/menu.svg';
class HomePage extends StatefulWidget {
  var logger = Logger();
  ApiLabel apiLabel;
  Direct direct;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;
  LiveApi liveApi;
  String url;

  HomePage({Key key,this.url, this.logger,this.liveApi, this.apiLabel, this.direct,this.lien,this.test,this.listChannelsbygroup})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<FormState> _formKey =
  new GlobalKey<FormState>(debugLabel: 'home');
  ListAndroid listAndroid;
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    autoDetectFullscreenDeviceOrientation:true,

    /*routePageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondAnimation, provider) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                                Icons.fullscreen,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },*/

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
      iconsColor: colorPrimary,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enablePip: true,
      enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: Colors.white,
      enableSkips: false,
      overflowMenuIconsColor:Colors.white
      //enableOverflowMenu: false,
    ),
  );
  var betterPlayerConfiguration1 = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    /*routePageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondAnimation, provider) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 16 / 9,

            ),
            //child: playerVideo(),
          );
        },
      );
    },*/

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
        iconsColor: colorPrimary,
        //controlBarColor: colorPrimary,
        liveTextColor: Colors.red,
        playIcon: Icons.play_arrow,
        enablePip: true,
        enableFullscreen: true,
        enableSubtitles: false,
        enablePlaybackSpeed: false,
        loadingColor: Colors.white,
        enableSkips: false,
        overflowMenuIconsColor:Colors.white
      //enableOverflowMenu: false,
    ),
  );
  BetterPlayerController _betterPlayerController;
  BetterPlayerController _betterPlayerController1;
  VideoPlayerController playerController;
  bool isVideoLoading = true;
  LiveApi liveApi ;
  ApiLabel apiLabel;
  ListChannelsbygroup listChannelsbygroup;
  var logger = Logger();
  String url, time,test,lien,logo,videoId, title, titre;
  GlobalKey _betterPlayerKey = GlobalKey();
  GlobalKey _betterPlayerKey1 = GlobalKey();
  String api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  StreamController<bool> _playController = StreamController.broadcast();
  Direct direct;
  bool loading = true;
  TabController _tabController;


  List<AlauneByGroup> sliderList = [];
  Future<LiveApi> fetchListAndroid() async {
    try {

      var postListUrl = Uri.parse("https://tveapi.acan.group/myapiv2/directplayback/46/json");
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
              //notificationChannelName: "LABEL TV",
              //activityName: "7TV Direct",
              title: "Vous suivez LABEL TV en direct",
              imageUrl:
              "https://adweknow.com/wp-content/uploads/2018/02/label.jpg",
            )
        );
        _betterPlayerController.setupDataSource(dataSource)
            .then((response) {

          isVideoLoading = false;
        })
            .catchError((error) async {
          // Source did not load, url might be invalid
          _getData();
          inspect(error);
        });
        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);

      }
    } catch (error, stacktrace) {
      return LiveApi.withError("Data not found / Connection issue");
    }
  }
  Future<LiveApi> fetchListAndroid1() async {
    try {
      var postListUrl = Uri.parse("https://tveapi.acan.group/myapiv2/directplayback/47/json");
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

              //notificationChannelName: "LABEL TV",
              //activityName: "7TV Direct",
              title: "Vous suivez LABEL TV en direct",

              imageUrl:
              "https://adweknow.com/wp-content/uploads/2018/02/label.jpg",
            )
        );
        _betterPlayerController1.setupDataSource(dataSource)
            .then((response) {

          isVideoLoading = false;
        })
            .catchError((error) async {
          // Source did not load, url might be invalid
          _getData1();
          inspect(error);
        });
        _betterPlayerController1.setupDataSource(dataSource);
        _betterPlayerController1.setupDataSource(dataSource);
        _betterPlayerController1.setBetterPlayerGlobalKey(_betterPlayerKey1);

      }
    } catch (error, stacktrace) {
      return LiveApi.withError("Data not found / Connection issue");
    }
  }
  Future<ApiLabel> fetchList() async {
    try {
      var postListUrl =
      Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/labeltv");
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
    Uri.parse("https://tveapi.acan.group/myapiv2/listChannelsByChaine/labeltv/46/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl = Uri.parse(
        "https://tveapi.acan.group/myapiv2/alauneByGroup/labeltv/json");
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
  loadData() {
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
                //notificationChannelName: "LABEL TV",

                imageUrl:
                "https://www.google.com/url?sa=i&url=https%3A%2F%2Fadweknow.com%2Flabel-tv-integre-bouquet-canal-1er-mars%2F&psig=AOvVaw3vFURGD87S-HQ5eSk2Fony&ust=1637600994056000&source=images&cd=vfe&ved=0CAgQjRxqFwoTCKDT_6X5qfQCFQAAAAAdAAAAABAY",
              )
          );

          _betterPlayerController.setupDataSource(dataSource);
          _betterPlayerController.setupDataSource(dataSource);
          _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);



        }
      } catch (error, stacktrace) {
        return LiveApi.withError("Data not found / Connection issue");
      }
    }
    setState(() {
      isVideoLoading = false;//setting state to false after data loaded
    });
  }
  Future<void> _getData() async {
    setState(() {
      fetchListAndroid();

    });
  }
  Future<void> _getData1() async {
    setState(() {
      fetchListAndroid1();
      //betterPlayerConfiguration1;
    });
  }
  @override
  void initState() {
    super.initState();
    betterPlayerConfiguration;
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _playController.add(false);
        // _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
      }
    });

    _getData();
    _getData1();
    //fetchListAndroid();
    //fetchListAndroid1();
    fetchList();
    //navigationPage();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  }
  @override
  void dispose() {
    if (_betterPlayerController !=null) {
      _betterPlayerController?.dispose();
      playerController?.dispose();
      _betterPlayerController=null;
    }
    if (_betterPlayerController1 !=null) {
      _betterPlayerController1?.dispose();
      playerController?.dispose();
      _betterPlayerController1=null;
    }

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  /*@override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }*/
  int _current = 0;
  final CarouselController _controller = CarouselController();
  int _index =1;
  var scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(

    key: scaffold,
      appBar: AppBar(

        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorPrimary
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: whiteColor,),
        centerTitle: true,
        title: Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  _getData();

                  setState(() {
                    if(_betterPlayerController1 !=null)_betterPlayerController1.pause();

                    _index = 1;
                  });
                },
                child: Container(
                  width: 139,
                  height: 111.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/icon4.png",

                          ),
                          fit: BoxFit.contain
                      )
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  logger.w(liveApi.directUrl);
                  _getData1();
                  _betterPlayerController;
                  _betterPlayerController1 = BetterPlayerController(betterPlayerConfiguration1);
                  _betterPlayerController1.addEventsListener((event) {
                    if (event.betterPlayerEventType == BetterPlayerEventType.play) {
                      _playController.add(false);
                      // _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
                    }
                  });
                  setState(() {
                    if(_betterPlayerController !=null)_betterPlayerController.pause();

                    _index = 2;
                    //Navigator.pop(context);
                  });
                },
                child: Container(
                  width: 139,
                  height: 111.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/icon3.png",

                          ),
                          fit: BoxFit.contain
                      )
                  ),
                ),
              )
            ],
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            menu1,
            width: 35,
            height: 38,
            color: whiteColor,
          ),
          onPressed: (){
            scaffold.currentState.openDrawer();
          },
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _getData,
        child:Container(
          width: double.infinity,
          //height: double.infinity,
          color: colorSecondary,
          child: Column(
            children: <Widget>[
              _index == 1 ? Home1(context) :  Home2(context),
              _index==  1 ? Homedescription1(context) : Homedescription2(context),



              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        dernierVideo(),
                        carousel(),
                        dernierEmision(),
                        makeItemEmissions()
                      ],
                    ),
                  ))

            ],
          ),
        ),
      ),
      drawer: DrawerPage(
        betterPlayerController: _betterPlayerController,
        betterPlayerController1: _betterPlayerController1,
        //direct: direct,
        //liveApi: liveApi,
      ),
    );
  }

  @override
  Widget Home1(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,


        child: BetterPlayer(
            controller: _betterPlayerController
        ),
        //key: _betterPlayerKey,
      ),
      //child: playerVideo(),
    );

  }
  @override
  Widget Home2(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController1,

        ),
        //key: _betterPlayerKey1,
      ),
      //child: playerVideo(),
    );
  }
  @override
  Widget Homedescription1(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: colorSecondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.tv,
            color: wite,
            size: 20,
          ),
          SizedBox(width: 5,),
          Text(
            "Vous suivez LABEL TV en direct",
            style: TextStyle(
              color: wite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "helvetica",
            ),
          )
        ],
      ),
    );
  }
  Widget Homedescription2(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: colorSecondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.tv,
              color: wite,
              size: 20,
            ),
          ),
          Container(
            child: Text(
              "Vous suivez SUNULABEL TV en direct",
              style: TextStyle(
                color: wite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "helvetica",
              ),
            ),
          ),

        ],
      ),
    );
  }
  Widget dernierVideo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.2),
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: <Widget>[
              Text(
                "Dernières Vidéos",
                style: TextStyle(
                  color: wite,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "helvetica",
                ),
              )
            ],
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.playlist_add,
              color: wite,
              size: 30,
            ),

            onPressed: () {
              if (_betterPlayerController != null)_betterPlayerController.pause();
              if (_betterPlayerController1 != null)_betterPlayerController1.pause();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return PlusPage();
                }),
              );
            }
        )

      ],
    );
  }
  Widget carousel() {
    return FutureBuilder(
        future: fetchAlauneByGroupe(),
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
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: colorPrimary,
                      shadowColor: Colors.black26,
                      child: Container(
                        width: double.infinity,
                        height: 310,
                        color: colorPrimary,
                        child: Stack(
                          children: [
                            Container(
                              height: 160,
                              child:  GestureDetector(
                                  child: FadeAnimation(
                                    0.5,
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(0),
                                      child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data.allitems[i].logo,
                                          width: 320,
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
                                  }
                              ),

                            ),
                            Positioned(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomCenter,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    strutStyle: StrutStyle(fontSize: 14.0),
                                    text: TextSpan(
                                        style: TextStyle(color: wite,fontWeight: FontWeight.bold,
                                          fontFamily: "helvetica",),
                                        text: "${snapshot.data.allitems[i].title}\n"),
                                  ),

                            )),
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
                      ),
                    );
                    /*Column(
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
                                    margin: EdgeInsets.all(0),
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
                                      //SizedBox(height: 33,),

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
                    )*/
                  },
                );
              }).toList(),
            );
        });
  }
  Widget dernierEmision() {
    return Row(
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
                  color: wite,
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
                color: wite,
                size: 30,
              ),
              iconSize: 14,
              onPressed: () {
                if (_betterPlayerController != null)_betterPlayerController.pause();
                if (_betterPlayerController1 != null)_betterPlayerController1.pause();
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
            return ListView.separated(itemBuilder: (context,position){
              return Container(
                width: 100,
                height: 100,
                color: Colors.deepOrange,
              );
            },
                itemCount: 5
            );
        },
      ),
    );
  }
}
