import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'drawers.dart';
final String menu1 = 'assets/images/menu.svg';
class BublePage extends StatefulWidget {
  const BublePage({Key key}) : super(key: key);

  @override
  _BublePageState createState() => _BublePageState();
}

class _BublePageState extends State<BublePage> {
  int _index =0;
  var scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      key: scaffold,
      appBar: AppBar(
        title: Text("test"),
        leading: IconButton(
          icon: SvgPicture.asset(
            menu1,
            width: 30,
            height: 30,

          ),
          onPressed: (){
            scaffold.currentState.openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          _index == 1 ? Home1(context) :  Home2(context),
          Padding(
            padding:  EdgeInsets.only(top: 10,left: 18,bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _index = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _index == 1 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,color: _index == 1 ? Colors.white : Colors.black,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 12),
                            child: Text(_index == 1 ? "Home":"",style: TextStyle(color: _index == 1 ? Colors.white : Colors.black ),),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _index = 2;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: _index == 2 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tv,color: _index == 2 ? Colors.white : Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(_index == 2 ? "Direct":"",style: TextStyle(color: _index == 2 ? Colors.white : Colors.black ),),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget Home1(BuildContext context) {
    return Expanded(child: Center(
      child: Text("1"),
    ));
  }
  @override
  Widget Home2(BuildContext context) {
    return Expanded(child: Center(
      child: Text("2"),
    ));
  }

}
