import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  final String name;
  final String matricula;

  const StudentDetailScreen({
    super.key,
    required this.name,
    required this.matricula,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: $name', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text('Matrícula: $matricula', style: const TextStyle(fontSize: 18)),
            // Aquí puedes agregar más información
          ],
        ),
      ),
    );
  }
}
