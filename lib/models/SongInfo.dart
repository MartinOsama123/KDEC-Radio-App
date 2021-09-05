class SongInfo {
  late String albumName;
  late String lang;
  late String songName;
 // late String author;

  SongInfo(this.albumName, this.lang, this.songName);
  SongInfo.fromJson(Map<String, dynamic> json) {
    albumName = json['albumName'];
    lang = json['lang'];
    songName = json['songName'];
    //author = json['author'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumName'] = this.albumName;
    data['lang'] = this.lang;
    data['songName'] = this.songName;
  //  data['author'] = this.author;
    return data;
  }
}