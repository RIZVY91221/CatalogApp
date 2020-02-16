import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/ui/active_ticket_tab_Screen.dart';
import 'package:brainhouse_client/activity/ui/clinet_work_note.dart';
import 'package:brainhouse_client/activity/ui/tciket_details_info.dart';
import 'package:brainhouse_client/activity/widget/chat_screen.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientTicketDetils extends StatefulWidget {
  final String id;
  final String ticketNo;

  const ClientTicketDetils({Key key, this.id,this.ticketNo}) : super(key: key);
  @override
  _ClientTicketDetilsState createState() => _ClientTicketDetilsState(id:id,ticketNo: ticketNo);
}

class _ClientTicketDetilsState extends State<ClientTicketDetils> with SingleTickerProviderStateMixin{
  final String  id;
  final String ticketNo;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Detail"),
    new Tab(text: "Activities"),
    new Tab(text: "Worknotes",),
    new Tab(text: "Chat",)
  ];

  TabController _tabController;

  _ClientTicketDetilsState({this.id,this.ticketNo});

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
          title: Text('Ticket no:#'+ticketNo,style: TextStyle(color: Colors.black,fontSize: 13.0),),
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
            TicketInfoDetails(id:id),
            ClientActiveTicketTab(),
            TicketWorkNoteTab(),
            ChatScreen()
          ],
        )
    );
  }
}
