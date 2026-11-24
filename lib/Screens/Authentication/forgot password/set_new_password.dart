import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Padres360/Screens/Authentication/forgot%20password/repo/forgot_pass_repo.dart';
import 'package:Padres360/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key, required this.email});

  final String email;

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isClicked = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool showPassword = true;
  bool showConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          surfaceTintColor: kWhite,
          backgroundColor: kWhite,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            "Nueva contraseña",
            //'Create New Password',
            style: textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Reestablecer contraseña",
                    // 'Set Up New Password',
                    style: textTheme.titleMedium?.copyWith(fontSize: 24.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Cambiar contraseña.",
                    //'Reset your password to recovery and log in your account',
                    style: textTheme.bodyMedium?.copyWith(color: kGreyTextColor, fontSize: 16), textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: showPassword,
                    decoration: kInputDecoration.copyWith(
                      hintText: '********',
                      labelText: "Nueva contraseña",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: FaIcon(
                          showPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                          color: kGreyTextColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        //return 'Password can\'t be empty';
                        return "La constraseña no puede estar vacía.";
                      } else if (value.length < 6) {
                        //return 'Please enter a bigger password';
                        return "Ingresa una contraseña mas larga.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: showConfirmPassword,
                    decoration: kInputDecoration.copyWith(
                      border: const OutlineInputBorder(),
                      //labelText: 'Confirm Password',
                      labelText: "Confirmar contraseña",
                      hintText: '********',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                        icon: FaIcon(
                          showConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                          color: kGreyTextColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        //return 'Password can\'t be empty';
                        return "La contraseña no puede estar vacía.";
                      } else if (value != _passwordController.text) {
                        //return 'Passwords do not match';
                        return "La contraseña no coincide";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (isClicked) {
                        return;
                      }
                      if (_formKey.currentState?.validate() ?? false) {
                        isClicked = true;
                        EasyLoading.show();
                        ForgotPassRepo repo = ForgotPassRepo();
                        if (await repo.resetPass(email: widget.email, password: _confirmPasswordController.text, context: context)) {
                          Navigator.pop(context);
                        } else {
                          isClicked = false;
                        }
                      }
                    },
                    child: Text("Guardar"),
                    //'Save',
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
