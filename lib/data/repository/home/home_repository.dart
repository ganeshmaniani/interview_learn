import 'dart:developer';

import 'package:interview_learn_process/core/service/base_db_service.dart';
import 'package:interview_learn_process/core/service/network_db_service.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';

import '../../model/student_model/student_model.dart';

class HomeRepository {
  final BaseDBService networkService = NetWorkDBService();
  Future<TeacherModel> getTeacherDetail(dynamic id) async {
    try {
      TeacherModel teacherModel = TeacherModel();
      List<Map<String, dynamic>> response =
          await networkService.getDataById('teacher_table', id);
      if (response.isEmpty) {
        return teacherModel;
      } else {
        for (var res in response) {
          teacherModel.id = res['id'];
          teacherModel.name = res['name'];
          teacherModel.email = res['email'];
          teacherModel.age = res['age'];
          teacherModel.gender = res['gender'];
          teacherModel.profileImage = res['profile_image'];
          teacherModel.password = res['password'];
        }
        return teacherModel;
      }
    } catch (e) {
      log(e.toString());
      TeacherModel teacherModel = TeacherModel();
      return teacherModel;
    }
  }

  Future<List<StudentModel>> getStudentList(dynamic id) async {
    try {
      List<Map<String, dynamic>> response =
          await networkService.getStudentDataById('student_table', id);
      if (response.isEmpty) {
        return [];
      } else {
        List<StudentModel> studentList =
            response.map((e) => StudentModel.fromJson(e)).toList();
        return studentList;
      }
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  Future<int> studentDelete(int id) async {
    try {
      int response = await networkService.deleteData('student_table', id);
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

  Future<StudentModel> getSingleStudentDetail(dynamic id) async {
    StudentModel studentModel = StudentModel();
    try {
      List<Map<String, dynamic>> response =
          await networkService.getDataById('student_table', id);

      if (response.isEmpty) {
        return studentModel;
      } else {
        for (var res in response) {
          studentModel.id = res['id'];
          studentModel.name = res['name'];
          studentModel.email = res['email'];
          studentModel.age = res['age'];
          studentModel.gender = res['gender'];
          studentModel.profileImage = res['profile_image'];
          studentModel.password = res['password'];
        }
        return studentModel;
      }
    } catch (e) {
      log(e.toString());
      return studentModel;
    }
  }

  Future<int> updateTeacher(TeacherModel teacherModel) async {
    try {
      Map<String, dynamic> data = {
        'id': teacherModel.id,
        'name': teacherModel.name,
        'email': teacherModel.email,
        'age': teacherModel.age,
        'profile_image': teacherModel.profileImage,
        'password': teacherModel.password
      };
      int response = await networkService.updateData('teacher_table', data);

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
