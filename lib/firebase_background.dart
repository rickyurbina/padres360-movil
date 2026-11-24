// firebase_background.dart
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("🔄 Background message recibido: ${message.messageId}");

  try {
    final prefs = await SharedPreferences.getInstance();
    int currentBadge = prefs.getInt('badge_count') ?? 0;
    currentBadge++;
    debugPrint("📱 Background: Badge antes: $currentBadge");

    await prefs.setInt('badge_count', currentBadge);
    debugPrint("💾 Background: Guardado en SharedPreferences: $currentBadge");

    await AppBadgePlus.updateBadge(currentBadge);
    debugPrint("✅ Background: Badge actualizado: $currentBadge");

  } catch (e) {
    debugPrint("❌ Error en background handler: $e");
  }
}