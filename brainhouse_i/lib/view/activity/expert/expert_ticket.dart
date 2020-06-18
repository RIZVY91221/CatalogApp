import 'package:brainhouse_i/view/activity/expert/expert_ticket_tab_bar.dart';
import 'package:flutter/material.dart';

class CustomTabApp extends MaterialApp {
  CustomTabApp()
      : super(
    debugShowCheckedModeBanner: false,
    title: 'Tickets',
    home: Ticket_Tab_bar(),
    theme: appTheme,
  );
}
final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.blueAccent,
);
