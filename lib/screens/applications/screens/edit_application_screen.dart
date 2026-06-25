import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../../features/widgets/app_header.dart';
import '../../../models/survey_row_controller.dart';
import '../../../services/firestore_service.dart';

import 'package:crop_survey/features/widgets/farmer_information_card.dart';
import 'package:crop_survey/features/widgets/save_button.dart';
import 'package:crop_survey/features/widgets/survey_table.dart';
import 'package:crop_survey/features/widgets/total_amount_card.dart';

class EditApplicationScreen extends StatefulWidget {
  final String farmerId;

  const EditApplicationScreen({
    super.key,
    required this.farmerId,
  });

  @override
  State<EditApplicationScreen> createState() =>
      _EditApplicationScreenState();
}

class _EditApplicationScreenState
    extends State<EditApplicationScreen> {

  final firestore = FirestoreService.instance;

  bool loading = true;

  final nameController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final mobileController =
      TextEditingController();

  DateTime selectedDate =
      DateTime.now();

  final List<SurveyRowController>
      surveyRows = [];

  final List<String> crops = [];

  final Map<String, double>
      cropRates = {};

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    await loadCropRates();

    await loadFarmer();

    await loadSurveyDetails();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> loadCropRates() async {

    final rates =
        await firestore.getCropRates();

    cropRates.clear();
    crops.clear();

    for (final rate in rates) {

      cropRates[rate.crop] =
          rate.ratePerGunte;

      crops.add(rate.crop);
    }
  }

  Future<void> loadFarmer() async {

    final farmer =
        await FirebaseFirestore.instance
            .collection("farmers")
            .doc(widget.farmerId)
            .get();

    if (!farmer.exists) return;

    final data = farmer.data()!;

    nameController.text =
        data["name"] ?? "";

    addressController.text =
        data["address"] ?? "";

    mobileController.text =
        data["mobile"] ?? "";

    final ts =
        data["date"] as Timestamp?;

    if (ts != null) {
      selectedDate =
          ts.toDate();
    }
  }

  Future<void> loadSurveyDetails() async {

    final snapshot =
        await FirebaseFirestore.instance
            .collection("farmers")
            .doc(widget.farmerId)
            .collection("surveyDetails")
            .get();

    surveyRows.clear();

    for (final doc
        in snapshot.docs) {

      final data = doc.data();

      final row =
          SurveyRowController(

        surveyNo:
            data["surveyNo"] ?? "",

        crop:
            data["crop"] ?? crops.first,
      );

      row.acreController.text =
          "${data["acre"] ?? 0}";

      row.gunteController.text =
          "${data["gunte"] ?? 0}";

      row.subGunteController.text =
          "${data["subGunte"] ?? 0}";

      row.amount =
          (data["amount"] ?? 0)
              .toDouble();

      surveyRows.add(row);
    }
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

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      const AppHeader(
        title: "Edit Application",
        subtitle: "Update Existing Application",
      ),

      Expanded(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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

                    const SizedBox(height: 24),

                    SurveyTable(
                      surveyRows: surveyRows,
                      crops: crops,
                      onAddSurvey: addSurvey,
                      onDeleteSurvey: removeSurvey,
                      onCalculate: calculateRow,
                    ),

                    const SizedBox(height: 24),

                    TotalAmountCard(
                      totalAmount: totalAmount,
                      surveyCount: surveyRows.length,
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: SaveButton(
                        isSaving: false,
                        onPressed: updateApplication,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ],
  );
}
void addSurvey() {
  surveyRows.add(
    SurveyRowController(
      crop: crops.first,
    ),
  );

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

void calculateRow(int index) {
  final row = surveyRows[index];

  final totalGunte =
      (row.acre * 40) +
      row.gunte +
      (row.subGunte / 16);

  row.amount =
      totalGunte *
      getRate(row.crop);

  setState(() {});
}

double get totalAmount {
  double total = 0;

  for (final row in surveyRows) {
    total += row.amount;
  }

  return total;
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

Future<void> updateApplication() async {

  try {

    final firestore =
        FirebaseFirestore.instance;

    final batch =
        firestore.batch();

    final farmerRef =
        firestore
            .collection("farmers")
            .doc(widget.farmerId);

    batch.update(
      farmerRef,
      {
        "name":
            nameController.text.trim(),

        "address":
            addressController.text.trim(),

        "mobile":
            mobileController.text.trim(),

        "date":
            Timestamp.fromDate(
              selectedDate,
            ),

        "totalAmount":
            totalAmount,
      },
    );

    //----------------------------------------------------
    // Delete old survey rows
    //----------------------------------------------------

    final oldRows =
        await farmerRef
            .collection(
              "surveyDetails",
            )
            .get();

    for (final doc in oldRows.docs) {

      batch.delete(doc.reference);

    }

    //----------------------------------------------------
    // Add new survey rows
    //----------------------------------------------------

    for (int i = 0;
        i < surveyRows.length;
        i++) {

      final row =
          surveyRows[i];

      final detailRef =
          farmerRef
              .collection(
                "surveyDetails",
              )
              .doc();

      batch.set(
        detailRef,
        {

          "detailId":
              detailRef.id,

          "farmerId":
              widget.farmerId,

          "surveyNo":
              row.surveyNoController.text,

          "crop":
              row.crop,

          "acre":
              row.acre,

          "gunte":
              row.gunte,

          "subGunte":
              row.subGunte,

          "amount":
              row.amount,
        },
      );
    }

    await batch.commit();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        backgroundColor:
            Colors.green,

        content: Text(
          "Application Updated Successfully",
        ),
      ),
    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        backgroundColor:
            Colors.red,

        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}
}