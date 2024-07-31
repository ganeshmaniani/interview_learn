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
    emit(RegisterButtonLoading());
    try {
      int response = await authRepository.createTeacher(teacherModel);
      if (response != 0) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(errorMessage: 'User Cannot added'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: e.toString()));
    }
  }

  loginTecher(TeacherModel teacherModel) async {
    emit(LoginButtonLoading());
    try {
      bool response = await authRepository.teacherLogin(teacherModel);
      if (response == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errorMessage: "Login Failed"));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: e.toString()));
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
    emit(LoginButtonLoading());
    try {
      bool response = await authRepository.studentLogin(studentModel);
      if (response == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errorMessage: "Login Failed"));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }

  updateStudent(StudentModel studentModel) async {
    emit(StudentEditButtonLoading());
    try {
      int response = await authRepository.studentEdit(studentModel);
      if (response != null) {
        emit(StudentEditSuccess());
      } else {
        emit(StudentEditFailure(errorMessage: 'Student Cannot Updated'));
      }
    } catch (e) {
      emit(StudentEditFailure(errorMessage: e.toString()));
    }
  }

  pickRegisterImage(XFile? file) async {
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

  pickEditImage(XFile? file) async {
    if (file == null) {
      emit(EditProfileFailure(errorMessage: "No image selected"));
      return;
    }
    try {
      Uint8List imageBytes = await file.readAsBytes();
      emit(EditProfileImage(imageByte: imageBytes));
    } catch (e) {
      emit(AuthProfileFailure(errorMessage: "Failed to process image: $e"));
    }
  }
}
