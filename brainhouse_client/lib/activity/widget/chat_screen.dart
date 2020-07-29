import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ChatScreen extends StatefulWidget {
  final String id;

  const ChatScreen({Key key, this.id}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState(id:id);
}

class _ChatScreenState extends State<ChatScreen> {
  final String id;

  _ChatScreenState({this.id});

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: "Fayeed",
    uid: "123456789",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
    var documentReference = Firestore.instance
        .collection('tickets').document(id).collection("conversation").document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });
    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child:StreamBuilder(
              stream: Firestore.instance.collection('tickets').document(id).collection("conversation").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> items = snapshot.data.documents;
                  var messages =
                  items.map((i) => ChatMessage.fromJson(i.data)).toList();
                  return Container(
                      child:DashChat(
                        height: MediaQuery.of(context).size.height*2.3/3,
                        key: _chatViewKey,
                        inverted: false,
                        onSend: onSend,
                        user: user,
                        inputDecoration:
                        InputDecoration.collapsed(hintText: "Add message here..."),
                        dateFormat: DateFormat('yyyy-MMM-dd'),
                        timeFormat: DateFormat('HH:mm'),
                        messages: messages,
                        showUserAvatar: true,
                        showAvatarForEveryMessage: false,
                        scrollToBottom: false,

                        onPressAvatar: (ChatUser user) {
                          print("OnPressAvatar: ${user.name}");
                        },
                        onLongPressAvatar: (ChatUser user) {
                          print("OnLongPressAvatar: ${user.name}");
                        },
                        inputMaxLines: 5,
                        messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                        alwaysShowSend: true,
                        inputTextStyle: TextStyle(fontSize: 16.0),
                        inputContainerStyle: BoxDecoration(
                          border: Border.all(width: 0.0),
                          color: Colors.white,
                        ),
                        onQuickReply: (Reply reply) {
                          setState(() {
                            messages.add(ChatMessage(
                                text: reply.value,
                                createdAt: DateTime.now(),
                                user: otherUser));

                            messages = [...messages];
                          });

                          Timer(Duration(milliseconds: 300), () {
                            _chatViewKey.currentState.scrollController
                              ..animateTo(
                                _chatViewKey.currentState.scrollController.position
                                    .maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );

                            if (i == 0) {
                              systemMessage();
                              Timer(Duration(milliseconds: 600), () {
                                systemMessage();
                              });
                            } else {
                              systemMessage();
                            }
                          });
                        },
                        onLoadEarlier: () {
                          print("laoding...");
                        },
                        shouldShowLoadEarlier: false,
                        showTraillingBeforeSend: false,
                        trailing: <Widget>[
                          IconButton(
                            icon: Icon(Icons.photo),
                            onPressed: () async {
                              File result = await ImagePicker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                                maxHeight: 400,
                                maxWidth: 400,
                              );

                              if (result != null) {
                                final StorageReference storageRef =
                                FirebaseStorage.instance.ref().child("chat_images");

                                StorageUploadTask uploadTask = storageRef.putFile(
                                  result,
                                  StorageMetadata(
                                    contentType: 'image/jpg',
                                  ),
                                );
                                StorageTaskSnapshot download =
                                await uploadTask.onComplete;

                                String url = await download.ref.getDownloadURL();

                                ChatMessage message =
                                ChatMessage(text: "", user: user, image: url);

                                var documentReference = Firestore.instance
                                    .collection('tickets').document(id).collection("conversation")
                                    .document(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString());

                                Firestore.instance.runTransaction((transaction) async {
                                  await transaction.set(
                                    documentReference,
                                    message.toJson(),
                                  );
                                });
                              }
                            },
                          )
                        ],
                      ));
                }
              })),
    );
  }
}