class UserModel {
  late String email;
  late String name;
  late String phone;
  late List<String> subs;


  UserModel({required this.email, required this.name, required this.phone, required this.subs});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    subs = json['subs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;

    return data;
  }

}