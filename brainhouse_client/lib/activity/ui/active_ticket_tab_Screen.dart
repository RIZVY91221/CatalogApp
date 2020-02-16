import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/model/demoTicket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientActiveTicketTab extends StatefulWidget {
  @override
  _ClientActiveTicketTabState createState() => _ClientActiveTicketTabState();
}

class _ClientActiveTicketTabState extends State<ClientActiveTicketTab> {
  static const String STATUS_WAITING_TO_ACCEPT = "Awaiting Acceptance";
  static final String STATUS_IN_PROGRESS = "In Progress";
  static final String STATUS_PAUSE = "Paused";
  static final String STATUS_PASS = "Passed";
  static final String STATUS_SUSPEND = "Suspended";
  static final String STATUS_EXPERT_CLOSED = "Requested for Closing";
  static final String STATUS_CLOSED = "Closed";

  List tickets = [
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: STATUS_CLOSED,
        lastStatus: "",
        skillGroupId: "AWS"),
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: STATUS_WAITING_TO_ACCEPT,
        lastStatus: "",
        skillGroupId: "AWS"),
    Ticket(
        ticketUID: "#brnhs2019010232-1234",
        companyName: "Vector It",
        jobDetail: "Need to configure NGINX web proxy server.",
        jobTitle: "AWS, Nginx",
        workRate: "10\$",
        currentHandler: "Rizvy Ahmed",
        createdAt: "23-01-2020",
        closedAt: "15-02-2020",
        status: STATUS_IN_PROGRESS,
        lastStatus:
        "Configuration file is configured and tested in stage server.",
        skillGroupId: "AWS"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body:Container(
        color: AppTheme.white,
        child: ListView.builder(
          itemCount: tickets.length,
          itemBuilder: _getItem,
        ),
      ),
    );
  }


  Widget _getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: null,
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.5)),
        child: Card(elevation: 5.5, child: makeListTitle(context, index)),
      ),
    );
  }
  Widget makeListTitle(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text(
        "Ticket No:#" + tickets[index].ticketUID,
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
          Text(tickets[index].jobDetail + "(" + tickets[index].jobTitle + ")"),
          SizedBox(
            height: 5,
          ),
          Text(
            tickets[index].companyName + " " + tickets[index].workRate + "/hr",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Status(tickets[index].status.toString(), index),
          )
        ],
      ),
    );
  }

  Status(String massege, int index) {
    if (tickets[index].status == STATUS_WAITING_TO_ACCEPT) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.cyanAccent,
          ),
          child:Text(
            massege,
            style: TextStyle(
                backgroundColor: Colors.cyanAccent,
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ));
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
  }
}