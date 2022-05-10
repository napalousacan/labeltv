import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import '../constant.dart';

class GuideTest extends StatefulWidget {
  GuideTest({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GuideTestState();
  }
}

class GuideTestState extends State<GuideTest> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Lun"),
    new Tab(text: "Mar"),
    new Tab(text: "Mer"),
    new Tab(text: "Jeu"),
    new Tab(text: "Ven"),
    new Tab(text: "Sam"),
    new Tab(text: "Dim")
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
        title: Text('Bubble Tab Indicator'),
        
        bottom: new TabBar(

          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Colors.blueAccent,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
            // Other flags
            // indicatorRadius: 1,
            // insets: EdgeInsets.all(1),
            // padding: EdgeInsets.all(10)
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return new Center(
              child: new Text(
                tab.text,
                style: new TextStyle(fontSize: 20.0),
              ));
        }).toList(),
      ),
    );
  }
}