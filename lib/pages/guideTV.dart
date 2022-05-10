/*
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/network/model/guide_channel_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

import '../constant.dart';
import 'guideTVMenu.dart';

class GuideTVPage extends StatefulWidget {
  @override
  _GuideTVPageState createState() => _GuideTVPageState();
}

class _GuideTVPageState extends State<GuideTVPage> {
  List<GuideChannelResponse> guideChannelsList = [];
  GuideChannelResponse guideChannelResponse;
  final logger = new Logger();
  int index = 0;

  bool isLoading = false;

  */
/*Future<void> getGuideChannel() async {
    setState(() {
      isLoading = true;
    });
    final dio = Dio();
    final client = RestClient(dio);
    client.getGuideTVChannel().then((it) async {
      setState(() {
        isLoading = false;
        guideChannelsList = it;
        for(int i=0;i<guideChannelsList.length;i++){
          if(i==0){
          isSelected.add(true);
          }else{
            isSelected.add(false);
          }
        }
      });
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          //
          //internetProblem();

          final res = (obj as DioError).response;
          if (res.statusCode == 400) {
            Fluttertoast.showToast(
                msg: "Server Problem",
                toastLength: Toast.LENGTH_LONG,
                *//*
*/
/*gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,*//*
*/
/*
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          logger.e("Got error : ${res.statusCode} -> ${res.statusMessage}");

          break;
        default:
          Fluttertoast.showToast(
              msg: "Server Problem",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        //logger.e("Got error ${obj}");
      }
    });
  }*//*

  Future<GuideChannelResponse> fetchListAndroid() async {
    try {
      var postListUrl =
      Uri.parse("https://acanvod.acan.group/myapiv2/guidetvchannels/walfvod/sat/walftv.stream/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data);
        setState(() {
          guideChannelResponse = GuideChannelResponse.fromJson(jsonDecode(response.body));
          //print(leral);

        });


      }
    } catch (error, stacktrace) {
      return GuideChannelResponse.withError("Data not found / Connection issue");
    }


  }

  @override
  void initState() {
    super.initState();
    fetchListAndroid();
  }

  int _page = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  Widget buildPageView() {
    return PageView.builder(
      itemCount: guideChannelsList.length,
      controller: pageController,
      itemBuilder: (BuildContext context, int itemIndex) {
        return new GuideTVMenu(guideChannels: guideChannelsList[itemIndex]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorPrimaryClear, colorPrimary],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            */
/*borderRadius:
                  BorderRadius.circular(10.0)*//*

          ),
          child: Stack(
            children: [
              Container(
                margin: guideChannelsList.length>1?EdgeInsets.only(top:165):EdgeInsets.only(top:75),
                alignment: Alignment.center,
                child: guideChannelsList.length > 0
                    ? buildPageView()
                    : Container(),
              ),
              Container(
                height: 75,
                child: appBar(),
              ),
              guideChannelsList.length>1?Container(
                margin: EdgeInsets.only(top: 70),
                height: 90,
                child:guideChannels(guideChannelsList)
              ):Container(),
            ],
          )),
    );
  }

  Widget appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              //width: 110,
              child: Row(
            children: [
              Text(
                "EPG/GuideTV",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
            ],
          )),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorPrimaryClear, colorPrimary],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          */
/*borderRadius:
                  BorderRadius.circular(10.0)*//*

        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
  List<bool> isSelected=[];
  Widget guideChannels(List<GuideChannelResponse> guideList) {

    return new Container(
      height: 85,
      child: ListView.builder(
        shrinkWrap: false,
        //physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          return new GestureDetector(
            onTap: () {
              setState(() {
                for(int i=0;i<guideList.length;i++){
                  isSelected[i]=false;
                }
                isSelected[i]=true;
                _page = i;
                pageController.animateToPage(_page,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
            child: Container(
                width: 85,
                decoration: new BoxDecoration(
                    //border: new Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected[i] ? Colors.red : Colors.white,width: 2),
                    color: Colors.white),
                margin: EdgeInsets.all(7),
                //padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    */
/*CachedNetworkImage(
                      imageUrl: guideList[i].allitems..trim(),
                      width: 60,
                    ),*//*

                  ],
                )),
          );
        },
        itemCount: guideList.length,
      ),
    );
  }
}
*/
