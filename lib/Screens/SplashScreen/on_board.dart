import 'package:Padres360/Repository/constant_functions.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/core/theme/app_colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants.dart';
import '../Authentication/Sign In/sign_in_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String buttonText = 'Next';

  List<Map<String, dynamic>> getSlider({required BuildContext context}) {
    List<Map<String, dynamic>> sliderList = [
      {
        "icon": onboard1,
        "title": "¡Bienvenido a Padres360!",
        "description": "Conecta fácilmente con la escuela de tus hijos. Mantente al tanto de todo lo que sucede en su día a día.",
      },
      {
        "icon": onboard2,
        "title": "Control de asistencia",
        "description": "Recibe notificaciones cuando tu hijo asista o falte a clases. Mantente informado al instante.",
      },
      {
        "icon": onboard3,
        "title": "Noticias escolares",
        "description": "Consulta avisos, circulares, eventos escolares y mensajes de los docentes desde un solo lugar.",
      },
    ];
    return sliderList;
  }

  List<Map<String, dynamic>> sliderList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserService.setViewOnBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    sliderList = getSlider(context: context);

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: Text(
                      "Saltar",
                      style: _theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  child: PageView.builder(
                    itemCount: sliderList.length,
                    controller: pageController,
                    onPageChanged: (int index) =>
                        setState(() => currentIndexPage = index),
                    itemBuilder: (_, index) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Image.asset(
                              sliderList[index]['icon'],
                              fit: BoxFit.contain,
                              width: context.width() - 100,
                              height: context.width() - 100,
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                sliderList[index]['title'].toString(),
                                style: _theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                sliderList[index]['description'].toString(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: _theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.kNeutral700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: sliderList.length,
                    effect: ExpandingDotsEffect(
                      dotColor: kMainColor.withOpacity(0.2),
                      activeDotColor: kMainColor,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    style: OutlinedButton.styleFrom(
                      maximumSize: const Size(double.infinity, 48),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currentIndexPage < 2
                            ? pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                            : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      "Siguiente",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        color: _theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

}
