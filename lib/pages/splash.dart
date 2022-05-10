import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/network/model/api_malikia.dart';
import 'package:labeltv/network/model/direct_api.dart';
import 'package:labeltv/network/model/list_android.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 'home_page.dart';
import 'malikia_tv_home.dart';







class SplashScreen extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  final logger = Logger();
  bool isLoading = false;
  dynamic error;
  ApiLabel  apiLabel;
  ListAndroid listAndroid;
  Direct direct;



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
        navigationPage();

      }
    } catch (error, stacktrace) {
      internetProblem();
      return ApiLabel.withError("Data not found / Connection issue");
    }


  }
  Future<void> testUrl() async {
    try {
      //await EasyLoading.show();
      String url =
          "https://tveapi.acan.group/myapiv2/appdetails/labeltv";
      final response = await http.get(url);
      print(response.body);

      ApiLabel apimalikia = ApiLabel.fromJson(jsonDecode(response.body));
      logger.w(apimalikia.aCANAPI[0].appDataToload);
     // await EasyLoading.dismiss();

      if (apimalikia.aCANAPI[0].appDataToload != "youtube") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              HomePage(
                apiLabel: apiLabel,
                direct: direct,
              ),
          ),
              (Route<dynamic> route) => false,
        );

      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              Malikiatv_HomePage(
                apiLabel: apiLabel,
              ),
          ),
              (Route<dynamic> route) => false,
        );
      }
    } catch (error, stacktrace) {

      return ApiLabel.withError("Data not found / Connection issue");
    }

  }
  String url;
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
        url = direct.allitems[0].feedUrl;
        navigationPage();
      }
    } catch (error, stacktrace) {
      internetProblem();
      return Direct.withError("Data not found / Connection issue");
    }


  }
  /*Future<void> _getData() async {
    setState(() {

    });
  }*/

  //https://acanvod.acan.group/myapiv2/listAndroid/sentv/json
  /*Future<void> reload() async {
    setState(() {
      isLoading = true;
      data = null;
      error = null;
    });
    try {
      data = await widget.loader();
    } catch (error) {
      this.error = error;
    } finally {
      setState(() => isLoading = false);
    }
  }*/

  Future<void> _refreshProducts() async {
     setState(() {

     });
  }



  Future<bool> internetProblem() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: new Text('Label TV',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontFamily: "CeraPro",
                fontWeight: FontWeight.bold,
                color: colorPrimary)),
        content: new Text(
          "Problème d\'accès à Internet, veuillez vérifier votre connexion et réessayez !!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontFamily: "CeraPro",
              fontWeight: FontWeight.normal,
              color: colorPrimary),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SplashScreen()));
                },
                child: Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorPrimary, colorSecondary],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(35)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "CeraPro",
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState(){
    super.initState();
    //fetchListAndroid();
    //fetchListAndroid();

    //testUrl();
    //_refreshProducts();
    //fetchMalikia();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    Future<void> testUrl() async {
      try {
        //await EasyLoading.show();
        String url =
            "https://tveapi.acan.group/myapiv2/appdetails/labeltv";
        final response = await http.get(url);
        print(response.body);

        ApiLabel apimalikia = ApiLabel.fromJson(jsonDecode(response.body));
        logger.w(apimalikia.aCANAPI[0].appDataToload);
        // await EasyLoading.dismiss();

        if (apimalikia.aCANAPI[0].appDataToload != "youtube") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>
                HomePage(
                  apiLabel: apiLabel,
                  direct: direct,
                ),
            ),
                (Route<dynamic> route) => false,
          );

        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>
                Malikiatv_HomePage(
                  apiLabel: apiLabel,
                ),
            ),
                (Route<dynamic> route) => false,
          );
        }
      } catch (error, stacktrace) {
        internetProblem();
        return ApiLabel.withError("Data not found / Connection issue");
      }

    }
    return new Timer(_duration, testUrl);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //var assetsImage = new AssetImage('assets/images/logo.png');
    var assetsBg = new AssetImage(
        'assets/images/splash.png');
    //var assetsBgLogo = new AssetImage('assets/images/bglogo.png');
    //var image = new Image(image: assetsImage, height: 100);
    //var bgLogo = new Image(image: assetsBgLogo, height: 100);
    var bg = new Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splash.png"),
                fit: BoxFit.cover
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Text('www.labeltelevision.com',style: TextStyle(color: wite),),
          ),
        )
      ],
    ); //<- Creates a widget that displays an image.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          new Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),
                  /* Container(
                    width: 300,
                    child:image
                ),
                Container(
                    height: Platform.isIOS?300:400,
                    width: Platform.isIOS?300:400,
                    child:bgLogo
                )*/
                ],
              )
          )
        ]), //<- place where the image appears
      ),
    );
  }

  Future<void> navigationPage() async {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          apiLabel: apiLabel,
          direct: direct,
        ),
        ),
            (Route<dynamic> route) => false,
      );
    }

}
