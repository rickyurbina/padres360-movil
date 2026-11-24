import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Const/api_config.dart';
import '../../constants.dart';

class ParentProfileDetails extends StatelessWidget {
  const ParentProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final profile = {
      'name': 'Carlos Pérez',
      'email': 'carlos.perez@example.com',
      'category': 'Padre de familia',
      'phone': '555-1234',
      'address': 'Av. Siempre Viva 742',
      'vatTitle': 'RFC',
      'vatNumber': 'PERC800101HDF',
      'pictureUrl': null,
    };

    return Scaffold(
        backgroundColor: AppColors.kSurfaceLight,
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
          backgroundColor: kWhite,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: profile['pictureUrl'] == null
                        ? BoxDecoration(
                      image: const DecorationImage(image: AssetImage('images/no_shop_image.png'), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50),
                    )
                        : BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(APIConfig.domain + (profile['pictureUrl'] as String)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildField(context, 'Nombre:', profile['name']),
                buildField(context, 'Email:', profile['email']),
                buildField(context, "Categoría de negocios:", profile['category']),
                buildField(context, 'Teléfono:', profile['phone']),
                buildField(context, "Domicilio:", profile['address']),
                buildField(context, 'RFC', profile['vatTitle']),
                buildField(context, 'RFC Número', profile['vatNumber']),
              ],
            ),
          ),
        ),
    );
  }

  Widget buildField(BuildContext context, String label, String? value) {
    return AppTextField(
      readOnly: true,
      controller: TextEditingController(text: value ?? ''),
      decoration: kInputDecoration.copyWith(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      textFieldType: TextFieldType.NAME,
    ).paddingAll(10);
  }
}
