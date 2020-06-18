
import 'package:brainhouse_i/model/Invoices.dart';
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/activity/expert/expert_invoice_details.dart';
import 'package:flutter/material.dart';

class ExpertInvoice extends StatefulWidget {
  @override
  _ExpertInvoiceState createState() => _ExpertInvoiceState();
}

class _ExpertInvoiceState extends State<ExpertInvoice> {

  List invoiceData=[Invoice(serviceRate: 125,serviceHour: "16",totalBill: "192",invoiceNumber: "153uMsdSjujuO",expertName: "Rizvy Ahmed",clientWebAddress: "db@gmail.com",clientCompanyName: "Vector It",ticketJobTitle: "Need To Solve Python",billiingDate: "October13,2019"),
    Invoice(serviceRate: 125,serviceHour: "16",totalBill: "192",invoiceNumber: "13uMsXyzO",expertName: "Rizvy Ahmed",clientWebAddress: "db@gmail.com",clientCompanyName: "Vector It",ticketJobTitle: "Need To Solve java",billiingDate: "October13,2019"),
    Invoice(serviceRate: 125,serviceHour: "16",totalBill: "192",invoiceNumber: "16uMsSxjujuO",expertName: "Rizvy Ahmed",clientWebAddress: "db@gmail.com",clientCompanyName: "Vector It",ticketJobTitle: "Need To Solve Aws Need To Solve Aws",billiingDate: "October13,2019"),
    Invoice(serviceRate: 125,serviceHour: "16",totalBill: "192",invoiceNumber: "17cUuMsSjujuO",expertName: "Rizvy Ahmed",clientWebAddress: "db@gmail.com",clientCompanyName: "Vector It",ticketJobTitle: "Need To Solve java Need To Solve java",billiingDate: "October13,2019")];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      body:Container(
        color: AppTheme.white,
        child: ListView.builder(
          itemCount: invoiceData.length,
            itemBuilder: _getItem,),
      ) ,
    );
  }

  Widget _getItem(BuildContext context ,int index){
    return GestureDetector(
      onTap: ()=>Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExpertInvoiceDetails(
              serviceRate:invoiceData[index].serviceRate
              ,serviceHour: invoiceData[index].serviceHour,
              totalBill: invoiceData[index].totalBill,
            invoiceNumber: invoiceData[index].invoiceNumber,
            expertName: invoiceData[index].expertName,
            clientWebAddress: invoiceData[index].clientWebAddress,
              clientCompanyName: invoiceData[index].clientCompanyName,
              ticketJobTitle: invoiceData[index].ticketJobTitle,
              billiingDate: invoiceData[index].billiingDate
            )),
      ),
      child:  Container(
        height: 130.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.5)
        ),
        child: Card(
            elevation: 5.5,
            child: makeListTitle(context, index)
        ),
      ),
    );
  }

  Widget makeListTitle(BuildContext context,int index){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      title: Text("Invoice#"+invoiceData[index].invoiceNumber,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w800),),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 8.0),),
          Text("Billing date: "+invoiceData[index].billiingDate),
          SizedBox(height: 5,),
          Text("Title: "+invoiceData[index].ticketJobTitle,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),
          Text("Total Bill: "+invoiceData[index].totalBill+" \$",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),)
        ],
      ),
      );
  }

}
