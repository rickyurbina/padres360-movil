import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Repo/sign_in_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Padres360/constants.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(title: Text("Olvidé mi contraseña")),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8.0),
                Text("Ingresa tu nombre de usuario para recuperar tu contraseña.",
                  style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor, fontSize: 16), textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: kInputDecoration.copyWith(
                    labelText: "Usuario",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El campo no debe estar vacío.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    maximumSize: const Size(double.infinity, 48),
                    minimumSize: const Size(double.infinity, 48),
                    disabledBackgroundColor: _theme.colorScheme.primary.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      FocusScope.of(context).unfocus();
                      EasyLoading.show();
                      LogInRepo repo = LogInRepo();
                      if (await repo.sendPassTemp(username: _emailController.text, context: context)) {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // opcional: evita cerrar tocando fuera
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 20, left: 24, right: 24, bottom: 16),
                              titlePadding: const EdgeInsets.only(
                                  top: 16, left: 24, right: 8),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Recuperación de contraseña',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: AppColors.kOnSurfaceLight,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: AppColors.kOnSurfaceLight),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animación Lottie centrada
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Lottie.asset(
                                      'assets/lottie/success.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Se ha enviado una contraseña temporal al correo.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop(); // cerrar diálogo
                                      Navigator.of(context).pop(); // regresar a pantalla anterior
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Aceptar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.kPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }

                    }
                  },
                  child: Text(
                    "Continuar",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: _theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
