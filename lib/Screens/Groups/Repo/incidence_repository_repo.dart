import 'dart:convert';

import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/http_helper.dart';
import 'package:Padres360/Screens/Groups/Models/incidence_model.dart';
import 'package:flutter/material.dart';

class IncidenceRepositoryRepo {
  Future<List<IncidenceModel>> getIncidenceList({
    required BuildContext context,
  }) async {
    final url = Uri.parse(
      '${APIConfig.domain}${APIConfig.studentIncidenceList}',
    );

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['incidences'];
        final List<IncidenceModel> incidences = data
            .map((e) => IncidenceModel.fromJson(e))
            .toList();
        return incidences;
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
