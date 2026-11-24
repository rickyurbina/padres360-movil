class UserInfo {
  final int id;
  final String username;
  final String email;
  final bool isStaff;
  final String profile;
  final dynamic students;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.profile,
    this.students,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isStaff: json['is_staff'],
      profile: json['profile'],
      students: json['students'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_staff': isStaff,
      'profile': profile,
      'students': students,
    };
  }

  factory UserInfo.empty() {
    return UserInfo(
      id: 0,
      username: '',
      email: '',
      isStaff: false,
      profile: '',
      students: null,
    );
  }
}
