import 'package:flutter/material.dart';

class Alumno {
  final int id;
  final String nombre;
  Alumno({required this.id, required this.nombre});
}

class SelectStudentScreen extends StatefulWidget {
  @override
  _SelectStudentScreenState createState() => _SelectStudentScreenState();
}

class _SelectStudentScreenState extends State<SelectStudentScreen> {
  final List<Alumno> alumnos = [
    Alumno(id: 1, nombre: 'Juan Pérez'),
    Alumno(id: 2, nombre: 'María López'),
    Alumno(id: 3, nombre: 'Carlos Ruiz'),
    Alumno(id: 4, nombre: 'Ana Martínez'),
    Alumno(id: 5, nombre: 'Luis García'),
  ];

  String filtro = '';

  @override
  Widget build(BuildContext context) {
    final alumnosFiltrados = alumnos.where((a) => a.nombre.toLowerCase().contains(filtro.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar Alumno')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar por nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => filtro = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alumnosFiltrados.length,
              itemBuilder: (context, index) {
                final alumno = alumnosFiltrados[index];
                return ListTile(
                  title: Text(alumno.nombre),
                  onTap: () => Navigator.pop(context, alumno),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
