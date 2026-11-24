import 'package:Padres360/Const/states.dart';
import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Models/incidence_teacher_model.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Repo/incidences_teachers_repo.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/all_incidences.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/all_teacher_incidence.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Padres360/constants.dart';

class IncidencesDashboard extends StatefulWidget {
  const IncidencesDashboard({super.key});

  @override
  State<IncidencesDashboard> createState() => _IncidencesDashboardState();
}

class _IncidencesDashboardState extends State<IncidencesDashboard> {
  ViewState state = ViewState.loading;
  List<IncidenceTeacher> incidences = [];
  IncidenceTeacherList? incidenceTeacherList;
  final incidenceTeacherRepo = IncidencesTeachersRepository();

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  final Map<int, String> monthsInSpanish = {
    1: 'Enero',
    2: 'Febrero',
    3: 'Marzo',
    4: 'Abril',
    5: 'Mayo',
    6: 'Junio',
    7: 'Julio',
    8: 'Agosto',
    9: 'Septiembre',
    10: 'Octubre',
    11: 'Noviembre',
    12: 'Diciembre',
  };

  @override
  void initState() {
    super.initState();
    _loadIncidences(context: context);
  }

  Future<void> _loadIncidences({required BuildContext context}) async {
    try {
      final loadedIncidences = await incidenceTeacherRepo.loadIncidences(
        context: context,
      );

      setState(() {
        incidences = loadedIncidences;
        incidenceTeacherList = IncidenceTeacherList(incidences);
        if (incidences.isEmpty) {
          state = ViewState.empty;
        } else {
          state = ViewState.loaded;
        }
      });
    } catch (e) {
      setState(() => state = ViewState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSurfaceLight,
      appBar: AppBar(title: Text("Resumen de Incidencias")),
      body: switch (state) {
        ViewState.loading => const LoadingView(),
        ViewState.empty => const EmptyView(),
        ViewState.error => ErrorView(
          onRetry: () {
            _loadIncidences(context: context);
          },
        ),
        ViewState.loaded => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              final filtered = incidenceTeacherList!.getByDateRange(
                DateTime(selectedYear, selectedMonth, 1),
                DateTime(selectedYear, selectedMonth + 1, 0),
              );

              final teacherSummary = incidenceTeacherList!.getTeacherSummary(
                filtered,
              );
              final reporterSummary = incidenceTeacherList!.getReporterSummary(
                filtered,
              );
              final typeSummary = incidenceTeacherList!.getTypeSummary(
                filtered,
              );

              final sortedTeachers = teacherSummary.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              final sortedReporters = reporterSummary.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              final sortedTypes = typeSummary.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Tarjeta de Resumen General ----
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Resumen del Mes",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: kTitleColor,
                                      fontFamily: 'NotoSans',
                                    ),
                              ),
                              Chip(
                                label: Text(
                                  "${filtered.length} incidencias",
                                  style: const TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                                backgroundColor: kMainColor,
                                shape: const StadiumBorder(),
                                side: BorderSide.none,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Periodo: ${monthsInSpanish[selectedMonth]} $selectedYear",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: kNeutralColor,
                                  fontFamily: 'NotoSans',
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---- Filtros ----
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Elegir periodo",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kTitleColor,
                                  fontFamily: 'NotoSans',
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: selectedYear,
                                  decoration: InputDecoration(
                                    labelText: 'Año',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide: BorderSide(
                                        color: AppColors.kNeutral700,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide: BorderSide(
                                        color: AppColors.kPrimary,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 10.0,
                                    ),
                                  ),
                                  items: [2024, 2025, 2026, 2027, 2028]
                                      .map(
                                        (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text("$y"),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => selectedYear = val!),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: selectedMonth,
                                  decoration: InputDecoration(
                                    labelText: 'Mes',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide: BorderSide(
                                        color: AppColors.kNeutral700,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide: BorderSide(
                                        color: AppColors.kPrimary,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 10.0,
                                    ),
                                  ),
                                  items:  monthsInSpanish.entries
                                      .map(
                                        (entry) => DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => selectedMonth = val!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---- Tipos de Incidencias ----
                  if (sortedTypes.isNotEmpty) ...[
                    _buildSectionTitle("Comunes"),
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: sortedTypes.take(5).map((entry) {
                            final percentage =
                                (entry.value / filtered.length * 100)
                                    .toStringAsFixed(1);
                            return _buildStatRow(
                              entry.key,
                              entry.value,
                              percentage,
                              AppColors.kPrimary,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],

                  // ---- Docentes con Más Incidencias ----
                  if (sortedTeachers.isNotEmpty) ...[
                    _buildSectionTitle("Por docente"),
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (
                              var i = 0;
                              i < sortedTeachers.take(5).length;
                              i++
                            )
                              _buildStatRow(
                                _abbreviateName(sortedTeachers[i].key),
                                sortedTeachers[i].value,
                                (sortedTeachers[i].value /
                                        filtered.length *
                                        100)
                                    .toStringAsFixed(1),
                                chartColors[i % chartColors.length],
                                showMedal: i < 3,
                              ),
                            if (sortedTeachers.length > 5) ...[
                              const Divider(color: AppColors.kDividerColor),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllTeachersScreen(
                                        teachers: sortedTeachers,
                                        totalIncidences: filtered.length,
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                  "Ver ${sortedTeachers.length - 5} más...",
                                  style: TextStyle(
                                    color: kMainColor,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: kMainColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],

                  // ---- Quienes Reportan Más ----
                  if (sortedReporters.isNotEmpty) ...[
                    _buildSectionTitle("Por prefecto"),
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (
                              var i = 0;
                              i < sortedReporters.take(5).length;
                              i++
                            )
                              _buildStatRow(
                                _abbreviateName(sortedReporters[i].key),
                                sortedReporters[i].value,
                                (sortedReporters[i].value /
                                        filtered.length *
                                        100)
                                    .toStringAsFixed(1),
                                chartColors.reversed.toList()[i %
                                    chartColors.length],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // ---- Botón Ver Todas las Incidencias ----
                  Center(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (_) => AllIncidencesScreen(incidences: incidences)));
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  backgroundColor: AppColors.kPrimary,
                                  foregroundColor: AppColors.kOnPrimary,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NotoSans',
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.list_alt, size: 20),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "Ver todas las Incidencias",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: kTitleColor,
          fontFamily: 'NotoSans',
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String title,
    int count,
    String percentage,
    Color color, {
    bool showMedal = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (showMedal) ...[
            Icon(Icons.emoji_events, color: _getMedalColor(count), size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: kTitleColor,
                fontFamily: 'NotoSans',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "$count incidencias",
              style: TextStyle(
                color: kNeutralColor,
                fontSize: 12,
                fontFamily: 'NotoSans',
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$percentage%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'NotoSans',
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMedalColor(int count) {
    if (count >= 3) return Colors.amber;
    if (count >= 2) return Colors.grey;
    return Colors.brown;
  }

  String _abbreviateName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1][0]}.';
    }
    return fullName;
  }
}
