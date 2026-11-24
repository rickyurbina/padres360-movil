import 'dart:async';
import 'package:Padres360/Screens/Notification/notification_detail_page.dart';
import 'package:Padres360/services/local_notification_service.dart';
import 'package:Padres360/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationNavigation {
  static StreamSubscription? _tapSubscription;
  static StreamSubscription? _localTapSubscription;
  static bool _isListening = false;

  // Iniciar la escucha de taps de notificaciones
  static void startListening(BuildContext context) {
    if (_isListening) return;

    // 🔥 Escuchar taps de notificaciones FCM
    _tapSubscription = NotificationService.onNotificationTap.listen(
      (data) {
        _handleNotificationTap(context, data, isLocal: false);
      },
      onError: (error) {
        debugPrint('❌ Error en stream de FCM: $error');
      },
    );

    // 🔥 Escuchar taps de notificaciones locales
    _localTapSubscription = LocalNotificationService.onLocalNotificationTap
        .listen(
          (data) {
            _handleNotificationTap(context, data, isLocal: true);
          },
          onError: (error) {
            debugPrint('❌ Error en stream de notificaciones locales: $error');
          },
        );

    _isListening = true;
    debugPrint('✅ Escuchando taps de notificaciones (FCM + Locales)');
  }

  // Detener la escucha
  static void stopListening() {
    _tapSubscription?.cancel();
    _localTapSubscription?.cancel();
    _isListening = false;
    debugPrint('⏹️ Escucha de notificaciones detenida');
  }

  // Manejar el tap de la notificación
  static void _handleNotificationTap(
    BuildContext context,
    Map<String, dynamic> data, {
    required bool isLocal,
  }) {
    try {
      final String? notificationId = data['id']?.toString();
      final String route = data['route'] ?? 'notification_detail';

      debugPrint(
        '📱 Tap de notificación ${isLocal ? 'LOCAL' : 'FCM'} - ID: $notificationId',
      );

      if (notificationId == null || notificationId.isEmpty) {
        debugPrint('⚠️ ID de notificación inválido');
        return;
      }

      final navigatorContext = context;
      if (navigatorContext.mounted) {
        Navigator.push(
          navigatorContext,
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(
              idIncidence: int.parse(notificationId ?? '') ?? 0,
            ),
          ),
        );
      } else {
        debugPrint('⚠️ Contexto no disponible para navegación');
      }
    } catch (e) {
      debugPrint('❌ Error navegando a detalle de notificación: $e');
    }
  }
}
