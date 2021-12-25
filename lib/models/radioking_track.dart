class RadioKingTrack {
  late String? artist;
  late String? title;
  late String? next_track;
  late double? duration;
  late bool? is_live;
  late String? cover;
  late String message;


  RadioKingTrack(this.artist, this.title, this.next_track, this.duration,
      this.is_live, this.cover,this.message);

  RadioKingTrack.fromJson(Map<String, dynamic> json) {
    artist = json['artist'] ?? "";

    title = json['title'] ?? "";

    cover = json['cover'] ?? "";

    duration = json['duration'] ?? 0.0;

    is_live = json['is_live'] ?? false;

    next_track = json['next_track'] ?? "";
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist'] = this.artist;
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['duration'] = this.duration;
    data['is_live'] = this.is_live;
    data['next_track'] = this.next_track;
    data['message'] = this.message;
    return data;
  }

}