import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class LoginButtonLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMessage;
  LoginFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class RegisterButtonLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String errorMessage;
  RegisterFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class AuthProfile extends AuthState {
  final Uint8List imageByte;
  AuthProfile({required this.imageByte});
  @override
  List<Object?> get props => [imageByte];
}

class AuthProfileFailure extends AuthState {
  final String errorMessage;
  AuthProfileFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class StudentEditButtonLoading extends AuthState {}

class StudentEditSuccess extends AuthState {}

class StudentEditFailure extends AuthState {
  final String errorMessage;
  StudentEditFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class EditProfileImage extends AuthState {
  final Uint8List imageByte;
  EditProfileImage({required this.imageByte});
  @override
  List<Object?> get props => [imageByte];
}

class EditProfileFailure extends AuthState {
  final String errorMessage;
  EditProfileFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
