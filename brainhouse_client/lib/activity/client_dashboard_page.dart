import 'dart:convert';

import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/chat_page.dart';
import 'package:brainhouse_client/activity/client_active_ticket_details.dart';
import 'package:brainhouse_client/activity/client_login_page.dart';
import 'package:brainhouse_client/activity/notification_page.dart';
import 'package:brainhouse_client/activity/ui/ticketDetails_newTicket.dart';
import 'package:brainhouse_client/activity/widget/navigation_drawer_controler.dart';
import 'package:brainhouse_client/data/response_status.dart';
import 'package:brainhouse_client/model/Ticket.dart';
import 'package:brainhouse_client/model/userInfo.dart';
import 'package:brainhouse_client/provider/Ticket_Api_provider.dart';
import 'package:brainhouse_client/provider/ticket_DB_Provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {

  bool isLoading=true;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  final String baseUrl = 'https://brainhouse.net/apiv2/user';
  String token;
  String fname,lname,imageUrl;
  var responseBody;
  List data;
  double height;
  double heightN;
  double heightCl;
  double heightCa;
  SharedPreferences sharedPreferences;


  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future getCheckLogin() async {
    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/info");
    responseBody = response.data;
    //print(responseBody.toString());
    return responseBody['data']['data']['role'];
  }
  Future<userInfo> getHttp() async {
    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/info");
    responseBody = response.data;
    return userInfo.fromJson(responseBody['data']['data']['profile']);
  }

  Future getHttpImage() async {
    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/info");
    responseBody = response.data;
    print(responseBody['data']['data']['avatar']);
    return responseBody['data']['data']['avatar'];
  }

  Future<String>getCurrentTicket()async {

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
        "/2", queryParameters: {"limit": 2,"offset":0});
    //print(response.toString());
    // final Map<String,dynamic> responseData=json.decode(response.data);
    //print(response.data['data']['tickets'].toString());
    setState(() {
      data=response.data['data']['tickets'];
    });
    return "Suceess";
  }
   Future getNewTicket()async {
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
         "/1", queryParameters: {"limit": 2,"offset":0});
     //print(response.toString());
     // final Map<String,dynamic> responseData=json.decode(response.data);
     //print(response.data['data']['tickets']);
     return response.data['data']['tickets'];
   }

  Future getCloseTicket()async{

    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = TicketUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/4",queryParameters:{"limit":2,"offset":0} );
    //final Map<String, dynamic> responseDataArchive=json.decode(response.data);
    return response.data['data']['tickets'];
   // print(archive.toString());
  }

  Future getCancelTicket()async{

    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = TicketUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/3",queryParameters:{"limit":2,"offset":0} );
    //final Map<String, dynamic> responseDataArchive=json.decode(response.data);
    return response.data['data']['tickets'];
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
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = TicketApiProvider();
    await apiProvider.getDashCurrentTicket();
    await apiProvider.getDashNewTicket();
    // print(await DBProvider.db.getAllCurrentTickets());

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    //checkLoginStatus();
    DBProvider.db.getDashCurrentTickets().then((value){
      print(value.length.toString());
      if(value.length==0){
        _loadFromApi();
      }
      return;
    });
    getCheckLogin().then((value){
      if(value!=3){
        Fluttertoast.showToast(
            msg: "Please Sign in Brainhouse Client Application",
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

      }
      return;
    });
    getHttp().then((valu){
      setState(() {
        fname=valu.firstname;
        lname=valu.lastname;
      });

    });
    getHttpImage().then((value){
      setState(() {
        imageUrl=value.toString();
      });


    });
//    getCurrentTicket();
//    getNewTicket();
//    getCancelTicket();
  }
  int _counter=1;
  int index;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
        child:AppBar(
        backgroundColor: AppTheme.nearlyWhite,
        elevation: 0,
        centerTitle: true,
        title:Padding(
          padding: EdgeInsets.only(top: 10),
            child:Text("DASHBOARD",style: TextStyle(color:AppTheme.nearlyBlack,fontSize: 18.0),)),

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
      )),
      drawer: Padding(
        padding: EdgeInsets.all(5),
          child:NavDrawer(fName: fname,lName: lname,avatar: imageUrl)),
      body:ListView(
        children: <Widget>[
          currentTicket(),
          newTicketItem(),

          //closeTicketItem(),
          //cancelTicketItem(),
        ],
      ),
    );
  }

  Widget currentTicket(){
    return FutureBuilder(
      future: DBProvider.db.getDashCurrentTickets(),
      builder: (BuildContext context,snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }else{
          if(snapshot.hasData){
            print("snap:"+snapshot.data.toString());
            if(snapshot.data.length==0){
              return Text('');
            }
            else if(snapshot.data.length==1){
              height=MediaQuery.of(context).size.height/4;
            }
            else{
              height=MediaQuery.of(context).size.height*1.1/2;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,top: 20),
                  child: Text("Current Tickets(${snapshot.data.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,),),
                ),

                Padding(padding: EdgeInsets.only(left: 10,top: 5,right: 10),
                  //color: AppTheme.white,
                  child:Container(
                    height: height,
                    child:ListView.separated(
                      separatorBuilder: (context, index)=> Divider(),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: () =>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClientTicketDetils(id:snapshot.data[index].id,
                              ticketNo: snapshot.data[index].ticketno,title: snapshot.data[index].title,des: snapshot.data[index].description,tag: snapshot.data[index].tags,)),
                          ),
                          child: Container(
                              height: MediaQuery.of(context).size.height/4,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child:ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  title: Text(
                                    "Ticket No",
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
                              )

                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
                Divider(),
                new Padding(
                    padding: EdgeInsets.only(right: 20),
                    child:Align(
                        alignment: Alignment.centerRight,
                        child: new GestureDetector(
                          onTap:()=> _showSnackBar(context,"No Ticket yet"),
                          child: new Text("View All",style: TextStyle(color:Colors.blue,fontSize: 15.0,decoration: TextDecoration.underline,),),
                        )
                    )
                ),
              ],
            );
          }
          else{
            return Text("No current Ticket");
          }
        }
      },
    );
  }


  Widget newTicketItem(){
    return FutureBuilder(
      future: DBProvider.db.getDashNewTickets(),
      builder: (BuildContext context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }else{
          if(snapshot.hasData){

            //print(snapshot.data.toString());
            if(snapshot.data.length==0){
              return Text("");
            }
            else if(snapshot.data.length==1){
              heightN=MediaQuery.of(context).size.height/4;
            }
            else{
              heightN=MediaQuery.of(context).size.height*1.1/2;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,top: 20),
                  child: Text("New Tickets(${snapshot.data.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,),),
                ),

                Padding(padding: EdgeInsets.only(left: 10,top: 5,right: 10),
                  //color: AppTheme.white,
                  child:Container(
                    height: heightN,
                    child:ListView.separated(
                      separatorBuilder: (context, index)=> Divider(),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: () =>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OnlyNewTicketDetails(ticketNo: snapshot.data[index].ticketno,title: snapshot.data[index].title,
                                des: snapshot.data[index].description,tag: snapshot.data[index].tags)),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height/4,

                            child: Padding(
                                padding: EdgeInsets.all(5),
                                   child:ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                                    title: Text(
                                      "Ticket No",
                                      style: TextStyle(
                                          color:Color(0xff7092be),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    subtitle: Container(
                                      child: Column(
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
                                                      color: Colors.blue
                                                  ),
                                                  child:Padding(
                                                      padding: EdgeInsets.all(5),
                                                      child:Text(
                                                        " New ",
                                                        style: TextStyle(fontSize: 14.0,color: Colors.black),
                                                      )))),
                                        ],
                                      ),
                                    )
                                )
                            )
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
                Divider(),
                new Padding(
                    padding: EdgeInsets.only(right: 20),
                    child:Align(
                        alignment: Alignment.centerRight,
                        child: new GestureDetector(
                          onTap:()=> _showSnackBar(context,"No Ticket yet"),
                          child: new Text("View All",style: TextStyle(color:Colors.blue,fontSize: 15.0,decoration: TextDecoration.underline,),),
                        )
                    )
                ),
              ],
            );
          }
          else{
            return Center(child:Text("No New Ticket available"));
          }
        }
      },
    );

  }

  Widget closeTicketItem(){
    return FutureBuilder(
      future: getCloseTicket(),
      builder: (_,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {

          return Center(child: CircularProgressIndicator(),);
        }else{
          if(snapshot.hasData){
            print(snapshot.data.toString());
            if(snapshot.data.length==0){
              return Text('');
            }
            else if(snapshot.data.length==1){
              heightCl=155.0;
            }
            else{
              heightCl=310.0;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,top: 20),
                  child: Text("Close Tickets(${snapshot.data.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,),),
                ),

                Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                  //color: AppTheme.white,
                  child:Container(
                    height: heightCl,
                    child:ListView.builder(
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
                            MaterialPageRoute(builder: (context) => ClientTicketDetils(id:newTicketModel.id,ticketNo: newTicketModel.ticketno,)),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height/6,

                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child:ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  title: Text(
                                    "Ticket No",
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
                                                  color: Colors.red
                                              ),
                                              child:Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child:Text(
                                                    " Close ",
                                                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                                                  )))),
                                    ],
                                  ),
                                )
                                ),
                                Divider()
                              ],
                            )
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),

                new Padding(
                    padding: EdgeInsets.only(right: 20),
                    child:Align(
                        alignment: Alignment.centerRight,
                        child: new GestureDetector(
                          onTap:()=> _showSnackBar(context,"No Ticket yet"),
                          child: new Text("View All",style: TextStyle(color:Colors.blue,fontSize: 15.0,decoration: TextDecoration.underline,),),
                        )
                    )
                ),
              ],
            );
          }
          else{
            return Text("No Close Ticket");
          }
        }
      },
    );
  }

  Widget cancelTicketItem(){
    return FutureBuilder(
      future: getCancelTicket(),
      builder: (_,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }else{
          if(snapshot.hasData){
            print(snapshot.data.toString());
            if(snapshot.data.length==0){
              return Text('');
            }else if(snapshot.data.length==1){
              heightCa=155.0;
            }
            else{
              heightCa=310.0;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,top: 20),
                  child: Text("Cancel Tickets(${snapshot.data.length.toString()}) ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,),),
                ),

                Padding(padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                  //color: AppTheme.white,
                  child:Container(
                    height: heightCa,
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
                            MaterialPageRoute(builder: (context) => ClientTicketDetils(id:newTicketModel.id,ticketNo: newTicketModel.ticketno,)),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height/6,

                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  title: Text(
                                    "Ticket No",
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
                                                  color: Colors.red
                                              ),
                                              child:Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child:Text(
                                                    " Close ",
                                                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                                                  )))),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),

                new Padding(
                    padding: EdgeInsets.only(right: 20),
                    child:Align(
                        alignment: Alignment.centerRight,
                        child: new GestureDetector(
                          onTap:()=> _showSnackBar(context,"No Ticket yet"),
                          child: new Text("View All",style: TextStyle(color:Colors.blue,fontSize: 15.0,decoration: TextDecoration.underline,),),
                        )
                    )
                ),
              ],
            );
          }
          else{
            return Text("No Cancel Ticket");
          }
        }
      },
    );
  }



  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
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