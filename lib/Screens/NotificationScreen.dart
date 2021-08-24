import 'package:church_app/Widgets/PlaylistWidget.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.separated(

        separatorBuilder: (_ , __ ) => Divider(height:1),itemBuilder: (context, index) => notificationContainer("hi", "body"),itemCount: 50,)
    );
  }

  Widget notificationContainer(String head,String body){
    return ListTile(title: Text(head,style: TextStyle(fontSize: 20),),subtitle: Text(body),tileColor: Colors.lightBlueAccent,);
  }

}

