import 'package:church_app/BackendQueries.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/models/NotificationInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<String>(
        future: FirebaseAuth.instance.currentUser?.getIdToken(true),
        builder: (context, token) => token.connectionState == ConnectionState.done ? FutureBuilder<List<NotificationInfo>>(
          future: BackendQueries.getAllNotifications(token.data ?? ""),
          builder: (context, snapshot) =>  snapshot.connectionState == ConnectionState.done ? ListView.separated(

            separatorBuilder: (_ , __ ) => Divider(height:1),itemBuilder: (context, index) => notificationContainer(snapshot.data?[index].title ?? "", snapshot.data?[index].body ?? ""),itemCount: snapshot.data?.length ?? 0) : Text("NO"),

        ) : CircularProgressIndicator(),
      )
    );
  }

  Widget notificationContainer(String head,String body){
    return ListTile(title: Text(head,style: TextStyle(fontSize: 20),),subtitle: Text(body),tileColor: Colors.lightBlueAccent,);
  }

}


