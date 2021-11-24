class AlbumInfo {
  late String albumName;
  late String imgPath;

  AlbumInfo({required this.albumName, required this.imgPath});

  AlbumInfo.fromJson(Map<String, dynamic> json) {
    albumName = json['albumName'];
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['albumName'] = this.albumName;
    data['imgPath'] = this.imgPath;
    return data;
  }


}