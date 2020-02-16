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
  final String id;

  TicketInfoDetails({this.id});

  @override
  _TicketInfoDetailsState createState() => _TicketInfoDetailsState(id: id);
}

class _TicketInfoDetailsState extends State<TicketInfoDetails> {
  final String id;

  _TicketInfoDetailsState({this.id});

  final String ticketDetailsUrl='https://brainhouse.net/apiv2/ticket/detail';
  bool isLoading=false;
  String token;


  String title;
  String ticketNo;
  String des;
  String cost;
  String role;
  String skill;
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<TicketDetails> getRecentTicketDetails()async {
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
  }

  @override
  void initState() {
    getRecentTicketDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      floatingActionButton: new FloatingActionButton(
          elevation: 5.5,
          child: new Icon(Icons.sms,color: AppTheme.white,),
          backgroundColor:AppTheme.bhb,
          onPressed: (){
            return showFancyCustomDialog(context);
          }
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body:isLoading?Center(child: SpinKitWave(color: AppTheme.bhb, type: SpinKitWaveType.center),):ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
            child: Center(child:Text(
              title.toString(),
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bhb),
            ),
          ),),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "TicketNo:",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Flexible(
                      child: Text(
                        ticketNo.toString(),
                        style:
                        TextStyle(fontSize: 18.0, color: AppTheme.bhb),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Job Description:",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Flexible(
                      child: Text(
                         des.toString() ,
                        style:
                        TextStyle(fontSize: 18.0, color: AppTheme.bhb),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cost:",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Flexible(
                      child: Text(
                        cost.toString()+ " \$"+"/hr",
                        style:
                        TextStyle(fontSize: 18.0, color: AppTheme.bh),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "CurrentStatus:",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Flexible(
                      child: Text(
                        "New",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            backgroundColor: Colors.cyanAccent),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Role: ",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  title.toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Reqired Skill: ",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  skill.toString(),
                  style: TextStyle(fontSize: 15.0),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Card(
                          child: Container(
                            width: 75,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.8),
                            ),
                            child: RaisedButton(
                              focusElevation: 6.6,
                              onPressed: () =>Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostTicket(id: id,title: title,description: des,cost: cost,tags: skill,)),
                              ),
                              elevation: 5.5,
                              color: AppTheme.bh,
                              child: Text(
                                "Edit",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ))
                    ],
                  ))

            ],
          )
        ],
      ),);
  }

  void showFancyCustomDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 400.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            /* Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child:ChatScreen(),
            ),*/
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: AppTheme.bhb,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Chat",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              child: ChatScreen(),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }


}

