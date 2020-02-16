
import 'package:brainhouse_client/activity/client_dashboard_page.dart';
import 'package:brainhouse_client/activity/client_login_page.dart';
import 'package:brainhouse_client/activity/client_profile_Page.dart';
import 'package:brainhouse_client/activity/client_ticket_page.dart';
import 'package:brainhouse_client/model/userInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  SharedPreferences sharedPreferences;
  String token;
  var responseBody;
  final String baseUrl = 'https://brainhouse.net/apiv2/user';

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<userInfo> getHttp() async {
    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/info");
    responseBody = response.data;
    return userInfo.fromJson(responseBody['data']['data']['profile']);
  }

  Future<imageUser> getHttpImage() async {
    getToken().then((value) {
      token = value;
    });
    var dio = await Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    }; //add your type of authentication
    // dio.options.contentType = ContentType.parse("application/json");
    Response response = await dio.get("/info");
    responseBody = response.data;
    return imageUser.fromJson(responseBody['data']['data']);
  }

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
    getHttp();
    getHttpImage();
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
          SizedBox(
            height: 100.0,
          ),
          _createDrawerItem(
            icon: Icons.dashboard,
            text: 'DASHBOARD',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientDashboard()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.person,
            text: 'PROFILE',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientMyProfile()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.receipt,
            text: 'TICKETS',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Ticket_Tab_bar()),
            ),
          ),
          _createDrawerItem(
              icon: Icons.power_settings_new,
              text: 'Logout',
              onTap: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => NewLoginPage()),
                    (Route<dynamic> route) => false);
              }),
          SizedBox(
            height: 220,
          ),
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
            colors: [Color(0xffffffff), Color(0xFFd4f4f9)],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Stack(children: <Widget>[image(), nameText()]));
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

  Widget nameText() {
    Widget name = new Positioned(
      bottom: 12.0,
      left: 16.0,
      child: FutureBuilder<userInfo>(
        future: getHttp(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                snapshot.data.firstname.toString() +
                    " " +
                    snapshot.data.lastname.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500));
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new CircularProgressIndicator();
        },
      ),
    );
    return name;
  }

  Widget image() {
    Widget image = new Positioned(
      top: 20.0,
      left: 16.0,
      child: FutureBuilder<imageUser>(
        future: getHttpImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(snapshot.data.avatar),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new CircularProgressIndicator();
        },
      ),
    );
    return image;
  }
}

class imageUser {
  String avatar;

  imageUser({this.avatar});

  imageUser.fromJson(Map<String, dynamic> map) : avatar = map['avatar'];
}
