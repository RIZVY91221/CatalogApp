
import 'package:brainhouse_i/model/Ticket.dart';
import 'package:brainhouse_i/provider/Ticket_Api_provider.dart';
import 'package:brainhouse_i/provider/ticket_DB_Provider.dart';
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_tickets_details.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpertActiveTicket extends StatefulWidget {
  @override
  _ExpertActiveTicketState createState() => _ExpertActiveTicketState();
}

class _ExpertActiveTicketState extends State<ExpertActiveTicket> {

  SharedPreferences sharedPreferences;
  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;
  bool isLoading=false;
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
      print(value.length.toString());
      if(value.length==0){
        _loadFromApi();
      }
      return;
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }else{
              if(snapshot.hasData){
                print(snapshot.data.toString());
                return Padding(padding: EdgeInsets.only(left: 10,top:10,right: 10),
                  //color: AppTheme.white,
                  child:ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){

                      return GestureDetector(
                        onTap: () =>Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExpertTicketDetils(id:snapshot.data[index].id,
                              ticketNo: snapshot.data[index].ticketno,title: snapshot.data[index].title,des: snapshot.data[index].description,tag: snapshot.data[index].tags)),
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
              }
              else{
                return Text("No current Ticket");
              }
            }
          },
        )
    );
  }


}
