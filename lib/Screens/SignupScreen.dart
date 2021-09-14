import 'dart:convert';
import 'package:church_app/AppColor.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/main.dart';
import 'package:church_app/models/UserInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return context.watch<User?>() == null  ? Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.black,onPressed: () => Navigator.pop(context))),
        body: SafeArea(
              child:  Column(
                  children: [
                              Text(
                                "signup",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).tr(),

                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'name'.tr(),
                                    ),
                                  ),
                               ),

                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'phone'.tr(),
                                    ),
                                  ),
                               ),

                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'email'.tr(),
                                    ),
                                  ),
                               ),

                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'password'.tr(),
                                    ),
                                  ),
                               ),

                              Container(
                                width: size.width / 2,
                                child: ElevatedButton(
                                  child: Text("signup").tr(),
                                  style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor),
                                  onPressed: () async {

                                    UserModel user = new UserModel(email: _emailController.text.trim(), name: _nameController.text.trim(), phone: _phoneController.text.trim(), subs: [],notifications: []);
                                    await context.read<FirebaseAuthService>().signUp(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim());
                                    String token = await context.read<User?>()?.getIdToken() ?? "";
                                    var en = jsonEncode(user.toJson());
                                    print(en);
                                    print(token);

                                   print( await BackendQueries.createUser(token,en));},
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),

                  ],
                    ),

                ),

        ),
      ) : MyHomePage();
  }
}