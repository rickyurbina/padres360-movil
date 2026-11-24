import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:Padres360/Screens/Teachers/Model/teacher_model.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherRepository {
  Future<List<Teacher>> getTeachers({required BuildContext context}) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.teacherList}');

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint('students ${response.body}');

      if (response.statusCode == 200) {
        debugPrint(response.body);
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Teacher.fromJson(json)).toList();
        } else if (response.statusCode == 403) {
          throw 'Acceso denegado. No tienes permisos suficientes.';
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          throw 'Ocurrió un error al procesar tu solicitud.';
        } else if (response.statusCode >= 500) {
          throw 'Error del servidor. Intenta más tarde.';
        }
    }catch (error) {
      final errorMessage = error.toString();
      debugPrint(errorMessage);
      rethrow;
    }
    return [];
  }
}
