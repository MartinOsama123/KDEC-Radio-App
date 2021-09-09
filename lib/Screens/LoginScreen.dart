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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool skip;

   LoginScreen({Key? key, this.skip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null  ? Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
            "images/login.svg",
            semanticsLabel: 'Login Logo'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                fillColor: AppColor.PrimaryColor,
                                border: OutlineInputBorder(),
                                labelText: 'Email',
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
                                labelText: 'Password',
                              ),
                            ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text("Don't have an account? "),
                              InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())), child: const Text("Click Here",style: TextStyle(color: AppColor.SecondaryColor,decoration: TextDecoration.underline))),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width / 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor),
                            child: Text("Login"),
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
                      builder: (context) => AudioServiceWidget(child: MyHomePage()))),child: const Text("Continue as a guest?",style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue))),
            )
          ],
        ),
      ),
    ):skip ? MyHomePage() : ProfileScreen();
  }
}