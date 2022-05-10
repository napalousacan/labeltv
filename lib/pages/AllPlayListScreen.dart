
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/yt_video.dart';


import '../constant.dart';
import 'PlayListVideoScreen.dart';
import 'home_page.dart';

class AllPlayListScreen extends StatefulWidget {
  List<YT_APIPlaylist> ytResult = [];

  AllPlayListScreen({this.ytResult, String apikey});

  @override
  _AllPlayListState createState() => _AllPlayListState();
}

class _AllPlayListState extends State<AllPlayListScreen> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<YT_APIPlaylist> ytResultPlaylist = [];

  Future<void> callAPI() async {
    /*print('UI callled');
    String query = "Dakaractu TV HD";

    ytResult = await ytApi.search(query);*/
    await Jiffy.locale("en");
    ytResultPlaylist = widget.ytResult;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    callAPI();
  }
  var scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(

      appBar:AppBar(
        title: Text('Replay',style: TextStyle(
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
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => scaffold.currentState.isEndDrawerOpen,
        ),*/
        centerTitle: true,

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
                        makeItemEmissions()
                        /*Container(
                          child: isLoading
                              ? Center(
                            child: makeShimmerEmissions(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemEmissions(),
                        ),*/
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
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayListVideoScreen()),
                                    ModalRoute.withName('/'));
                              },
                            )
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ],
              ))),
    ),
        onWillPop: () async => true
    );
  }

  Widget makeItemEmissions() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return FadeAnimation(
          0.5,
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  print(ytResultPlaylist[position].id);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PlayListVideoScreen(
                          title: ytResultPlaylist[position].id,apiKey: apiKey,)),
                        (Route<dynamic> route) => true,);
                },
                child: Container(
                  //height: 200.0,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(color: whiteColor,blurRadius: 3 ),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FadeAnimation(
                          0.5,
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: ytResultPlaylist[position]
                                    .thumbnail['high']['url'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/labeltv.jpg",
                                  fit: BoxFit.contain,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/labeltv.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                            ),
                          )
                      ),
                      Flexible(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              ytResultPlaylist[position].title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: colorSecondary,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(height: 5,)
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
      },
      itemCount: ytResultPlaylist.length,
    );
  }
  Widget makeShimmerEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
   */
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
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