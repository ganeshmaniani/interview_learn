import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/core/app/app.dart';
import 'package:interview_learn_process/data/repository/auth/auth_repostory.dart';
import 'package:interview_learn_process/data/repository/home/home_repository.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiRepositoryProvider(
      providers: repositoryprovider(),
      child: MultiBlocProvider(
        providers: blocProvider(),
        child: const UserApp(),
      )));
}

repositoryprovider() {
  return [
    RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
    RepositoryProvider<HomeRepository>(create: (context) => HomeRepository()),
  ];
}

blocProvider() {
  return [
    BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(authRepository: (context).read<AuthRepository>())),
    BlocProvider<HomeCubit>(
        create: (context) =>
            HomeCubit(homeRepository: (context).read<HomeRepository>()))
  ];
}
