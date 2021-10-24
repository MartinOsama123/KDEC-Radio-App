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
}