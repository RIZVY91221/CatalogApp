import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/ui/client_post_ticket.dart';
import 'package:brainhouse_client/activity/widget/chat_screen.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:brainhouse_client/model/ticket_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketInfoDetails extends StatefulWidget {
  /*final String id;

  TicketInfoDetails({this.id});*/
  final String ticketNo;
  final String title;
  final String des;
  final String tag;


  TicketInfoDetails({this.ticketNo, this.title, this.des, this.tag});

  @override
  _TicketInfoDetailsState createState() => _TicketInfoDetailsState(ticketNo: ticketNo,title: title,tag: tag,des: des);
}

class _TicketInfoDetailsState extends State<TicketInfoDetails> {
 /* final String id;

  _TicketInfoDetailsState({this.id});*/
  final String ticketNo;
  final String title;
  final String des;
  final String tag;


  _TicketInfoDetailsState({this.ticketNo, this.title, this.des, this.tag});

  final String ticketDetailsUrl='https://brainhouse.net/apiv2/ticket/detail';
  bool isLoading=false;
  String token;


 /* String title;
  String ticketNo;
  String des;
  String cost;
  String role;
  String skill;*/
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /*Future<TicketDetails> getRecentTicketDetails()async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      getToken().then((value) {
        token = value;
      });
      var dio = await Dio();
      dio.options.baseUrl = ticketDetailsUrl;
      dio.options.headers = {
        "Authorization": "Bearer $token"
      }; //add your type of authentication
      // dio.options.contentType = ContentType.parse("application/json");
      if(id!=null) {
        try{
          Response response = await dio.get("/$id");
          //print("response" + response.toString());
          title = response.data['data']['detail']['title'];
          ticketNo = response.data['data']['ticketno'];
          des = response.data['data']['detail']['description'];
          cost = response.data['data']['detail']['cost'];
          role = response.data['data']['detail']['title'];
          skill = response.data['data']['detail']['tags'];
        }
        catch(e){
          e.toString();
        }

        //print("response" + response.toString());
        // print(response.data['data']['detail']['title']);
        setState(() {
          //recentticketDetails.add(recentTicket);
          isLoading = false;
        });
      }else{
        print("no id get");
      }

    }
  }*/

  @override
  void initState() {
    //getRecentTicketDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body:isLoading?Center(child: SpinKitWave(color: AppTheme.bhb, type: SpinKitWaveType.center),):ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
         Padding(
            padding: EdgeInsets.only(top:10,left: 5.0, right: 5.0, bottom: 5.0),
            child: Center(child:Text(
              title.toString(),
              style: TextStyle(
                  fontSize: 22.0,
                  //fontWeight: FontWeight.bold,
                  color: AppTheme.bhb),
            ),
          ),),
          SizedBox(height: 15,),
          Padding(
                  padding: EdgeInsets.only(top: 10.0,left: 15,right: 5,bottom: 5),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Ticket No ",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color:AppTheme.bhb),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0,top: 5),
                        child: Text(
                          ticketNo.toString(),
                          style: TextStyle(fontSize: 14.0,color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 5.0,top: 5),
                            child:Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.amberAccent
                                ),
                                child:Padding(
                                  padding: EdgeInsets.all(5),
                                    child:Text(
                                  " In Progress ",
                                  style: TextStyle(fontSize: 14.0,),
                                ))),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Description ",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bhb),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0,top: 5),
                        child: Text(
                          des.toString(),
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          " Skills ",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bhb),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0,top: 5),
                        child: Container(
                          //height: 25,
                          //width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.nearlyWhite
                            ),
                            child:Padding(
                                padding:EdgeInsets.all(5),
                                child:Text(
                                  "    "+ tag.toString()+"    ",
                                  style: TextStyle(fontSize: 14.0),
                                ))),
                      ),



                    ],
                  )),


        ],
      ),);
  }


}

