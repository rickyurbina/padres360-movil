import 'dart:convert';
import 'package:Padres360/Screens/Groups/Models/GroupModel.dart';
import 'package:flutter/material.dart';
import '../../../../Const/api_config.dart';
import '../../../../Repository/http_helper.dart';

class ListGroupAttendanceRepo {
  Future<List<Group>> getGroupList({required BuildContext context}) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.groupList}');

    try {
      final response = await performRequest(context: context, url: url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Group> groups = jsonList.map((e) => Group.fromJson(e)).toList();
        return groups;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      rethrow;
    }

    return [];
  }
}
