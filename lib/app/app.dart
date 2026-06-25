import 'package:crop_survey/app/app_shell.dart';
//import 'package:crop_survey/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'theme.dart';


class CropSurveyApp extends StatelessWidget {
  const CropSurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Survey',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: const AppShell(),
    );
  }
}