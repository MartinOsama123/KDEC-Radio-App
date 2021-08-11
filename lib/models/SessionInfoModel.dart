class SessionInfo {
  late String channelName;
  late String token;

  SessionInfo({required this.channelName, required this.token});

  SessionInfo.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['token'] = this.token;
    return data;
  }
}