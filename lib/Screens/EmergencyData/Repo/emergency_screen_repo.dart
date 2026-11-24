import 'dart:convert';
import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/EmergencyData/Model/emergency_data_model.dart';
import 'package:Padres360/Screens/EmergencyData/Model/emergency_data_response.dart';
import 'package:flutter/material.dart';

class EmergencyDataRepo {
  Future<EmergencyData> getEmergencyData({
    required BuildContext context,
    required String type,
    required int id,
  }) async {
    String apiUrl = APIConfig.getEmergencyData;

    String paramName;
    switch (type.toLowerCase()) {
      case 'student':
        paramName = 'student_id';
        break;
      case 'teacher':
        paramName = 'teacher_id';
        break;
      default:
        throw ArgumentError('Tipo no soportado: $type');
    }

    final url = Uri.parse('${APIConfig.domain}$apiUrl')
        .replace(queryParameters: {paramName: id.toString()});

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final emergencyDataResponse = EmergencyDataResponse.fromJson(responseData);

        if (emergencyDataResponse.success) {
          return emergencyDataResponse.data!;
        } else {
          throw Exception('La solicitud no fue exitosa');
        }
      } else if (response.statusCode == 403) {
        throw 'Acceso denegado. No tienes permisos suficientes.';
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

    return EmergencyData.empty(studentId: 0);
  }

  Future<void> saveEmergencyData({
    required BuildContext context,
    required EmergencyData emergencyData,
    required String type,
    required int id,}) async {

    String paramName;

    switch (type) {
      case 'student':
        paramName = 'student';
        break;
      case 'teacher':
        paramName = 'teacher';
        break;
      default:
        throw Exception(
          'Tipo no soportado para información médica: $type',
        );
    }

    final Map<String, dynamic> body = {
      ...emergencyData.toJson(),
      paramName: id,
    };
    var url = Uri.parse('${APIConfig.domain}${APIConfig.updateEmergencyData}');
    try {
      debugPrint('${body}');
      final response = await performRequest(context: context, url: url, method: 'POST', body: jsonEncode(body));
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final emergencyDataResponse = EmergencyDataResponse.fromJson(responseData);

        if (emergencyDataResponse.success) {
          return;
        } else {
          throw Exception('La solicitud no fue exitosa');
        }
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
  }
}