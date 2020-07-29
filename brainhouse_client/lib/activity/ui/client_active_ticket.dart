import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/client_active_ticket_details.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:brainhouse_client/provider/Ticket_Api_provider.dart';
import 'package:brainhouse_client/provider/ticket_DB_Provider.dart';
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
  List data;
  final List<Ticket>recent=[];


  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future getCurrentTicket()async {

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
        "/2", queryParameters: {"limit": 20,"offset":0});
    //print(response.toString());
    // final Map<String,dynamic> responseData=json.decode(response.data);
    //print(response.data['data']['tickets'].toString());
    return response.data['data']['tickets'];
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = TicketApiProvider();
    await apiProvider.getCurrentTicket();
    // print(await DBProvider.db.getAllCurrentTickets());

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    DBProvider.db.getAllCurrentTickets().then((value){
      if(value.length==0){
        _loadFromApi();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder(
        future: DBProvider.db.getAllCurrentTickets(),
        builder: (_,snapshot){
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(snapshot.hasData){
              print(snapshot.data.toString());
              return  Padding(
                padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                //color: AppTheme.white,
                  child:ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      //data.add(newTicketModel);

                      return GestureDetector(
                        onTap: () =>Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClientTicketDetils(id:snapshot.data[index].id,ticketNo: snapshot.data[index].ticketno,)),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height/4,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                            title: Text(
                              "Ticket No:",
                              style: TextStyle(
                                  color:Color(0xff7092be),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    snapshot.data[index].ticketno.toString(),
                                    style: TextStyle(fontSize: 14.0,color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                Text(snapshot.data[index].title+ "(" + snapshot.data[index].tags + ")",style: TextStyle(color: Colors.black,fontSize: 16),),
                                SizedBox(height: 10,),

                                Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child:Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.amberAccent
                                        ),
                                        child:Padding(
                                            padding: EdgeInsets.all(5),
                                            child:Text(
                                              " In Progress ",
                                              style: TextStyle(fontSize: 14.0,color: Colors.black),
                                            )))),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                  ),

              );
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  Divider()
                ],
              );*/
            }
            else{
              return Text("No current Ticket");
            }
          }
        },
      )
    );
  }


 /* Widget _getItem(BuildContext context, int index) {
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
  }*/
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
            "Hourly 300 /hr",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5),
              child: Card(elevation: 5.5,child: Text(' In progress ',style: TextStyle(backgroundColor: Colors.amberAccent,fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16.0),),)
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
