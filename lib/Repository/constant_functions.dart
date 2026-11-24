import 'dart:convert';

import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  static Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('refresh') ?? '';
    return token;
  }

  static Future<void> saveUserData({
    required String token,
    required Map<String, dynamic> userEntity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint("Usuraio: ${userEntity.toString()}");
    await prefs.setString('token', token);
    await prefs.setString('refresh', userEntity['tokens']['refresh']);
    await prefs.setString('user', jsonEncode(userEntity));
  }

  static Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  static Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('refresh');
  }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(userJson);
      return User.fromJson(jsonMap);
    }
    return User.empty();
  }

  static Future<void> setViewOnBoard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('viewOnBoard', true);
  }

  static Future<bool> getViewOnBoard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('viewOnBoard') ?? false;
  }

  static Future<void> removeViewOnBoard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('viewOnBoard');
  }
}
