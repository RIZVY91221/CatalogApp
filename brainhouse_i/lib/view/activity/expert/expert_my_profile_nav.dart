import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_Invoices_screen.dart';
import 'package:brainhouse_i/view/activity/expert/expert_profile.dart';
import 'package:brainhouse_i/view/activity/expert/expert_profile_review.dart';
import 'package:brainhouse_i/view/activity/expert/expert_settings_screen.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class ExpertMyProfile extends StatefulWidget {
  @override
  _ExpertMyProfileState createState() => _ExpertMyProfileState();
}

class _ExpertMyProfileState extends State<ExpertMyProfile>with SingleTickerProviderStateMixin {

  //AnimationController animationController;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "PROFILE"),
    new Tab(text: "SETTINGS"),
    new Tab(text: "PAYMENT"),
    new Tab(text: "REVIEW")
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
    return Scaffold(
      backgroundColor:AppTheme.nearlyWhite ,
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(150.0),
       child:new AppBar(
        backgroundColor: AppTheme.nearlyWhite,
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(top: 10),
            child:Container(
              //width: MediaQuery.of(context).size.width*8/10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //color: AppTheme.bh
                ),
                child:Padding(
                    padding: EdgeInsets.all(5),
                    child:Text("MY PROFILE",style: TextStyle(color: Colors.black,fontSize: 18.0),)))),
        centerTitle: true,
        leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child:IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context, false),
            )),
        bottom: new TabBar(
          isScrollable: true,
          labelPadding: EdgeInsets.all(15),
          unselectedLabelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 15,),
          unselectedLabelStyle: TextStyle(fontSize: 15),
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 32.0,
            indicatorColor: AppTheme.bhb,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ExpertProfile(),
          ExpertSettings(),
          ExpertInvoice(),
          ReviewProfile()
        ],
      ),
    );
  }
}
