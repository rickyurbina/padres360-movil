import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/DashBoard/components/dashboard_card.dart';
import 'package:Padres360/Screens/EmergencyData/student_list_for_emergencyData.dart';
import 'package:Padres360/Screens/SosScreen/SOSEmergencyScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Padres360/constants.dart';

class NursingDashboard extends StatefulWidget {
  const NursingDashboard({super.key});

  @override
  State<NursingDashboard> createState() => _NursingDashboardState();
}

class _NursingDashboardState extends State<NursingDashboard> {
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
                      svgAsset: 'assets/icons/medical_data.svg',
                      title: "Datos Médicos\nAlumnos",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentListForEmergencyData(),
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