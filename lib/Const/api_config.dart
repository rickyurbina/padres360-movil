import 'package:Padres360/env/environment.dart';

class APIConfig {
  static String domain = Environment().config?.baseUrl ?? '';

  // Account
  static const String register = 'api/register/';
  static const String login = 'api/accounts/login/';
  static const String logout = 'api/accounts/logout/';
  static const String tokenRefresh = 'api/token/refresh/';
  static const String userInfo = 'api/accounts/user-information/';
  static const String recoveryPass = 'api/accounts/send-password-reset-email/';

  static String userUpdate(int pk) => 'api/accounts/user-update/$pk/';

  // Groups API
  static String group(int groupId) => 'api/groups/$groupId/';
  static const String groupList = 'api/teachers/groups-subjects-teachers/';
  static String studentList(int groupId) => 'api/groups/$groupId/students/';

  // Parents
  static const String parentCreate = 'parents/api/create/';
  static String parentUpdateFcm(int parentId) => 'api/parents/$parentId/update-fcm/';
  static String teacherUpdateFcm(int teacherId) => 'api/teachers/$teacherId/update-fcm/';

  // Students
  static const String studentCreate = 'students/api/create/';
  static const String allStudentList = 'api/students/list';

  // Incidences
  static const String studentIncidenceList = 'api/incidences/list/';
  static const String createIncidence = 'api/incidences/incidence-records/';
  static const String allTeacherIncidences = 'api/incidences/teacher-incidences/';
  static const String allStudentIncidences = 'api/incidences/student-incidences/';
  static String getNotificationById(int id) => 'api/incidences/$id/details/';

  static String readIncidence(int parentId) => 'api/incidences/parents/$parentId/';
  static String markReadIncidence(int incidenceId) => 'api/incidences/$incidenceId/mark-read/';
  static String readIncidenceTeacher(int teacherId) => 'api/incidences/teachers/$teacherId/';

  // Teachers
  static const String teacherList = 'api/teachers/teachers-list/';

  // Emergency data
  static const String getEmergencyData = 'api/students/medical-information/get/';
  static const String updateEmergencyData = 'api/students/medical-information/create-update/';
}
