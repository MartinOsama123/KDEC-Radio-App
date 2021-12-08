import 'dart:convert';
import 'package:church_app/app_color.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/firebase_auth.dart';
import 'package:church_app/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool emailValid = true, passValid = true, phoneValid = true, nameValid = true, ageValid = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null
        ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background.png"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context))),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Text(
                        "signup",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ).tr(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'name'.tr(),
                              errorText: !nameValid ? "Name must not be empty" : null
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'phone'.tr(),
                                errorText: !phoneValid ? "Email must be 11 number" : null
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'email'.tr(),
                                errorText: !emailValid ? "Email must be valid" : null
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'password'.tr(),
                              errorText: !passValid ? "Password must be at least 5 characters" : null
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'age'.tr(),
                                errorText: !ageValid ? "Age must not be empty" : null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width / 2,
                        child: ElevatedButton(
                          child: Text("signup").tr(),
                          style: ElevatedButton.styleFrom(
                              primary: AppColor.PrimaryColor),
                          onPressed: () async {
                            if(!_emailController.text.trim().contains("@")) emailValid = false; else emailValid = true;
                            if(_nameController.text.trim().isEmpty) nameValid = false; else nameValid = true;
                            if(_phoneController.text.trim().length != 11) phoneValid = false; else phoneValid = true;
                            if(_passwordController.text.length < 5) passValid = false; else passValid = true;
                            if(_ageController.text.trim().isEmpty) ageValid = false; else ageValid = true;

                            if(emailValid && nameValid && phoneValid && passValid && ageValid) {
                              UserModel user = new UserModel(
                                  email: _emailController.text.trim(),
                                  name: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  subs: [],
                                  notifications: [],
                                  age: int.parse(_ageController.text.trim()));
                              await context.read<FirebaseAuthService>().signUp(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim());
                              String token =
                                  await context.read<User?>()?.getIdToken() ?? "";
                              var en = jsonEncode(user.toJson());
                              await BackendQueries.createUser(token, en);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : MyHomePage();
  }
}
