import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//!XFile  image pickerden gelen bir Deyişkenir

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key, this.pickedImage, required this.function});

  final XFile? pickedImage; //?Bir resim seçildiğinde burda XFile  o resmi tutar
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: pickedImage == null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  )
                : Image.file(
                    //* Bu kez dosyamız uygulamaın dosyalarından alacağımız için .file dedik
                    File(pickedImage!.path),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.blue,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                function();
              },
              splashColor: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.image,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
