import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/core/validator/validator.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/views/teacher/teacher_login.dart';

import '../../bloc/auth/auth_state.dart';

class TeacherRegisterScreen extends StatefulWidget {
  const TeacherRegisterScreen({super.key});

  @override
  State<TeacherRegisterScreen> createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen>
    with InputValidator {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  XFile? selectedProfile;
  String selectGender = '';
  bool isMale = false;
  bool isFemale = false;
  bool isOthers = false;
  DateTime? _selectDob;
  int? _age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 246, 246),
        appBar: AppBar(
          title: const Text('Teacher Register'),
        ),
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
                      if (state is AuthProfile)
                        GestureDetector(
                          onTap: () => pickProfileImage(),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(state.imageByte)),
                        )
                      else
                        GestureDetector(
                          onTap: () => pickProfileImage(),
                          child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: const Icon(Icons.add_a_photo)),
                        ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: nameController,
                        label: 'Name',
                        validator: (name) {
                          if (isCheckTextFieldEmpty(name!)) {
                            return null;
                          } else {
                            return 'Enter a name';
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: emailController,
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
                      GestureDetector(
                        onTap: () => pickDob(),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            _age == null
                                ? 'Select DOB'
                                : 'Age:${_age.toString()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: isMale,
                                  onChanged: (v) {
                                    setState(() {
                                      isMale = v!;
                                      if (isMale == false) {
                                        isFemale = false;
                                        isOthers = false;
                                      } else {
                                        isFemale = false;
                                        isOthers = false;
                                      }
                                    });
                                  }),
                              const Text('Male'),
                              Checkbox(
                                  value: isFemale,
                                  onChanged: (v) {
                                    setState(() {
                                      isFemale = v!;
                                      if (isFemale == false) {
                                        isMale = false;
                                        isOthers = false;
                                      } else {
                                        isMale = false;
                                        isOthers = false;
                                      }
                                    });
                                  }),
                              const Text('Female'),
                              Checkbox(
                                  value: isOthers,
                                  onChanged: (v) {
                                    setState(() {
                                      isOthers = v!;
                                      if (isOthers == false) {
                                        isFemale = false;
                                        isMale = false;
                                      } else {
                                        isMale = false;
                                        isFemale = false;
                                      }
                                    });
                                  }),
                              const Text('Others'),
                            ],
                          )),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: passwordController,
                        label: "Password",
                        validator: (password) {
                          if (isPasswordValid(password!)) {
                            return null;
                          } else {
                            return 'Password should be 8 character';
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              state is AuthProfile) {
                            TeacherModel teacherModel = TeacherModel(
                                name: nameController.text,
                                email: emailController.text,
                                age: ageController.text,
                                gender: isMale == true ? "Male" : "Female",
                                password: passwordController.text,
                                profileImage: state.imageByte);
                            BlocProvider.of<AuthCubit>(context)
                                .createTeacher(teacherModel);
                          }
                        },
                        child: state is RegisterButtonLoading
                            ? const CircularProgressIndicator(
                                backgroundColor: Colors.white)
                            : const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      )
                    ],
                  )),
            );
          },
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Register Successfull')));
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const TeacherLogin()));
            }
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
        ));
  }

  pickProfileImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final _selectProfile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (_selectProfile != null) {
      setState(() {
        selectedProfile = _selectProfile;
      });
      BlocProvider.of<AuthCubit>(context).pickRegisterImage(selectedProfile);
      log("Image Selected");
    } else {
      log("Image Cannot Selected");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected. Please select an image.'),
        ),
      );
    }
  }

  pickDob() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        _selectDob = pickedDate;
        _age = calculateAge(_selectDob!);
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    return age;
  }
}
