import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';
import 'package:interview_learn_process/presentation/views/get_start/get_start.dart';
import 'package:interview_learn_process/presentation/views/student/student_edit.dart';
import 'package:interview_learn_process/presentation/views/student/student_register.dart';
import 'package:interview_learn_process/presentation/views/teacher/techer_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  @override
  void initState() {
    super.initState();
    initTeacherDetail();
  }

  void initTeacherDetail() async {
    // Check for errors in state transitions
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getInt("TeacherId");
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    await homeCubit.getTeacherDetails(id); // Ensure await for async operations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 252, 250, 250).withOpacity(0.9),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AddStudentPage()))
                  .whenComplete(() => initTeacherDetail());
            },
            label: const Row(
              children: [Text('Add Student'), Icon(Icons.add)],
            )),
        body: BlocConsumer<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoadData) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.only(
                        top: 32, right: 16, left: 16, bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.5)),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              MemoryImage(state.teacherModel.profileImage!),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.teacherModel.name ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              state.teacherModel.email ?? '',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherEditPage(
                                            id: state.teacherModel.id ?? 0,
                                            name: state.teacherModel.name ?? '',
                                            email:
                                                state.teacherModel.email ?? '',
                                            age: state.teacherModel.age ?? '',
                                            gender:
                                                state.teacherModel.gender ?? '',
                                            profileImage: state
                                                .teacherModel.profileImage!,
                                            password:
                                                state.teacherModel.password ??
                                                    '',
                                          ))).whenComplete(
                                  () => initTeacherDetail());
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GetStartPage()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.logout))
                      ],
                    ),
                  ),
                  const Text('Student List',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  state.studentList.isEmpty
                      ? const Center(child: Text("No Student List Found"))
                      : Expanded(
                          child: ListView.separated(
                          padding: const EdgeInsets.all(8.0),
                          itemBuilder: (context, index) {
                            final student = state.studentList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentEditPage(
                                              id: student.id ?? 0,
                                              name: student.name ?? '',
                                              age: student.age ?? '',
                                              email: student.email ?? '',
                                              gender: student.gender ?? '',
                                              password: student.password ?? '',
                                              profileImage:
                                                  student.profileImage!,
                                            ))).whenComplete(
                                    () => initTeacherDetail());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          MemoryImage(student.profileImage!),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name ?? '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          student.email ?? '',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    IconButton(
                                        onPressed: () {
                                          BlocProvider.of<HomeCubit>(context)
                                              .deleteStudent(student.id ?? 0);
                                          setState(() {
                                            initTeacherDetail();
                                          });
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemCount: state.studentList.length,
                        )),
                ],
              );
            }

            return Container();
          },
          listener: (context, state) {},
        ));
  }
}
