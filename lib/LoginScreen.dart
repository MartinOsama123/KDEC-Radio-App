import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
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
              Row(
                children: [
                  const Text("Don't have an account? "),
                  InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())), child: const Text("Click Here",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline))),
                ],
              ),

              ElevatedButton(
                child: Text("Login"),
                onPressed: () {
                  context.read<FirebaseAuthService>().signIn(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );},
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}