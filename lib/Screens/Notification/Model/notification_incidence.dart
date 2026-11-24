class NotificationIncidence {
  int id;
  int incidence;
  String incidenceName;
  String observation;
  String type;
  bool read;
  DateTime createdAt;
  String personName; // Puede ser alumno o docente
  int studentId;
  String createdBy;

  String get incidenceToShow {
    return "$incidenceName - $observation";
  }

  NotificationIncidence({
    required this.id,
    required this.incidence,
    required this.incidenceName,
    required this.observation,
    required this.type,
    required this.read,
    required this.createdAt,
    required this.personName,
    required this.studentId,
    required this.createdBy
  });

  factory NotificationIncidence.fromJson(Map<String, dynamic> json) {
    return NotificationIncidence(
      id: json['id'] ?? 0,
      incidence: json['incidence'] ?? 0,
      incidenceName: json['incidence_name'] ?? '',
      observation: json['observation'] ?? '',
      type: json['type'] ?? '',
      read: json['read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      personName: json['teacher_name'] ?? json['student_name'] ?? '',
      studentId: json['student'] ?? 0,
      createdBy: json['created_by_name'] ?? ''
    );
  }

  factory NotificationIncidence.empty() {
    return NotificationIncidence(
        id: 0,
        incidence: 0,
        incidenceName: '',
        observation: '',
        type: '',
        read: false,
        createdAt: DateTime.now(),
        personName: '',
        studentId: 0,
        createdBy: ''
    );
  }
}
