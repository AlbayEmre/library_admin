import 'package:flutter/material.dart';

class GradyanTheme extends StatelessWidget {
  const GradyanTheme({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0, 0.2, 0.5, 0.8, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 155, 243, 255), // Kenarların rengi ve yoğunluğu
            Colors.white,
            Colors.white,

            Colors.white,
            Color.fromARGB(255, 251, 254, 197), // Kenarların rengi ve yoğunluğu
          ],
        ),
      ),
    );
  }
}
