import 'package:flutter/material.dart';

class SurveyRowController {
  final TextEditingController surveyNoController;

  final TextEditingController acreController;

  final TextEditingController gunteController;

  final TextEditingController subGunteController;

  String crop;

  double amount;

  SurveyRowController({
    String surveyNo = '',
    this.crop = 'Arecanut',
    this.amount = 0,
  })  : surveyNoController =
            TextEditingController(text: surveyNo),
        acreController =
            TextEditingController(text: '0'),
        gunteController =
            TextEditingController(text: '0'),
        subGunteController =
            TextEditingController(text: '0');

  double get acre =>
      double.tryParse(
        acreController.text,
      ) ??
      0;

  double get gunte =>
      double.tryParse(
        gunteController.text,
      ) ??
      0;

  double get subGunte =>
      double.tryParse(
        subGunteController.text,
      ) ??
      0;

  void dispose() {
    surveyNoController.dispose();
    acreController.dispose();
    gunteController.dispose();
    subGunteController.dispose();
  }
}