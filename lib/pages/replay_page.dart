import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labeltv/animation/fadeanimation.dart';
import 'package:labeltv/network/model/api_list_by_groupe.dart';

import '../constant.dart';
import 'emisions_page.dart';
import 'home_page.dart';


class ReplyerPage extends StatefulWidget {


  ReplyerPage({Key key,}) : super(key: key);

  @override
  _ReplyerPageState createState() => _ReplyerPageState();
}

class _ReplyerPageState extends State<ReplyerPage> {
  dynamic data;
  var loading = false;
  String url, time,test,lien,logo,videoId, title, titre;
  bool isVideoLoading = true;
  bool isPlay = false;
  bool isVisible = false;
  ListChannelsbygroup listChannelsbygroup;

  String query;
  TextEditingController nameController = TextEditingController();

  bool textField;

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

  @override
  void initState() {
    this.textField = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorPrimary
            ),
          ),
          iconTheme: IconThemeData(color: whiteColor,),
        ),
        body: Container(
          color: colorSecondary,
          child: _buildCard(),
        )
    );
  }


  Widget _buildCard(){
    return Container(
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  FutureBuilder(
            future: fetchReplay(),
            builder: (context,snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorSecondary,
                  ),
                );
              } else
                return GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2 ,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                  children: List.generate(snapshot.data.allitems.length,(index){
                    return Column(
                      children: [
                        GestureDetector(
                            child: FadeAnimation(
                                0.5,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(

                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.allitems[index].logo,width: 100,height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        "assets/images/labeltv.jpg",width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        "assets/images/labeltv.jpg",width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                  ),
                                )
                            ),
                            onTap: () {
                              print(snapshot.data.allitems[index].feedUrl);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EmisionsPage(
                                      //test: snapshot.data.allitems[index].feedUrl,
                                      lien: snapshot.data.allitems[index].feedUrl,
                                      listChannelsbygroup: snapshot.data,
                                    )
                                ),
                              );
                            }
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text("${snapshot.data.allitems[index].title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: whiteColor
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                );
            }
        ),
      ),
    );
  }

}

