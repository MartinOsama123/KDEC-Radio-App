import 'package:http/http.dart' as http;
class AgoraChannelModel {
  late bool success;
  late Data data;

  AgoraChannelModel({required this.success, required this.data});

  AgoraChannelModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  late List<Channels> channels;
  late int totalSize;

  Data({required this.channels, required this.totalSize});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['channels'] != null) {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels.add(new Channels.fromJson(v));
      });
    }
    totalSize = json['total_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.channels != null) {
      data['channels'] = this.channels.map((v) => v.toJson()).toList();
    }
    data['total_size'] = this.totalSize;
    return data;
  }
}

class Channels {
  late String channelName;
  late int userCount;

  Channels({required this.channelName, required this.userCount});

  Channels.fromJson(Map<String, dynamic> json) {
    channelName = json['channel_name'];
    userCount = json['user_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_name'] = this.channelName;
    data['user_count'] = this.userCount;
    return data;
  }
}