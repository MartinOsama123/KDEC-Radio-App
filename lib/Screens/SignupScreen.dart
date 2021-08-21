import 'package:church_app/AppColor.dart';
import 'package:church_app/FirebaseAuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.black,onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
                "images/signup.svg",
                semanticsLabel: 'Login Logo'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "SIGNUP",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
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
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                        width: size.width / 2,
                        child: ElevatedButton(
                          child: Text("Sign up"),
                          style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor),
                          onPressed: () {
                            context.read<FirebaseAuthService>().signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );},
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}