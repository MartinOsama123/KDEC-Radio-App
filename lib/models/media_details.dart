import 'dart:convert';

class MediaDetails {
  late String id;
  late String title;
  late String? album;


  MediaDetails({
    required this.id,
    required this.title,
    this.album,

  });
  MediaDetails.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.album = json['album'] ?? "";

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['album'] = this.album;
    return data;
  }
  static Map<String, dynamic> toMap(MediaDetails music) => {
    'id': music.id,
    'title': music.title,
    'album': music.album
  };

  static String encode(List<MediaDetails> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => MediaDetails.toMap(music))
        .toList(),
  );

  static List<MediaDetails> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<MediaDetails>((item) => MediaDetails.fromJson(item))
          .toList();

}