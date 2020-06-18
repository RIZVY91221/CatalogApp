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
    new Tab(text: "Profile"),
    new Tab(text: "Settings"),
    new Tab(text: "Payments"),
    new Tab(text: "Review")
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
      appBar: new AppBar(
        backgroundColor: AppTheme.nearlyWhite,
        title: Text('My Profile',style: TextStyle(color:AppTheme.nearlyBlack,)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor:  Color(0xff7092be),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
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
