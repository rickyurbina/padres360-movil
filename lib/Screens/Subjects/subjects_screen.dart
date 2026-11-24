import 'package:Padres360/Screens/Subjects/Repo/subjects_repo.dart';
import 'package:Padres360/Screens/Subjects/subject_detail_screen.dart'
    show SubjectDetailScreen;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final SubjectRepository _repository = SubjectRepository();
  late Future<List<Map<String, String>>> _futureSubjects;

  String? _selectedGrade;
  String? _selectedGroup;

  final List<String> _grades = ['1°', '2°', '3°'];
  final List<String> _groups = ['A', 'B'];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() {
    setState(() {
      _futureSubjects = _repository.getSubjects(
        grade: _selectedGrade,
        group: _selectedGroup,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Materias'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
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
                        ElevatedButton(
                          onPressed: _loadSubjects,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final subjects = snapshot.data ?? [];

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubjectDetailScreen(
                              subjectName: item['subject']!,
                              grade: item['grade']!,
                              group: item['group']!,
                              shift: item['teacher']!,
                            ),
                          ),
                        );
                      },
                      child: Card(
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
                                item['subject']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Grado: ${item['grade']}'),
                              Text('Grupo: ${item['group']}'),
                              Text('Docente: ${item['teacher']}'),
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
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedGrade,
              decoration: const InputDecoration(labelText: 'Grado'),
              items: _grades.map((grade) {
                return DropdownMenuItem(value: grade, child: Text(grade));
              }).toList(),
              onChanged: (value) {
                _selectedGrade = value;
                _loadSubjects();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedGroup,
              decoration: const InputDecoration(labelText: 'Grupo'),
              items: _groups.map((group) {
                return DropdownMenuItem(value: group, child: Text(group));
              }).toList(),
              onChanged: (value) {
                _selectedGroup = value;
                _loadSubjects();
              },
            ),
          ),
        ],
      ),
    );
  }
}
