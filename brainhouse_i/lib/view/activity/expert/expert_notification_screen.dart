
import 'package:brainhouse_i/model/notification.dart';
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:flutter/material.dart';

class ExpertNotification extends StatefulWidget {
  @override
  _ExpertNotificationState createState() => _ExpertNotificationState();
}

class _ExpertNotificationState extends State<ExpertNotification> {

   List notify=[
    NotificationModel(ntfName:"Steve Munush",ntfDes:"Add your as a connection",ntfDuration:"27 minute ago"),
    NotificationModel(ntfName:"Steve Munush",ntfDes:"Add your as a connection",ntfDuration:"27 minute ago"),
    NotificationModel(ntfName:"Steve Munush",ntfDes:"Add your as a connection",ntfDuration:"27 minute ago")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Notifications",style: TextStyle(color: AppTheme.nearlyBlack),),
        backgroundColor: AppTheme.nearlyWhite,
      ),
      body:Container(
        color: AppTheme.white,
        child: ListView.builder(
          itemCount: notify.length,
          itemBuilder: _getItem,

        ),
      ),
    );
  }

  Widget _getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => null,
      child: Container(
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.5)),
         child: makeListTitle(context, index),
      ),
    );
  }

  Widget makeListTitle(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      leading: CircleAvatar(
        backgroundImage:AssetImage("assets/images/as.png"),
        radius: 30,
      ),
      title: Text(
        notify[index].ntfName,
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
            padding: EdgeInsets.only(top: 3.0),
          ),
          Text(notify[index].ntfDes),
          SizedBox(
            height: 5,
          ),
          Text(
           notify[index].ntfDuration,
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
