import 'dart:convert';

import 'package:Padres360/Repository/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../Const/api_config.dart';
import '../../../../Repository/constant_functions.dart';
import '../../../Home/home.dart';

class LogInRepo {
  Future<bool> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.login}');

    final body = {
      'identifier': email,
      'password': password,
    };

    try {
      final response = await performRequest(
        context: context,
        url: url,
        method: 'POST',
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      EasyLoading.dismiss();

      debugPrint('Signin ${response.body}');

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${msgError[0]}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de internet, intenta de nuevo.')),
      );
    }

    return false;
  }


  Future<bool> sendPassTemp({
    required String username,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${APIConfig.domain}${APIConfig.recoveryPass}');

    final body = {
      'user_name': username,
    };

    try {
      final response = await performRequest(
        context: context,
        url: url,
        method: 'POST',
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      EasyLoading.dismiss();

      debugPrint('send mail ${response.body} code:${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final msgError = responseData['non_field_errors'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${msgError[0]}')),
        );
      } else if (response.statusCode == 404){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no encontrado')),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de internet, intenta de nuevo.')),
      );
      return false;
    }

    return true;
  }
}
