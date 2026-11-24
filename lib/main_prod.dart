import 'package:Padres360/app.dart';
import 'package:Padres360/env/environment.dart';
import 'package:Padres360/firebase_background.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String environment = const String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.prod,
  );
  Environment().initConfig(environment);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}
