import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // 🔥 Stream para manejar taps de notificaciones locales
  static final StreamController<Map<String, dynamic>> _localTapStreamController =
  StreamController.broadcast();

  static Stream<Map<String, dynamic>> get onLocalNotificationTap =>
      _localTapStreamController.stream;

  // Inicializar el plugin
  static Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    _isInitialized = true;
    debugPrint('✅ LocalNotificationService inicializado');
  }

  // 🔥 Callback cuando se toca la notificación (App en primer plano)
  static void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Notificación local tocada (primer plano): ${response.payload}');
    _handleNotificationTap(response);
  }

  // 🔥 Callback cuando se toca la notificación (App en segundo plano o cerrada)
  static void _onBackgroundNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Notificación local tocada (segundo plano): ${response.payload}');
    _handleNotificationTap(response);
  }

  // 🔥 Manejar el tap de la notificación
  static void _handleNotificationTap(NotificationResponse response) {
    try {
      final String? payload = response.payload;

      if (payload == null || payload.isEmpty) {
        debugPrint('⚠️ Payload vacío, no se puede navegar');
        return;
      }

      // Parsear el payload (esperamos un JSON)
      Map<String, dynamic> data;
      try {
        data = Map<String, dynamic>.from(
            (payload).split('|').fold<Map<String, String>>({}, (map, pair) {
              final parts = pair.split(':');
              if (parts.length == 2) {
                map[parts[0]] = parts[1];
              }
              return map;
            })
        );
        // Si el payload es un JSON válido
        // data = jsonDecode(payload);
      } catch (e) {
        // Si no es JSON, usamos el payload como ID
        debugPrint('⚠️ Payload no es JSON, usando como ID: $payload');
        data = {
          'id': payload,
          'route': 'notification_detail',
        };
      }

      // Enviar al stream para navegación
      _localTapStreamController.add({
        'id': data['id'] ?? payload,
        'route': data['route'] ?? 'notification_detail',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'isLocalNotification': true,
      });

      debugPrint('✅ Tap de notificación local procesado: ${data['id']}');

    } catch (e) {
      debugPrint('❌ Error manejando tap de notificación local: $e');
    }
  }

  // Mostrar notificación local
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload, // 🔥 El payload debe contener el ID de la notificación
    String? imageUrl,
  }) async {
    try {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Notificaciones Generales',
        channelDescription: 'Canal para notificaciones generales',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        sound: null,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF2196F3),
        autoCancel: true,
      );

      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default.wav',
      );

      NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload, // 🔥 El payload se usará para navegar
      );

      debugPrint('✅ Notificación local mostrada: $title');
    } catch (e) {
      debugPrint('❌ Error mostrando notificación local: $e');
    }
  }

  // Mostrar notificación desde un RemoteMessage
  static Future<void> showNotificationFromRemoteMessage(
      RemoteMessage message,
      ) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      final int id = DateTime.now().millisecondsSinceEpoch % 100000;

      // 🔥 Crear un payload con el ID y otros datos
      final String payload = _createPayload(message);

      await showNotification(
        id: id,
        title: notification.title ?? 'Nueva notificación',
        body: notification.body ?? 'Tienes una nueva notificación',
        payload: payload, // 🔥 Pasar el payload
      );
    } catch (e) {
      debugPrint('❌ Error mostrando notificación desde RemoteMessage: $e');
    }
  }

  // 🔥 Crear payload con la información de la notificación
  static String _createPayload(RemoteMessage message) {
    try {
      final data = message.data;
      final id = data['id'] ?? data['notificationId'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      final route = data['route'] ?? 'notification_detail';

      // Crear un payload simple (puedes usar JSON si prefieres)
      return 'id:$id|route:$route|title:${message.notification?.title ?? ''}';

      // O usar JSON:
      // return jsonEncode({
      //   'id': id,
      //   'route': route,
      //   'title': message.notification?.title ?? '',
      // });
    } catch (e) {
      debugPrint('❌ Error creando payload: $e');
      return message.data['id']?.toString() ?? 'unknown';
    }
  }

  // Método para cancelar todas las notificaciones
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('✅ Todas las notificaciones canceladas');
  }

  // Método para cancelar una notificación específica
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
    debugPrint('✅ Notificación $id cancelada');
  }

  // 🔥 Dispose del stream
  static void dispose() {
    _localTapStreamController.close();
  }
}