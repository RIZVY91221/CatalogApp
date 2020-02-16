import 'dart:convert';

import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/chat_page.dart';
import 'package:brainhouse_client/activity/client_active_ticket_details.dart';
import 'package:brainhouse_client/activity/client_login_page.dart';
import 'package:brainhouse_client/activity/notification_page.dart';
import 'package:brainhouse_client/activity/widget/navigation_drawer_controler.dart';
import 'package:brainhouse_client/data/response_status.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {

  bool isLoading=false;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;
  final List<Ticket>recent=[];
  final List<Ticket>archive=[];
  SharedPreferences sharedPreferences;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


   void getRecentTicket()async {
     if (!isLoading) {
       setState(() {
         isLoading = true;
       });

       getToken().then((value) {
         token = value;
       });
       var dio = await Dio();
       dio.options.baseUrl = TicketUrl;
       dio.options.headers = {
         "Authorization": "Bearer $token"
       }; //add your type of authentication
       // dio.options.contentType = ContentType.parse("application/json");
       Response response = await dio.get(
           "/recent", queryParameters: {"limit": 5,"offset":0});
       //print(response.toString());
       // final Map<String,dynamic> responseData=json.decode(response.data);
        print(response.data['data']['tickets'].toString());
       response.data['data']['tickets'].forEach((ticketDetails) {
         final Ticket recentTicket = Ticket(
             id:ticketDetails['id'] ,
             ticketno: ticketDetails['ticketno'],
             title: ticketDetails['detail']['title'],
             cost: ticketDetails['detail']['cost'],
             tags: ticketDetails['detail']['tags'],
             serviceid: ticketDetails['detail']['serviceid'],
             description: ticketDetails['detail']['description'],
             hourly_contract: ticketDetails['detail']['hourly_contract']
         );
         setState(() {
           recent.add(recentTicket);
           isLoading = false;
         });
       });
       //print(recent.toString());
     }
   }
  void getArchiveTicket()async{

    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = TicketUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/archived",queryParameters:{"limit":5,"offset":0} );
    //final Map<String, dynamic> responseDataArchive=json.decode(response.data);
    response.data['data']['tickets'].forEach((ticketDetails){
      final Ticket archiveTicket=Ticket(
          id:ticketDetails['id'] ,
          ticketno: ticketDetails['ticketno'],
          title: ticketDetails['detail']['title'] ,
          cost: ticketDetails['detail']['cost'],
          tags: ticketDetails['detail']['tags'],
          serviceid: ticketDetails['detail']['serviceid'],
          description: ticketDetails['detail']['description'],
          hourly_contract: ticketDetails['detail']['hourly_contract']
      );
      setState(() {
        archive.add(archiveTicket);
        isLoading=false;
      });
    });
   // print(archive.toString());
  }
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null || sharedPreferences.get("roleId")!=3) {
      Fluttertoast.showToast(
          msg: "Please Sign in Brainhouse Expert Application",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: AppTheme.bhb,
          textColor: Colors.black,
          fontSize: 16.0
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => NewLoginPage()), (
          Route<dynamic> route) => false);
    }else
    {
      Fluttertoast.showToast(
          msg: "Welcome Client to Brainhouse",
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
    super.initState();
   getRecentTicket();
    checkLoginStatus();
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
      body: isLoading?Center(child: SpinKitWave(color: AppTheme.bhb, type: SpinKitWaveType.center),):ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5,top: 10),
                child: Text("Recent Tickets(${this.recent.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color: AppTheme.nearlyBlack),),
              ),

              Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 5.0),
                child: Container(
                  height: 500,
                  color: AppTheme.white,
                  child:ListView.builder(
                    itemCount: this.recent.length,
                    itemBuilder: _getItem,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5,top: 10),
                child: Text("Recent Close Tickets(${this.archive.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color: AppTheme.nearlyBlack),),
              ),
              Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 5.0),
                child: Container(
                  height: 500,
                  color: AppTheme.white,
                  child: ListView.builder(
                    itemCount: this.archive.length,
                    itemBuilder: _getItemCloseTicket,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _getItem(BuildContext context, int index) {
    var recentTicket=this.recent[index];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientTicketDetils(id:recentTicket.id,ticketNo: recentTicket.ticketno,)),
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
      onTap: () => null,
      child: Container(
        height: 150.0,
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitleCloseTickets(context, index)),
      ),
    );
  }

  Widget makeListTitle(BuildContext context, int index) {
    var recentTicket=this.recent[index];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        "Ticket No:#" + recentTicket.ticketno,
        style: TextStyle(
            color:Color(0xff7092be),
            fontSize: 15.0,
            fontWeight: FontWeight.w800),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(recentTicket.title+ "(" + recentTicket.tags + ")"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hourly" + " \$" + recentTicket.cost + "/hr",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5),
              child: Card(elevation: 5.5,child: Text('New',style: TextStyle(backgroundColor: Colors.lightBlueAccent,fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16.0),),)
          )
        ],
      ),
    );
  }

 /* Status(String massege, int index) {
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
  }*/

  Widget makeListTitleCloseTickets(BuildContext context, int index) {
    var archiveTciket=this.archive[index];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        "Ticket No:#" + archiveTciket.ticketno,
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
          Text(archiveTciket.title + "(" + archiveTciket.tags + ")"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hourly" + " \$" + archiveTciket.cost+ " /hr",
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
                return Navigator.push(context, MaterialPageRoute(builder: (context)=>ClientNotification()));
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