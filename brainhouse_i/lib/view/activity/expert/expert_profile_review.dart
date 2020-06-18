import 'package:flutter/material.dart';
class ReviewProfile extends StatefulWidget {
  @override
  _ReviewProfileState createState() => _ReviewProfileState();
}

class _ReviewProfileState extends State<ReviewProfile>with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Text("Review")
      ),
    );
  }
}
