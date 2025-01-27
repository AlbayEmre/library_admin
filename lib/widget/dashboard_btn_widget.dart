import 'package:flutter/material.dart';

import 'suptitle_text.dart';

class DashboardBtnWidget extends StatelessWidget {
  const DashboardBtnWidget({super.key, required this.text, required this.imagePath, required this.onPressed});

  final String text;
  final String imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          color: Color.fromARGB(255, 247, 243, 230),
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 50,
                width: 50,
              ),
              SizedBox(
                height: 10,
              ),
              SubTitleTextWidget(
                label: text,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        onPressed();
      },
    );
  }
}
