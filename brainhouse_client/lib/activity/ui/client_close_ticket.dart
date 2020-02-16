
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClientCloseTickets extends StatefulWidget {
  @override
  _ClientCloseTicketsState createState() => _ClientCloseTicketsState();
}

class _ClientCloseTicketsState extends State<ClientCloseTickets> {

  static const String STATUS_WAITING_TO_ACCEPT = "Awaiting Acceptance";
  static final String STATUS_IN_PROGRESS = "In Progress";
  static final String STATUS_PAUSE = "Paused";
  static final String STATUS_PASS = "Passed";
  static final String STATUS_SUSPEND = "Suspended";
  static final String STATUS_EXPERT_CLOSED = "Requested for Closing";
  static final String STATUS_CLOSED = "Finished";

  bool isLoding=false;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;
  final List<Ticket>archive=[];
  SharedPreferences sharedPreferences;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
    Response response = await dio.get("/archived" );
    //final Map<String, dynamic> responseDataArchive=json.decode(response.data);
    response.data['data']['tickets'].forEach((ticketDetails){
      final Ticket archiveTicket=Ticket(
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
        isLoding=false;
      });
    });
    // print(archive.toString());
  }

  @override
  void initState() {
    getArchiveTicket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Container(
        color: AppTheme.white,
        child: ListView.builder(
          itemCount: this.archive.length,
          itemBuilder: _getItem,
        ),
      ),
    );
  }

  Widget _getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => null),
      ),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitleCloseTickets(context, index)),
      ),
    );
  }

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

 /* Status(String massege, int index) {
    if (tickets[index].status == STATUS_WAITING_TO_ACCEPT) {
      return Text(
        massege,
        style: TextStyle(
            backgroundColor: Colors.cyanAccent,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      );
    } else if (tickets[index].status == STATUS_CLOSED) {
      return Text(
        massege,
        style: TextStyle(
            backgroundColor: Colors.redAccent,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      );
    } else if (tickets[index].status == STATUS_IN_PROGRESS) {
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
}
