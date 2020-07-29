
import 'package:brainhouse_i/model/Ticket.dart';
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ExpertCloseTickets extends StatefulWidget {
  @override
  _ExpertCloseTicketsState createState() => _ExpertCloseTicketsState();
}

class _ExpertCloseTicketsState extends State<ExpertCloseTickets> {

  final String TicketUrl="https://brainhouse.net/apiv2/tickets";
  String token;

  SharedPreferences sharedPreferences;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
    Response response = await dio.get("/4",queryParameters:{"limit":20,"offset":0} );
    //final Map<String, dynamic> responseDataArchive=json.decode(response.data);
    return response.data['data']['tickets'];
    // print(archive.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    getCloseTicket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: getCloseTicket(),
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
                      Ticket newTicketModel=Ticket(
                        id:snapshot.data[index]['id'] ,
                        ticketno: snapshot.data[index]['ticketno'],
                        title: snapshot.data[index]['detail']['title'] ,
                        cost: snapshot.data[index]['detail']['cost'],
                        tags: snapshot.data[index]['detail']['tags'],
                        serviceid: snapshot.data[index]['detail']['serviceid'],
                        description: snapshot.data[index]['detail']['description'],
                      );
                      return GestureDetector(
                        onTap: () =>print("closeTicketDtails"),/*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExpertTicketDetils(id:newTicketModel.id,ticketNo: newTicketModel.ticketno)),
                        ),*/
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
                return Text("No Close Ticket");
              }
            }
          },
        )
    );
  }


}
