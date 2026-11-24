import 'dart:convert';

import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> performRequest({
  required BuildContext context,
  required Uri url,
  String method = 'GET',
  Map<String, String>? headers,
  Object? body,
}) async {
  final token = await UserService.getAuthToken();

  final mergedHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    ...?headers,
  };
  if (token != null && token.trim().isNotEmpty) {
    mergedHeaders['Authorization'] = 'Bearer $token';
  }

  debugPrint('URL Request: $url');
  http.Response response;
  try {
    if (method == 'POST') {
      response = await http.post(url, headers: mergedHeaders, body: body);
    } else if (method == 'PUT') {
      response = await http.put(url, headers: mergedHeaders, body: body);
    } else if (method == 'DELETE') {
      response = await http.delete(url, headers: mergedHeaders, body: body);
    } else {
      response = await http.get(url, headers: mergedHeaders);
    }

    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión expirada. Inicia sesión nuevamente.'),
        ),
      );
      await AuthService.logout(context: context);
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
    return response;
  } catch (error) {
    final message = error.toString();
    debugPrint("Error de red: $message");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error de red: $message')));
    rethrow;
  }
}
