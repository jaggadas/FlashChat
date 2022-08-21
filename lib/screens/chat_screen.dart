import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat Room'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email,'timestamp':FieldValue.serverTimestamp()});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;

        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = loggedInUser.email;
          if (currentUser == messageSender) {}
          final messageWidget = MessageBubble(
            messageSender: messageSender,
            messageText: messageText,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }

        return Expanded(
            child: ListView(reverse: true,
          children: messageWidgets,
        ));
      },
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final messageText;
  final messageSender;
  final isMe;
  MessageBubble({this.messageText, this.messageSender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
              color: isMe?Colors.lightBlueAccent:Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: isMe?Radius.circular(30):Radius.circular(0),
                  topRight: isMe?Radius.circular(0):Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$messageText',
                  style: TextStyle(color: isMe?Colors.white:Colors.black87, fontSize: 15),
                ),
              )),
        ],
      ),
    );
  }
}
