import 'package:church_app/backend/backend_queries.dart';
import 'package:church_app/models/notification_info.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  late String email;
  late String name;
  late String phone;

  late List<NotificationInfo> notifications;
  late List<String> messages;
  late int age;


  UserModel({required this.email, required this.name, required this.phone, required this.notifications,required this.messages,required this.age});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];

    notifications = <NotificationInfo>[];
    json['notifications'].forEach((element) {notifications.add(element);});
    messages = <String>[];
    json['messages'].forEach((element) {messages.add(element);});
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['notifications'] = <NotificationInfo>[];
    this.notifications.forEach((element) {data['notifications'].add(element);});
    data['messages'] = <String>[];
    this.messages.forEach((element) {data['messages'].add(element);});
    data['age'] = this.age;
    return data;
  }
 void setUser(UserModel model){
   email = model.email;
   name = model.name;
   phone = model.phone;

   notifications = model.notifications;
   messages = model.messages;
   age = model.age;
   notifyListeners();
 }
 /*Future<void> removeSub(String token, String albumName) async {

      await BackendQueries.deleteSub(token, albumName);
      messages.remove(albumName);
      notifyListeners();

 }
  Future<void> addSub(String token, String albumName) async {

      await BackendQueries.addSub(token, albumName);
      messages.add(albumName);
      notifyListeners();

  }*/
}