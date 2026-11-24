class Group {
  int id;
  int grade;
  String shift;
  String group;
  String subject;
  String teacher;

  Group({
    required this.id,
    required this.grade,
    required this.shift,
    required this.group,
    required this.subject,
    required this.teacher,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      grade: json['grade'] ?? 0,
      shift: json['shift'] ?? '',
      group: json['group'] ?? '',
      subject: json['subject'] ?? '',
      teacher: json['teacher'] ?? '',
    );
  }
}

class Student {
  int id;
  String firstName;
  String firstSurname;
  String secondSurname;
  String fullName;
  String controlNumber;
  bool? selected;

  String get nameToShow {
    return "$firstSurname $secondSurname $firstName";
  }

  Student({
    required this.id,
    required this.firstName,
    required this.firstSurname,
    required this.secondSurname,
    required this.fullName,
    required this.controlNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      firstSurname: json['first_surname'] ?? '',
      secondSurname: json['second_surname'] ?? '',
      fullName: json['full_name'] ?? '',
      controlNumber: json['control_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'first_surname': firstSurname,
      'second_surname': secondSurname,
      'full_name': fullName,
      'control_number': controlNumber,
    };
  }
}

