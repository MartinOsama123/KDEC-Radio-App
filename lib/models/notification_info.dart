
class NotificationInfo {

  late String title;
  late String body;
  late String sendAt;

  NotificationInfo( this.title, this.body);
  NotificationInfo.fromJson(Map<String, dynamic> json) {

    title = json['title'];
    body = json['body'];
    sendAt = json['sendAt'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = title;
    data['body'] = body;
    return data;
  }
}
