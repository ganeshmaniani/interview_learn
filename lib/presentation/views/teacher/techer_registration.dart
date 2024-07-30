import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/data/model/teacher_model/teacher_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/views/teacher/teacher_login.dart';

import '../../bloc/auth/auth_state.dart';

class TeacherRegisterScreen extends StatefulWidget {
  const TeacherRegisterScreen({super.key});

  @override
  State<TeacherRegisterScreen> createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  XFile? selectedProfile;
  String selectGender = '';
  bool isMale = false;
  bool isFemale = false;
  DateTime? _selectDob;
  int? _age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: MemoryImage(state.imageByte))),
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
                              child: const Icon(Icons.add)),
                        ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                          controller: nameController, label: 'Name'),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                          controller: emailController, label: "Email"),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: ageController,
                        label: "Age",
                        icon: Icons.calendar_month,
                        onPressed: () => pickDateTime(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text("Select Gender"),
                          const SizedBox(width: 8),
                          Checkbox(
                              value: isMale,
                              onChanged: (v) {
                                setState(() {
                                  isMale = v!;
                                  if (isMale == false) {
                                    isFemale = true;
                                  } else {
                                    isFemale = false;
                                  }
                                });
                              }),
                          const Text("Male"),
                          Checkbox(
                              value: isFemale,
                              onChanged: (v) {
                                setState(() {
                                  isFemale = v!;
                                  if (isFemale == false) {
                                    isMale = true;
                                  } else {
                                    isMale = false;
                                  }
                                });
                              }),
                          const Text("Female"),
                        ],
                      ),
                      CustomTextFormField(
                          controller: passwordController, label: "Password"),
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
                        child: state is AuthLoading
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
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Register Successfull')));
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const TeacherLogin()));
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
        ));
  }

  pickDateTime() async {
    DateTime? pickdate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime.now());
    if (pickdate != null) {
      setState(() {
        _selectDob = pickdate;
        _age = calculateAge(_selectDob!);
        ageController.text = _age.toString();
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  pickProfileImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final _selectProfile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (_selectProfile != null) {
      setState(() {
        selectedProfile = _selectProfile;
      });
      BlocProvider.of<AuthCubit>(context).pickImage(selectedProfile);
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
}
