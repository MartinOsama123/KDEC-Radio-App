import 'package:church_app/AppColor.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/Screens/ProfileScreen.dart';
import 'package:church_app/Screens/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null  ? Scaffold(
      body: Column(
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
                          onPressed: () {
                            context.read<FirebaseAuthService>().signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );},
                        ),
                      )
        ],
      ),
    ):ProfileScreen();
  }
}