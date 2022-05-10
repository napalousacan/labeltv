import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labeltv/network/model/guide_channel_response.dart';
import 'package:logger/logger.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class GuidePages extends StatefulWidget {
  const GuidePages({Key key}) : super(key: key);

  @override
  _GuidePagesState createState() => _GuidePagesState();
}

class _GuidePagesState extends State<GuidePages> {
  GuideChannelResponse guideChannelResponse;
  List<Matin> matin;
  var logger =Logger();

  Future<GuideChannelResponse> fetchReplay() async {
    var postListUrl = Uri.parse(
        "https://acanvod.acan.group/myapiv2/guidetvchannels/walfvod/mon/walftv.stream/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return GuideChannelResponse.fromJson(jsonDecode(response.body));
      //logger.w(guideChannelResponse.allitems.matin[0].title);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [colorPrimary, colorPrimary, colorSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorbg,
          child: _guidetv(),
        ),
      ),
    );
  }



  Widget _guidetv() {
    return FutureBuilder(
        future: fetchReplay(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {

            return Center(
              child: CircularProgressIndicator(
                color: colorSecondary,
              ),
            );
          } else

            return ListView.builder(
              shrinkWrap: true,

              itemBuilder: (context, position) {

                return Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(""),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      elevation: 8.0,
                      margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Icon(
                              Icons.play_circle_outline
                          ),
                          title: Text("${snapshot.data.allitems.soir[position].title}"),
                          trailing: Text('${snapshot.data.allitems.soir[position].title}'),
                        ),
                      ),
                    )
                  ],
                );
              },
              itemCount: snapshot.data.allitems.soir==null?0:snapshot.data.allitems.soir.length,
            );


        });
  }
}

List _elements = <Element>[
  Element(DateTime(2020, 6, 24, 18), 'Got to gym', Icons.fitness_center),
  Element(DateTime(2020, 6, 24, 9), 'Work', Icons.work),
  Element(DateTime(2020, 6, 25, 8), 'Buy groceries', Icons.shopping_basket),
  Element(DateTime(2020, 6, 25, 16), 'Cinema', Icons.movie),
  Element(DateTime(2020, 6, 25, 20), 'Eat', Icons.fastfood),
  Element(DateTime(2020, 6, 26, 12), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 27, 12), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 27, 13), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 27, 14), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 27, 15), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 28, 12), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 29, 12), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 29, 12), 'Car wash', Icons.local_car_wash),
  Element(DateTime(2020, 6, 30, 12), 'Car wash', Icons.local_car_wash),
];
var list = ['lundi','mardi','mercredi','jeudi'];

class Element {
  DateTime date;
  String name;
  IconData icon;

  Element(this.date, this.name, this.icon);
}
