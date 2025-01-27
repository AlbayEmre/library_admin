import 'package:flutter/material.dart';
import 'package:lib_admin/Services/Assets_Manager.dart';
import 'package:lib_admin/screens/Serach_Screen.dart';
import 'package:lib_admin/screens/editorUploadProduct.dart';

class DashboardBtnModel {
  final String imagePath;
  final String text;
  final Function onPressed;

  DashboardBtnModel({required this.text, required this.imagePath, required this.onPressed});
  static List<DashboardBtnModel> dashboardBtnList(context) => [
        DashboardBtnModel(
          text: "Add new Book",
          imagePath: AssetsManager.NewBook,
          onPressed: () {
            Navigator.pushNamed(context, EditoruploadproductScreen.routName);
          },
        ),
        DashboardBtnModel(
          text: "All Books",
          imagePath: AssetsManager.Books,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routName);
          },
        ),
        /*
        DashboardBtnModel(
          text: "View Orders",
          imagePath: AssetsManager.NewBook,
          onPressed: () {
            Navigator.pushNamed(context, EditoruploadproductScreen.routName);
          },
        ),
        */
      ];
}
