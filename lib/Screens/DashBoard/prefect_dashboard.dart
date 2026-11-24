import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/DashBoard/components/dashboard_card.dart';
import 'package:Padres360/Screens/GeneralMessagesStudents/group_list_message.dart';
import 'package:Padres360/Screens/MyIncidencesReported/my_incidences_reported.dart';
import 'package:Padres360/Screens/SosScreen/SOSEmergencyScreen.dart';
import 'package:Padres360/Screens/Teachers/TeacherList/teacher_list_screen.dart';
import 'package:Padres360/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrefectDashboardScreen extends StatefulWidget {
  const PrefectDashboardScreen({super.key});

  @override
  State<PrefectDashboardScreen> createState() => _PrefectDashboardScreenState();
}

class _PrefectDashboardScreenState extends State<PrefectDashboardScreen> {
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
      userName = user.username; // ajusta al campo correcto
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
        backgroundColor: AppColors.kOnPrimary,
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

            /// GRID DE OPCIONES
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 102 / 78,
                  children: [

                    DashboardCard(
                      icon: Icons.school,
                      title: "Registrar\nIncidencias",
                      color: AppColors.kTertiary,
                      onTap: () {
                        Navigator.pushNamed(context, '/student-attendance');
                      },
                    ),

                    DashboardCard(
                      icon: Icons.how_to_reg,
                      title: "Asistencia\nDocentes",
                      color: AppColors.kTertiary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeacherListScreen(),
                          ),
                        );
                      },
                    ),

                    DashboardCard(
                      icon: Icons.message,
                      title: "Mensajes\nAlumnos",
                      color: AppColors.kTertiary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupsListScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      icon: Icons.list,
                      title: "Incidencias\n que registré",
                      color: AppColors.kTertiary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyIncidencesReportedScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// BOTON SOS ABAJO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.warning, size: 32),
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

          ],
        ),
      ),
    );
  }
}

