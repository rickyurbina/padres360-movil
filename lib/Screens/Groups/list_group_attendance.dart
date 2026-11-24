import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:Padres360/Screens/Groups/Repo/list_group_attendance_repo.dart';
import 'package:Padres360/Screens/Students/StudentList/students_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final ListGroupAttendanceRepo _repository = ListGroupAttendanceRepo();
  late Future<List<Group>> _futureSubjects;
  List<Group> _allSubjects = [];
  List<Group> _filteredSubjects = [];

  String? _selectedGrade = 'Todos';
  String? _selectedGroup = 'Todos';

  final List<String> _grades = ['Todos', '1', '2', '3', '4', '5', '6'];
  final List<String> _groups = [
    'Todos',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() {
    _futureSubjects = _repository.getGroupList(context: context).then((
      subjects,
    ) {
      _allSubjects = subjects;
      _applyFilters();
      return subjects;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredSubjects = _allSubjects.where((subject) {
        final matchesGrade =
            _selectedGrade == 'Todos' ||
                subject.grade.toString() == _selectedGrade;
        final matchesGroup =
            _selectedGroup == 'Todos' || subject.group == _selectedGroup;
        return matchesGrade && matchesGroup;
      }).toList();

      _filteredSubjects.sort((a, b) {
        // Primero comparar por grado numérico
        final gradeComparison = a.grade.compareTo(b.grade);
        if (gradeComparison != 0) {
          return gradeComparison;
        }

        // Si el grado es igual, comparar por grupo (A, B, C, etc.)
        return _compareGroups(a.group, b.group);
      });
    });
  }

        int _compareGroups(String groupA, String groupB) {
      // Convertir a mayúsculas para comparación case-insensitive
      final upperA = groupA.toUpperCase();
      final upperB = groupB.toUpperCase();

      // Comparar letras simples (A, B, C, etc.)
      return upperA.compareTo(upperB);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSurfaceLight,
      appBar: AppBar(title: const Text('Lista de Grupos')),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Group>>(
              future: _futureSubjects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/loading.json',
                      width: 200,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/lottie/error.json', width: 200),
                        const Text('Error al cargar las materias'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _loadSubjects,
                          child: const Text(
                            'Reintentar',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.kPrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final subjects = _filteredSubjects;

                if (subjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/lottie/empty.json', width: 200),
                        const Text('No hay materias disponibles'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subjects.length,
                  itemBuilder: (_, index) {
                    final item = subjects[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => StudentsListScreen(group: item)));
                      },
                      child: Card(
                        color: AppColors.kPrimary.withAlpha(50),
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.subject!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.teacher!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.grade} - ${item.group}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        item.shift.toLowerCase() == 'matutino'
                                            ? Icons.wb_sunny
                                            : Icons.nights_stay,
                                        color: item.shift.toLowerCase() == 'matutino'
                                            ? Colors.orange
                                            : Colors.indigo,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.shift,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child:
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedGrade,
              decoration: InputDecoration(
                labelText: 'Grado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: AppColors.kNeutral700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: AppColors.kPrimary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
              ),
              items: _grades.map((grade) {
                return DropdownMenuItem(value: grade, child: Text(grade));
              }).toList(),
              onChanged: (value) {
                _selectedGrade = value;
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedGroup,
              decoration: InputDecoration(
                labelText: 'Grupo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: AppColors.kNeutral700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: AppColors.kPrimary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
              ),
              items: _groups.map((group) {
                return DropdownMenuItem(value: group, child: Text(group));
              }).toList(),
              onChanged: (value) {
                _selectedGroup = value;
                _applyFilters();
              },
            ),
          ),
        ],
      ),
    );
  }
}
