import 'package:Padres360/Screens/Authentication/Sign%20In/Model/user_role_enum.dart';
import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';

class User {
  int id;
  String username;
  String email;
  bool isStaff;
  String profile;
  List<Student> students;
  Tokens tokens;
  int parentId;
  String firstName;
  String lastName;
  UserRole role;
  int teacherId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.profile,
    required this.students,
    Tokens? tokens,
    required this.parentId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.teacherId,
  }) : tokens = tokens ?? Tokens.empty();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isStaff: json['is_staff'] ?? false,
      profile: json['profile'] ?? '',
      students: (json['students'] != null && json['students'] is List)
          ? (json['students'] as List)
                .map((studentJson) => Student.fromJson(studentJson))
                .toList()
          : <Student>[],
      tokens: Tokens.fromJson(json['tokens'] as Map<String, dynamic>?),
      parentId: json['parent_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: UserRole.fromString(json['role'] ?? ''),
      teacherId: json['teacher_id'] ?? 0,
    );
  }

  String get roleLabel => role.label;

  String get fullName => '${firstName} ${lastName}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_staff': isStaff,
      'profile': profile,
      'students': students.map((s) => s.toJson()).toList(),
      'tokens': tokens.toJson(),
      'parent_id': parentId,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory User.empty() {
    return User(
      id: 0,
      username: '',
      email: '',
      isStaff: false,
      profile: '',
      students: [],
      tokens: Tokens.empty(),
      parentId: 0,
      firstName: '',
      lastName: '',
      role: UserRole.DEFAULT,
      teacherId: 0,
    );
  }
}

class Student {
  int id;
  Group group;
  String firstName;
  String firstSurname;
  String secondSurname;
  String controlNumber;
  String curp;
  String uuid;
  List<int> parent;

  String get lastName {
    if (firstSurname == null) return secondSurname;
    if (secondSurname == null) return firstSurname;
    return '$firstSurname $secondSurname';
  }

  String get nameToShow {
    return "$firstSurname $secondSurname $firstName";
  }

  Student({
    required this.id,
    required this.group,
    required this.firstName,
    required this.firstSurname,
    required this.secondSurname,
    required this.controlNumber,
    required this.curp,
    required this.uuid,
    required this.parent,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      group: json['group'] != null
          ? Group.fromJson(json['group'])
          : Group.empty(),
      firstName: json['first_name'] ?? '',
      firstSurname: json['first_surname'] ?? '',
      secondSurname: json['second_surname'] ?? '',
      controlNumber: json['control_number'] ?? '',
      curp: json['curp'] ?? '',
      uuid: json['uuid'] ?? '',
      parent: json['parent'] != null ? List<int>.from(json['parent']) : <int>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group,
      'first_name': firstName,
      'first_surname': firstSurname,
      'second_surname': secondSurname,
      'control_number': controlNumber,
      'curp': curp,
      'uuid': uuid,
      'parent': parent,
    };
  }

  factory Student.empty() {
    return Student(
      id: 0,
      group: Group.empty(),
      firstName: '',
      firstSurname: '',
      secondSurname: '',
      controlNumber: '',
      curp: '',
      uuid: '',
      parent: [],
    );
  }


}

class Tokens {
  String refresh;
  String access;

  Tokens({required this.refresh, required this.access});

  factory Tokens.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Tokens.empty();
    }
    return Tokens(refresh: json['refresh'] ?? '', access: json['access'] ?? '');
  }

  factory Tokens.empty() {
    return Tokens(refresh: '', access: '');
  }

  Map<String, dynamic> toJson() {
    return {'refresh': refresh, 'access': access};
  }
}

class Group {
  int id;
  String name;
  int grade;
  String specialty;
  String shift;

  Group({
    required this.id,
    required this.name,
    required this.grade,
    required this.specialty,
    required this.shift,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      grade: json['grade'] ?? 0,
      specialty: json['specialty'] ?? '',
      shift: json['shift'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'specialty': specialty,
      'shift': shift,
    };
  }

  factory Group.empty() {
    return Group(
      id: 0,
      name: '',
      grade: 0,
      specialty: '',
      shift: '',
    );
  }
}
