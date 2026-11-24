class Teacher {
  final int id;
  final String firstName;
  final String firstSurname;
  final String secondSurname;
  final String fullName;
  final String phone;
  final String email;
  bool? selected;

  String get nameToShow {
    return "$firstSurname $secondSurname $firstName";
  }

  Teacher({
    required this.id,
    required this.firstName,
    required this.firstSurname,
    required this.secondSurname,
    required this.fullName,
    required this.phone,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      firstSurname: json['first_surname'] as String,
      secondSurname: json['second_surname'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'first_surname': firstSurname,
      'second_surname': secondSurname,
      'full_name': fullName,
      'phone': phone,
      'email': email,
    };
  }
}
