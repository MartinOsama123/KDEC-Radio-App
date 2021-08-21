import 'package:church_app/FirebaseAuthService.dart';
import 'package:church_app/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  context.watch<User?>() != null ? Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextIcon(text: "Change E-Mail",icons: Icons.email),
          TextIcon(text: "Change Password",icons: Icons.password,),
          InkWell(onTap: (){ context.read<FirebaseAuthService>().signOut();},child: TextIcon(text: "Logout",icons: Icons.person_off,)),
        ],),
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