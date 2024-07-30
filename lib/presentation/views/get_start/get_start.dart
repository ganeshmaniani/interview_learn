import 'package:flutter/material.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/presentation/views/student/student_login.dart';
import 'package:interview_learn_process/presentation/views/teacher/teacher_login.dart';

class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TeacherLogin()));
                },
                child: const Text(
                  'Techer Login',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StudentLogin()));
                },
                child: const Text(
                  'Student Login',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
