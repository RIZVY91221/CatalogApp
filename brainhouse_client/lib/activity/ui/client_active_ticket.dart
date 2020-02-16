import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/client_active_ticket_details.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientActiveTicket extends StatefulWidget {
  @override
  _ClientActiveTicketState createState() => _ClientActiveTicketState();
}

class _ClientActiveTicketState extends State<ClientActiveTicket> {

  SharedPreferences sharedPreferences;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;
  bool isLoading=false;
  final List<Ticket>recent=[];


  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void getRecentTicket()async {
    if (!isLoading) {
      setState(() {
        isLoading=true;
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
      Response response = await dio.get("/recent");
      //print(response.toString());
      // final Map<String,dynamic> responseData=json.decode(response.data);
      // print(response.data['data']['tickets'].toString());
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
      // print(recent.toString());
    }
  }
  @override
  void initState() {
    getRecentTicket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body:isLoading?Center(child: SpinKitWave(color: AppTheme.bhb, type: SpinKitWaveType.center),):Container(
        color: AppTheme.white,
        child: ListView.builder(
          itemCount: this.recent.length,
          itemBuilder: _getItem,
        ),
      ),
    );
  }


  Widget _getItem(BuildContext context, int index) {
    var recentTicket=this.recent[index];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientTicketDetils(id:recentTicket.id,ticketNo: recentTicket.ticketno)),
      ),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitle(context, index)),
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
    if (tickets[index].status == STATUS_WAITING_TO_ACCEPT) {
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
