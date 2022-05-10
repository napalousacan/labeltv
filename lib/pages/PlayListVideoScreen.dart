
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';


import '../constant.dart';
import 'YoutubePlayer.dart';
import 'YoutubePlaylist.dart';
import 'home_page.dart';

class PlayListVideoScreen extends StatefulWidget {

  PlayListVideoScreen({Key key, this.title,this.url,this.ytResultPlaylist, String apiKey, this.image, this.lien}) : super(key: key);
  List<YT_APIPlaylist> ytResultPlaylist = [];
  final String title,image,lien;
  final String url;

  @override
  _PlayListVideoState createState() => _PlayListVideoState();
}

class Video {
  final String thumbnail;

  Video(this.thumbnail);
}

class _PlayListVideoState extends State<PlayListVideoScreen> {
  final logger = Logger();
  List<PlayListItem> videos = new List();
  PlayListItemListResponse currentPage;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  String veux;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    getVideos();
  }

  setVideos(videos) {
    setState(() {
      this.videos = videos;
      isLoading = false;
    });
  }

  Future<void> getVideos() async {
    YoutubeAPIv3 api = new YoutubeAPIv3(apiKey);

    PlayListItemListResponse playlist = await api.playListItems(
        playlistId: widget.title, maxResults: 50, part: Parts.snippet);
    var videos = playlist.items.map((video) {
      return video;
    }).toList();
    currentPage = playlist;
    for(int i=0;i<videos.length;i++){
      if(videos[i].snippet.title=="Private video"){
        videos.remove(videos[i]);
      }
    }
    this.videos.clear();
    this.videos.addAll(videos);
    logger.w(this.videos.length);
    setVideos(this.videos);
  }

  Future<void> nextPage() async {
    PlayListItemListResponse playlist = await currentPage.nextPage();
    var videos = playlist.items.map((video) {
      return video;
    }).toList();
    currentPage = playlist;
    this.videos.addAll(videos);
    setVideos(this.videos);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorPrimary
          ),
        ),
        centerTitle: true,

        elevation: 0.0,
        backgroundColor:whiteColor,
      ),
      body: new Container(
          color: colorSecondary,
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: getVideos,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [

                        makeItemVideos(),
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
                                nextPage();
                              },
                            )
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget makeItemVideos() {
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
                  logger.w(videos[position].snippet.resourceId.videoId);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => YoutubePlayerPlaylistPage(
                          image: videos[position].snippet.thumbnails.medium.url,
                          url: videos[position].snippet.resourceId.videoId,
                          title: videos[position].snippet.title,
                          lien: videos[position].snippet.thumbnails.medium.url,
                          related: "",
                          videos: videos,
                        )),
                        (Route<dynamic> route) => true,
                  );
                },

                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      width: 160,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                              0.5,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: videos[position].snippet.thumbnails.medium.url,
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

                                ),
                              )),
                          SizedBox(height: 5,),
                          Container(
                            child:Text(
                              videos[position].snippet.title,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CeraPro',
                                  color: whiteColor),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Positioned(
                child: Container(
                  padding: EdgeInsets.fromLTRB(40, 10, 50, 0),
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
                            builder: (context) => YoutubePlayerPlaylistPage(
                              image: videos[position].snippet.thumbnails.medium.url,
                              url: videos[position].snippet.resourceId.videoId,
                              title: videos[position].snippet.title,
                              lien: videos[position].snippet.thumbnails.medium.url,
                              related: "",
                              videos: videos,
                            )),
                            (Route<dynamic> route) => true,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: videos.length,
    );
  }

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
