// lib/repositories/subject_repo.dart

class SubjectRepository {
  Future<List<Map<String, String>>> getSubjects({String? grade, String? group}) async {
    await Future.delayed(const Duration(seconds: 1));

    final data = [
      {'subject': 'Matemáticas', 'grade': '1°', 'group': 'A', 'teacher': 'Mtro. Juan Pérez'},
      {'subject': 'Español', 'grade': '1°', 'group': 'B', 'teacher': 'Mtra. Laura Díaz'},
      {'subject': 'Ciencias', 'grade': '2°', 'group': 'A', 'teacher': 'Mtro. Pedro Gómez'},
      {'subject': 'Historia', 'grade': '2°', 'group': 'B', 'teacher': 'Mtra. Ana Torres'},
      {'subject': 'Geografía', 'grade': '3°', 'group': 'A', 'teacher': 'Mtro. Carlos Ruiz'},
    ];

    return data.where((item) {
      final matchesGrade = grade == null || item['grade'] == grade;
      final matchesGroup = group == null || item['group'] == group;
      return matchesGrade && matchesGroup;
    }).toList();
  }
}
