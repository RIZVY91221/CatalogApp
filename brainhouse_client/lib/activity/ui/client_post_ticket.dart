

import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/client_dashboard_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PostTicket extends StatefulWidget {

  @override
  _PostTicketState createState() => _PostTicketState();
}

class _PostTicketState extends State<PostTicket> {


  SharedPreferences sharedPreferences;
  final String baseUrl="https://brainhouse.net/apiv2";
  var responseBody;
  bool isLoading=false;
  TextEditingController titleText=new TextEditingController();
  TextEditingController desText=new TextEditingController();
  TextEditingController costText=new TextEditingController();

  var tag ;
  String skillTag;
  String _value = "Select Service";
  String token;
  String _workinType = "Remote";
  int serviceId;
  List<String> _serviceCategory =
  ['Select Service','AWS','Google Cloud','Java','Azure'];

  List<String>workingType=[
    'Remote','onSite','Contract'
  ];

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<dynamic>postTicketUser(int Service_id,String ticketTags,String ticketTitle,String ticketDes,int status,String modality)async{
    getToken().then((value) {
      token = value;
    });

    Map ticket= {
      "serviceid": Service_id,
      "tags":ticketTags,
      "title":ticketTitle,
      "description":ticketDes,
      "status":status,
      "work_modality":modality

    };
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.post("/ticket",data: ticket);
    print(response);
    responseBody = response.data;
    if(responseBody!=null){

      setState(() {
        isLoading=false;
      });
      try{
        Fluttertoast.showToast(
            msg: "Ticket Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: AppTheme.bhb,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => ClientDashboard()), (
            Route<dynamic> route) => false);
      }catch(e){
        e.toString();
      }
    }
    else{
      setState(() {
        isLoading=false;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const mockResults = <SkillName>[
      SkillName('Aws'),
      SkillName('Java'),
      SkillName('Phython'),
      SkillName('Jquery'),
      SkillName('Flutter'),
    ];
    return Scaffold(
      body: isLoading?Center(child: CircularProgressIndicator(),):Container(
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15.0,),
                  Center(child: Text("Post a Ticket",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: AppTheme.bhb),),),
                  Padding(padding: EdgeInsets.only(left: 22,top: 20),
                    child: Text("Ticket Title",style: TextStyle(fontSize: 15,color: AppTheme.bhb),),),
                  Padding(padding: EdgeInsets.only(left: 10,top: 5),
                      child:Center(child:new Container(
                        width: MediaQuery.of(context).size.width*9/10,
                        child: new TextField(
                          controller:titleText,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                          decoration: new InputDecoration(
                            hintText: 'e.g Seniour product Designer',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(width: 1,style: BorderStyle.solid,color: AppTheme.bh)
                            ),

                          ),
                        ),
                      ) ,) ),
                  Padding(padding: EdgeInsets.only(left: 22,top: 20),
                    child: Text("Description",style: TextStyle(fontSize: 15,color:AppTheme.bhb),),),
                  Padding(padding: EdgeInsets.only(left: 10,top: 5),
                      child:Center(
                        child:new Container(
                          width: MediaQuery.of(context).size.width*9/10,
                          height: MediaQuery.of(context).size.width/2,
                          child: new TextField(
                            controller: desText,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            maxLength: 4700,
                            decoration: new InputDecoration(
                              hintText: 'Enter your description here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(width: 1,style: BorderStyle.solid,color: AppTheme.bh)
                              ),

                            ),
                          ),
                        ) ,) ),
                  Padding(padding: EdgeInsets.only(left: 22,top: 20),
                    child: Text("Service Category",style: TextStyle(fontSize: 15,color: AppTheme.bhb),),),
                  Padding(padding: EdgeInsets.only(left: 10,top: 5),
                      child:Center(
                        child:new Container(
                          width: MediaQuery.of(context).size.width*9/10,
                          height: MediaQuery.of(context).size.width*1.5/10,
                          child:DropdownButton<String>(
                            value: _value,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down,size: 30,color: AppTheme.bh,),
                            iconSize: 24,
                            elevation: 16,
                            hint: Text("Option1"),
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            onChanged: (String data) {
                              setState(() {
                                _value = data;
                                serviceId=_serviceCategory.indexOf(data);
                              });
                            },
                            items: _serviceCategory
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ) ,) ),


                  Padding(padding: EdgeInsets.only(left: 22,top: 20),
                    child: Text("Skills Required",style: TextStyle(fontSize: 15,color: AppTheme.bhb),),),
                  Padding(padding: EdgeInsets.only(left: 10,top: 5),
                      child:Center(child:new Container(
                        width: MediaQuery.of(context).size.width*9/10,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          border: new Border.all(
                            color: AppTheme.bhb,
                            width: 1.5,
                          ),
                        ),
                        child:ChipsInput(
                          initialValue: [
                            SkillName('Aws')
                          ],
                          keyboardAppearance: Brightness.dark,
                          textCapitalization: TextCapitalization.words,
                          enabled: true,
                          maxChips: 3,
                          textStyle:
                          TextStyle(height: 1.5, fontFamily: "Roboto", fontSize: 16),
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.search),
                            hintText: "add Skill",
                            //labelText: "Add Skill",
                            // enabled: false,
                            // errorText: field.errorText,
                          ),
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery = query.toLowerCase();
                              return mockResults.where((profile) {
                                return profile.name
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList(growable: false)
                                ..sort((a, b) => a.name
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)
                                    .compareTo(
                                    b.name.toLowerCase().indexOf(lowercaseQuery)));
                            }
                            return mockResults;
                          },
                          onChanged: (data) {
                            tag=data.toString();
                            setState(() {
                              tag=data;
                              skillTag=tag.join(',');
                              print(skillTag);
                            });

                          },
                          chipBuilder: (context, state, profile) {
                            return InputChip(
                              key: ObjectKey(profile),
                              label: Text(profile.name),
                              onDeleted: () => state.deleteChip(profile),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile.name),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ) ,) ),

                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20,left: 22),
              child: Text("Type of working time",style: TextStyle(fontSize: 15,color: AppTheme.bhb),),),
            Padding(padding: EdgeInsets.only(left: 22,top: 5,right: 80),
                child:new Container(
                  width: MediaQuery.of(context).size.width*2/5,
                  //height: MediaQuery.of(context).size.width/5,
                  decoration: new BoxDecoration(
                    /*shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: AppTheme.bh,
                                width: 1.5,
                              ),*/
                  ),
                  child:DropdownButton<String>(
                    value: _workinType,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,size: 30,color: AppTheme.bh,),
                    iconSize: 24,
                    //elevation: 16,
                    hint: Text("Option1"),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    onChanged: (String data) {
                      setState(() {
                        _workinType = data;
                      });
                    },
                    items: workingType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildPostTicketbtn(),
                _buildDraftbtn(),
                _buildResetbtn(),
              ],
            )
          ],
        ),
      ),

    );
  }

  Widget _buildPostTicketbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width*1.5/5,
      child: RaisedButton(
        elevation: 5.0,
        onPressed:titleText.text==" "||desText.text==" "?null:(){
          setState(() {
            isLoading=true;
          });
          postTicketUser(serviceId, skillTag, titleText.text, desText.text, 1,
              _workinType);

        },
       /* {
          print(titleText.text);
          print(desText.text);
          print(_workinType);
          print(serviceId);
          print(costText.text);


        },*/
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppTheme.bhb,
        child: Text(
          'Post Ticket',
          style: TextStyle(
            color: AppTheme.white,
            letterSpacing: 1.5,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildResetbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width*1.5/5,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ()=>print("postTicket"),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppTheme.nearlyWhite,
        child: Text(
          'Cancel',
          style: TextStyle(
            color: AppTheme.nearlyBlack,
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  Widget _buildDraftbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width*1.5/5,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: titleText.text==" "||desText.text==" "?null:(){
          setState(() {
            isLoading=true;
          });

          //postTicketUser(serviceId,titleText.text, desText.text, costText.text, _workinType);
          postTicketUser(serviceId, skillTag, titleText.text, desText.text,0 , _workinType);

        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppTheme.bh,
        child: Text(
          'Draft',
          style: TextStyle(
            color: AppTheme.white,
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  void _onChanged(List<SkillName> data) {
    print('onChanged $data');
  }

}

class SkillName{
  final String name;

  const SkillName(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SkillName &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }

}

