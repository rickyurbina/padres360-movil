import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class EmergencyDataRepository {
  Future<List<Student>> getAllStudents({
    required BuildContext context,
  }) async {
    final url = Uri.parse(
      '${APIConfig.domain}${APIConfig.allStudentList}',
    );

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint('students ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> parsed = jsonDecode(response.body);
        if (parsed['success'] == true) {
          final List<dynamic> studentsList = parsed['students'];
          return studentsList.map((json) => Student.fromJson(json)).toList();
        }
      } else if (response.statusCode == 403) {
        throw 'Acceso denegado. No tienes permisos suficientes.';
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw 'Ocurrió un error al procesar tu solicitud.';
      } else if (response.statusCode >= 500) {
        throw 'Error del servidor. Intenta más tarde.';
      }
    } catch (error) {
      debugPrint('${error}');
      rethrow;
    }
    return [];
  }
}