import 'dart:developer';

import 'package:interview_learn_process/core/service/base_db_service.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';

import '../../../core/service/network_db_service.dart';

class AuthRepository {
  final BaseDBService networkService = NetWorkDBService();

  Future<int> createTeacher(TeacherModel teacherModel) async {
    try {
      Map<String, dynamic> data = {
        'name': teacherModel.name,
        'email': teacherModel.email,
        'age': teacherModel.age,
        'gender': teacherModel.gender,
        'password': teacherModel.password,
        'profile_image': teacherModel.profileImage,
      };
      int response = await networkService.inserData("teacher_table", data);
      if (response != null) {
        return response;
      } else {
        return 0;
      }
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<bool> teacherLogin(TeacherModel teacherModel) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      List<Map<String, dynamic>> respone =
          await networkService.getData('teacher_table');

      if (respone.isEmpty) {
        return false;
      } else {
        bool isValid = false;
        for (var res in respone) {
          if (res['email'] == teacherModel.email &&
              res["password"] == teacherModel.password) {
            // preferences.setInt("TeacherId", res['id']);
            isValid = true;

            log('Teacher ID saved: ${res['id']}');
          } else {
            isValid = false;
          }
        }
        return isValid;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<int> createStudent(StudentModel studentModel) async {
    try {
      var data = {
        "name": studentModel.name,
        "age": studentModel.age,
        'email': studentModel.email,
        "gender": studentModel.gender,
        'password': studentModel.password,
        "profile_image": studentModel.profileImage,
      };
      int response = await networkService.inserData("student_table", data);
      if (response != null) {
        return response;
      } else {
        return 0;
      }
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<bool> studentLogin(StudentModel studentModel) async {
    try {
      List<Map<String, dynamic>> respone =
          await networkService.getData('student_table');

      if (respone.isEmpty) {
        return false;
      } else {
        bool isValid = false;
        for (var res in respone) {
          if (res['email'] == studentModel.email &&
              res['password'] == studentModel.password) {
            isValid = true;
          } else {
            isValid = false;
          }
        }
        return isValid;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
