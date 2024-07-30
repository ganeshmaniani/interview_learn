import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';
import 'package:interview_learn_process/presentation/views/student/student_view_page.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController studentEmailController = TextEditingController();
  final TextEditingController studentPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('Student Login')),
        body: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                          controller: studentEmailController, label: "Email"),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                          controller: studentPasswordController,
                          label: "Password"),
                      const SizedBox(height: 32),
                      CustomButton(
                          onTap: () {
                            StudentModel studentModel = StudentModel(
                                email: studentEmailController.text,
                                password: studentPasswordController.text);
                            BlocProvider.of<AuthCubit>(context)
                                .studentLogin(studentModel);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )),
            );
          },
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Login Successfully..')));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentViewPage()));
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
        ));
  }
}
