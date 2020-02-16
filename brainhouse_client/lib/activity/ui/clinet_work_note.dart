
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class TicketWorkNoteTab extends StatefulWidget {
  @override
  _TicketWorkNoteTabState createState() => _TicketWorkNoteTabState();
}

class _TicketWorkNoteTabState extends State<TicketWorkNoteTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: Text("WorkNote"),
      ),
    );
  }
}
