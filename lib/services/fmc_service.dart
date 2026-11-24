import 'dart:convert';

import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/user_role_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<String> getToken() async {
    try {

      // Solicitar permisos (solo necesario en iOS)
      await _requestPermissions();
      await Future.delayed(const Duration(milliseconds: 500));
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print("APNS Token: $apnsToken");

      // Obtener nuevo token
      String? newToken = await _fcm.getToken();
      if (newToken != null) {
        await _saveTokenToCache(newToken); // Guardar localmente
        await _sendTokenToServer(newToken); // Enviar a tu backend
      }
      return newToken ?? '';
    } catch (e) {
      debugPrint('Error obteniendo token: $e');
      return '';
    }
  }

  static Future<void> _requestPermissions() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
  }

  static Future<void> _sendTokenToServer(String token) async {
    debugPrint('Token para enviar al server: $token');
    final authToken = await UserService.getAuthToken();
    final user = await UserService.getUser();
    String apiUrl = user.role == UserRole.TEACHER ? APIConfig.teacherUpdateFcm(user.teacherId) :
    APIConfig.parentUpdateFcm(user.parentId);
    final url = Uri.parse(
      '${APIConfig.domain}${apiUrl}',
    );

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({"fcm": token}),
    );

    if (response.statusCode == 200) {
      debugPrint('FCM actualizado correctamente: ${response.body}');
    } else {
      debugPrint(
        'Error al actualizar FCM USerid${user.parentId} (${response.statusCode}): ${response.body}',
      );
    }
  }

  static Future<String?> _loadTokenFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('fcm_token');
  }

  static Future<void> _saveTokenToCache(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  static Future<void> monitorTokenRefresh(String token) async {
    _fcm.onTokenRefresh.listen((newToken) async {
      debugPrint('Token actualizado: $newToken');
      await _saveTokenToCache(newToken);
      await _sendTokenToServer(newToken);
    });
  }
}
