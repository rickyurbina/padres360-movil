import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/EmergencyData/Repo/get_all_students.dart';
import 'package:Padres360/Screens/EmergencyData/emergency_data_screen.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:Padres360/Screens/States/enum_state.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StudentListForEmergencyData extends StatefulWidget {

  const StudentListForEmergencyData({super.key});

  @override
  State<StudentListForEmergencyData> createState() => _StudentListForEmergencyDataState();
}

class _StudentListForEmergencyDataState extends State<StudentListForEmergencyData> {
  final EmergencyDataRepository _repository = EmergencyDataRepository();
  ListState state = ListState.loading;
  List<Student> filteredStudents = [];
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents(context: context);
  }

  Future<void> _loadStudents({required BuildContext context}) async {
    try {
      final loadedStudents = await _repository.getAllStudents(
        context: context,
      );
      setState(() {
        students = loadedStudents;
        filteredStudents = students;
        if (students.isEmpty) {
          state = ListState.empty;
        } else {
          state = ListState.loaded;
        }
      });
    } catch (e) {
      setState(() {
        state = ListState.error;
      });
    }
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students
            .where((student) =>
            student.nameToShow.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Alumnos'),
          centerTitle: true,
        ),
        body: switch(state) {
          ListState.loading => const LoadingView(),
          ListState.empty => const EmptyView(),
          ListState.error =>
              ErrorView(
                  onRetry: () {
                    _loadStudents(context: context);
                  }
              ),
          ListState.loaded => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Filtrar estudiantes',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40), // bordes redondeados
                      borderSide: const BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(color: AppColors.kPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(color: AppColors.kPrimary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onChanged: _filterStudents,
                ),

              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];

                    return ListTile(
                      leading: GestureDetector(
                        onTap: () => {
                          
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const SizedBox.shrink(),
                        ),
                      ),
                      title: Text(student.nameToShow),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                            EmergencyDataScreen(student: student)));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        }
    );
  }
}