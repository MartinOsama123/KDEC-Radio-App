
class NotificationInfo {
  late int id;
  late String title;
  late String body;
  late String birthDay;

  NotificationInfo(this.id, this.title, this.body, this.birthDay);
  NotificationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    birthDay = json['birthDay'];
  }
}
