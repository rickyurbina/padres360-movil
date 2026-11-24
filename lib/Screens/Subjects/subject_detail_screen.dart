import 'package:flutter/material.dart';

class SubjectDetailScreen extends StatelessWidget {
  final String subjectName;
  final String grade;
  final String group;
  final String shift;

  const SubjectDetailScreen({
    super.key,
    required this.subjectName,
    required this.grade,
    required this.group,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grado: $grade', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Grupo: $group', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Docente: $shift', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.group),
              label: const Text('Ver lista de alumnos'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/students', arguments: {
                  'subject': subjectName,
                  'grade': grade,
                  'group': group,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
