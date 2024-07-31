// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/core/validator/validator.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';

import '../../../config/widgets/button.dart';
import '../../../config/widgets/text_field.dart';
import '../../../data/model/teacher_model/teacher_model.dart';

class TeacherEditPage extends StatefulWidget {
  final int id;
  final String name;
  final String email;
  final String age;
  final String gender;
  final Uint8List profileImage;
  final String password;
  const TeacherEditPage({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.profileImage,
    required this.password,
  });

  @override
  State<TeacherEditPage> createState() => _TeacherEditPageState();
}

class _TeacherEditPageState extends State<TeacherEditPage> with InputValidator {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  XFile? selectedProfile;
  Uint8List? editImage;
  String selectGender = '';
  bool isMale = false;
  bool isFemale = false;
  bool isOthers = false;
  DateTime? _selectedDOB;
  int? _age;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
    if (_isNumeric(widget.age)) {
      _age = int.parse(widget.age);
    } else {
      log('Invalid age: ${widget.age}');
      _age = null;
    }
    isMale = widget.gender == 'Male' ? true : false;
    isFemale = widget.gender == 'Female' ? true : false;
    isOthers = widget.gender == 'Others' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 252, 250, 250).withOpacity(0.9),
      appBar: AppBar(
        title: Text('Teacher Edit'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is EditProfile
                        ? GestureDetector(
                            onTap: () => pickProfileImage(),
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: MemoryImage(state.imageByte))),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => pickProfileImage(),
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: MemoryImage(widget.profileImage))),
                            ),
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
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Uint8List imageBytes = state is EditProfile
                              ? state.imageByte
                              : widget.profileImage;
                          TeacherModel teacherModel = TeacherModel(
                              id: widget.id,
                              name: nameController.text,
                              email: emailController.text,
                              age: _age.toString(),
                              gender: isMale == true ? "Male" : "Female",
                              password: passwordController.text,
                              profileImage: imageBytes);
                          BlocProvider.of<HomeCubit>(context)
                              .updateTecher(teacherModel);
                        }
                      },
                      child: state is HomeLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white)
                          : const Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    )
                  ],
                )),
          );
        },
        listener: (context, state) {
          if (state is EditSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Update Successfull...')));
          }
          if (state is EditFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Update Failure...')));
          }
        },
      ),
    );
  }

  pickProfileImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final _selectProfile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (_selectProfile != null) {
      setState(() {
        selectedProfile = _selectProfile;
      });
      BlocProvider.of<HomeCubit>(context).pickImage(selectedProfile);

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
        _selectedDOB = pickedDate;
        _age = calculateAge(_selectedDOB!);
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    return age;
  }

  bool _isNumeric(String str) {
    // Check if the string is empty
    if (str.isEmpty) {
      return false;
    }

    // Try parsing the string to an integer
    return int.tryParse(str) != null;
  }
}
