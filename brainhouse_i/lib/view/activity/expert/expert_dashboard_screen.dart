
import 'package:brainhouse_i/model/Ticket.dart';
import 'package:brainhouse_i/model/response.dart';
import 'package:brainhouse_i/view/activity/expert/NewLoginPage.dart';
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_active_ticket.dart';
import 'package:brainhouse_i/view/activity/expert/expert_chat_tab.dart';
import 'package:brainhouse_i/view/activity/expert/expert_notification_screen.dart';
import 'package:brainhouse_i/view/activity/expert/expert_tickets_details.dart';
import 'package:brainhouse_i/view/activity/expert/navigation_home_screen.dart';
import 'package:dio/dio.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ExpertDashboard extends StatefulWidget {
  @override
  _ExpertDashboardState createState() => _ExpertDashboardState();
}

class _ExpertDashboardState extends State<ExpertDashboard> {

  SharedPreferences sharedPreferences;
  String token;
  var jsonBodyRecent;
  List archive;
  List recent;
  var jsonBodyArchive;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";

  List tickets = [
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: TicketResponse.STATUS_CLOSED,

        lastStatus: "",
        skillGroupId: "AWS"),
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: TicketResponse.STATUS_WAITING_TO_ACCEPT,
        lastStatus: "",
        skillGroupId: "AWS"),
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: TicketResponse.STATUS_IN_PROGRESS,
        lastStatus:
        "Configuration file is configured and tested in stage server.",
        skillGroupId: "AWS"),
  ];


  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<dynamic>getRecentTicket(int limit)async{

    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = TicketUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/recent",queryParameters:{"limit":limit} );
    jsonBodyRecent=response.data;
    recent=jsonBodyRecent['data']['tickets'];
    print(response.toString());

  }
  Future<dynamic>getArchiveTicket(int limit)async{

    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = TicketUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/archived",queryParameters:{"limit":limit} );
    jsonBodyArchive=response.data;
    archive=jsonBodyArchive['data']['tickets'];
    //print();

  }

   checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null || sharedPreferences.get("roleId")!=4) {
      Fluttertoast.showToast(
          msg: "Please Sign in Brainhouse Client Application",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: AppTheme.nearlyWhite,
          textColor: Colors.black,
          fontSize: 16.0
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => NewLoginPage()), (
          Route<dynamic> route) => false);
    }else
      {
        Fluttertoast.showToast(
            msg: "Welcome Expert to Brainhouse",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: AppTheme.bh,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }
  int _counter=1;
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyWhite,
      title:Text("DASHBOARD",style: TextStyle(color:AppTheme.nearlyBlack,fontSize: 18.0),),

        iconTheme: IconThemeData(color: AppTheme.bh),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20,top: 12),
            child:AppbarMassage() ,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20,top: 10),
            child:AppbarNotification() ,
          )

        ],
      ),
      drawer: NavDrawer(),
      body:Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5,top: 10),
                child: Text("Recent Tickets() ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color: AppTheme.nearlyBlack),),
              ),

              Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 5.0),

                child:Container(
                  height:480.0,
                  child: ListView.builder(
                  itemCount: recent.length,
                  itemBuilder: _getItem,
                  scrollDirection: Axis.vertical,
                ),
              )),

              Padding(
                padding: EdgeInsets.only(left: 5,top: 10),
                child: Text("Recent Close Tickets() ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color: AppTheme.nearlyBlack),),
              ),

              Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 5.0),


                child: Container(
                  height: 480.0,
                  child:ListView.builder(
                  itemCount: archive.length,
                  itemBuilder: _getItemCloseTicket,
                  scrollDirection: Axis.vertical,
                ),
              ),)
            ]
          ),
        ),
      )
    );
  }

  Widget _getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpertTicketDetils()),
      ),
      child: Container(
        height: 150.0,
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitle(context, index)),
      ),
    );
  }
  Widget _getItemCloseTicket(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpertTicketDetils()),
      ),
      child: Container(
        height: 150.0,
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitleCloseTickets(context, index)),
      ),
    );
  }

  Widget makeListTitle(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        "Ticket No:#" + recent[index]['ticketno'],
        style: TextStyle(
            color:Color(0xff7092be),
            fontSize: 18.0,
            fontWeight: FontWeight.w800),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(recent[index]['detail']['title']+ "(" + recent[index]['detail']['tags'] + ")"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hourly" + " \$" + recent[index]['detail']['cost'] + "/hr",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Card(elevation: 5.5,child: Text('New',style: TextStyle(backgroundColor: Colors.lightBlueAccent,fontWeight: FontWeight.bold,color: Colors.white),),)
          )
        ],
      ),
    );
  }

  Status(String massege, int index) {
    if (tickets[index].status == TicketResponse.STATUS_WAITING_TO_ACCEPT) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.cyanAccent,
          ),
          child:Text(
            massege,
            style: TextStyle(
                backgroundColor: Colors.cyanAccent,
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ));
    } else if (tickets[index].status == TicketResponse.STATUS_CLOSED) {
      return Text(
        massege,
        style: TextStyle(
            backgroundColor: Colors.redAccent,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      );
    } else if (tickets[index].status == TicketResponse.STATUS_IN_PROGRESS) {
      return Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              massege,
              style: TextStyle(
                  backgroundColor: Colors.yellowAccent,
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Last Status: ",
                style: TextStyle(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(child: Padding(
            padding: EdgeInsets.only(left: 2.0),
            child: Text(
              tickets[index].lastStatus,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ) ,)

        ],
      );
    }
  }

  Widget makeListTitleCloseTickets(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        "Ticket No:#" + archive[index]['ticketno'],
        style: TextStyle(
            color:Color(0xff7092be),
            fontSize: 18.0,
            fontWeight: FontWeight.w800),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(archive[index]['detail']['title'] + "(" + archive[index]['detail']['tags'] + ")"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hourly" + " \$" + archive[index]['detail']['cost'],
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Card(child: Text("Close",style: TextStyle(backgroundColor: AppTheme.bh,color:Colors.white),),)
          )
        ],
      ),
    );
  }

  Widget AppbarMassage(){
    return Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          GestureDetector(child:Icon(
            Icons.sms,
            color: AppTheme.grey,
            size: 30,
          ),
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TicketChatAction())),
          ),

          Container(
            width: 30,
            height: 30,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(left: 7.0),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bh,
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _counter.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget AppbarNotification(){
    return Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          GestureDetector(
            child:Icon(
              Icons.notifications,
              color: AppTheme.grey,
              size: 30,
            ),
            onTap: (){
              return Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpertNotification()));
              }
          ),

          Container(
            width: 30,
            height: 30,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 5),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bh,
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _counter.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationDetails(){
    return ListView(
      children: <Widget>[
        ListTile(
          title:Text("Steve Munish"),
        )
      ],
    );
  }

}
