import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:labeltv/pages/ytoubeplayer.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import 'package:youtube_api/youtube_api.dart';
import '../constant.dart';
import 'home_page.dart';

// ignore: must_be_immutable
class YoutubeVideoChannelScreen extends StatefulWidget {
  List<YT_API> ytResult = [];

  YoutubeVideoChannelScreen({this.ytResult, String apikey});

  @override
  _YoutubeChannelState createState() => new _YoutubeChannelState();
}

class _YoutubeChannelState extends State<YoutubeVideoChannelScreen> {
  static String key =
      apiKey; // ** ENTER YOUTUBE API KEY HERE **
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI ytApi = new YoutubeAPI(key, maxResults: 50, type: "video");
  List<YT_API> ytResult = [];
  bool isLoading = true;
  final logger=new Logger();

  Future<void> callAPI() async {
    /*print('UI callled');
    String query = "Dakaractu TV HD";

    ytResult = await ytApi.search(query);*/
    await Jiffy.locale("en");
    ytResult = widget.ytResult;
    setState(() {
      print('UI Updated');
      ytResult.removeAt(0);
      for(int i=0;i<ytResult.length;i++){
        if(ytResult[i].kind=="playlist"){
          ytResult.remove(ytResult[i]);
        }
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    callAPI();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: true,
        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorPrimary
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: new Container(
            color: colorSecondary,
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: callAPI,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          child: isLoading
                              ? Center(
                                  child: makeShimmerVideos(),
                                  //child: CircularProgressIndicator(),
                                )
                              : makeItemVideos(),
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: 120,
                                height: 50,
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff2CA3E1),
                                        Color(0xff5D20C1)
                                      ],
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Voir Plus +",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onTap: () {},
                            )
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
  Widget makeItemVideos() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return ConstrainedBox(
          constraints: BoxConstraints(),
          child: FadeAnimation(
            0.5,
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => YtoubePlayerPage(
                          videoId: ytResult[position].url,
                          title: ytResult[position].title,

                          ytResult: ytResult,
                        )),
                        (Route<dynamic> route) => true);
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
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl:  ytResult[position].thumbnail['medium']
                                  ['url'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    "assets/images/labeltv.jpg",
                                    fit: BoxFit.cover,
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
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
                                              color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                      width: 60,
                      height: 60,

                      child: IconButton(
                        icon: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 70,

                        ),
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => YtoubePlayerPage(
                                    videoId: ytResult[position].url,
                                    title: ytResult[position].title,

                                    related: "",
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
          ),
        );
      },
      itemCount: ytResult.length,
    );
  }
  /*Widget makeItemVideos() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      shrinkWrap: true,
      //padding: EdgeInsets.all(),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return Container(

          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => YtoubePlayerPage(
                        videoId: ytResult[position].url,
                        title: ytResult[position].title,

                        related: "",
                        ytResult: ytResult,
                      )),
                      (Route<dynamic> route) => true);
            },
            child: Stack(
              children: [
                Container(

                  width: 150,
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          0.5,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    ytResult[position].thumbnail['medium']
                                    ['url'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                ],
                              ),
                            ),
                          )),
                      Container(
                          width: 170,
                          height: 85,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Center(
                                child: FadeAnimation(
                                  0.6,
                                  Text(
                                    ytResult[position].title,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'CeraPro',
                                        color: Colors.black),
                                  ),
                                ),
                              ),

                            ],
                          )),
                    ],
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(35, 10, 50, 0),
                    width: 60,
                    height: 60,

                    child: IconButton(
                      icon: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 70,

                      ),
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => YtoubePlayerPage(
                                  videoId: ytResult[position].url,
                                  title: ytResult[position].title,

                                  related: "",
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
      itemCount: ytResult.length,
    );
  }*/
  Widget makeShimmerVideos() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return FadeAnimation(
          0.5,
          Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.white,
              child: Container(
                height: 120.0,
                width: 200,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  //borderRadius: BorderRadius.circular(20),
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
      itemCount: 6,
    );
  }
}
