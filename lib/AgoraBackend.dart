import 'dart:convert';
import 'dart:io';

import 'package:church_app/models/AgoraChannelModel.dart';
import 'package:http/http.dart' as http;




class AgoraBackend {
  static const BASE_URL = "https://api.agora.io";
  static const USER = "d0f040453156454ca8cf3fbbd6c67f2e";
  static const PASS = "cc9d0dfbed654b9a942d80243aabc546";
  static const APP_ID = "343e0fece606410eb65bc1b9a877b65e";
  static String auth = 'Basic '+ base64Encode(utf8.encode('$USER:$PASS'));


  static Future<AgoraChannelModel> getChannels() async{
    var response = await http.get(Uri.parse("$BASE_URL/dev/v1/channel/$APP_ID"),headers: {HttpHeaders.authorizationHeader: auth});
    var temp = AgoraChannelModel.fromJson(jsonDecode(response.body));
    return temp;
  }
}