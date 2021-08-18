class SessionInfo {
  late String channelName;
  late String token;
  late String description;
  late String hostName;
  late String lang;
  late String imgPath;



  SessionInfo({required this.channelName, required this.token,required this.description,required this.hostName, required this.lang,required this.imgPath});

  SessionInfo.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    token = json['token'];
    description = json['description'];
    hostName = json['hostName'];
    lang = json['lang'];
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['token'] = this.token;
    data['description'] = this.description;
    data['hostName'] = this.hostName;
    data['lang'] = this.lang;
    data['imgPath'] = this.imgPath;
    return data;
  }
}