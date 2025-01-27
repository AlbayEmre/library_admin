import 'package:flutter/material.dart';
import 'package:lib_admin/Colors/theme_Advance.dart';
import 'package:lib_admin/Services/Assets_Manager.dart';
import 'package:lib_admin/widget/dashboard_btn_model.dart';
import 'package:lib_admin/widget/dashboard_btn_widget.dart';
import 'package:lib_admin/widget/suptitle_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GradyanTheme(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 248, 250, 216),
            leading: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.AdminImage),
            ),
            title: SubTitleTextWidget(
              label: "Admin",
            ),
          ),
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              DashboardBtnModel.dashboardBtnList(context).length,
              (index) => DashboardBtnWidget(
                text: DashboardBtnModel.dashboardBtnList(context)[index].text,
                imagePath: DashboardBtnModel.dashboardBtnList(context)[index].imagePath,
                onPressed: DashboardBtnModel.dashboardBtnList(context)[index].onPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
