class IncidenceTeacher {
  final int id;
  final String incidenceName;
  final String teacherName;
  final String observation;
  final String type;
  final DateTime createdAt;
  final bool read;
  final String createdByName;
  final String studentName;

  String get incidenceToShow {
    return "$incidenceName - $observation";
  }

  IncidenceTeacher({
    required this.id,
    required this.incidenceName,
    required this.teacherName,
    required this.observation,
    required this.type,
    required this.createdAt,
    required this.read,
    required this.createdByName,
    required this.studentName
  });

  factory IncidenceTeacher.fromJson(Map<String, dynamic> json) {
    return IncidenceTeacher(
      id: (json['id'] ??  0) as int,
      incidenceName: (json['incidence_name'] ?? '' ) as String,
      teacherName: (json['teacher_name'] ?? '' ) as String,
      observation: (json['observation'] ?? '' ) as String,
      type: (json['type'] ?? '' ) as String,
      createdAt: DateTime.parse((json['created_at'] ?? DateTime.now().toIso8601String()) as String),
      read: (json['read'] ?? false ) as bool,
      createdByName: (json['created_by_name'] ?? '' )  as String,
      studentName: (json['student_name'] ?? '' ) as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidence_name': incidenceName,
      'teacher_name': teacherName,
      'observation': observation,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'read': read,
      'created_by_name': createdByName,
    };
  }

  @override
  String toString() {
    return 'Incidence(id: $id, incidenceName: $incidenceName, teacherName: $teacherName, read: $read)';
  }

  // Método para copiar el objeto con algunos campos modificados
  IncidenceTeacher copyWith({
    int? id,
    String? incidenceName,
    String? teacherName,
    String? observation,
    String? type,
    DateTime? createdAt,
    bool? read,
    String? createdByName,
    String? studentName
  }) {
    return IncidenceTeacher(
      id: id ?? this.id,
      incidenceName: incidenceName ?? this.incidenceName,
      teacherName: teacherName ?? this.teacherName,
      observation: observation ?? this.observation,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      createdByName: createdByName ?? this.createdByName,
      studentName: studentName ?? this.studentName
    );
  }
}

// Clase helper para trabajar con listas de incidencias
class IncidenceTeacherList {
  final List<IncidenceTeacher> incidences;

  IncidenceTeacherList(this.incidences);

  factory IncidenceTeacherList.fromJson(List<dynamic> json) {
    return IncidenceTeacherList(
      json.map((item) => IncidenceTeacher.fromJson(item)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return incidences.map((incidence) => incidence.toJson()).toList();
  }

  // Métodos útiles
  List<IncidenceTeacher> get unreadIncidences =>
      incidences.where((incidence) => !incidence.read).toList();

  List<IncidenceTeacher> get readIncidences =>
      incidences.where((incidence) => incidence.read).toList();

  List<IncidenceTeacher> getByTeacher(String teacherName) =>
      incidences.where((incidence) => incidence.teacherName == teacherName).toList();

  List<IncidenceTeacher> getByReporter(String reporterName) =>
      incidences.where((incidence) => incidence.createdByName == reporterName).toList();

  List<IncidenceTeacher> getByType(String type) =>
      incidences.where((incidence) => incidence.type == type).toList();

  List<IncidenceTeacher> getByDateRange(DateTime start, DateTime end) =>
      incidences.where((incidence) =>
      incidence.createdAt.isAfter(start) && incidence.createdAt.isBefore(end)
      ).toList();

  // Método para las estadísticas del dashboard
  Map<String, int> getTeacherSummary(List<IncidenceTeacher> list) {
    final Map<String, int> summary = {};
    for (var incidence in list) {
      summary[incidence.teacherName] = (summary[incidence.teacherName] ?? 0) + 1;
    }
    return summary;
  }

  Map<String, int> getStudentSummary(List<IncidenceTeacher> list) {
    final Map<String, int> summary = {};
    for (var incidence in list) {
      summary[incidence.studentName] = (summary[incidence.studentName] ?? 0) + 1;
    }
    return summary;
  }

  Map<String, int> getReporterSummary(List<IncidenceTeacher> list) {
    final Map<String, int> summary = {};
    for (var incidence in list) {
      summary[incidence.createdByName] = (summary[incidence.createdByName] ?? 0) + 1;
    }
    return summary;
  }

  Map<String, int> getTypeSummary(List<IncidenceTeacher> list) {
    final Map<String, int> summary = {};
    for (var incidence in list) {
      summary[incidence.incidenceName] = (summary[incidence.incidenceName] ?? 0) + 1;
    }
    return summary;
  }
}