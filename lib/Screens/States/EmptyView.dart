import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottie/empty.json', width: 250, height: 250),
        Text(
          "No hay contenido que mostrar",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    )
    );
  }
}
