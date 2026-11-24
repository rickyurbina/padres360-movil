import 'package:flutter/material.dart';
import 'package:Padres360/Screens/Profile%20Screen/Repo/profile_repo.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ProfileRepo _repo = ProfileRepo();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: newPasswordController,
              keyboardType: TextInputType.text,
              obscureText: _obscureNew,
              decoration: kInputDecoration.copyWith(
                //labelText: 'Password',
                labelText: "Contraseña",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureNew = !_obscureNew;
                    });
                  },
                  icon: FaIcon(
                    _obscureNew
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Password can\'t be empty';
                  return "La contraseña no puede estar vacía.";
                } else if (value.length < 8) {
                  //return 'Please enter a bigger password';
                  return "Ingresa una contraseña más grande";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: confirmPasswordController,
              keyboardType: TextInputType.text,
              obscureText: _obscureConfirm,
              decoration: kInputDecoration.copyWith(
                //labelText: 'Password',
                labelText: "Confirma la contraseña",
                border: const OutlineInputBorder(),
                //hintText: 'Enter password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                  icon: FaIcon(
                    _obscureConfirm
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: kGreyTextColor,
                    size: 18,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Password can\'t be empty';
                  return "La contraseña no puede estar vacía.";
                } else if (value.length < 8) {
                  //return 'Please enter a bigger password';
                  return "Ingresa una contraseña más grande";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final newPassword = newPasswordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();
                  final user = await UserService.getUser();

                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'), // o 'Error'
                        content: const Text('Por favor llena todos los campos.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text("La constraseña no coincide."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  try {
                    final success = await _repo.updateProfile(
                      id: user.id,
                      pass: newPassword,
                      context: context,
                    );

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(success ? 'Listo' : 'Error'),
                        content: Text(success ? 'Contraseña cambiada.' : 'No se pudo cambiar la contraseña.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (success) Navigator.of(context).pop(); // Cierra la pantalla si tuvo éxito
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  } catch (error) {
                    final errorMessage = error.toString();
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(errorMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
