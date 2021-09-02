import 'dart:convert';

import 'package:church_app/BackendQueries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';

class MessegeScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Message",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TextField(
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  )),
            )),
            ElevatedButton(
                onPressed: () async {
                  await BackendQueries.createMessage(await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? "",_messageController.text);
                },
                child: Text("Send"),
                style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor))
          ],
        ),
      ),
    );
  }
}
