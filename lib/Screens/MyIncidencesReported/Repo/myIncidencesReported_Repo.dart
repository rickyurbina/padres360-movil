import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:Padres360/Screens/Incidedences%20Dashboard/Models/incidence_teacher_model.dart';
import 'package:Padres360/Screens/Students/Model/incidence_model.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class MyincidencesReportedRepo {
  Future<List<IncidenceTeacher>> getMyReportedIncidences({
    required BuildContext context,
  }) async {
    String apiUrl = APIConfig.allStudentIncidences;
    final url = Uri.parse(
      '${APIConfig.domain}${apiUrl}',
    );

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<IncidenceTeacher> notifications =
        data.map((e) => IncidenceTeacher.fromJson(e)).toList();
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
}
