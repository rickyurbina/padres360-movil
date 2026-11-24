import 'package:Padres360/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

class LogOutRepo {
  static Future<void> logout({required BuildContext context}) async {
    AuthService.logout(context: context);
  }
}
