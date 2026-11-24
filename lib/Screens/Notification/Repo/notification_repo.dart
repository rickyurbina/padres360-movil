import 'dart:convert';
import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/user_role_enum.dart';
import 'package:Padres360/Screens/Notification/Model/notification_incidence.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  Future<List<NotificationIncidence>> loadNotificaton({
    required BuildContext context,
  }) async {
    final user = await UserService.getUser();
    String apiUrl = user.role == UserRole.TEACHER
        ? APIConfig.readIncidenceTeacher(user.teacherId)
        : APIConfig.readIncidence(user.parentId);
    final url = Uri.parse('${APIConfig.domain}${apiUrl}');

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<NotificationIncidence> notifications = data
            .map((e) => NotificationIncidence.fromJson(e))
            .toList();
        return notifications;
      } else if (response.statusCode == 403) {
        throw 'Acceso denegado. No tienes permisos suficientes.';
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw 'Ocurrió un error al procesar tu solicitud.';
      } else if (response.statusCode >= 500) {
        throw 'Error del servidor. Intenta más tarde.';
      }
    } catch (error) {
      final errorMessage = error.toString();
      debugPrint(errorMessage);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      rethrow;
    }

    return [];
  }

  Future<bool> markAsReadNotification({
    required BuildContext context,
    required NotificationIncidence incidence,
  }) async {
    final url = Uri.parse(
      '${APIConfig.domain}${APIConfig.markReadIncidence(incidence.id)}',
    );
    final body = jsonEncode({"read": true});
    try {
      final response = await performRequest(
        context: context,
        url: url,
        method: 'PUT',
        body: body,
      );
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw 'Acceso denegado. No tienes permisos suficientes.';
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw 'Ocurrió un error al procesar tu solicitud.';
      } else if (response.statusCode >= 500) {
        throw 'Error del servidor. Intenta más tarde.';
      }
    } catch (error) {
      final errorMessage = error.toString();
      debugPrint(errorMessage);
      return false;
    }
    return false;
  }

  Future<int> getUnreadCount() async {
    final user = await UserService.getUser();
    String apiUrl = user.role == UserRole.TEACHER
        ? APIConfig.readIncidenceTeacher(user.teacherId)
        : APIConfig.readIncidence(user.parentId);
    final url = Uri.parse('${APIConfig.domain}${apiUrl}');
    final token = await UserService.getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<NotificationIncidence> notifications = data
            .map((e) => NotificationIncidence.fromJson(e))
            .toList();
        return notifications.where((test) => !test.read).length;
      }
    } catch (error) {
      return 0;
    }
    return 0;
  }

  Future<NotificationIncidence> getById({
    required BuildContext context,
    required int id
  }) async {
    String apiUrl = APIConfig.getNotificationById(id);
    final url = Uri.parse('${APIConfig.domain}${apiUrl}');

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          return NotificationIncidence.empty();
        }
        final NotificationIncidence notification =
        NotificationIncidence.fromJson(data.first);

        return notification;
      } else if (response.statusCode == 403) {
        throw 'Acceso denegado. No tienes permisos suficientes.';
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw 'Ocurrió un error al procesar tu solicitud.';
      } else if (response.statusCode >= 500) {
        throw 'Error del servidor. Intenta más tarde.';
      }
    } catch (error) {
      final errorMessage = error.toString();
      debugPrint(errorMessage);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      rethrow;
    }

    return NotificationIncidence.empty();
  }
}
