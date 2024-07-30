import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_cubit.dart';
import 'package:interview_learn_process/presentation/bloc/home/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key});

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
    var id = preferences.getInt('StudentId');
    BlocProvider.of<HomeCubit>(context).initialCallDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student View'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is StudentDetail) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                MemoryImage(state.studentModel.profileImage!))),
                  )
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
}
