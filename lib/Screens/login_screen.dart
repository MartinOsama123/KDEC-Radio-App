import 'package:audio_service/audio_service.dart';
import 'package:church_app/Screens/password_reset_screen.dart';
import 'package:church_app/app_color.dart';
import 'package:church_app/backend_queries.dart';
import 'package:church_app/firebase_auth.dart';
import 'package:church_app/Screens/profile_screen.dart';
import 'package:church_app/Screens/signup_screen.dart';
import 'package:church_app/models/album_info.dart';
import 'package:church_app/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

  bool emailValid = true, passValid = true;


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
                            child: Text(
                              "login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  fillColor: AppColor.PrimaryColor,
                                  border: OutlineInputBorder(),
                                  labelText: "email".tr(),
                                  errorText: !emailValid
                                      ? "Please enter a valid email"
                                      : null),
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
                                  fillColor: AppColor.PrimaryColor,
                                  border: OutlineInputBorder(),
                                  labelText: 'password'.tr(),
                                  errorText: !passValid
                                      ? "Password should be 5 characters at least"
                                      : null),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => Navigator.pushNamed(context, "/signup"),
                              child: const Text("noEmail",
                                      style: TextStyle(
                                          color: AppColor.SecondaryColor,
                                          decoration: TextDecoration.underline))
                                  .tr()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => Navigator.pushNamed(context, "/reset"),
                              child: const Text("passReset",
                                      style: TextStyle(
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
                              if (_emailController.text.contains("@") &&
                                  _passwordController.text.length >= 5) {
                                await context
                                    .read<FirebaseAuthService>()
                                    .signIn(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim());
                                context.watch<UserModel>().setUser(
                                    await BackendQueries.getUserInfo(
                                        await FirebaseAuth.instance.currentUser
                                                ?.getIdToken(true) ??
                                            ""));
                              } else {
                                setState(() {
                                  emailValid = passValid = false;
                                });
                              }
                            },
                          ),
                        ),
                        //      Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false),
                              child: const Text("guest",
                                      style: TextStyle(
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
