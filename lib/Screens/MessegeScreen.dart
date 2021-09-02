import 'package:flutter/material.dart';

import '../AppColor.dart';

class MessegeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height,child: TextField(expands: true,minLines: null,maxLines: null,)),
          )),
          ElevatedButton(onPressed: ()=>  Navigator.push(context, MaterialPageRoute(builder: (context) => MessegeScreen())), child: Text("Send"),style: ElevatedButton.styleFrom(primary: AppColor.PrimaryColor))
        ],),
      ),
    );
  }

}