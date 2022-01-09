import 'package:church_app/models/message_info.dart';
import 'package:church_app/models/user_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:church_app/backend/backend_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_color.dart';

class MessegeScreen extends StatefulWidget {
  @override
  _MessegeScreenState createState() => _MessegeScreenState();
}

class _MessegeScreenState extends State<MessegeScreen> {
  final TextEditingController _messageController = TextEditingController();

  List<String> messages = ["prayerMsg".tr()];
  _buildMessage(String message, bool isMe) {
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

           SizedBox(height: 8.0),
            Text(
              message,
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


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: AppColor.PrimaryColor),onPressed: () => Navigator.pop(context)),
          title: const Text("prayer",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )).tr(),
          elevation: 0,
          backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: context.read<User?>()?.getIdToken(),
          builder: (context, token) => token.hasData ? Column(
            children: [
              Expanded(child:  FutureBuilder<UserModel>(
                  future: BackendQueries.getUserInfo(token.data ?? ""),
                  builder: (context, snapshot) => snapshot.hasData ? ListView.builder(itemBuilder: (context, index) => _buildMessage(snapshot.data?.messages[index].replaceFirst("Me:", "") ?? "",(snapshot.data!.messages[index].contains("Me:") ? true : false)),itemCount: snapshot.data?.messages.length ?? 0,): Center(child: CircularProgressIndicator())) ,
              ),
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
                    await BackendQueries.createMessage(await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "","Me: ${_messageController.text}");
                    setState(() {
                      messages.add(_messageController.text);
                      _messageController.text = "";
                    });
                  },
                  child: Text("send").tr(),
                  style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor))
            ],
          ) : Center(child: Text("Please Login to chat with KDEC Radio"),),
        ),
      ),
    );
  }
}
