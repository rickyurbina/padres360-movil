import 'package:flutter/material.dart';
import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNotificationScreen extends StatefulWidget {
  final String idEmergency;

  const EmergencyNotificationScreen({
    super.key,
    required this.idEmergency
  });

  @override
  State<EmergencyNotificationScreen> createState() => _EmergencyNotificationScreenState();
}

class _EmergencyNotificationScreenState extends State<EmergencyNotificationScreen> {
  bool _isConfirmed = false;
  bool _isLoading = false;
  late final String senderName = "sender name";
  late final String message = "messages";
  late final DateTime timestamp = DateTime.now();
  late final String? location = "location";

  Future<void> _callEmergency() async {
    // Abrir aplicación de teléfono con número de emergencia
     final url = 'tel:911';
     if (await canLaunchUrl(Uri.parse(url))) {
       await launchUrl(Uri.parse(url));
     }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Llamando a emergencias...'),
        backgroundColor: AppColors.kEmergency,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kEmergency.shade50,
      appBar: AppBar(
        title: const Text('Emergencia Recibida'),
        backgroundColor: AppColors.kEmergency,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Icono de advertencia animado
              Container(
                height: 180,
                padding: const EdgeInsets.all(20),
                child:  Lottie.asset('assets/lottie/emergency_alert.json', width: 200),
              ),

              // Tarjeta principal de la alerta
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado de la alerta
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.kEmergency.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppColors.kEmergency,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  senderName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  _formatDateTime(timestamp),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.warning,
                            color: AppColors.kEmergency,
                            size: 32,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Mensaje de emergencia
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.kEmergency.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.kEmergency.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MENSAJE DE EMERGENCIA:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kEmergency,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Información de ubicación (si está disponible)
                      if (location != null) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.kEmergency,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ubicación: ${location}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 8),
                      Text(
                        'ID de alerta: #${timestamp.millisecondsSinceEpoch.toString().substring(8)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botón para llamar a emergencias
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _callEmergency,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.kEmergency,
                    side: const BorderSide(
                      color: AppColors.kEmergency,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 8),
                      Text(
                        'LLAMAR A EMERGENCIAS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}