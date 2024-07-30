import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:interview_learn_process/data/repository/home/home_repository.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository}) : super(HomeInitial());

  getTeacherDetails(dynamic id) async {
    emit(HomeLoading());

    try {
      TeacherModel teacherModels = await homeRepository.getTeacherDetail(id);
      List<StudentModel> response = await homeRepository.getStudentList(id);
      if (teacherModels.id != null) {
        emit(HomeLoadData(teacherModels, response));
      } else {
        emit(HomeFailure(errormessage: "Cannot load Teacher"));
      }
    } catch (e) {
      emit(HomeFailure(errormessage: e.toString()));
    }
  }

  deleteStudent(int id) async {
    emit(HomeLoading());
    try {
      int response = await homeRepository.studentDelete(id);
      if (response != null) {
        emit(DeleteSuccess());
      } else {}
    } catch (e) {
      emit(EmptyStudentList(errormessage: e.toString()));
    }
  }

  initialCallDetail(dynamic id) async {
    StudentModel studentModel = await homeRepository.getSingleStudentDetail(id);
    emit(StudentDetail(studentModel: studentModel));
  }

  updateTecher(TeacherModel teacherModel) async {
    int response = await homeRepository.updateTeacher(teacherModel);
    if (response != null) {
      emit(EditSuccess());
    } else {
      emit(EditFailure());
    }
  }

  pickImage(XFile? file) async {
    if (file == null) {
      // emit(AuthProfileFailure(errorMessage: "No image selected"));
      return;
    }
    try {
      Uint8List imageBytes = await file.readAsBytes();
      emit(EditProfile(imageByte: imageBytes));
    } catch (e) {
      // emit(AuthProfileFailure(errorMessage: "Failed to process image: $e"));
    }
  }
}
