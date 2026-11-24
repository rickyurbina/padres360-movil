import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class StudentRepository {
  Future<List<Student>> getStudents({
    required BuildContext context,
    required Group group,
  }) async {
    final url = Uri.parse(
      '${APIConfig.domain}${APIConfig.studentList(group.id)}',
    );

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint('students ${response.body}');

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body) as List<dynamic>;
        return parsed.map((json) => Student.fromJson(json)).toList();
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
