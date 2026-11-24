import 'dart:convert';

import 'package:Padres360/Const/api_config.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.login}');

    final body = {'identifier': email, 'password': password};
    final headers = {'Accept': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);

      final responseData = jsonDecode(response.body);
      EasyLoading.dismiss();
      print('Signin ${response.body}');
      if (response.statusCode == 200) {
        await UserService.saveUserData(
          token: responseData['tokens']['access'],
          userEntity: responseData,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        return true;
      } else if (response.statusCode == 400) {
        final msgError = responseData['non_field_errors'];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${msgError[0]}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de internet, intenta de nuevo.')),
      );
    }
    return false;
  }

  static Future<void> logout({required BuildContext context}) async {
    final uri = Uri.parse('${APIConfig.domain}${APIConfig.logout}');
    final token = await UserService.getRefreshToken();
    final body = {'refresh': token};
    final headers = {'Accept': 'application/json'};
    final response = await http.post(uri, headers: headers, body: body);
    UserService.removeTokens();
    UserService.deleteUserData();
  }
}