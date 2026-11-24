import 'dart:async';

class AlumnoRepositoryMock {
  Future<List<Map<String, String>>> fetchAlumnos({String filtro = ''}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      20,
          (index) => {
        'name': 'Alumno ${index + 1}',
        'matricula': 'A00${index + 1}',
      },
    );
  }

  Future<void> enviarMensaje({required int alumnoId, required String mensaje}) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simula envío
    print('Mensaje enviado a alumnoId $alumnoId: $mensaje');
  }
}
