import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/core/validator/validator.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';
import 'package:interview_learn_process/presentation/views/student/student_view_page.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> with InputValidator {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController studentEmailController = TextEditingController();
  final TextEditingController studentPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 252, 250, 250).withOpacity(0.9),
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
                        controller: studentEmailController,
                        label: "Email",
                        validator: (email) {
                          if (isEmailValid(email!)) {
                            return null;
                          } else {
                            return 'Enter a email address';
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: studentPasswordController,
                        label: "Password",
                        validator: (password) {
                          if (isPasswordValid(password!)) {
                            return null;
                          } else {
                            return 'Password should be 8 character';
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              StudentModel studentModel = StudentModel(
                                  email: studentEmailController.text,
                                  password: studentPasswordController.text);
                              BlocProvider.of<AuthCubit>(context)
                                  .studentLogin(studentModel);
                              if (state is LoginSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Login Successfully..')));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentViewPage()),
                                    (route) => false);
                              }
                            }
                          },
                          child: state is LoginButtonLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                )),
                    ],
                  )),
            );
          },
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
        ));
  }
}
