import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/EmergencyData/Model/emergency_data_model.dart';
import 'package:Padres360/Screens/EmergencyData/Repo/emergency_screen_repo.dart';
import 'package:Padres360/Screens/Teachers/Model/teacher_model.dart';
import 'package:Padres360/constants.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class EmergencyDataScreen extends StatefulWidget {
  final Student? student;
  final Teacher? teacher;
  final bool isEditable;

  const EmergencyDataScreen({
    super.key,
    this.student,
    this.teacher,
    this.isEditable = true,
  });

  @override
  State<EmergencyDataScreen> createState() => _EmergencyDataScreenState();
}

class _EmergencyDataScreenState extends State<EmergencyDataScreen> {
  final EmergencyDataRepo _repo = EmergencyDataRepo();
  late Future<EmergencyData> _futureEmergencyData;

  final _formKey = GlobalKey<FormState>();

  String _type = '';
  int _id = 0;
  String _name = '';

  // Controladores
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _chronicDiseasesController = TextEditingController();
  final TextEditingController _emergencyContactsController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _insuranceNumberController = TextEditingController();
  final TextEditingController _medicalInsuranceController = TextEditingController();
  final TextEditingController _regularMedicationsController = TextEditingController();
  bool _autorization = true;

  @override
  void initState() {
    super.initState();

    if (widget.student != null){
      _type = 'student';
      _id = widget.student!.id;
      _name = widget.student!.firstName;
    }else if(widget.teacher != null) {
      _type = 'teacher';
      _id = widget.teacher!.id;
      _name = widget.teacher!.firstName;
    }
    _futureEmergencyData = _repo.getEmergencyData(
      context: context,
      type:  _type,
      id: _id,
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final emergencyData = EmergencyData(
          student: widget.student!.id,
          allergies: _allergiesController.text.trim(),
          bloodType: _bloodTypeController.text.trim(),
          chronicDiseases: _chronicDiseasesController.text.trim(),
          emergencyContacts: _emergencyContactsController.text.trim(),
          emergencyPhoneNumbers: _emergencyPhoneController.text.trim(),
          insuranceNumber: _insuranceNumberController.text.trim(),
          medicalInsurance: _medicalInsuranceController.text.trim(),
          regularMedications: _regularMedicationsController.text.trim(),
          autorization: _autorization,
        );

        // Aquí iría la lógica para guardar en la API
        await _repo.saveEmergencyData(
          context: context,
          emergencyData: emergencyData,
          type: _type,
          id: _id
        );

        // Mostrar mensaje de éxito
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
                      '¡Información guardada!',
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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Lottie.asset(
                        'assets/lottie/success.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Se guardó la información correctamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kOnSurfaceLight,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // cerrar dialog
                    Navigator.of(context).pop(); // regresar pantalla
                  },
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );


        // Actualizar los datos
        setState(() {
          _futureEmergencyData = Future.value(emergencyData);
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          title: Text('Datos Médicos'),
        ),
        body: FutureBuilder<EmergencyData>(
          future: _futureEmergencyData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar datos: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final emergencyData = snapshot.data!;

            // Inicializar controladores con datos
            if (_allergiesController.text.isEmpty) {
              _allergiesController.text = emergencyData.allergies;
              _bloodTypeController.text = emergencyData.bloodType;
              _chronicDiseasesController.text = emergencyData.chronicDiseases;
              _emergencyContactsController.text = emergencyData.emergencyContacts;
              _emergencyPhoneController.text = emergencyData.emergencyPhoneNumbers;
              _insuranceNumberController.text = emergencyData.insuranceNumber ?? '';
              _medicalInsuranceController.text = emergencyData.medicalInsurance;
              _regularMedicationsController.text = emergencyData.regularMedications;
              _autorization = emergencyData.autorization;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kPrimary,
                      ),
                    ).paddingSymmetric(vertical: 12),
                    // Tipo de Sangre
                    buildField(
                      context,
                      'Tipo de Sangre',
                      _bloodTypeController,
                      readOnly: !widget.isEditable,
                    ),

                    // Alergias
                    buildField(
                      context,
                      'Alergias',
                      _allergiesController,
                      readOnly: !widget.isEditable,
                    ),

                    // Enfermedades Crónicas
                    buildField(
                      context,
                      'Enfermedades Crónicas',
                      _chronicDiseasesController,
                      readOnly: !widget.isEditable,
                    ),

                    // Medicamentos Regulares
                    buildField(
                      context,
                      'Medicamentos Regulares',
                      _regularMedicationsController,
                      readOnly: !widget.isEditable,
                    ),

                    // Seguro Médico
                    buildField(
                      context,
                      'Seguro Médico',
                      _medicalInsuranceController,
                      readOnly: !widget.isEditable,
                    ),

                    // Número de Seguro
                    buildField(
                      context,
                      'Número de Seguro',
                      _insuranceNumberController,
                      readOnly: !widget.isEditable,
                    ),

                    // Contactos de Emergencia
                    buildField(
                      context,
                      'Contacto de Emergencia',
                      _emergencyContactsController,
                      readOnly: !widget.isEditable,
                    ),

                    // Teléfono de Emergencia
                    buildField(
                      context,
                      'Teléfono de Emergencia',
                      _emergencyPhoneController,
                      readOnly: !widget.isEditable,
                    ),

                    // Autorización
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Autorización para primeros auxilios',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (widget.isEditable)
                                  Switch(
                                    value: _autorization,
                                    onChanged: (value) {
                                      setState(() {
                                        _autorization = value;
                                      });
                                    },
                                    activeColor: AppColors.kPrimary,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botón de guardar
                    if (widget.isEditable)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _saveForm();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('Guardar'),
                        ).paddingSymmetric(vertical: 10, horizontal: 40),

                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  Widget buildField(
      BuildContext context,
      String label,
      TextEditingController controller, {
        bool readOnly = false,
      }) {
    return AppTextField(
      readOnly: readOnly,
      controller: controller,
      decoration: kInputDecoration.copyWith(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      textFieldType: TextFieldType.NAME,
    ).paddingAll(10);
  }
}