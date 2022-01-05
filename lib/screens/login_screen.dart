import 'package:church_app/Screens/profile_screen.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/backend/backend_queries.dart';
import 'package:church_app/backend/firebase_auth.dart';
import 'package:church_app/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool skip;

  LoginScreen({Key? key, this.skip = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();




  @override
  void initState() {
   //initDynamicLinks();
    super.initState();
  }
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
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                hint: Text("language").tr(),
                                items: [
                                  DropdownMenuItem(
                                    child: const Text("English"),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: const Text("French"),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: const Text("Arabic"),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == 1)
                                    context.setLocale(Locale('en', 'US'));
                                  else if (value == 2)
                                    context.setLocale(Locale('fr', 'FR'));
                                  else if (value == 3)
                                    context.setLocale(Locale('ar', 'AR'));
                                }),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  "login",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ).tr(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () => Navigator.pushNamed(context, "/signup"),
                                      child: const Text("noEmail",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.SecondaryColor,
                                              decoration: TextDecoration.underline))
                                          .tr()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  fillColor: AppColor.PrimaryColor,
                                  border: OutlineInputBorder(),
                                  labelText: "email".tr()),
                            ),

                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  fillColor: AppColor.PrimaryColor,
                                  border: OutlineInputBorder(),
                                  labelText: 'password'.tr()),
                            ),

                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => Navigator.pushNamed(context, "/reset"),
                              child: const Text("passReset",
                                      style: TextStyle(
                                        fontSize: 20,
                                          color: AppColor.SecondaryColor,
                                          decoration: TextDecoration.underline))
                                  .tr()),
                        ),
                        Container(
                          width: size.width / 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.PrimaryColor),
                            child: Text("login").tr(),
                            onPressed: () async {
                              try {
                                await context.read<FirebaseAuthService>()
                                    .signIn(email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());

                                context.read<UserModel>().setUser(
                                    await BackendQueries.getUserInfo(
                                        await FirebaseAuth.instance.currentUser
                                            ?.getIdToken(true) ?? ""));
                              }on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case "invalid-email":
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text('Your username or password is incorrect. Please try again'),
                                            actions: <Widget>[
                                              Center(
                                                child: TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('OK')),
                                              ),
                                            ],
                                          );
                                        });
                                  break;
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false),
                              child: const Text("guest",
                                      style: TextStyle(
                                        fontSize: 20,
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue))
                                  .tr()),
                        )
                      ],
                    ),
                  ),
                )),
          )
        : widget.skip
            ? MyHomePage()
            : ProfileScreen();
  }
}
