import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Models/incidence_teacher_model.dart';
import 'package:flutter/material.dart';

class IncidenceStudentDetail extends StatelessWidget {
  final IncidenceTeacher incidence;

  const IncidenceStudentDetail({super.key, required this.incidence});

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final localTime = date.isUtc ? date.toLocal() : date;

    return '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Fecha no disponible';
    final localTime = date.isUtc ? date.toLocal() : date;

    return '${localTime.day.toString().padLeft(2, '0')}/${localTime.month.toString().padLeft(2, '0')}/${localTime.year}';
  }

  Color _getIncidenceColor(String? incidenceName) {
    final name = incidenceName?.toLowerCase() ?? '';

    if (name.contains('falta') || name.contains('grave')) {
      return Colors.red.shade600;
    } else if (name.contains('tardanza') || name.contains('retardo')) {
      return Colors.orange.shade600;
    } else if (name.contains('advertencia') || name.contains('observación')) {
      return Colors.amber.shade700;
    } else if (name.contains('felicitación') ||
        name.contains('reconocimiento')) {
      return Colors.green.shade600;
    }
    return Colors.blue.shade600;
  }

  IconData _getIncidenceIcon(String? incidenceName) {
    final name = incidenceName?.toLowerCase() ?? '';

    if (name.contains('falta')) return Icons.warning_rounded;
    if (name.contains('tardanza')) return Icons.access_time_rounded;
    if (name.contains('comportamiento')) return Icons.psychology_rounded;
    if (name.contains('tarea')) return Icons.assignment_rounded;
    if (name.contains('material')) return Icons.school_rounded;
    if (name.contains('felicitación')) return Icons.star_rounded;
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, incidence?.read ?? false);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          title: const Text('Detalle de Incidencia'),
          elevation: 0,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
        return _buildSuccessView();
  }

  Widget _buildSuccessView() {
    if (incidence == null) {
      return const Center(child: Text('No se encontró la incidencia'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMainCardFromSketch(),
        ],
      ),
    );
  }
  Widget _buildMainCardFromSketch() {
    final date = incidence?.createdAt;
    final observation = incidence?.observation ?? '';
    final isRead = incidence?.read ?? false;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER: ícono + texto Incidencia + check ----------
            Row(
              children: [
                // Ícono izquierda
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getIncidenceColor(incidence?.incidenceName),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIncidenceIcon(incidence?.incidenceName),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Nombre de la incidencia
                Expanded(
                  child: Text(
                    incidence?.incidenceName ?? 'Incidencia',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Check de leído
                Icon(
                  isRead ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isRead ? Colors.green : Colors.grey,
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ---------- FECHA ----------
            Text(
              "${_formatDate(date)} a las ${_formatTime(date)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // ---------- NOMBRE DEL ESTUDIANTE ----------
            Text(
              incidence?.studentName ?? "",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // ---------- NOMBRE DEL Registrador ----------
            Text(
              incidence?.createdByName ?? "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // ---------- OBSERVACIÓN ----------
            const Text(
              "Observación:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade200,
                ),
              ),
              child: Text(
                observation.isEmpty ? "Sin observación" : observation,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}