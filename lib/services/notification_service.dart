// lib/services/notification_service.dart
import 'dart:async';
import 'package:Padres360/services/local_notification_service.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:Padres360/providers/badge_provider.dart';
import 'package:Padres360/Screens/Notification/Repo/notification_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  final Ref ref;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final notificationRepository = NotificationRepository();

  static bool _isInitialized = false;
  static NotificationService? _instance;

  NotificationService(this.ref) {
    _instance = this;
  }

  static final StreamController<Map<String, dynamic>> _tapStreamController =
  StreamController.broadcast();

  static Stream<Map<String, dynamic>> get onNotificationTap =>
      _tapStreamController.stream;

  static final StreamController<RemoteMessage> _foregroundController =
  StreamController.broadcast();

  static Stream<RemoteMessage> get onForegroundNotification =>
      _foregroundController.stream;

  // ---------------------------------------------------------
  // INICIALIZACIÓN
  // ---------------------------------------------------------
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint("🚀 Inicializando NotificationService...");

      // 0. Inicializar notificaciones locales PRIMERO
      await LocalNotificationService.initialize();

      // 1. Verificar soporte de badges
      await _checkBadgeSupport();

      // 2. Solicitar permisos
      await _requestPermissions();

      // 3. Configurar token FCM
      await _setupFcmToken();

      // 4. Configurar listeners de Firebase
      _setupFirebaseListeners();

      // 5. Manejar notificación inicial
      await _handleInitialMessage();

      // 6. Sincronizar con backend
      await syncUnreadNotifications();

      _isInitialized = true;
      debugPrint("✅ NotificationService inicializado correctamente");

    } catch (e) {
      debugPrint("❌ Error inicializando NotificationService: $e");
    }
  }

  // ---------------------------------------------------------
  // VERIFICAR SOPORTE DE BADGES
  // ---------------------------------------------------------
  Future<void> _checkBadgeSupport() async {
    try {
      final isSupported = await AppBadgePlus.isSupported();
      debugPrint("📱 Soporte de badges: ${isSupported ? 'SÍ' : 'NO'}");

      if (!isSupported) {
        debugPrint("⚠️ El dispositivo no soporta badges nativos");
        debugPrint("ℹ️ Los badges solo se mostrarán en la UI de la app");
      }
    } catch (e) {
      debugPrint("❌ Error verificando soporte de badges: $e");
    }
  }

  // ---------------------------------------------------------
  // SOLICITAR PERMISOS
  // ---------------------------------------------------------
  Future<void> _requestPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,  // IMPORTANTE: Permiso para badges
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('📱 Permisos de notificación: ${settings.authorizationStatus}');

      // Configurar opciones para Android
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

    } catch (e) {
      debugPrint("❌ Error solicitando permisos: $e");
    }
  }

  // ---------------------------------------------------------
  // TOKEN FCM
  // ---------------------------------------------------------
  Future<void> _setupFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        debugPrint("📱 FCM Token: $token");
      }
    } catch (e) {
      debugPrint("❌ Error obteniendo FCM token: $e");
    }
  }

  // ---------------------------------------------------------
  // LISTENERS DE FIREBASE
  // ---------------------------------------------------------
  void _setupFirebaseListeners() {
    // 1. Mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📱 Mensaje en primer plano: ${message.messageId}");
      _handleForegroundMessage(message);
      _foregroundController.add(message);
    });

    // 2. App abierta desde notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📱 App abierta desde notificación");
      _handleNotificationTap(message);
    });
  }

  // ---------------------------------------------------------
  // MANEJO DE MENSAJES
  // ---------------------------------------------------------
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint("📱 Mensaje en primer plano: ${message.messageId}");

    // 🆕 MOSTRAR NOTIFICACIÓN LOCAL CON SONIDO
    LocalNotificationService.showNotificationFromRemoteMessage(message);

    // Incrementar badge cuando llega notificación
    ref.read(badgeProvider.notifier).increment();

    // Procesar datos
    _processNotificationData(message.data);

    debugPrint("📱 Notificación en primer plano procesada con sonido");
  }


  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("📱 Notificación inicial encontrada");

      // Esperar un momento para que la UI esté lista
      await Future.delayed(Duration(milliseconds: 500));

      // Manejar el tap
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    try {
      final data = message.data;
      final id = data["id"]?.toString() ?? data["notificationId"]?.toString() ?? "unknown";
      final type = data["route"] ?? "notification";

      debugPrint("👆 Notificación clickeada - ID: $id");

      _tapStreamController.add({
        "id": id,
        "route": type,
        "data": data,
        "title": message.notification?.title ?? "Notificación",
        "body": message.notification?.body ?? "",
        "timestamp": DateTime.now().toIso8601String(),
      });

      // Decrementar badge cuando se abre la notificación
      ref.read(badgeProvider.notifier).decrement();

      // Marcar como leída en backend
      _markNotificationAsRead(id);

    } catch (e) {
      debugPrint("❌ Error manejando tap de notificación: $e");
    }
  }

  // ---------------------------------------------------------
  // SYNC CON BACKEND
  // ---------------------------------------------------------
  // notification_service.dart
  Future<void> syncUnreadNotifications() async {
    try {
      debugPrint("🔄 Iniciando sincronización completa de notificaciones...");

      // PRIMERO: Sincronizar badge interno con sistema
      await ref.read(badgeProvider.notifier).syncWithSystemBadge();

      final currentBadgeFromSystem = ref.read(badgeProvider);
      debugPrint("📱 Badge del sistema actual: $currentBadgeFromSystem");

      // SEGUNDO: Obtener conteo REAL desde backend
      final unreadCount = await notificationRepository.getUnreadCount();
      debugPrint("📡 Backend reporta: $unreadCount notificaciones no leídas");

      // TERCERO: Comparar y decidir qué valor usar
      if (unreadCount != currentBadgeFromSystem) {
        debugPrint("⚠️ Discrepancia detectada!");
        debugPrint("   - Sistema: $currentBadgeFromSystem");
        debugPrint("   - Backend: $unreadCount");

        debugPrint("🎯 Usando valor final: $unreadCount");

        await ref.read(badgeProvider.notifier).setBadge(unreadCount);

        debugPrint("✅ Badge sincronizado: $unreadCount");
      } else {
        debugPrint("✅ Badges ya están sincronizados: $unreadCount");
      }

    } catch (e) {
      debugPrint("❌ Error sincronizando notificaciones: $e");

      // En caso de error, al menos sincronizar con sistema
      try {
        await ref.read(badgeProvider.notifier).syncWithSystemBadge();
        final fallbackBadge = ref.read(badgeProvider);
        debugPrint("📱 Usando badge del sistema como fallback: $fallbackBadge");
      } catch (syncError) {
        debugPrint("❌ Error en fallback: $syncError");
      }
    }
  }
  // ---------------------------------------------------------
  // MÉTODOS AUXILIARES
  // ---------------------------------------------------------
  void _processNotificationData(Map<String, dynamic> data) {
    debugPrint("📨 Datos de notificación: $data");
    // Aquí procesas los datos según tu lógica
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      debugPrint("✅ Notificación marcada como leída: $notificationId");
    } catch (e) {
      debugPrint("❌ Error marcando notificación como leída: $e");
    }
  }

  Future<void> incrementBadge() async {
    await ref.read(badgeProvider.notifier).increment();
  }

  Future<void> decrementBadge() async {
    await ref.read(badgeProvider.notifier).decrement();
  }

  Future<void> resetBadge() async {
    await ref.read(badgeProvider.notifier).clear();
  }

  Future<int> getCurrentBadge() async {
    return ref.read(badgeProvider);
  }

  Future<bool> isBadgeSupported() async {
    return await ref.read(badgeProvider.notifier).isSupported();
  }

  void dispose() {
    _tapStreamController.close();
    _isInitialized = false;
    debugPrint("🧹 NotificationService disposed");
  }
}