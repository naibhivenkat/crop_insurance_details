import 'package:crop_survey/features/widgets/farmer_information_card.dart';
import 'package:crop_survey/features/widgets/save_button.dart';
import 'package:crop_survey/features/widgets/survey_table.dart';
import 'package:crop_survey/features/widgets/total_amount_card.dart';
import 'package:crop_survey/models/farmer_model.dart';
import 'package:crop_survey/models/survey_detail_model.dart';
import 'package:crop_survey/models/survey_row_controller.dart';
import 'package:crop_survey/services/application_service.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:crop_survey/services/firestore_service.dart';

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({super.key});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final mobileController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool isSaving = false;

  final FirestoreService firestore = FirestoreService.instance;

  final Uuid uuid = const Uuid();

  final List<SurveyRowController> surveyRows = [];

  final List<String> crops = [];
  Map<String, double> cropRates = {};
  @override
  void initState() {
    super.initState();
    loadCropRates();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();

    for (final row in surveyRows) {
      row.dispose();
    }

    super.dispose();
  }

  void addSurvey() {
    if (crops.isEmpty) {
      return;
    }

    surveyRows.add(SurveyRowController(crop: crops.first));

    setState(() {});
  }

  void removeSurvey(int index) {
    surveyRows[index].dispose();

    surveyRows.removeAt(index);

    setState(() {});
  }

  double getRate(String crop) {
    return cropRates[crop] ?? 0;
  }

  Future<void> loadCropRates() async {
    final rates = await firestore.getCropRates();

    cropRates.clear();
    crops.clear();

    for (final rate in rates) {
      cropRates[rate.crop] = rate.ratePerGunte;
      crops.add(rate.crop);
    }

    if (surveyRows.isEmpty) {
      addSurvey();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void calculateRow(int index) {
    final row = surveyRows[index];

    final totalGunte = (row.acre * 40) + row.gunte + (row.subGunte / 16);

    row.amount = totalGunte * getRate(row.crop);

    setState(() {});
  }

  double get totalAmount {
    double total = 0;

    for (final row in surveyRows) {
      total += row.amount;
    }

    return total;
  }

  void resetForm() {
    nameController.clear();

    addressController.clear();

    mobileController.clear();

    selectedDate = DateTime.now();

    for (final row in surveyRows) {
      row.dispose();
    }

    surveyRows.clear();

    if (crops.isNotEmpty) {
      addSurvey();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: selectedDate,
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });
  }

  Future<void> saveSurvey() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter farmer name")));

      return;
    }

    if (surveyRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add survey details")),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final farmerId = uuid.v4();

      final slNo = await firestore.getNextSlNo();

      final farmer = FarmerModel(
        id: farmerId,
        slNo: slNo,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        mobile: mobileController.text.trim(),
        date: Timestamp.fromDate(selectedDate),
        totalAmount: totalAmount,

        status: "Pending",
        ackNo: "",
        remarks: "",
      );

      final List<SurveyDetailModel> details = [];

      for (final row in surveyRows) {
        details.add(
          SurveyDetailModel(
            detailId: uuid.v4(),

            farmerId: farmerId,

            surveyNo: row.surveyNoController.text,

            crop: row.crop,

            acre: row.acre,

            gunte: row.gunte,

            subGunte: row.subGunte,

            amount: row.amount,
          ),
        );
      }

      //await firestore.saveSurvey(farmer: farmer, surveys: details);
      await ApplicationService.instance.saveApplication(
        farmer: farmer,
        surveys: details,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Survey Saved Successfully")),
        );

        resetForm();

        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crop Survey")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            FarmerInformationCard(
              nameController: nameController,

              addressController: addressController,

              mobileController: mobileController,

              selectedDate: selectedDate,

              onSelectDate: pickDate,
            ),

            const SizedBox(height: 20),

            SurveyTable(
              surveyRows: surveyRows,

              crops: crops,

              onAddSurvey: addSurvey,

              onDeleteSurvey: removeSurvey,

              onCalculate: calculateRow,
            ),

            const SizedBox(height: 20),

            TotalAmountCard(
              totalAmount: totalAmount,

              surveyCount: surveyRows.length,
            ),

            const SizedBox(height: 20),

            SaveButton(isSaving: isSaving, onPressed: saveSurvey),
          ],
        ),
      ),
    );
  }
}
