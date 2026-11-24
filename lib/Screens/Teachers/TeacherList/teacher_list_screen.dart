import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:Padres360/Screens/States/enum_state.dart';
import 'package:Padres360/Screens/Teachers/Model/teacher_model.dart';
import 'package:Padres360/Screens/Teachers/TeacherList/teacher_incidence_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../Repo/teacher_repo.dart';
import 'teacher_detail_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final TeacherRepository _repository = TeacherRepository();
  ListState state = ListState.loading;
  List<Teacher> teachers = [];
  List<Teacher> filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers(context: context);
  }

  Future<void> _loadTeachers({required BuildContext context}) async {
    try {
      final loadedTeachers = await _repository.getTeachers(context: context);
      setState(() {
        teachers = loadedTeachers;
        // Ordenar alfabéticamente por nameToShow
        teachers.sort((a, b) => a.nameToShow.compareTo(b.nameToShow));
        filteredTeachers = teachers;
        if (teachers.isEmpty) {
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

  void _toggleSelection(Teacher teacher) {
    setState(() {
      teacher.selected = !(teacher.selected ?? false);
    });
  }

  void _filterTeachers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTeachers = List.from(teachers); // Crear copia de la lista ordenada
      } else {
        filteredTeachers = teachers
            .where(
              (teacher) => teacher.nameToShow.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
            .toList();
        // Ordenar los resultados filtrados alfabéticamente
        filteredTeachers.sort((a, b) => a.nameToShow.compareTo(b.nameToShow));
      }
    });
  }

  void _showActionOnSelected(String actionType) {
    switch (actionType) {
      case 'incidencia':
        final selectedteachers = teachers
            .where((teacher) => teacher.selected == true)
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeacherIncidenceScreen(
              teachersSelected: selectedteachers.map((s) => s.id).toList(),
            ),
          ),
        );
        break;

      case 'seleccionarTodo':
        setState(() {
          teachers.map((teacher) => teacher.selected = true).toList();
        });
        break;

      case 'invertirSeleccion':
        setState(() {
          for (var teacher in teachers) {
            teacher.selected = !(teacher.selected ?? false);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Docentes'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
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
      body: switch (state) {
        ListState.loading => const LoadingView(),
        ListState.empty => const EmptyView(),
        ListState.error => ErrorView(
          onRetry: () {
            _loadTeachers(context: context);
          },
        ),
        ListState.loaded => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Filtrar docentes',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    // bordes redondeados
                    borderSide: const BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: AppColors.kPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: AppColors.kPrimary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onChanged: _filterTeachers,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTeachers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final teacher = filteredTeachers[index];

                  return ListTile(
                    leading: GestureDetector(
                      onTap: () => _toggleSelection(teacher),
                      child: CircleAvatar(
                        backgroundColor: (teacher.selected ?? false)
                            ? Colors.green
                            : Colors.blue.shade100,
                        child: teacher.selected ?? false
                            ? const Icon(Icons.check, color: Colors.white)
                            : Text(''),
                      ),
                    ),
                    title: Text(teacher.nameToShow),
                    subtitle: Text(teacher.email),
                    onTap: () {
                      teacher.selected = !(teacher.selected ?? false);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      },
    );
  }
}
