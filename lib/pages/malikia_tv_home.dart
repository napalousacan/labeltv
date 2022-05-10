import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
import 'package:labeltv/pages/replay_page.dart';
import 'package:labeltv/pages/youtubePlayer.dart';
import 'package:labeltv/pages/ytoubeplayer.dart';
import 'package:logger/logger.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constant.dart';
import 'AllPlayListScreen.dart';
import 'PlayListVideoScreen.dart';
import 'YoutubeVideoChannelScreen.dart';
import 'buble_page.dart';
import 'chaine_page.dart';

import 'drawers.dart';
import 'emisions_page.dart';
import 'lecteur_malikia.dart';



final String menu = 'assets/images/menu.svg';
final String lecteur = 'assets/images/lecteur.svg';
Color gren = const Color(0xFF00722f);
Color wite = const Color(0xFFf8fbf8);
Color bg = const Color(0xFFEBEBEB);

class Malikiatv_HomePage extends StatefulWidget {
  var logger = Logger();
  ApiLabel apiLabel;
  Direct direct;
  String  test, lien;
  final String apiKey,channelId;
  ListChannelsbygroup listChannelsbygroup;

  Malikiatv_HomePage({Key key, this.logger, this.apiLabel, this.direct,this.lien,this.test,this.listChannelsbygroup, this.apiKey, this.channelId})
      : super(key: key);

  @override
  _Malikiatv_HomePageState createState() => _Malikiatv_HomePageState();
}

class _Malikiatv_HomePageState extends State<Malikiatv_HomePage> {

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
  ChewieController _chewieController;
  bool isVideoLoading = true;
  LiveApi liveApi;
  ApiLabel apiLabel;
  ListChannelsbygroup listChannelsbygroup;
  var logger = Logger();
  String url, time,test,lien,logo,videoId, title, titre;
  GlobalKey _betterPlayerKey = GlobalKey();
  GlobalKey _betterPlayerKey1 = GlobalKey();
  String api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  StreamController<bool> _playController = StreamController.broadcast();
  Direct direct;
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  //String title;
  //String query = "JoyNews";
  String API_Key = 'AIzaSyA6qu7Yw62GjwAsCyviSKnUsWZ3od9-6uk';
  String API_CHANEL = 'UCZX0q49y3Sig3p-yS0IfDIg';
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

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

              imageUrl: "https://adweknow.com/wp-content/uploads/2018/02/label.jpg",)
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
        "https://acanvod.acan.group/myapiv2/alauneByGroup/labeltv/json");
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
                title: "Vous suivez MALIKIA TV en direct",
                imageUrl:
                "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
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
        return LiveApi.withError("Data not found / Connection issue");
      }
    }
    setState(() {
      isVideoLoading = false;//setting state to false after data loaded
    });
  }
  final List<String> _ids = [
    'qkyxY-JjRXU',
    'MgUL3BKQlvc',
    '7XNS2wMl_IM',
    'MgUL3BKQlvc',
    'qHWDToZdRhU',
    '3JZUstlOGac',
    '0mmJ-mnH-EU',
    'MgUL3BKQlvc',
  ];
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
  Future<void> testUrl() async {
    String url =
        "https://acanvod.acan.group/myapiv2/directplayback/46/json";
    final response = await http.get(url);
    print(response.body);

    VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
    logger.w(videoUrl.videoUrl);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl.videoUrl,
        liveStream: true,

        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,

          //notificationChannelName: "7TV Direct",
          //activityName: "7TV Direct",
          title: "Vous suivez MALIKIA TV en direct",
          imageUrl:
          "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
        )
    );

    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
  }
  @override
  void initState() {
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 9, type: "playlist");
    callAPI();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
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
    ///
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
    testUrl();
    //fetchListAndroid();
    //fetchListAndroid1();
    fetchList();
    //navigationPage();
    /*BackButtonInterceptor.add(myInterceptor);*/
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
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



  int _index =1;


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
            child: IconButton(
              icon: Icon(
                Icons.picture_in_picture,color: gren,
              ),
              onPressed: (){
                _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
              },
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
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
   // BackButtonInterceptor.remove(myInterceptor);
    if (_betterPlayerController !=null) {
      _betterPlayerController.dispose();
      _betterPlayerController=null;
    }
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
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
        title: Row(
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
        leading: IconButton(
        icon: SvgPicture.asset(
        menu1,
        width: 30,
        height: 30,
        color: whiteColor,
      ),
      onPressed: (){
        scaffold.currentState.openDrawer();
        },
      ),
        iconTheme: IconThemeData(color: whiteColor,),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        //height: double.infinity,
        color: colorSecondary,
        child: Column(
          children: <Widget>[
            _index == 1 ? Home1(context) :  Home2(context),
            _index==  1 ? Homedescription1(context) : Homedescription2(context),
            dernierVideo(),
            Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child:  Wrap(
                        spacing: 2,
                        children: <Widget>[carousel(), dernierEmision(), makeItemEmissions()]
                    )
                    /*Column(
                        children: [item(), emissions(), itemVideos()],
                      )*/,
                  ),
                ))
          ],
        ),
      ),
      drawer: DrawerPage(
        apiLabel: widget.apiLabel,
        betterPlayerController: _betterPlayerController,
        betterPlayerController1: _betterPlayerController1,
        controller: _controller,
      ),
    );
  }
  @override
  Widget Home1(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: 

      AspectRatio(
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
            color: whiteColor,
            size: 20,
          ),
          SizedBox(width: 5,),
          Text(
            "Vous suivez LABEL TV en direct",
            style: TextStyle(
              color: wite,
              fontSize: 13,
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
          SizedBox(width: 5,),
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
  Widget carousel() {
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

      items: [1,2,3,4,5,6,7]?.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //color: Colors.white,
              shadowColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 300,
                color: colorPrimary,
                child: Stack(
                  children: [
                    Container(
                      height: 168,
                      child:  GestureDetector(
                        child: FadeAnimation(
                          0.5,
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(0),
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl:  ytResult[i].thumbnail['medium']
                                ['url'],
                                width: 310,
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
                          if (_controller !=null)_controller.pause();
                          if (_betterPlayerController != null)_betterPlayerController.pause();
                          if (_betterPlayerController1 != null)_betterPlayerController1.pause();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => YtoubePlayerPage(
                                    videoId: ytResult[i].url,
                                    title: ytResult[i].title,
                                    ytResult: ytResult,
                                  )),
                                  (Route<dynamic> route) => true);
                        },
                      ),

                    ),
                    Positioned(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            strutStyle: StrutStyle(fontSize: 14.0),
                            text: TextSpan(
                                style: TextStyle(color: wite,fontWeight: FontWeight.bold,
                                  fontFamily: "helvetica",),
                                text:
                                ytResult[i].title),
                          ),

                        ),
                    ),
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(110, 50, 0, 0),
                        width: 60,
                        height: 60,

                        child: IconButton(
                          icon: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 70,

                          ),
                          onPressed: (){
                            if (_controller !=null)_controller.pause();
                            if (_betterPlayerController != null)_betterPlayerController.pause();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YtoubePlayerPage(
                                      videoId: ytResult[i].url,
                                      title: ytResult[i].title,
                                      ytResult: ytResult,
                                    )),
                                    (Route<dynamic> route) => true);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );

          },
        );
      })?.toList()??[],
    );
  }
 /* Widget carousel() {
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

      items: [1,2,3,4].map((i) {
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
                                       imageUrl:  ytResult[i].thumbnail['medium']
                                        ['url'],
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
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => YtoubePlayerPage(
                                            videoId: ytResult[i].url,
                                            title: ytResult[i].title,
                                            ytResult: ytResult,
                                          )),
                                          (Route<dynamic> route) => true);
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
                                      ytResult[i].title),
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
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YtoubePlayerPage(
                                      videoId: ytResult[i].url,
                                      title: ytResult[i].title,
                                      ytResult: ytResult,
                                    )),
                                    (Route<dynamic> route) => true);
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
  }*/
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
                        color: wite,
                        fontSize: 15,
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
                      size: 26,
                    ),

                    onPressed: () {
                      if (_controller !=null)_controller.pause();
                      if (_betterPlayerController != null)_betterPlayerController.pause();
                      if (_betterPlayerController1 != null)_betterPlayerController1.pause();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  YoutubeVideoChannelScreen(

                                    ytResult: ytResult,

                                    apikey: API_Key,)
                          ),
                              (Route<dynamic> route) => true);
                    }
                ),

              )

            ],
          ),
        ],
      ),
    );
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
                        color: wite,
                        fontSize: 15,
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
                      size: 26,
                    ),
                    iconSize: 14,
                    onPressed: () {
                      if (_controller !=null)_controller.pause();
                      if (_betterPlayerController != null)_betterPlayerController.pause();
                      if (_betterPlayerController1 != null)_betterPlayerController1.pause();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllPlayListScreen(ytResult: ytResultPlaylist,apikey:API_Key)),
                              (Route<dynamic> route) => true);
                    }
                ),

              )

            ],
          ),
        ],
      ),
    );
  }
  /*Widget makeItemEmissions() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
    //margin: const EdgeInsets.symmetric(horizontal: 10.2),
        height: 200.0,
        child: Container(
        child: ListView.builder(
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
                                    ytResult[position].title,
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
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => YtoubePlayerPage(
                                          videoId: ytResult[position].url,
                                          title: ytResult[position].title,

                                          ytResult: ytResult,
                                        )),
                                        (Route<dynamic> route) => true);
                                var  logger = Logger();
                                //logger.d(snapshot.data.allitems[i].relatedItems);
                              }
                          ),
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: GestureDetector(
                                child: CachedNetworkImage(
                                  imageUrl: ytResult[position].thumbnail['medium']
                                  ['url'],
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
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => YtoubePlayerPage(
                                            videoId: ytResult[position].url,
                                            title: ytResult[position].title,

                                            ytResult: ytResult,
                                          )),
                                          (Route<dynamic> route) => true);
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
      itemCount: ytResult.length>6?6:ytResult.length>0?ytResult.length:0,
    ),
    ),
  );

  }*/
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
                              color: colorPrimary,
                                borderRadius: BorderRadius.circular(10)

                            ),
                            child: Stack(
                              children: [
                                Container(

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FadeAnimation(
                                          0.5,
                                          Container(

                                            width: MediaQuery.of(context).size.width,
                                            height: 110,
                                            //alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                new Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
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
                                                            color: wite,
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
                                                                  color: wite),
                                                            ),
                                                          )),
                                                    ),

                                                    ClipRRect(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                                                      child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
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
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                                Container(
                                                  alignment: Alignment.bottomLeft,
                                                  padding: EdgeInsets.fromLTRB(85, 10, 0, 10),
                                                  child: Text("présenter par LABEL TV",style: TextStyle(fontSize: 10,color: wite),

                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                      ),

                                    ],
                                  ),
                                ),
                               
                              ],
                            )),
                      ),
                    ))
                  /*GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                              child: FadeAnimation(
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
                                                ytResult[position].title,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            )),
                                      ),

                                      ClipRRect(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                                child: CachedNetworkImage(
                                                  imageUrl: ytResult[position].thumbnail['medium']
                                                  ['url'],
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
                                                  if (_controller !=null)_controller.pause();
                                                  if (_betterPlayerController1 != null)_betterPlayerController1.pause();
                                                  if (_betterPlayerController != null)_betterPlayerController.pause();
                                                  //logger.d(snapshot.data.allitems[index].video_url);
                                                  Navigator.of(context).pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) => YtoubePlayerPage(
                                                            videoId: ytResult[position].url,
                                                            title: ytResult[position].title,

                                                            ytResult: ytResult,
                                                          )),
                                                          (Route<dynamic> route) => true);
                                                  var  logger = Logger();
                                                  //logger.d(snapshot.data.allitems[i].relatedItems);
                                                }
                                            ),
                                            Positioned(
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(40, 15, 50, 0),
                                                width: 60,
                                                height: 60,

                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.play_circle_outline,
                                                    color: Colors.white,
                                                    size: 70,

                                                  ),
                                                  onPressed: (){

                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_betterPlayerController1 != null)_betterPlayerController1.pause();
                                if (_betterPlayerController != null)_betterPlayerController.pause();
                                //logger.d(snapshot.data.allitems[index].video_url);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => YtoubePlayerPage(
                                          videoId: ytResult[position].url,
                                          title: ytResult[position].title,

                                          ytResult: ytResult,
                                        )),
                                        (Route<dynamic> route) => true);
                                var  logger = Logger();
                                //logger.d(snapshot.data.allitems[i].relatedItems);
                              }
                          ),

                        ],
                      ),
                    ),
                  ),
                )*/;
              },
              itemCount: ytResultPlaylist==null?0:ytResultPlaylist.length,
            );
        },
      ),
    );



  }

  Widget youtubeEmissions(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),

      height: 200.0,
      child: Container(
        child: ListView.builder(
            itemCount: ytResult.length,
            itemBuilder: (context, position) {
              return Container(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: wite,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          color: Colors.grey.withOpacity(0.2)),
                    ]),
                child: Container(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Container(
                            height: 80,
                            width: 140,
                            child: GestureDetector(
                              child: FadeAnimation(
                                0.5,
                                  ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      height: 110,
                                      width: MediaQuery.of(context).size.width,
                                      imageUrl:  ytResult[position].thumbnail['medium']
                                      ['url'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        "assets/images/malikiaError.png",
                                        fit: BoxFit.contain,
                                        height: 120,
                                        width: 120,
                                        //color: colorPrimary,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        "assets/images/malikiaError.png",
                                        fit: BoxFit.contain,
                                        height: 120,
                                        width: 120,
                                        //color: colorPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => YtoubePlayerPage(
                                            videoId: ytResult[position].url,
                                            title: ytResult[position].title,

                                            ytResult: ytResult,
                                          )),
                                          (Route<dynamic> route) => true);
                                }
                            ),
                      )
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text:
                              ytResult[position].title),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YtoubePlayerPage(
                                      videoId: ytResult[position].url,
                                      title: ytResult[position].title,

                                      ytResult: ytResult,
                                    )),
                                    (Route<dynamic> route) => true);
                          },
                          child: Icon(Icons.play_arrow,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), primary: gren),
                        ),
                        alignment: Alignment.bottomRight,
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }



/*Future<void> navigationPage() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LecteurMalikiaPage(
        apimalikia: apimalikia,
        direct: direct,
      ),
      ),
          (Route<dynamic> route) => false,
    );
  }*/


}
