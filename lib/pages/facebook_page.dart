import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:labeltv/network/model/api_malikia.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class FacebookPage extends StatefulWidget {
  const FacebookPage({Key key}) : super(key: key);

  @override
  _FacebookPageState createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {
  ApiLabel apiLabel;
  Future<ApiLabel> fetchMalikia() async {
    try {

      var postListUrl =
      Uri.parse("https://tveapi.acan.group/myapiv2/listAndroid/labeltv/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        setState(() {
          apiLabel = ApiLabel.fromJson(jsonDecode(response.body));
          //print(leral);
        });


        //print(leral.allitems[0].mesg);


      }
    } catch (error, stacktrace) {

      return ApiLabel.withError("Data not found / Connection issue");
    }


  }
  @override
  Widget build(BuildContext context) {
    return Container();
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
