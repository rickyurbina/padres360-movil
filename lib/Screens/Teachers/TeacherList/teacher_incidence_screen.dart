import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Groups/Models/incidence_model.dart';
import 'package:Padres360/Screens/Groups/Repo/incidence_repository_repo.dart';
import 'package:Padres360/Screens/Students/Model/incidence_model.dart';
import 'package:Padres360/Screens/Students/Repo/student_incidence_repo.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<List<IncidenceModel>> fetchIncidences(BuildContext context) async {
  IncidenceRepositoryRepo incidenceRepo = IncidenceRepositoryRepo();
  final incidences = await incidenceRepo.getIncidenceList(context: context);
  return incidences
      .where(
        (incidence) => incidence.type.toLowerCase() == 'DOCENTE'.toLowerCase(),
      )
      .toList();
}

class TeacherIncidenceScreen extends StatefulWidget {
  final List<int> teachersSelected;

  const TeacherIncidenceScreen({super.key, required this.teachersSelected});

  @override
  State<TeacherIncidenceScreen> createState() => _IncidenceScreenState();
}

class _IncidenceScreenState extends State<TeacherIncidenceScreen> {
  List<IncidenceModel> _incidences = [];
  String? _actionType;
  final TextEditingController _obsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadIncidences();
  }

  Future<void> loadIncidences() async {
    final list = await fetchIncidences(context);
    setState(() {
      _incidences = list;
      for (var incidence in _incidences) {
        incidence.selected = false;
      }
    });
  }

  void _onConfirm() {
    final selected = _incidences.where((inc) => inc.selected == true).toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione al menos una incidencia.')),
      );
      return;
    }

    if (_obsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese una observación.')));
      return;
    }
    final incidencesToSend = generateIncidencesToSend();
    sendIncidences(incidencesToSend);

    String resultMsg = 'Incidencia(s) registrada(s).';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.only(
            top: 20,
            left: 24,
            right: 24,
            bottom: 16,
          ),
          titlePadding: const EdgeInsets.only(top: 16, left: 24, right: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Listo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.kOnSurfaceLight,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.kOnSurfaceLight),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie animation centrado
              SizedBox(
                height: 120,
                width: 120,
                child: Lottie.asset(
                  'assets/lottie/success.json',
                  // Asegúrate de tener este archivo
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                resultMsg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void sendIncidences(List<IncidenceModelSend> incidencesToSend) async {
    StudentIncidenceRepo incidenceRepo = StudentIncidenceRepo();
    final incidences = await incidenceRepo.sendIncidence(
      context: context,
      incidences: incidencesToSend,
    );
  }

  List<IncidenceModelSend> generateIncidencesToSend() {
    final selectedIncidences = _incidences
        .where((inc) => inc.selected == true)
        .toList();
    final List<IncidenceModelSend> incidencesToSend = [];

    for (var incidence in selectedIncidences) {
      for (var teacherId in widget.teachersSelected) {
        incidencesToSend.add(
          IncidenceModelSend(
            incidence: incidence.id,
            observation: _obsController.text.trim(),
            type: incidence.type,
            teacher: teacherId,
          ),
        );
      }
    }

    return incidencesToSend;
  }

  void _onIncidenceChanged(IncidenceModel incidence) {
    setState(() {
      incidence.selected = !(incidence.selected ?? false);
      final selectedIncidences = _incidences
          .where((inc) => inc.selected == true)
          .toList();
      if (selectedIncidences.length == 1) {
        _actionType = selectedIncidences.first.name;
      } else {
        _actionType = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicar acción a docentes'),
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Cerrar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _incidences.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.kPrimary),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Se aplicará la acción a ${widget.teachersSelected.length} docentes.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Seleccione las incidencias:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kOnSurfaceLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Widget Wrap para los botones tipo pill con colores del tema
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _incidences.map((incidence) {
                        final isSelected = incidence.selected ?? false;
                        return FilterChip(
                          label: Text(
                            incidence.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.kPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) =>
                              _onIncidenceChanged(incidence),
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.kPrimary,
                          checkmarkColor: Colors.white,
                          // ¡Este es el color importante!
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.kPrimary
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          elevation: isSelected ? 2 : 0,
                          shadowColor: AppColors.kPrimary.withOpacity(0.3),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _obsController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 16, // Tamaño de texto más grande
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Observaciones',
                        labelStyle: const TextStyle(
                          color: AppColors.kPrimary,
                          fontSize: 18, // Texto del label más grande
                          fontWeight: FontWeight.w600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.kPrimary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.kPrimary,
                            width: 2,
                          ),
                        ),
                        hintText:
                            'Ingrese las observaciones de la incidencia...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15, // Hint text un poco más grande
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        // Padding interno
                        filled: true,
                        fillColor: Colors
                            .grey[50], // Fondo ligeramente gris para mejor contraste
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          elevation: 3,
                          shadowColor: AppColors.kPrimary.withOpacity(0.4),
                        ),
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
