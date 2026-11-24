class IncidenceModelSend {
  final int incidence;
  final String observation;
  final String type;
  final int? student;
  final int? teacher;

  IncidenceModelSend({
    required this.incidence,
    required this.observation,
    required this.type,
    this.student,
    this.teacher,
  });

  factory IncidenceModelSend.fromJson(Map<String, dynamic> json) {
    return IncidenceModelSend(
      incidence: json['incidence'] as int,
      observation: json['observation'] as String,
      type: json['type'] as String,
      student: json['student'] != null ? json['student' ]as int : null,
      teacher: json['teacher'] != null ? json['teacher'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incidence': incidence,
      'observation': observation,
      'type': type,
      'student': student,
      'teacher': teacher,
    };
  }
}
