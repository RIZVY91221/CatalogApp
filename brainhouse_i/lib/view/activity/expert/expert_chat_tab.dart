
import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:brainhouse_i/view/ui/chat_screen.dart';
import 'package:flutter/material.dart';
class TicketChatAction extends StatefulWidget {
  @override
  _TicketChatActionState createState() => _TicketChatActionState();
}

class _TicketChatActionState extends State<TicketChatAction> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat",style:TextStyle(color: Colors.black),),
          backgroundColor: AppTheme.nearlyWhite,
          leading: IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: ChatScreen()
    );
  }
}
