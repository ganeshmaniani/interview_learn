import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/repository/auth/auth_repostory.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';

import '../../../data/model/teacher_model/teacher_model.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  createTeacher(TeacherModel teacherModel) async {
    emit(AuthLoading());
    try {
      int response = await authRepository.createTeacher(teacherModel);
      if (response != 0) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(errorMessage: 'User Cannot added'));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  loginTecher(TeacherModel teacherModel) async {
    emit(AuthLoading());
    try {
      bool response = await authRepository.teacherLogin(teacherModel);
      if (response == true) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(errorMessage: "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  createStudent(StudentModel studentModel) async {
    emit(AuthLoading());
    try {
      int response = await authRepository.createStudent(studentModel);
      if (response != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(errorMessage: "Student Cannot added"));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  studentLogin(StudentModel studentModel) async {
    emit(AuthLoading());
    try {
      bool response = await authRepository.studentLogin(studentModel);
      if (response == true) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(errorMessage: "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  pickImage(XFile? file) async {
    if (file == null) {
      emit(AuthProfileFailure(errorMessage: "No image selected"));
      return;
    }
    try {
      Uint8List imageBytes = await file.readAsBytes();
      emit(AuthProfile(imageByte: imageBytes));
    } catch (e) {
      emit(AuthProfileFailure(errorMessage: "Failed to process image: $e"));
    }
  }
}
