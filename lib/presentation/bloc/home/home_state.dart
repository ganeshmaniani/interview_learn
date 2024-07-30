import 'package:equatable/equatable.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadData extends HomeState {
  final TeacherModel teacherModel;
  final List<StudentModel> studentList;
  HomeLoadData(this.teacherModel, this.studentList);
  @override
  List<Object?> get props => [teacherModel];
}

class HomeFailure extends HomeState {
  final String errormessage;
  HomeFailure({required this.errormessage});
  @override
  List<Object?> get props => [errormessage];
}

class StudentList extends HomeState {
  final List<StudentModel> studentList;
  StudentList({required this.studentList});
  @override
  List<Object?> get props => [studentList];
}

class EmptyStudentList extends HomeState {
  final String errormessage;
  EmptyStudentList({required this.errormessage});
  @override
  List<Object?> get props => [errormessage];
}

class StudentDetail extends HomeState {
  final StudentModel studentModel;
  StudentDetail({required this.studentModel});
  @override
  List<Object?> get props => [studentModel];
}
