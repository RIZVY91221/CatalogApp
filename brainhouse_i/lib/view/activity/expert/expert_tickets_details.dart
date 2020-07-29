import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_active_ticket.dart';
import 'package:brainhouse_i/view/activity/expert/expert_chat_tab.dart';
import 'package:brainhouse_i/view/activity/expert/expert_ticket_activity_tab.dart';
import 'package:brainhouse_i/view/activity/expert/expert_worknote_tab.dart';
import 'package:brainhouse_i/view/activity/expert/ticket_tasks.dart';
import 'package:brainhouse_i/view/ui/chat_screen.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpertTicketDetils extends StatefulWidget {

  final String  id;
  final String ticketNo;
  final String title;
  final String des;
  final String tag;


  ExpertTicketDetils({this.id, this.ticketNo, this.title, this.des, this.tag});

  @override
  _ExpertTicketDetilsState createState() => _ExpertTicketDetilsState(id:id,ticketNo: ticketNo,title: title,tag: tag,des: des);
}

class _ExpertTicketDetilsState extends State<ExpertTicketDetils>with SingleTickerProviderStateMixin {

  final String  id;
  final String ticketNo;
  final String title;
  final String des;
  final String tag;


  _ExpertTicketDetilsState({this.id, this.ticketNo, this.title, this.des,
      this.tag});

  final List<Tab> tabs = <Tab>[
    new Tab(text: "DETAILS"),
    new Tab(text: "TASKS"),
    new Tab(text: "WORKNOTE",),
    new Tab(text: "CHAT",)
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
        appBar:PreferredSize(
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
                          child:Text("CURRENT TICKET",style: TextStyle(color: Colors.black,fontSize: 18.0),)))),
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
        body:TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TicketDetailsTab(ticketNo: ticketNo,title: title,tag: tag,des: des,),
            TicketTask(ticketId:id,ticketUid: ticketNo,),
            TicketWorkNoteTab(ticketNo: ticketNo,ticketId: id,),
            ChatScreen(id:id)
          ],
        )
    );
  }
}
