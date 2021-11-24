import 'package:church_app/models/message_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:church_app/backend_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_color.dart';

class MessegeScreen extends StatefulWidget {
  @override
  _MessegeScreenState createState() => _MessegeScreenState();
}

class _MessegeScreenState extends State<MessegeScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageInfo> messages = <MessageInfo>[];
  _buildMessage(MessageInfo message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:  EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),

        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
          borderRadius: isMe
              ? BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          )
              : BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.time,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
           SizedBox(height: 8.0),
            Text(
              message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    messages.add(new MessageInfo("prayerMsg".tr(), DateTime.now().toIso8601String(), false));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("prayer",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ListView.builder(itemBuilder: (context, index) => _buildMessage(messages[index],messages[index].isMe),itemCount: messages.length,)),
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  )),
            ),
            ElevatedButton(
                onPressed: () async {
                  await BackendQueries.createMessage(await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "",_messageController.text);
                  setState(() {
                    messages.add(new MessageInfo(_messageController.text, DateTime.now().toIso8601String(), true));
                  });
                },
                child: Text("send").tr(),
                style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor))
          ],
        ),
      ),
    );
  }
}
