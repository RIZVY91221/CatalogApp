import 'package:attendenceapp/Activity/LoginPage.dart';
import 'package:attendenceapp/AppTheme/Apptheme.dart';
import 'package:attendenceapp/page/attendenceScreen.dart';
import 'package:attendenceapp/page/taskScreen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DashboardPage extends StatefulWidget {
  final String fullName;
  final String username;
  final String postName;
  final String uid;

  DashboardPage({this.fullName, this.username, this.postName,this.uid});

  @override
  _DashboardPageState createState() => _DashboardPageState(fullName: fullName,username: username,postName: postName,uid: uid);
}

class _DashboardPageState extends State<DashboardPage> {
  final String fullName;
  final String username;
  final String postName;
  final String uid;

  _DashboardPageState({this.fullName, this.username, this.postName, this.uid});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<String> images = [
    'assets/images/attendence.png',
    'assets/images/task.png',
    'assets/images/person.png',
    'assets/images/settings.png'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            backgroundColor: AppTheme.nearlyWhite,
            elevation: 0,
            centerTitle: true,
            title: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("DASHBOARD", style: TextStyle(
                    color: AppTheme.nearlyBlack, fontSize: 18.0),)),

            iconTheme: IconThemeData(color: AppTheme.grey),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],

          )),
      body:ListView(
        children: <Widget>[
          customHeader(),
          SizedBox(height: 100,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customButton(images[0], "ATTENDENCE"),
                  customButton(images[1], "TASK")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customButton(images[2], "PROFILE"),
                  customButton(images[3], "SETTINGS")
                ],
              )
            ],
          ),
        ],
    )
    );
  }
  Widget customHeader(){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0,horizontal:0
      ),
      child: Material(
        color:AppTheme.nearlyWhite,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(0.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "Welcome \n        Mr "+fullName,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
                ),

              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10
                ),
                child: Material(
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    // changing from 200 to 150 as to look better
                    height: 60.0,
                    width: 60.0,
                    child: ClipOval(
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://api.adorable.io/avatars/285/rizvyahamed2015@gmail.com.png')
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(String image,String name){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: InkWell(
        onTap: (){
         if(name=='ATTENDENCE'){
           Navigator.push(
               context,
               new MaterialPageRoute(
                   builder: (BuildContext context) =>
                   AttendenceScreen(fullName: fullName,username: username,uid: uid,postName: postName,)));
         }else if(name=='TASK'){
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) =>
                       TaskScreen()));
         }else if(name=='PROFILE'){
           Fluttertoast.showToast(
               msg: "Profile Not created yet",
               toastLength: Toast.LENGTH_LONG,
               gravity: ToastGravity.BOTTOM,
               backgroundColor: Colors.green,
               textColor: Colors.white,
               fontSize: 16.0
           );
         }
         else{
           Fluttertoast.showToast(
               msg: "Setting Not ready yet",
               toastLength: Toast.LENGTH_LONG,
               gravity: ToastGravity.BOTTOM,
               backgroundColor: Colors.green,
               textColor: Colors.white,
               fontSize: 16.0
           );
         }
        },
        child: Material(
          color: AppTheme.bhb,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            height: 165,
            width: 150,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      // changing from 200 to 150 as to look better
                      height: 120.0,
                      width: 120.0,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 /* Widget buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() => currentIndex = index);
      },
      children: <Widget>[
        AttendenceScreen(fullName: fullName,postName: postName,username: username,uid: uid,),
        TaskScreen()
      ],
    );
  }*/

  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        _signOut();
        break;
      case 'Settings':
        break;
    }
  }

  Future <LoginScreen> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen()), (
        Route<dynamic> route) => false);
  }
}
