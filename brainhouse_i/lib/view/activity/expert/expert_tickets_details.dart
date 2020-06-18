import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_active_ticket.dart';
import 'package:brainhouse_i/view/activity/expert/expert_chat_tab.dart';
import 'package:brainhouse_i/view/activity/expert/expert_ticket_activity_tab.dart';
import 'package:brainhouse_i/view/activity/expert/expert_worknote_tab.dart';
import 'package:brainhouse_i/view/ui/chat_screen.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpertTicketDetils extends StatefulWidget {
  @override
  _ExpertTicketDetilsState createState() => _ExpertTicketDetilsState();
}

class _ExpertTicketDetilsState extends State<ExpertTicketDetils>with SingleTickerProviderStateMixin {

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Detail"),
    new Tab(text: "Activities"),
    new Tab(text: "Worknotes",),
    new Tab(text: "Chat",)
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
        appBar: new AppBar(
          backgroundColor: AppTheme.nearlyWhite,
          title: Text('Ticket no: #brnhs-201902982-1234',style: TextStyle(color: Colors.black,fontSize: 17.0),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
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
              indicatorColor: AppTheme.bhb,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: tabs,
            controller: _tabController,
          ),
        ),
      body:TabBarView(
        controller: _tabController,
        children: <Widget>[
          TicketDetailsTab(),
          ExpertActiveTicket(),
          TicketWorkNoteTab(),
          ChatScreen()
        ],
      )
    );
  }
}
