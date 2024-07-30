import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:interview_learn_process/data/repository/home/home_repository.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository}) : super(HomeInitial());

  getTeacherDetails() async {
    emit(HomeLoading());
    List<StudentModel> studentModel = [];
    try {
      TeacherModel teacherModels = await homeRepository.getTeacherDetail();
      List<StudentModel> response = await homeRepository.getStudentList();
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
        getTeacherDetails();
      } else {}
    } catch (e) {
      emit(EmptyStudentList(errormessage: e.toString()));
    }
  }

  initialCallDetail(dynamic id) async {
    StudentModel studentModel = await homeRepository.getSingleTeacherDetail(id);
    emit(StudentDetail(studentModel: studentModel));
  }
}
