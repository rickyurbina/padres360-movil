import 'package:Padres360/Screens/Message/MessageToParents/select_student.dart';
import 'package:flutter/material.dart';

class SendMessageScreen extends StatefulWidget {
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  Alumno? alumnoSeleccionado;
  final TextEditingController _mensajeController = TextEditingController();

  Future<void> _seleccionarAlumno() async {
    final alumno = await Navigator.pushNamed(context, '/select-student') as Alumno?;
    if (alumno != null) {
      setState(() {
        alumnoSeleccionado = alumno;
      });
    }
  }

  void _enviarMensaje() {
    final texto = _mensajeController.text.trim();

    if (alumnoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona un alumno primero')),
      );
      return;
    }

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Escribe un mensaje antes de enviar')),
      );
      return;
    }

    // Aquí agregar lógica para enviar el mensaje a backend o servicio
    print('Enviar mensaje a padres de ${alumnoSeleccionado!.nombre}: $texto');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensaje enviado a ${alumnoSeleccionado!.nombre}')),
    );

    _mensajeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Mensaje a Padres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _seleccionarAlumno,
              icon: Icon(Icons.search),
              label: Text(alumnoSeleccionado == null ? 'Seleccionar Alumno' : 'Alumno: ${alumnoSeleccionado!.nombre}'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mensajeController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarMensaje,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
