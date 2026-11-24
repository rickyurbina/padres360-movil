import 'dart:convert';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Profile%20Screen/Models/user_info.dart';
import 'package:flutter/material.dart';
import '../../../../Const/api_config.dart';
import '../../../../Repository/http_helper.dart';

class ProfileRepo {
  Future<User> getProfile({required BuildContext context}) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.userInfo}');

    try {
      final response = await performRequest(context: context, url: url);
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userInfo = User.fromJson(jsonData);
        return userInfo;
      } else if (response.statusCode == 404) {
        throw 'No encontrado';
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

    return User.empty();
  }

  Future<bool> updateProfile({required int id, required String pass, required BuildContext context }) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.userUpdate(id)}');
    try {
      final response = await performRequest(context: context,
          url: url,
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
        body: jsonEncode({ "password": pass}),
      );
      debugPrint(response.body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw 'No encontrado';
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
    return false;
  }
}
