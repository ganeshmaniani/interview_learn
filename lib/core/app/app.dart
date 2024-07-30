import 'package:flutter/material.dart';
import 'package:interview_learn_process/presentation/views/get_start/get_start.dart';

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStartPage(),
    );
  }
}
