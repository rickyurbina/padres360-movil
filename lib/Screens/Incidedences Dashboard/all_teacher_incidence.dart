import 'package:Padres360/constants.dart';
import 'package:flutter/material.dart';

class AllTeachersScreen extends StatelessWidget {
  final List<MapEntry<String, int>> teachers;
  final int totalIncidences;

  const AllTeachersScreen({
    super.key,
    required this.teachers,
    required this.totalIncidences,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todos los Docentes",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.w500,
            color: kDarkWhite,
          ),
        ),
        backgroundColor: kMainColor,
        iconTheme: const IconThemeData(color: kDarkWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: teachers.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            final percentage = (teacher.value / totalIncidences * 100).toStringAsFixed(1);

            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Navegar a pantalla de detalles si se desea
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (_) => TeacherDetailScreen(teacher: teacher),
                // ));
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(color: kWhite),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Número de posición
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getPositionColor(index),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nombre y estadísticas
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre del docente
                          Text(
                            teacher.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSans',
                              color: kTitleColor,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Total de incidencias y porcentaje
                          Row(
                            children: [
                              Text(
                                "${teacher.value} incidencias",
                                style: const TextStyle(
                                  color: kNeutralColor,
                                  fontSize: 14,
                                  fontFamily: 'NotoSans',
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPercentageColor(percentage).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "$percentage%",
                                  style: TextStyle(
                                    color: _getPercentageColor(percentage),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Colores para las posiciones 1, 2, 3
  Color _getPositionColor(int index) {
    if (index == 0) return Colors.amber.shade600; // Oro
    if (index == 1) return Colors.grey.shade600;  // Plata
    if (index == 2) return Colors.brown.shade600; // Bronce
    return kMainColor; // Para los demás
  }

  // Colores según porcentaje
  Color _getPercentageColor(String percentage) {
    final percent = double.parse(percentage);
    if (percent >= 20) return Colors.red.shade600;
    if (percent >= 10) return Colors.orange.shade600;
    if (percent >= 5) return Colors.yellow.shade700;
    return Colors.green.shade600;
  }
}
