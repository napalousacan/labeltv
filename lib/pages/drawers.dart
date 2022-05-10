import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:labeltv/network/model/api_malikia.dart';
import 'package:labeltv/network/model/direct_api.dart';
import 'package:labeltv/network/model/guide_channel_response.dart';
import 'package:labeltv/network/model/live_api.dart';
import 'package:labeltv/pages/politique_page.dart';
import 'package:labeltv/pages/replay_page.dart';
import 'package:labeltv/pages/youtube_malikia.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


import 'AllPlayListScreen.dart';
import 'YoutubeChannelScreen.dart';
import 'buble_page.dart';
import 'description_page.dart';
import 'guide_pages.dart';
import 'guidetest.dart';
import 'home_page.dart';
import 'lecteur_malikia.dart';
import 'malikia_tv_home.dart';
import '../constant.dart';

final String assetIcons1 = 'assets/images/facebook.svg';
final String assetIcons2 = 'assets/images/info.svg';
final String assetIcons3 = 'assets/images/lock.svg';
final String assetIcons4 = 'assets/images/notification.svg';
final String assetIcons5 = 'assets/images/replay.svg';
final String assetIcons6 = 'assets/images/tv.svg';
final String assetIcons7 = 'assets/images/youtube.svg';
final String assetIcons8 = 'assets/images/playlist.svg';

class DrawerPage extends StatefulWidget {
  LiveApi liveApi;
  Direct direct;
  ApiLabel apiLabel;

  BetterPlayerController betterPlayerController;
  BetterPlayerController betterPlayerController1;
  YoutubePlayerController controller;
  GuideChannelResponse guideChannelResponse;
  DrawerPage({Key key, this.liveApi,this.betterPlayerController,this.controller,this.guideChannelResponse,this.direct,this.apiLabel,this.betterPlayerController1})
      : super(key: key);
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with SingleTickerProviderStateMixin {
  Direct direct;
  String lien;
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

  Future<Direct> fetchListAndroid() async {
    try {
      var postListUrl =
      Uri.parse("https://tveapi.acan.group/myapiv2/listLiveTV/labeltv/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data);
        setState(() {
          direct = Direct.fromJson(jsonDecode(response.body));
          //print(leral);

        });


      }
    } catch (error, stacktrace) {
      return Direct.withError("Data not found / Connection issue");
    }


  }

  Future<void> testUrl() async {
    String url =
        "https://tveapi.acan.group/myapiv2/appdetails/labeltv";
    final response = await http.get(url);
    print(response.body);

    ApiLabel apiLabel = ApiLabel.fromJson(jsonDecode(response.body));
    //logger.w(apimalikia.aCANAPI[0].appDataToload);

    if (apiLabel.aCANAPI[0].appDataToload == "youtube") {
      if (widget.controller !=null)widget.controller.pause();
      if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
      if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  AllPlayListScreen(ytResult: ytResultPlaylist,apikey:API_Key)),
              (Route<dynamic> route) => true);

    } else{
      if (widget.controller !=null)widget.controller.pause();
      if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
      if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ReplyerPage()));

    }

  }
  Future<void> _getData() async {
    setState(() {
      testUrl();

    });
  }
  Future<void> malikiaHome() async {
    String url =
        "https://tveapi.acan.group/myapiv2/appdetails/labeltv";
    final response = await http.get(url);
    print(response.body);

    ApiLabel apiLabel = ApiLabel.fromJson(jsonDecode(response.body));
    //logger.w(apimalikia.aCANAPI[0].appDataToload);

    if (apiLabel.aCANAPI[0].appDataToload != "youtube") {
      if (widget.controller !=null)widget.controller.pause();
      if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
      if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage(
        direct: direct,
        liveApi: widget.liveApi,


      )
      ));
    } else{
      if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
      if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Malikiatv_HomePage(
        direct: direct,

      )
      ));

    }

  }
  @override
  void initState() {
    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 9, type: "playlist");
    callAPI();
    callAPIPlaylist();
    //testUrl();
    fetchListAndroid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bgmenu.png"), fit: BoxFit.cover),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/lg.png",
                  ),
                  fit: BoxFit.contain
                ),
              ),
            ),
            ),
            SizedBox(height: 5,),
            ListTile(
              onTap: () {
                var logger = Logger();
                logger.i(widget.direct);
                malikiaHome();

              },
              leading: SvgPicture.asset(
                assetIcons6,
                width: 30,
                height: 30,
                color: colorSecondary,
              ),
              title: Text(
                "Les Directs",
                style: TextStyle(color: colorSecondary),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              onTap: () {
                _getData();

                },

              leading: SvgPicture.asset(
                assetIcons5,
                width: 30,
                height: 30,
                color: colorSecondary,
              ),
              title: Text(
                "Replay TV",
                style: TextStyle(color: colorSecondary),
              ),
            ),
            /*ListTile(
              onTap: () {

                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => GuideTest()));
              },
              leading: SvgPicture.asset(
                assetIcons8,
                width: 30,
                height: 30,

              ),
              title: Text(
                "EPG/Guide TV",
                style: TextStyle(color: Colors.black),

              ),
            )*/
            SizedBox(height: 15,),
            ListTile(
              /*onTap: (){
                const url ="https://youtube.com/c/7TVSénégal";
                launchURL(url);
              },*/
              onTap: () {
                if (widget.controller !=null)widget.controller.pause();
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => YoutubeChannelScreens()));
               /* Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => YoutubeChannelScreens()),

                );*/
              },
              leading: SvgPicture.asset(
                assetIcons7,
                width: 30,
                height: 30,
                color: colorSecondary,
              ),
              title: Text(
                "YouTube",
                style: TextStyle(color: colorSecondary),
              ),
            ),
            SizedBox(height: 40,),
            ListTile(

             onTap: (){
               if (widget.controller !=null)widget.controller.pause();
               if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
               if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
               _launchURL();
             },
              leading: SvgPicture.asset(
                assetIcons1,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "Facebook",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              onTap: () {
                if (widget.controller !=null)widget.controller.pause();
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PolitiquePage(),
                    )
                );
              },
              leading: SvgPicture.asset(
                assetIcons3,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "Politique de confidentialité",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15,),
            ListTile(
              onTap: () {
                if (widget.controller !=null)widget.controller.pause();
                if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                if(widget.betterPlayerController1 !=null)widget.betterPlayerController1.pause();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DescriptionPage()
                    )
                );
              },
              leading: SvgPicture.asset(
                assetIcons2,
                width: 30,
                height: 30,
                color: Colors.white,
              ),
              title: Text(
                "A propos",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.fromLTRB(70, 90, 0, 0),
                child: Text(
                  "www.labeltelevision.com",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  static const _url = 'https://fr-fr.facebook.com/alabeltv/';
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
