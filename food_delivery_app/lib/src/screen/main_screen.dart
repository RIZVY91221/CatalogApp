import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/pages/favorite_page.dart';
import 'package:food_delivery_app/src/pages/home_page.dart';
import 'package:food_delivery_app/src/pages/order_page.dart';
import 'package:food_delivery_app/src/pages/profile_page.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentTab=0;
  HomePage homePage;

  Widget currentPage;
  List<Widget> pages;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        Order(),
        Favorite(),
        Profile()
      ],
    );
  }

  @override
  void initState() {
//    homePage=HomePage();
//    pages=[homePage];
//    currentPage=homePage;
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      currentTab = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentTab,
        itemCornerRadius: 20,
        showElevation: true,
        onItemSelected: (index){
          setState(() {
            bottomTapped(index);

          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home,color: Colors.green),
            title: Text("Home",style: TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,color: Colors.black),),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.shopping_cart,color: Colors.green),
              title: Text("Order",style: TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,color: Colors.black),),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.favorite_border,color: Colors.green,),
              title: Text("Favorite",style: TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,color: Colors.black),),
            activeColor: Colors.pink
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.person,color: Colors.green,),
              title: Text("Profile",style: TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,color: Colors.black),),
            activeColor: Colors.blue
          ),

        ],
      ),
      body: buildPageView(),
    );
  }
}
