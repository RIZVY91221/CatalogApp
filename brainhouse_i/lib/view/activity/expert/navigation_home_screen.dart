
import 'package:brainhouse_i/provider/ticket_DB_Provider.dart';
import 'package:brainhouse_i/view/activity/expert/NewLoginPage.dart';
import 'package:brainhouse_i/view/activity/expert/expert_dashboard_screen.dart';
import 'package:brainhouse_i/view/activity/expert/expert_my_profile_nav.dart';
import 'package:brainhouse_i/view/activity/expert/expert_ticket_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  final String fName,lName,avatar;


  NavDrawer({this.fName, this.lName, this.avatar});

  @override
  _NavDrawerState createState() => _NavDrawerState(fName: fName,lName: lName,avatar: avatar);
}

class _NavDrawerState extends State<NavDrawer> {
  final String fName,lName,avatar;
  int index;

  _NavDrawerState({this.fName, this.lName, this.avatar});

  SharedPreferences sharedPreferences;
  String token;

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => NewLoginPage()),
              (Route<dynamic> route) => false);
    }
    return sharedPreferences.getString("token");
  }
  
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        children: <Widget>[
          _createHeader(),

          SizedBox(height: 100.0,),
          _createDrawerItem(
            icon: Icons.dashboard,
            text: 'DASHBOARD',
            onTap:()=>Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpertDashboard()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.person,
            text: 'PROFILE',
            onTap: ()=>Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>ExpertMyProfile ()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.receipt,
            text: 'TICKETS',
            onTap: ()=>Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Ticket_Tab_bar()),
            ),
          ),
          _createDrawerItem(
              icon: Icons.power_settings_new,
              text: 'Logout',
              onTap: (){
                checkLoginStatus().then((_){
                  sharedPreferences.clear();
                  sharedPreferences.commit();
                  DBProvider.db.deleteAllDashCurrentTicket();
                  DBProvider.db.deleteAllCurrentTicket();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => NewLoginPage()),
                          (Route<dynamic> route) => false);
                });


              }
          ),
          SizedBox(height: 220,),
          ListTile(
            title: Text('version:0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffffffff),  Color(0xFFd4f4f9)],
            tileMode: TileMode.repeated,
          ),),
        child: Stack(children: <Widget>[
          image(),
          nameText(),
        ]));
  }
  Widget nameText() {
    Widget name = new Positioned(
      bottom: 12.0,
      left: 16.0,
      child: Text(
         fName.toString()+lName.toString(),
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500))
    );
    return name;
  }
  Widget image() {
    Widget image = new Positioned(
      top: 20.0,
      left: 16.0,
      child: CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(avatar.toString()),
      )
    );
    return image;
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );

  }
}


