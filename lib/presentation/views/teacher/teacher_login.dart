import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';
import 'package:interview_learn_process/presentation/views/teacher/teacher_dashboard.dart';
import 'package:interview_learn_process/presentation/views/teacher/techer_registration.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController teacherEmailController = TextEditingController();
  final TextEditingController teacherPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 240, 240),
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('Teacher Login')),
        body: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                          controller: teacherEmailController, label: "Email"),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                          controller: teacherPasswordController,
                          label: "Password"),
                      const SizedBox(height: 32),
                      CustomButton(
                          onTap: () {
                            TeacherModel teacherModel = TeacherModel(
                                email: teacherEmailController.text,
                                password: teacherPasswordController.text);
                            BlocProvider.of<AuthCubit>(context)
                                .loginTecher(teacherModel);
                          },
                          child: state is AuthLoading
                              ? CircularProgressIndicator()
                              : const Text('Login',
                                  style: TextStyle(color: Colors.white))),
                      const Text('or'),
                      CustomButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TeacherRegisterScreen()));
                          },
                          child: const Text('Register',
                              style: TextStyle(color: Colors.white)))
                    ],
                  )),
            );
          },
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Login Successfully..')));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TeacherHome()));
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
