import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Authentication/change%20password/change_password_screen.dart';
import 'package:Padres360/Screens/Profile%20Screen/Repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/constants.dart';
import 'package:Padres360/Const/api_config.dart';
import 'package:nb_utils/nb_utils.dart';

class TeacherProfileDetails extends StatefulWidget {
  const TeacherProfileDetails({super.key});

  @override
  State<TeacherProfileDetails> createState() => _TeacherProfileDetailsState();
}

class _TeacherProfileDetailsState extends State<TeacherProfileDetails> {
  final ProfileRepo _repo = ProfileRepo();
  late Future<User> _futureUser;

  // Controladores de los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _roleControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureUser = _repo.getProfile(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          title: Text("Perfil"),
          // Sin acciones, sin lápiz
        ),
        body: FutureBuilder<User>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final profile = snapshot.data!;

            // Inicializar controladores con datos del perfil
            _usernameController.text = profile.username;
            _emailController.text = profile.email;
            _profileController.text = profile.profile;
            _nameController.text = profile.firstName;
            _surnameController.text = profile.lastName;
            _roleControler.text = profile.roleLabel;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: profile == null
                                  ? BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'images/no_shop_image.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              )
                                  : BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    APIConfig.domain + "profile.pictureUrl!",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildField(context, 'Usuario:', _usernameController, readOnly: true),
                          buildField(context, "Nombre:", _nameController, readOnly: true),
                          buildField(context, 'Apellido:', _surnameController, readOnly: true),
                          buildField(context, 'Email:', _emailController, readOnly: true),
                          buildField(context, 'Rol:', _roleControler, readOnly: true)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () { Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                      );},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("Cambiar la contraseña"), // "Cambiar contraseña"
                    ).paddingSymmetric(vertical: 10, horizontal: 40),

                  ),
                  const SizedBox(height: 80)
                ],
              ),
            );
          },
        ),
    );
  }

  Widget buildField(
      BuildContext context,
      String label,
      TextEditingController controller, {
        bool readOnly = false,
      }) {
    return AppTextField(
      readOnly: readOnly,
      controller: controller,
      decoration: kInputDecoration.copyWith(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      textFieldType: TextFieldType.NAME,
    ).paddingAll(10);
  }
}
