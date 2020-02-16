
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/ui/client_active_ticket.dart';
import 'package:brainhouse_client/activity/ui/client_close_ticket.dart';
import 'package:brainhouse_client/activity/ui/client_post_ticket.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
class Ticket_Tab_bar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}


class HomeWidgetState extends State<Ticket_Tab_bar> with SingleTickerProviderStateMixin{

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Active"),
    new Tab(text: "Closed"),
    new Tab(text: "Post Ticket"),
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
        backgroundColor: AppTheme.nearlyWhite,
        title: Text('Tickets',style: TextStyle(color: AppTheme.nearlyBlack),),
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
            indicatorColor: Color(0xff7092be),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          ClientActiveTicket(),
          ClientCloseTickets(),
          PostTicket()
        ],
        /* children: tabs.map((Tab tab) {
          ExpertActiveTicket();


         /* return new Center(
              child: new Text(
                tab.text,
                style: new TextStyle(
                    fontSize: 20.0
                ),
              )
          );*/
        }).toList(),*/
      ),
    );
  }
}
final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.blueAccent,
);