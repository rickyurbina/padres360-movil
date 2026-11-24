import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class DefaultDashboard extends StatefulWidget {
  const DefaultDashboard({super.key});

  @override
  State<DefaultDashboard> createState() => _DefaultDashboardState();
}

class _DefaultDashboardState extends State<DefaultDashboard> {
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await UserService.getUser();
    setState(() {
      userName = user.firstName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kMainColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(title: Text('${userName ?? ''}')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/empty.json', width: 200),
              const SizedBox(height: 16),
              const Text(
                'Aún no hay contenido disponible para tu perfil.\n'
                    'Cuando se te asignen funciones, aparecerán aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
