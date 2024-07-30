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
