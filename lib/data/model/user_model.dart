import 'dart:typed_data';

class UserModel {
  int? id;
  String? name;
  String? age;
  String? gender;
  Uint8List? profileImage;

  UserModel({this.id, this.name, this.age, this.gender, this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    age = json["age"];
    gender = json["gender"];
    profileImage = json["profile_image"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "gender": gender,
      "profile_image": profileImage,
    };
  }
}
