
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/ui/client_active_ticket.dart';
import 'package:brainhouse_client/activity/ui/client_close_ticket.dart';
import 'package:brainhouse_client/activity/ui/client_post_ticket.dart';
import 'package:brainhouse_client/activity/ui/closed_ticket_tab.dart';
import 'package:brainhouse_client/activity/ui/new_ticket_tab.dart';
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
    new Tab(text: "OPEN TICKET"),
    new Tab(text: "NEW TICKET"),
    new Tab(text: "ClOSE TICKET",),
    new Tab(text: "UNPUBLISHED TICKET"),
    new Tab(text: "POST TICKET"),
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: new AppBar(
            elevation: 0,
            backgroundColor: AppTheme.nearlyWhite,
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
                        child:Text("TICKET",style: TextStyle(color: Colors.black,fontSize: 18.0),)))),
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
          )),
      body: new TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          ClientActiveTicket(),
          NewTicketTab(),
          ClosedTicketTab(),
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