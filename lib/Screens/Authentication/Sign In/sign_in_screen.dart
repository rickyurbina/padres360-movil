import 'package:Padres360/Screens/Authentication/forgot%20password/forgot_password.dart';
import 'package:Padres360/services/fmc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Padres360/GlobalComponents/button_global.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'Repo/sign_in_repo.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword = true;
  bool _isChecked = false;

  ///__________variables_____________
  bool isClicked = false;

  final key = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = prefs.getBool('remember_me') ?? false;
      if (_isChecked) {
        emailController.text = prefs.getString('email') ?? '';
      }
    });
  }

  void _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', _isChecked);
    if (_isChecked) {
      prefs.setString('email', emailController.text);
    } else {
      prefs.remove('email');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final _theme = Theme.of(context);
    return Consumer(
        builder: (_, ref, watch) {
          return Scaffold(
            backgroundColor: kWhite,
            appBar: AppBar(
              surfaceTintColor: kWhite,
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: kWhite,
              titleSpacing: 16,
              title: Text(
                // 'Sign in',
                "Iniciar sesión",
              ),
              iconTheme: IconThemeData(color: kTitleColor),
              titleTextStyle: TextStyle(
                color: kTitleColor,
                fontSize: 20,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const NameWithLogo(),
                      const SizedBox(height: 24),
                      Text(
                        // 'Welcome back!',f
                        "¡Bienvenido de nuevo!",
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: kInputDecoration.copyWith(
                          labelText: "Usuario:",
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return 'Email can\'t be empty';
                            return "Debe ingresar un nombre de usuario.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: showPassword,
                        decoration: kInputDecoration.copyWith(
                          //labelText: 'Password',
                          labelText: "Contraseña",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: FaIcon(
                              showPassword
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
                            return "La contraseña no puede estar vacía";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            checkColor: Colors.white,
                            activeColor: kMainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            fillColor: WidgetStateProperty.all(
                              _isChecked ? kMainColor : Colors.transparent,
                            ),
                            visualDensity: const VisualDensity(horizontal: -4),
                            side: const BorderSide(color: kGreyTextColor),
                            value: _isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                _isChecked = newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Recuérdame",
                            //'Remember me',
                            style: textTheme.bodyMedium?.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            ),
                            child: Text(
                              "Has olvidado tu contraseña",
                              style: textTheme.bodyMedium?.copyWith(
                                color: kMainColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(double.infinity, 48),
                          minimumSize: const Size(double.infinity, 48),
                          disabledBackgroundColor: _theme.colorScheme.primary
                              .withAlpha(38), // con .withAlpha o .withOpacity
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () async {
                          if (isClicked) {
                            return;
                          }
                          if (key.currentState?.validate() ?? false) {
                            isClicked = true;
                            EasyLoading.show();
                            LogInRepo repo = LogInRepo();
                            if (await repo.logIn(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            )) {
                              _saveUserCredentials();
                              FCMService.getToken();

                              EasyLoading.showSuccess('Listo');
                            } else {
                              isClicked = false;
                            }
                          }
                        },
                        child: Text(
                          "Entrar",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            color: _theme.colorScheme.primaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}
