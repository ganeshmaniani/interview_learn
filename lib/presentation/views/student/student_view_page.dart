import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/config/widgets/button.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';
import 'package:interview_learn_process/presentation/views/get_start/get_start.dart';
import 'package:interview_learn_process/presentation/views/student/student_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentViewPage extends StatefulWidget {
  final int? id;
  final bool? isHomeOntap;
  const StudentViewPage({super.key, this.id, this.isHomeOntap = false});

  @override
  State<StudentViewPage> createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  @override
  void initState() {
    super.initState();

    initialCallback();
  }

  initialCallback() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = widget.isHomeOntap == true
        ? widget.id
        : preferences.getInt('StudentId');
    BlocProvider.of<HomeCubit>(context).initialCallDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 244, 244),
      appBar: AppBar(
        title: const Text('Student View'),
        centerTitle: true,
        actions: [
          widget.isHomeOntap == true
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const GetStartPage()),
                        (route) => false);
                  },
                  icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is StudentDetail) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        MemoryImage(state.studentModel.profileImage!),
                  ),
                  customContainer(
                      key: "Name", value: state.studentModel.name ?? ''),
                  customContainer(
                      key: "Email", value: state.studentModel.email ?? ''),
                  customContainer(
                      key: "Age", value: state.studentModel.age ?? ''),
                  customContainer(
                      key: "Gender", value: state.studentModel.gender ?? ''),
                  const SizedBox(height: 32),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StudentEditPage(
                                      id: state.studentModel.id ?? 0,
                                      name: state.studentModel.name ?? '',
                                      email: state.studentModel.email ?? '',
                                      age: state.studentModel.age ?? '',
                                      gender: state.studentModel.gender ?? '',
                                      password:
                                          state.studentModel.password ?? '',
                                      profileImage:
                                          state.studentModel.profileImage!,
                                    ))).whenComplete(() => initialCallback());
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            );
          }
          return Container();
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget customContainer({required String key, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(
            key,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 32),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
