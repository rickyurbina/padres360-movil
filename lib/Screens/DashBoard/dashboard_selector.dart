import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/user_role_enum.dart';
import 'package:Padres360/Screens/DashBoard/default_dashboard.dart';
import 'package:Padres360/Screens/DashBoard/educational_guidance_dashboard.dart';
import 'package:Padres360/Screens/DashBoard/nursing_dasboard.dart';
import 'package:Padres360/Screens/DashBoard/prefect_dashboard.dart';
import 'package:Padres360/Screens/DashBoard/principal_dashboard.dart';
import 'package:Padres360/Screens/DashBoard/school_services_dashboard.dart';
import 'package:Padres360/Screens/DashBoard/teaching_services_dashboard.dart';
import 'package:flutter/material.dart';

import 'parent_dashboard.dart';
import 'teacher_dashboard.dart';

class DashboardSelector extends StatelessWidget {
  const DashboardSelector({super.key});

  Future<User> getProfileId() async {
    final prefs = await UserService.getUser();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getProfileId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras carga
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Error al cargar el perfil
          return const Scaffold(
            body: Center(child: Text('Error al obtener el perfil')),
          );
        } else {
          final user = snapshot.data!;

          switch (user.role){
            case UserRole.PRINCIPAL:
              return const PrincipalDashboard();
            case UserRole.TEACHING_SERVICES:
              return const TeachingServicesDashboard();
            case UserRole.SCHOOL_SERVICES:
              return const SchoolServicesDashboard();
            case UserRole.PREFECTURE:
              return const PrefectDashboardScreen();
            case UserRole.EDUCATIONAL_GUIDANCE:
              return const EducationalGuidanceDashboard();
            case UserRole.NURSING:
              return const NursingDashboard();
            case UserRole.TEACHER:
              return const TeacherDashboard();
            case UserRole.PARENT:
              return const ParentDashboard();
            case UserRole.DEFAULT:
              return const DefaultDashboard();
          }
        }
      },
    );
  }
}
