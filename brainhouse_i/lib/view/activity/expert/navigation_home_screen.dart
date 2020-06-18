
import 'package:brainhouse_i/view/activity/expert/NewLoginPage.dart';
import 'package:brainhouse_i/view/activity/expert/expert_dashboard_screen.dart';
import 'package:brainhouse_i/view/activity/expert/expert_my_profile_nav.dart';
import 'package:brainhouse_i/view/activity/expert/expert_ticket_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  SharedPreferences sharedPreferences;


  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => NewLoginPage()),
              (Route<dynamic> route) => false);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    checkLoginStatus();
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
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => NewLoginPage()),
                        (Route<dynamic> route) => false);
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
          Positioned(
            top: 20.0,
            left: 16.0,
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                  'assets/images/as.png'),
            ),
          ),
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Christopher Hemsworth",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500))),
        ]));
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

