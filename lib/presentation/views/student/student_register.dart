import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/config/widgets/text_field.dart';
import 'package:interview_learn_process/data/model/student_model/student_model.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/auth/auth_state.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentEmailController = TextEditingController();
  final TextEditingController studentPasswordController =
      TextEditingController();
  DateTime? _selectedDOB;
  int? _age;
  bool isMale = false;
  bool isFemale = false;
  bool isOthers = false;
  XFile? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 252, 250, 250).withOpacity(0.9),
        appBar: AppBar(
            title: const Text(
          'Add Student Detail',
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
                      if (state is AuthProfile)
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
                          child: Container(
                            height: 80,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              size: 36,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                          controller: studentNameController,
                          label: "Student Name"),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                          controller: studentEmailController,
                          label: "Student Email"),
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
                          label: "Student Password"),
                      const SizedBox(height: 32),
                      CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                state is AuthProfile) {
                              StudentModel studentModel = StudentModel(
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
                                  profileImage: state.imageByte,
                                  password: studentPasswordController.text);
                              BlocProvider.of<AuthCubit>(context)
                                  .createStudent(studentModel);
                              if (state is AuthSuccess) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Student Add Successfull')));
                              }
                            }
                          },
                          child: state is AuthLoading
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
          listener: (context, state) {},
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
      BlocProvider.of<AuthCubit>(context).pickRegisterImage(selectedProfile);
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
