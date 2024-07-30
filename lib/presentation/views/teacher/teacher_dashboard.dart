import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';
import 'package:interview_learn_process/presentation/views/student/student_register.dart';

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
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    await homeCubit.getTeacherDetails(); // Ensure await for async operations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: const EdgeInsets.only(
                        top: 32, right: 16, left: 16, bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.5)),
                    child: Row(
                      children: [
                        CircleAvatar(
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
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.logout))
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                      child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final student = state.studentList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: MemoryImage(student.profileImage!),
                        ),
                        title: Text(student.name ?? ''),
                        subtitle: Text(
                            'Age: ${student.age ?? ''}, Email: ${student.email ?? ''}'),
                        onTap: () {
                          // Handle student item tap
                        },
                        trailing: IconButton(
                            onPressed: () {
                              BlocProvider.of<HomeCubit>(context)
                                  .deleteStudent(student.id ?? 0);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
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
