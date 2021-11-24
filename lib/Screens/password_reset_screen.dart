import 'package:church_app/app_color.dart';
import 'package:church_app/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';


class PasswordResetScreen extends StatefulWidget {
  final bool skip;

  PasswordResetScreen({Key? key, this.skip = false}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();



  bool emailValid = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "passReset",
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
                  Container(
                    width: size.width / 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.PrimaryColor),
                      child: Text("confirm").tr(),
                      onPressed: () async {
                        if (_emailController.text.contains("@")) {
                          await context.read<FirebaseAuthService>().resetPassword(email: _emailController.text.trim());
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            emailValid  = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
