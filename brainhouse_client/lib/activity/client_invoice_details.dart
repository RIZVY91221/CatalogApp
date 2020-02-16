import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientInvoiceDetails extends StatelessWidget {
  final int serviceRate;
  final String serviceHour;
  final String totalBill;
  final String billiingDate;
  final String invoiceNumber;
  final String expertName;
  final String clientCompanyName;
  final String clientWebAddress;
  final String ticketJobTitle;

  ClientInvoiceDetails(
      {this.serviceRate,
        this.serviceHour,
        this.totalBill,
        this.billiingDate,
        this.invoiceNumber,
        this.expertName,
        this.clientCompanyName,
        this.clientWebAddress,
        this.ticketJobTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(
          "Invoice Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "BrainHouse",
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bh,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Invoice# " + invoiceNumber,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text("Date: " + billiingDate),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
                child: Row(
                  children: <Widget>[
                    Text("Status: "),
                    Card(
                      elevation: 5.5,
                      child: Text(
                        "Paid",
                        style: TextStyle(
                            backgroundColor: Colors.lightGreen,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Bill To ",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.double),
                        ),
                        Text(
                          "Dead By " + clientCompanyName,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          "House #32,Sectot #3,Uttora",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          clientWebAddress,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Bill From ",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.double),
                        ),
                        Text(
                          expertName,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          "Nhikonja-2,Khilkhat,Dhaka",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          clientWebAddress,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Job Title ",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.double),
                    ),
                    Text(ticketJobTitle,
                        style: TextStyle(fontStyle: FontStyle.italic))
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 31.0,
                          color:AppTheme.bh,
                          child: Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              verticalInside: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  "Billing Hour",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  "Billing Rate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  "Total Bill",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ])
                            ],
                          ),
                        ),
                        Container(
                          height: 31.0,
                          color: AppTheme.nearlyWhite,
                          child: Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              verticalInside: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  serviceHour,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.nearlyBlack,
                                      fontSize: 17),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  serviceRate.toString() + " /h",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.nearlyBlack,
                                      fontSize: 17),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                ),
                                Text(
                                  totalBill + " \$",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.nearlyBlack,
                                      fontSize: 17),
                                ),
                              ])
                            ],
                          ),
                        ),
                      ])),
              Padding(
                  padding: EdgeInsets.only(top: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Card(
                          child: Container(
                            width: 75,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.8),
                            ),
                            child: RaisedButton(
                              focusElevation: 6.6,
                              onPressed: () => null,
                              elevation: 5.5,
                              color: AppTheme.bh,
                              child: Text(
                                "Pay",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ))
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
