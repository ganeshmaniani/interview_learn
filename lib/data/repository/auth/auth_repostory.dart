import 'dart:developer';

import 'package:interview_learn_process/core/service/base_db_service.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      List<Map<String, dynamic>> respone =
          await networkService.getData('teacher_table');
      log(respone.toString());
      if (respone.isEmpty) {
        return false;
      } else {
        for (var res in respone) {
          if (res['email'] == teacherModel.email &&
              res["password"] == teacherModel.password) {
            TeacherModel loggedInTeacher = TeacherModel.fromJson(res);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setInt("TeacherId", loggedInTeacher.id!);

            log('Teacher ID saved: ${loggedInTeacher.id.toString()}');
            return true;
          }
        }
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<int> createStudent(StudentModel studentModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var teacherId = preferences.getInt('TeacherId');
    try {
      var data = {
        "name": studentModel.name,
        'teacher_id': teacherId,
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
      log(respone.toString());
      if (respone.isEmpty) {
        return false;
      } else {
        for (var res in respone) {
          if (res['email'] == studentModel.email &&
              res['password'] == studentModel.password) {
            StudentModel loggedInStudent = StudentModel.fromJson(res);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setInt("StudentId", loggedInStudent.id!);
            return true;
          }
        }
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<int> studentEdit(StudentModel studentModel) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var teacherId = preferences.getInt('TeacherId');
    try {
      var data = {
        'id': studentModel.id,
        // 'teacher_id': teacherId,
        'name': studentModel.name,
        'email': studentModel.email,
        'age': studentModel.age,
        'gender': studentModel.gender,
        'password': studentModel.password,
        'profile_image': studentModel.profileImage
      };
      int response = await networkService.updateData('student_table', data);
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
}
