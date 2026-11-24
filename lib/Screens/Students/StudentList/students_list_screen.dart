import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:Padres360/Screens/States/enum_state.dart';
import 'package:Padres360/Screens/Students/StudentList/student_incidence_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../Repo/student_repo.dart';
import 'student_detail_screen.dart';

class StudentsListScreen extends StatefulWidget {
  final Group group;

  const StudentsListScreen({super.key, required this.group});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final StudentRepository _repository = StudentRepository();
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
      final loadedStudents = await _repository.getStudents(
        context: context,
        group: widget.group,
      );
      setState(() {
        students = loadedStudents;
        filteredStudents = students;
        _sortStudentsByName();
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

  void _sortStudentsByName() {
    filteredStudents.sort((a, b) =>
        a.nameToShow.toLowerCase().compareTo(b.nameToShow.toLowerCase()));
  }

  void _toggleSelection(Student student) {
    setState(() {
      student.selected = !(student.selected ?? false);
    });
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

  void _showActionOnSelected(String actionType) {
    switch (actionType) {
      case 'incidencia':
        final selectedStudents = students
            .where((student) => student.selected == true)
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                IncidenceScreen(
                  group: widget.group,
                  studentsSelected: selectedStudents.map((s) => s.id).toList(),
                ),
          ),
        );
        break;


      case 'seleccionarTodo':
        setState(() {
          students.map((student) => student.selected = true).toList();
        });
        break;

      case 'invertirSeleccion':
        setState(() {
          for (var student in students) {
            student.selected = !(student.selected ?? false);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.group.subject),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(icon:
              const Icon(Icons.more_vert),
              onSelected: _showActionOnSelected,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'incidencia',
                  child: Text('Enviar incidencia'),
                ),
                const PopupMenuItem(
                  value: 'seleccionarTodo',
                  child: Text('Seleccionar todo'),
                ),
                const PopupMenuItem(
                  value: 'invertirSeleccion',
                  child: Text('Invertir selección'),
                ),
              ],
            ),
          ],
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
                        onTap: () => _toggleSelection(student),
                        child: CircleAvatar(
                          backgroundColor: student.selected ?? false
                              ? Colors.green
                              : Colors.blue.shade100,
                          child: student.selected ?? false
                              ? const Icon(Icons.check, color: Colors.white)
                              : const SizedBox.shrink(),
                        ),
                      ),
                      title: Text(student.nameToShow),
                      onTap: () {
                        setState(() {
                          student.selected = !(student.selected ?? false);
                        });
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