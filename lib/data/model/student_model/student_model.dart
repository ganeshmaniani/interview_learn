import 'dart:typed_data';

class StudentModel {
  int? id;

  String? name;
  String? age;
  String? email;
  String? password;
  String? gender;
  Uint8List? profileImage;

  StudentModel(
      {this.id,
      this.name,
      this.age,
      this.gender,
      this.email,
      this.password,
      this.profileImage});

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    age = json["age"];
    email = json['email'];
    gender = json["gender"];
    password = json['password'];
    profileImage = json["profile_image"];
  }
}
