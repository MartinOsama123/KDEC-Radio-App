import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/Screens/LoginScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  context.watch<User?>() != null ? Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Profile",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,),onPressed: ()=> Navigator.pop(context))),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                InkWell(onTap:(){},child:  TextIcon(text: "changeEmail".tr(),icons: Icons.email)),
                InkWell(onTap:(){},child:  TextIcon(text: "changePass".tr(),icons: Icons.password,)),
                InkWell(onTap:(){},child:  TextIcon(text: "language".tr(),icons: Icons.language,)),
                InkWell(onTap: (){ context.read<FirebaseAuthService>().signOut();},child:  TextIcon(text: "logout".tr(),icons: Icons.person_off,)),
              ],),
            ),
          ),
        ),
      ),
    ) : LoginScreen();
  }

}

class TextIcon extends StatelessWidget {
  final String text;
  final IconData icons;
  const TextIcon({
    Key? key, required this.text, required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(border: Border.all(
          color: Colors.black,
          width: 1,
        ),borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icons),
          ),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(text),
           )
        ],),
      ),
    );
  }
}