import 'dart:core';
import 'dart:math';

import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/model/demoTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ClientActiveTicketTab extends StatefulWidget {
  final String ticketUid;
  final String ticketId;

  ClientActiveTicketTab({this.ticketUid,this.ticketId});

  @override
  _ClientActiveTicketTabState createState() => _ClientActiveTicketTabState(ticketUid: ticketUid,ticketId: ticketId);
}

class _ClientActiveTicketTabState extends State<ClientActiveTicketTab> {

  final String ticketUid;
  final String ticketId;

  _ClientActiveTicketTabState({this.ticketUid,this.ticketId});

  bool submitting=false;
  var _priority;
  DocumentSnapshot _currentDocument;
  List<String>element1=[
    "High",
    "Medium",
    "Low"
  ];

  TextEditingController taskTitleController=TextEditingController();
  TextEditingController taskTimeController=TextEditingController();


  static var uuid = Uuid();
  var uidTask=uuid.v4(options: {
    'rng': UuidUtil.cryptoRNG
  });

  void taskUpload(String title,String duration,String taskPriority,String submittedBy,String submittedTo) {

    DocumentReference ds=Firestore.instance.collection('tickets').document(ticketId).collection('tasks').document(uidTask);
    Map<String,dynamic> tasks={
      "title":title,
      "task_duration":duration,
      "priority":taskPriority
    };
    Map<String,dynamic>finalTask={
      "submitted_by":submittedBy,
      "submitted_at":submittedTo,
      "task":tasks,
      "status": 1
    };


    ds.setData(finalTask).whenComplete((){
      print("task updated");
    });
  }

  Future getWork()async{
    var firestore=Firestore.instance;
    QuerySnapshot qn =await firestore.collection('tickets').document(ticketId).collection('tasks').getDocuments();
    print(qn.documents.toString());
    return qn.documents;
  }
  Future UpdateStatus(selectDoc,newValue){
    Firestore.instance.collection('tickets')
        .document(ticketId).collection('tasks').document(selectDoc).updateData(newValue).catchError((e){
          print(e.toString());
    });
  }
  @override
  void initState() {
    getWork();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      getWork();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.white,
        floatingActionButton: new FloatingActionButton(
            elevation: 5.0,
            child: new Icon(Icons.assignment),
            backgroundColor: AppTheme.bhb,
            onPressed: ()=>_showPostTaskDialog(context)
        ),
        body:Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            //color: AppTheme.white,
            child:FutureBuilder(
              future: getWork(),
              builder: (_,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }else{
                  if(snapshot.hasData){
                    return ListView.separated(
                      separatorBuilder: (context,index)=>Divider(),
                         itemCount: snapshot.data.length,
                         itemBuilder:(context, index) {
                           return GestureDetector(
                               child: Container(
                                 height: MediaQuery.of(context).size.height/8,
                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
                                    child: Slidable(
                                     actionPane: SlidableDrawerActionPane(),
                                     actionExtentRatio: 0.25,
                                     child: Container(
                                         //color: Colors.white,
                                         child: makeListTitle(snapshot.data[index]),),
                                     secondaryActions: <Widget>[
                                       IconSlideAction(
                                         caption: ' Doing ',
                                         color: Colors.deepOrange,
                                         icon: Icons.sync,
                                         onTap: () {
                                           try {
                                             setState(() {
                                               UpdateStatus(snapshot.data[index]
                                                   .documentID, {
                                                 'status': 2
                                               });
                                             });
                                           }catch(e){
                                             print(e.toString());
                                           }
                                         }
                                       ),
                                       IconSlideAction(
                                         caption: 'Done',
                                         color: AppTheme.bhb,
                                         icon: Icons.done_outline,
                                         onTap: () {
                                           try {
                                             setState(() {
                                               UpdateStatus(snapshot.data[index]
                                                   .documentID, {
                                                 'status': 3
                                               });
                                             });
                                           }catch(e){
                                             print(e.toString());
                                           }
                                         },
                                       ),
                                       IconSlideAction(
                                         caption: 'Cancel',
                                         color: AppTheme.bh,
                                         icon: Icons.cancel,
                                         onTap: () {
                                           try {
                                             setState(() {
                                               UpdateStatus(snapshot.data[index]
                                                   .documentID, {
                                                 'status': 4
                                               });
                                             });
                                           }catch(e){
                                             print(e.toString());
                                           }
                                         },
                                       ),

                                     ],
                                   ),

                                   )
                           );
                         }
                    );
                  }else{
                    return Center(child:Text("No task available"));
                  }
                }
              },
            )

          ),
        )
    );
  }


  Widget makeListTitle(DocumentSnapshot post) {
    return
        Padding(
          padding: EdgeInsets.all(5),
            child:ListTile(
          //contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          title: Text(
            post.data['task']['title'].toString(),
            style: TextStyle(
                color: Color(0xff7092be),
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Duration: " + post.data['task']['task_duration'].toString(),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
            ),
          ),
          leading: statusWork(post),
          trailing: Text(post.data['task']['priority'].toString()),
        ));

  }

  Widget statusWork(DocumentSnapshot post){
    if(post['status']==1){
        return Padding(
                padding: EdgeInsets.only(top: 5),
                child:Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue
                    ),
                    child:Padding(
                        padding: EdgeInsets.all(5),
                        child:Text(
                          " New ",
                          style: TextStyle(fontSize: 14.0,color: Colors.white),
                        ))));
    }else if(post['status']==2){
      return Padding(
              padding: EdgeInsets.only(top: 5),
              child:Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amberAccent
                  ),
                  child:Padding(
                      padding: EdgeInsets.all(5),
                      child:Text(
                        " Doing ",
                        style: TextStyle(fontSize: 14.0,color: Colors.white),
                      ))));
    }
    else if(post['status']==3){
      return Padding(
              padding: EdgeInsets.only(top: 5),
              child:Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green
                  ),
                  child:Padding(
                      padding: EdgeInsets.all(5),
                      child:Text(
                        " Done ",
                        style: TextStyle(fontSize: 14.0,color: Colors.white),
                      ))));
    }
    else if(post['status']==4){
      return Padding(
          padding: EdgeInsets.only(top: 5),
          child:Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red
              ),
              child:Padding(
                  padding: EdgeInsets.all(5),
                  child:Text(
                    " Cancel ",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ))));
    }
    else{
      return Card(
          elevation: 5.5,
          child: Container(
            color: Colors.cyan,
            child: Text(" No status ",style: TextStyle(color: Colors.white), ),
          )
      );
    }
  }
  Widget Workstatus(String title ){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: Colors.cyanAccent,
        ),
        child: Padding(padding: EdgeInsets.only(left: 10,right: 10),
          child:Text(
            title,
            style: TextStyle(
              //backgroundColor: Colors.cyanAccent,
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        )
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _showPostTaskDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: 20),
            child: TextField(
              controller:taskTitleController ,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  prefixIcon: Icon(Icons.title),
                  hintText: "Task title"
              ),
            ),
          ),
          content:Container(
            height: MediaQuery.of(context).size.height/5,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: TextField(
                    controller:taskTimeController ,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        prefixIcon: Icon(Icons.timeline),
                        hintText: "Task Duration"
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                    child:DropdownButton(
                      hint: _priority == null
                          ? Text('Select Priority')
                          : Text(
                        _priority,
                        style: TextStyle(color: Colors.blue),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items: ['High', 'Medium', 'Low'].map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            _priority = val;
                          },
                        );
                      },
                    )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              color: AppTheme.bh,
              onPressed: () {
                if(taskTitleController.text!=null || taskTimeController.text!=null){
                  taskUpload(taskTitleController.text, taskTimeController.text, _priority, "Client Name", "Expert_Name");
                }else{
                  print("Something Wrong");
                }
                setState(() {
                  getWork();
                });
                Navigator.of(context).pop();

              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  /*void showSimpleCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 400.0,
        width: 400.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                      padding:EdgeInsets.only(top:10),child:Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Add Task",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: TextField(
                    controller:taskTitleController ,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      prefixIcon: Icon(Icons.title),
                      hintText: "Task title"
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: TextField(
                    controller:taskTimeController ,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        prefixIcon: Icon(Icons.timeline),
                        hintText: "Task Duration"
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                  child:DropdownButton(
                    hint: _priority == null
                        ? Text('Select Priority')
                        : Text(
                      _priority,
                      style: TextStyle(color: Colors.blue),
                    ),
                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.blue),
                    items: ['High', 'Medium', 'Low'].map(
                          (val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(
                            () {
                          _priority = val;
                        },
                      );
                    },
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        color: AppTheme.bh,
                        onPressed: () {
                          if(taskTitleController.text!=null || taskTimeController.text!=null){
                            taskUpload(taskTitleController.text, taskTimeController.text, _priority, "Client Name", "Expert_Name");
                          }else{
                            print("Something Wrong");
                          }
                          setState(() {
                            getWork();
                          });
                          Navigator.of(context).pop();

                        },
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        color: AppTheme.bhb,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }*/
}
