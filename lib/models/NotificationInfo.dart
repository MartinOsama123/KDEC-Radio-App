
class NotificationInfo {
  late int id;
  late String title;
  late String body;
  late String sendAt;

  NotificationInfo(this.id, this.title, this.body, this.sendAt);
  NotificationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    sendAt = json['sendAt'];
  }
}
