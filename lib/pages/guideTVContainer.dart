/*
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:labeltv/network/model/alauneByGroup.dart';
import 'package:labeltv/network/model/guide_channel_response.dart';

import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;




class GuideTVContainer extends StatefulWidget {
  final String channelId, today, day;

  const GuideTVContainer({Key key, this.channelId, this.day, this.today})
      : super(key: key);

  @override
  _GuideTVContainerState createState() => _GuideTVContainerState();
}

class _GuideTVContainerState extends State<GuideTVContainer>
    with AutomaticKeepAliveClientMixin<GuideTVContainer> {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = false;
  //Allitems allItemsData;
  final logger = new Logger();
 */
/* List<GuideData> dataMorning = [];
  List<GuideData> dataEvening = [];
  List<Guide> guideMorning = [];
  List<Guide> guideEvening = [];*//*

  GuideChannelResponse guideChannelResponse;

  Future<void> getGuideData() async {
    setState(() {
      isLoading = true;
    });

    final dio = Dio();
    final client = RestClient(dio);
    String day = "";
    if (widget.day.toLowerCase() == "aujourd'hui") {
      day = widget.today;
    } else {
      if (widget.day == "Lun") {
        day = "mon";
      } else if (widget.day == "Mar") {
        day = "tue";
      } else if (widget.day == "Mer") {
        day = "wed";
      } else if (widget.day == "Jeu") {
        day = "thu";
      } else if (widget.day == "Ven") {
        day = "fri";
      } else if (widget.day == "Sam") {
        day = "sat";
      } else if (widget.day == "Dim") {
        day = "sun";
      }
    }
    //logger.i(widget.day);
    client.getGuideData(widget.channelId, day).then((it) async {
      allItemsData = it.allitems;
      dataMorning = allItemsData.matin;
      dataEvening = allItemsData.soir;
      if (dataMorning.length % 2 == 0) {
        for (int i = 0; i < dataMorning.length; i = i + 2) {
          Guide guide = new Guide(
              guideStart: dataMorning[i], guideEnd: dataMorning[i + 1]);
          guideMorning.add(guide);
        }
      } else {
        final data = dataMorning[dataMorning.length - 1];
        dataMorning.remove(data);
        for (int i = 0; i < dataMorning.length; i = i + 2) {
          Guide guide = new Guide(
              guideStart: dataMorning[i], guideEnd: dataMorning[i + 1]);
          guideMorning.add(guide);
        }
        logger.i(guideMorning.length);
        guideMorning.add(new Guide(guideStart: data, guideEnd: null));
      }
      if (dataEvening.length % 2 == 0) {
        for (int i = 0; i < dataEvening.length; i = i + 2) {
          Guide guide = new Guide(
              guideStart: dataEvening[i], guideEnd: dataEvening[i + 1]);
          guideEvening.add(guide);
        }
      } else {
        final data = dataEvening[dataEvening.length - 1];
        dataEvening.remove(data);
        for (int i = 0; i < dataEvening.length; i = i + 2) {
          Guide guide = new Guide(
              guideStart: dataEvening[i], guideEnd: dataEvening[i + 1]);
          guideEvening.add(guide);
        }
        logger.i(dataEvening.length);
        guideEvening.add(new Guide(guideStart: data, guideEnd: null));
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if (res.statusCode == 400) {
            Fluttertoast.showToast(
                msg: "Server Problem",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          logger.e("Got error : ${res.statusCode} -> ${res.statusMessage}");

          break;
        default:
        */
/*Fluttertoast.showToast(
              msg: "Server Problem",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);*//*

        //logger.e("Got error ${obj}");
      }
    });
  }
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
    getGuideData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  const _MessageTimeline(
                    icon: FontAwesomeIcons.mugHot,
                    message: 'Matin',
                  ),
                ]),
              ),
              _TimelineGuide(data: guideMorning),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  const _MessageTimeline(
                    icon: FontAwesomeIcons.solidMoon,
                    message: 'Soir',
                  ),
                ]),
              ),
              _TimelineGuide(data: guideEvening),
            ],
          )),
    );
  }
}

class _MessageTimeline extends StatelessWidget {
  const _MessageTimeline({Key key, this.message, this.icon}) : super(key: key);

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          //color: Colors.white.withOpacity(0.2),
          color: colorPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineGuide extends StatelessWidget {
  const _TimelineGuide({Key key, this.data}) : super(key: key);

  final List<Guide> data;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          print(index);
          final Guide event = data[index];
          var isLeftChild = false;
          */
/*if (index % 2 == 0) {
            isLeftChild = true;
          } else {
            isLeftChild = false;
          }*//*


          final childStart = _TimelineGuideChild(
            //action: event.action,
            guide: event.guideStart,
            isLeftChild: isLeftChild,
          );
          Widget childEnd;
          if (event.guideEnd == null) {
            childEnd = null;
          } else {
            childEnd = _TimelineGuideChild(
              //action: event.action,
              guide: event.guideEnd,
              isLeftChild: !isLeftChild,
            );
          }

          return TimelineTile(
            alignment: TimelineAlign.center,
            startChild: childStart,
            endChild: childEnd,
            indicatorStyle: IndicatorStyle(
              width: 25,
              height: 25,
              indicator: _TimelineIndicator(),
              drawGap: true,
            ),
            beforeLineStyle: LineStyle(
              //color: Colors.white.withOpacity(0.2),
              color: colorPrimaryClear,
              thickness: 3,
            ),
          );
        },
        childCount: data.length,
      ),
    );
  }
}

class _TimelineGuideChild extends StatelessWidget {
  const _TimelineGuideChild({
    Key key,
    this.guide,
    this.isLeftChild,
  }) : super(key: key);

  final GuideData guide;
  final bool isLeftChild;

  @override
  Widget build(BuildContext context) {
    List<Color> myColor=[Colors.green,Colors.red,Colors.blue,Colors.pink,Colors.purple,Colors.orange,Colors.cyan,Colors.deepPurple,Colors.indigo,Colors.teal,Colors.grey,Colors.brown];
    return Container(
      margin: !isLeftChild?EdgeInsets.only(left: 10, right: 10,bottom: 10):EdgeInsets.only(top:50,left: 10, right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: myColor[Random().nextInt(myColor.length)],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          */
/*ClipOval(
              child: Container(
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl: guide.logo,
              width: 60,
              height: 60,
            ),
          )),*//*

          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              guide.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Text(
              guide.categoryName.trim(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            child: Text(
              guide.description.trim(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "${guide.startTime} - ${guide.endTime}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          //color: Colors.white.withOpacity(0.2),
          color: colorPrimaryClear,
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
*/
