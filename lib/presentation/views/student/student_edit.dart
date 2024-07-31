import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';

import '../../../core/validator/validator.dart';

class StudentEditPage extends StatefulWidget {
  final int id;
  final String name;
  final String email;
  final String age;
  final String gender;
  final String password;
  final Uint8List profileImage;
  const StudentEditPage(
      {super.key,
      required this.id,
      required this.name,
      required this.email,
      required this.age,
      required this.gender,
      required this.password,
      required this.profileImage});

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> with InputValidator {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentEmailController = TextEditingController();
  TextEditingController studentPasswordController = TextEditingController();
  DateTime? _selectedDOB;
  int? _age;
  bool isMale = false;
  bool isFemale = false;
  bool isOthers = false;
  XFile? selectedProfile;
  @override
  void initState() {
    super.initState();
    studentNameController = TextEditingController(text: widget.name);
    studentEmailController = TextEditingController(text: widget.email);
    studentPasswordController = TextEditingController(text: widget.password);
    _age = int.parse(widget.age);
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
            title: const Text(
          'Edit Student Detail',
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        body: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (state is EditProfileImage)
                        GestureDetector(
                          onTap: () => pickImage(),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(state.imageByte),
                          ),
                        )
                      else
                        GestureDetector(
                            onTap: () => pickImage(),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(widget.profileImage),
                            )),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: studentNameController,
                        label: "Student Name",
                        validator: (name) {
                          if (isCheckTextFieldEmpty(name!)) {
                            return null;
                          } else {
                            return 'Enter a name';
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: studentEmailController,
                        label: "Student Email",
                        validator: (email) {
                          if (isEmailValid(email!)) {
                            return null;
                          } else {
                            return 'Enter a email address';
                          }
                        },
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: studentPasswordController,
                        label: "Student Password",
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
                              Uint8List imageBytes = state is EditProfileImage
                                  ? state.imageByte
                                  : widget.profileImage;
                              StudentModel studentModel = StudentModel(
                                  id: widget.id,
                                  name: studentNameController.text,
                                  email: studentEmailController.text,
                                  age: _age.toString(),
                                  gender: isMale == true
                                      ? 'Male'
                                      : isFemale
                                          ? 'Female'
                                          : isOthers
                                              ? 'Others'
                                              : "",
                                  profileImage: imageBytes,
                                  password: studentPasswordController.text);
                              BlocProvider.of<AuthCubit>(context)
                                  .updateStudent(studentModel);
                            }
                          },
                          child: state is StudentEditButtonLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ))
                    ],
                  )),
            );
          },
          listener: (context, state) {
            if (state is StudentEditSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Student Update Successfull')));
              Navigator.pop(context);
            }
            if (state is StudentEditFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
            if (state is EditProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage)));
            }
          },
        ));
  }

  pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final _selectedProfile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);
    if (_selectedProfile != null) {
      setState(() {
        selectedProfile = _selectedProfile;
      });
      BlocProvider.of<AuthCubit>(context).pickEditImage(selectedProfile);
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
}
