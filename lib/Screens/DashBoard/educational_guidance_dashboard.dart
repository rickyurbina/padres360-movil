import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/DashBoard/components/dashboard_card.dart';
import 'package:Padres360/Screens/GeneralMessagesStudents/group_list_message.dart';
import 'package:Padres360/Screens/Incidedences Dashboard/IncidencesDashboard.dart';
import 'package:Padres360/Screens/Incidences Dashboard Alumnos/IncidencesDashboard.dart';
import 'package:Padres360/Screens/SosScreen/SOSEmergencyScreen.dart';
import 'package:Padres360/Screens/Teachers/TeacherList/teacher_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Padres360/constants.dart';

class EducationalGuidanceDashboard extends StatefulWidget {
  const EducationalGuidanceDashboard({super.key});

  @override
  State<EducationalGuidanceDashboard> createState() =>
      _EducationalGuidanceDashboardState();
}

class _EducationalGuidanceDashboardState
    extends State<EducationalGuidanceDashboard> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await UserService.getUser();
    setState(() {
      userName = user.username;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kMainColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 16,
          surfaceTintColor: AppColors.kOnSecondary,
          backgroundColor: AppColors.kOnSecondary,
          centerTitle: false,
          title: Text(
            '${userName ?? ''}',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.kOnSurfaceLight
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  (userName != null && userName!.isNotEmpty)
                      ? userName![0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [

            /// GRID DE BOTONES
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [

                    DashboardCard(
                      icon: Icons.assignment,
                      title: "Registrar\nIncidencia",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/student-attendance',
                        );
                      },
                    ),

                    DashboardCard(
                      icon: Icons.bar_chart,
                      title: "Dashboard\nAlumnos",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const IncidencesStudentDashboard(),
                          ),
                        );
                      },
                    ),

                    DashboardCard(
                      icon: Icons.person,
                      title: "Incidencias\nDocentes",
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TeacherListScreen(),
                          ),
                        );
                      },
                    ),

                    DashboardCard(
                      icon: Icons.mail_outline,
                      title: "Buzón de\nmensajes",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupsListScreen(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),

            /// BOTON SOS ABAJO
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.warning_rounded, size: 30),
                    label: const Text(
                      "SOS — Emergencia escolar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kEmergency,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SOSEmergencyScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}