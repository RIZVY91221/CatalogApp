
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class TicketWorkNoteTab extends StatefulWidget {
  final String ticketNo;
  final String ticketId;
  TicketWorkNoteTab({this.ticketId,this.ticketNo});

  @override
  _TicketWorkNoteTabState createState() => _TicketWorkNoteTabState(ticketNo: ticketNo,ticketId: ticketId);
}

class _TicketWorkNoteTabState extends State<TicketWorkNoteTab> with WidgetsBindingObserver {

  final String ticketNo;
  final String ticketId;
  var temFile;
  bool isTitle=false;
  String fileName;
  bool downloading = false;
  var progressString = "";
  final TextEditingController titleController=TextEditingController();
  final TextEditingController desController=TextEditingController();
  ReceivePort _port = ReceivePort();

  static var uuid = Uuid();
  var uidWork=uuid.v4(options: {
    'rng': UuidUtil.cryptoRNG
  });
  static  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);


  _TicketWorkNoteTabState({this.ticketId,this.ticketNo});

  ScrollController scrollController;
  bool dialVisible = true;


  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  @override
  void initState(){
    // TODO: implement initState
    getWork();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
//    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
//    _port.listen((dynamic data) {
//      String id = data[0];
//      DownloadTaskStatus status = data[1];
//      int progress = data[2];
//      setState((){ });
//    });
    FlutterDownloader.initialize();
    //FlutterDownloader.registerCallback(downloadCallback);
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
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  createWork(String title,String des,String time)async{
    DocumentReference ds=Firestore.instance.collection('tickets').document(ticketId).collection('worknote').document(uidWork);
    Map<String,dynamic> tasks={
      "title":title,
      "description":des,
      "time":time
    };

    ds.setData(tasks).whenComplete((){
      print("task updated");
    });
  }
  Future getWork()async{
    var firestore=Firestore.instance;
    QuerySnapshot qn =await firestore.collection('tickets').document(ticketId).collection('worknote').getDocuments();
    print(qn.documents.toString());
    return qn.documents;
  }

  Future getfileAndUpload()async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    fileName = '${randomName}.pdf';
    setState(() {
      temFile=fileName;
    });
    print(fileName);
    print('${file.readAsBytesSync()}');
    savePdf(file.readAsBytesSync(), fileName);
  }
  Future savePdf(List<int> asset, String name) async {

    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url,formattedDate,fileName);
    return  url;
  }
  void documentFileUpload(String str,String time,String fineName) {

    DocumentReference ds=Firestore.instance.collection('tickets').document(ticketId).collection('worknote').document(uidWork);
    Map<String,dynamic> tasks={
      "fileName":fileName,
      "attachment":str,
      "time":time
    };

    ds.setData(tasks).whenComplete((){
      print("task updated");
    });
  }

  Future<bool> checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
   inti(String url,String file) async {
    await checkPermission();
    final directory = await getExternalStorageDirectory();
    FlutterDownloader.initialize();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      fileName:file ,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    FlutterDownloader.initialize();
    FlutterDownloader.registerCallback((id, status,progress) {
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
    });
    return taskId;
  }

  /*Future<void> downloadFile(String url,String file) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.toString());

      await dio.download(url, "${dir.path}/$file",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.white,
        floatingActionButton: buildSpeedDial(),
        body: Container(
          child: FutureBuilder(
              future: getWork(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                              onTap: () {
                                _showDialog(context, snapshot.data[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Container(
                                    height: MediaQuery.of(context).size.height/7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius
                                            .circular(20)),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(5),
                                            child:ListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,vertical: 5),
                                              title: Padding(
                                                  padding: EdgeInsets.only(left: 4),
                                                  child: textTitle(
                                                      snapshot.data[index])),
                                            )
                                        ),
                                        Divider()
                                      ],
                                    )
                                ),
                              )
                          );
                        });
                  }else{
                    return Center(child: Text("No Worksnote Available"),);
                  }
                }
              }
          ),
        )
    );
  }

  Widget textTitle(DocumentSnapshot post) {
    if (post.data['title'] == null) {
      return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
              padding: EdgeInsets.only(left: 1),
              child: Text(post.data['fileName'].toString(), style: TextStyle(
                  color: AppTheme.bhb,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800))),
          Padding(
              padding: EdgeInsets.only(left: 1), child: Row(
            children: <Widget>[
              Text(
                "Posted at: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
              Text(post.data['time'].toString(),style: TextStyle(fontSize: 12),),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal:1),
                  child: Container(
                      height: 30,
                      width: 60,
                      child:new OutlineButton(
                      child: Icon(Icons.cloud_download,color: AppTheme.bh,),
                      onPressed:(){
                        try{
                          //downloadFile(post.data['attachment'].toString(), post.data['fileName'].toString());
                          inti(post.data['attachment'].toString(),post.data['fileName'].toString());
                          ;
                        }catch(e){
                          e.toString();
                        }
                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
                  ))),
            ],))
        ],);
    } else {
      return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 1),
              child: Text(post.data['title'].toString(), style: TextStyle(
                  color: AppTheme.bhb,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800),)),
          Padding(
              padding: EdgeInsets.only(left: 1), child: Row(
            children: <Widget>[
              Text(
                "Posted at: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              Text(post.data['time'].toString(),style: TextStyle(fontSize: 12),)
            ],))

        ],
      );
    }
  }

  Widget destext(DocumentSnapshot post){
    if(post.data['description']==null){
      return null;
    }else{
      return Text(post.data['description'].toString());
    }
  }
  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.event_add,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.note_add, color: Colors.white),
          backgroundColor: AppTheme.bhb,
          onTap: () => _showDialogPost(context),
          label: 'WorkNote',
          labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
          labelBackgroundColor: AppTheme.bhb,
        ),
        SpeedDialChild(
          child: Icon(Icons.attachment, color: Colors.white),
          backgroundColor: AppTheme.bhb,
          onTap: () => _showFilePikerDialog(context),
          label: "Attached file here",
          labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
          labelBackgroundColor: AppTheme.bhb,
        ),
      ],
    );
  }
  Widget buildBody() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 30,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  /*void showSimpleCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 440.0,
        width: 400.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            ),
        child: Column(
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
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Add Work note",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
                child:Container(
                decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color:AppTheme.nearlyWhite,
                border: new Border.all(
                  color: AppTheme.bh,
                  width: 1.5,
                ),
              ),
              child: new TextField(
                controller:titleController,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
                decoration: new InputDecoration(
                  hintText: 'Add note title',
                  border: InputBorder.none,

                ),
              ),
            ) ),
            SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(left: 5.0,right: 5.0),
            child:Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color:AppTheme.nearlyWhite,
                border: new Border.all(
                  color: AppTheme.bh,
                  width: 1.5,
                ),
              ),
              child: new TextField(
                controller: desController,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 4700,
                decoration: new InputDecoration(
                  hintText: 'Enter your description here',
                  border: InputBorder.none,

                ),
              ),
            ) ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: AppTheme.bh,
                    onPressed: () {
                      //Navigator.of(context).pop();
                      createWork(titleController.text, desController.text, formattedDate);
                      titleController.clear();
                      desController.clear();
                      setState(() {
                        getWork();
                      });
                      Navigator.pop(context);

                    },
                    child: Text(
                      'Update',
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
                      'Cancel!',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }*/
  void _showDialogPost(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(

                child: new TextField(
                  controller:titleController,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                  decoration: new InputDecoration(
                    hintText: 'Add note title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                  ),
                ),
              ) ),
          content: Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(
                child: new TextField(
                  controller: desController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  maxLength: 4700,
                  decoration: new InputDecoration(
                    hintText: 'Enter your description here',

                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                  ),
                ),
              ) ),
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
                createWork(titleController.text, desController.text, formattedDate);
                titleController.clear();
                desController.clear();
                setState(() {
                  getWork();
                });
                Navigator.pop(context);

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
  void _showDialog(BuildContext context,DocumentSnapshot post) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: textTitle(post),
          content: destext(post),
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
                Navigator.pop(context);

              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  void _showFilePikerDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child:new OutlineButton(
              child: new Text("Chose file"),
              onPressed:(){
                try{
                  getfileAndUpload();
                  Navigator.of(context).pop();
                }catch(e){
                  e.toString();
                  print("excep"+e.toString());
                }
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  /*void showDetailsDialog(BuildContext context,DocumentSnapshot post) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
        child:Container(
        height: 450.0,
        width: 400.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child:Column(
         // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(
                  child:textTitle(post)
              ),) ,
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(
                  child:destext(post)
              ),) ,
                  SizedBox(height: 100,),
                  Align(
                    alignment: Alignment.bottomCenter,
                      child:FlatButton(
                    color: AppTheme.bh,
                    onPressed: () {
                      Navigator.pop(context);

                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  )),

          ],
        )),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }*/

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void showDialogFilePiker(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
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
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Add Work note Attachetment",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 15,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child:new OutlineButton(
                child: new Text("Chose file"),
                onPressed:(){
                  try{
                    getfileAndUpload();
                  }catch(e){
                    e.toString();
                    print("excep"+e.toString());
                  }
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
            ),),
            SizedBox(height: 15,),
            Padding(padding: EdgeInsets.only(left: 10),
            child: temFile==null?Text("no file select"):Text(temFile.toString()),)

          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }


}

