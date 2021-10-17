import 'package:audio_service/audio_service.dart';
import 'package:church_app/AppColor.dart';
import 'package:church_app/BackendQueries.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/Screens/ProfileScreen.dart';
import 'package:church_app/Screens/SignupScreen.dart';
import 'package:church_app/main.dart';
import 'package:church_app/models/UserInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'HomeScreen.dart';
class LoginScreen extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool skip;

   LoginScreen({Key? key, this.skip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null  ? Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
        body: SafeArea(
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
                          if(value == 1) context.setLocale( Locale('en', 'US'));
                          else if(value == 2) context.setLocale( Locale('fr', 'FR'));
                         else  if(value == 3) context.setLocale( Locale('ar', 'AR'));
                          }),
                    ),
                  ),
                  Spacer(),
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
                                 child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      fillColor: AppColor.PrimaryColor,
                                      border: OutlineInputBorder(),
                                      labelText: "email".tr(),
                                    ),
                                  ),
                               ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      fillColor: AppColor.PrimaryColor,
                                      border: OutlineInputBorder(),
                                      labelText: 'password'.tr(),
                                    ),
                                  ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())), child: const Text("noEmail",style: TextStyle(color: AppColor.SecondaryColor,decoration: TextDecoration.underline)).tr()),

                              ),
                              Container(
                                width: size.width / 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor),
                                  child: Text("login").tr(),
                                  onPressed: () async {
                                    await context.read<FirebaseAuthService>().signIn(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());
                                    context.watch<UserModel>().setUser(await BackendQueries.getUserInfo(await FirebaseAuth.instance.currentUser?.getIdToken(true) ?? ""));
                                    },
                                ),
                              ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(onTap: ()=>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AudioServiceWidget(child: MyHomePage()))),child: const Text("guest",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue)).tr()),
                  )
                ],
              ),
        )
      ),
    ):skip ? AudioServiceWidget(child: MyHomePage()) : ProfileScreen();
  }
}