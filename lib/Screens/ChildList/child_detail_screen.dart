import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/EmergencyData/emergency_data_screen.dart';
import 'package:Padres360/Screens/Notification/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Authentication/Sign In/Model/LogInResponseModel.dart';

class ChildDetailScreen extends StatelessWidget {
  final Student student;

  const ChildDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Alumno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------- CARD PRINCIPAL ----------
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade50,
                      Colors.white,
                      Colors.blue.shade50,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // -------------------------
                      // Datos Generales
                      // -------------------------
                      Text(
                        '${student.firstName} ${student.lastName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        '${student.group?.grade ?? ""}${student.group?.name ?? ""}  ${student.group?.specialty ?? ""}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Text(
                            'No. Control: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            student.controlNumber ?? 'No disponible',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'CURP:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        student.curp,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 25),
/*
                      // -------------------------
                      // Datos Médicos (estilo simple)
                      // -------------------------
                      const Text(
                        'Datos Médicos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildMedicalLine(
                        title: "Tipo de servicio médico:",
                        value:  "No disponible",
                      ),

                      _buildMedicalLine(
                        title: "Número de servicio médico:",
                        value:  "No disponible",
                      ),

                      _buildMedicalLine(
                        title: "Alergias:",
                        value:  "Sin alergias registradas",
                      ),

                      _buildMedicalLine(
                        title: "Medicamento actual:",
                        value:  "No especificado",
                      ),

                      _buildMedicalLine(
                        title: "Tipo de sangre:",
                        value:  "Desconocido",
                      ),*/
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ---------- BOTONES INFERIORES ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón incidencias
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(student: student),
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.kSecondary,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                  ),
                ),

                const SizedBox(width: 30),

                // Botón datos médicos
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmergencyDataScreen(student: student),
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,                       // 👈 Aquí va el color
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/medical_data.svg',
                        width: 40,
                        height: 40,
                        colorFilter: const ColorFilter.mode(
                          Colors.white, // 👈 Color del icono
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMedicalLine({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título en negritas
          Text(
            '$title ',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Valor simple estilo "controlNumber"
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

}
