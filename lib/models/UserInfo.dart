import 'package:church_app/BackendQueries.dart';
import 'package:church_app/models/NotificationInfo.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  late String email;
  late String name;
  late String phone;
  late List<String> subs;
  late List<NotificationInfo> notifications;


  UserModel({required this.email, required this.name, required this.phone, required this.subs,required this.notifications});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    subs = <String>[];
    json['subs'].forEach((element) {subs.add(element);});
    notifications = <NotificationInfo>[];
    json['notifications'].forEach((element) {notifications.add(element);});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['notifications'] = <NotificationInfo>[];
    this.notifications.forEach((element) {data['notifications'].add(element);});
    data['subs'] = <String>[];
    this.subs.forEach((element) {data['subs'].add(element);});
    return data;
  }
 void setUser(UserModel model){
   email = model.email;
   name = model.name;
   phone = model.phone;
   subs = model.subs;
   notifications = model.notifications;
   notifyListeners();
 }
 Future<void> removeSub(String token, String albumName) async {

      await BackendQueries.deleteSub(token, albumName);
      subs.remove(albumName);
      notifyListeners();

 }
  Future<void> addSub(String token, String albumName) async {

      await BackendQueries.addSub(token, albumName);
      subs.add(albumName);
      notifyListeners();

  }
}