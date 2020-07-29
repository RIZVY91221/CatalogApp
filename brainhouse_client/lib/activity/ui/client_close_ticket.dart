
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/ui/unpublish_ticket_details.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClientCloseTickets extends StatefulWidget {
  @override
  _ClientCloseTicketsState createState() => _ClientCloseTicketsState();
}

class _ClientCloseTicketsState extends State<ClientCloseTickets> {


  bool isLoding=false;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;
  final List<Ticket>archive=[];
  SharedPreferences sharedPreferences;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future getUnpublishTicket()async {
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
        "/0", queryParameters: {"limit": 20,"offset":0});
    //print(response.toString());
    // final Map<String,dynamic> responseData=json.decode(response.data);
    //print(response.data['data']['tickets']);
    return response.data['data']['tickets'];
  }

  @override
  void initState() {
    getUnpublishTicket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder(
        future: getUnpublishTicket(),
        builder: (_,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(snapshot.hasData){
              //print(snapshot.data.toString());
              return  Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                //color: AppTheme.white,
                  child:ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      Ticket newTicketModel=Ticket(
                        id:snapshot.data[index]['id'] ,
                        ticketno: snapshot.data[index]['ticketno'],
                        title: snapshot.data[index]['detail']['title'] ,
                        tags: snapshot.data[index]['detail']['tags'],
                        serviceid: snapshot.data[index]['detail']['serviceid'],
                        description: snapshot.data[index]['detail']['description'],
                      );
                      return GestureDetector(
                        onTap: () =>Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UnpublishTicketDetails(id:newTicketModel.id)),
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
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    newTicketModel.ticketno.toString(),
                                    style: TextStyle(fontSize: 14.0,color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                Text(newTicketModel.title+ "(" + newTicketModel.tags + ")",style: TextStyle(color: Colors.black,fontSize: 16),),
                                SizedBox(height: 10,),

                                Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child:Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.cyanAccent
                                        ),
                                        child:Padding(
                                            padding: EdgeInsets.all(5),
                                            child:Text(
                                              " Unpublish ",
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



                ],
              );*/
            }
            else{
              return Center(child:Text("No New Ticket available"));
            }
          }
        },
      )
    );
  }

  Widget _getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => null,/*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => null),
      ),*/
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
