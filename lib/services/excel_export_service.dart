import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';

class ExcelExportService {
  ExcelExportService._();

  static final ExcelExportService instance =
      ExcelExportService._();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<Excel> buildWorkbook() async {
    final excel = Excel.createExcel();

    //-------------------------------------------------
    // Farmers Sheet
    //-------------------------------------------------

    final farmerSheet = excel["Farmers"];

    farmerSheet.appendRow([
      TextCellValue("Sl No"),
      TextCellValue("Name"),
      TextCellValue("Mobile"),
      TextCellValue("Address"),
      TextCellValue("Status"),
      TextCellValue("ACK No"),
      TextCellValue("Total Amount"),
    ]);

    final farmerSnapshot =
        await firestore.collection("farmers").orderBy("slNo").get();

    for (final farmerDoc in farmerSnapshot.docs) {
      final farmer = farmerDoc.data();

      farmerSheet.appendRow([
        IntCellValue(farmer["slNo"] ?? 0),
        TextCellValue(farmer["name"] ?? ""),
        TextCellValue(farmer["mobile"] ?? ""),
        TextCellValue(farmer["address"] ?? ""),
        TextCellValue(farmer["status"] ?? "Pending"),
        TextCellValue(farmer["ackNo"] ?? ""),
        DoubleCellValue(
          (farmer["totalAmount"] ?? 0).toDouble(),
        ),
      ]);
    }

    //-------------------------------------------------
    // Survey Details Sheet
    //-------------------------------------------------

    final surveySheet = excel["SurveyDetails"];

    surveySheet.appendRow([
      TextCellValue("Farmer"),
      TextCellValue("Survey No"),
      TextCellValue("Crop"),
      TextCellValue("Acre"),
      TextCellValue("Gunte"),
      TextCellValue("Sub Gunte"),
      TextCellValue("Amount"),
    ]);

    final surveySnapshot =
        await firestore.collection("surveyDetails").orderBy("surveyNo").get();

    for (final surveyDoc in surveySnapshot.docs) {
      final survey = surveyDoc.data();

      String farmerName = "";

      final farmerDoc = await firestore
          .collection("farmers")
          .doc(survey["farmerId"])
          .get();

      if (farmerDoc.exists) {
        farmerName =
            farmerDoc.data()?["name"] ?? "";
      }

      surveySheet.appendRow([
        TextCellValue(farmerName),
        TextCellValue(survey["surveyNo"] ?? ""),
        TextCellValue(survey["crop"] ?? ""),
        DoubleCellValue(
          (survey["acre"] ?? 0).toDouble(),
        ),
        DoubleCellValue(
          (survey["gunte"] ?? 0).toDouble(),
        ),
        DoubleCellValue(
          (survey["subGunte"] ?? 0).toDouble(),
        ),
        DoubleCellValue(
          (survey["amount"] ?? 0).toDouble(),
        ),
      ]);
    }

    //-------------------------------------------------
    // Remove default empty sheet
    //-------------------------------------------------

    if (excel.tables.containsKey("Sheet1")) {
      excel.delete("Sheet1");
    }

    return excel;
  }
}