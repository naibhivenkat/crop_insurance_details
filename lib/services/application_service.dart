import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/farmer_model.dart';
import '../models/survey_detail_model.dart';
import '../pdf/pdf_service.dart';
import 'firestore_service.dart';

class ApplicationService {
  ApplicationService._();

  static final ApplicationService instance = ApplicationService._();

  final FirestoreService firestore = FirestoreService.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final Uuid uuid = const Uuid();

  // Future<void> saveApplication({
  //   required FarmerModel farmer,
  //   required List<SurveyDetailModel> surveys,
  //   bool previewPdf = true,
  // }) async {
  //   //----------------------------------------------------
  //   // Save Firestore
  //   //----------------------------------------------------

  //   // await firestore.saveSurvey(
  //   //   farmer: farmer,
  //   //   surveys: surveys,
  //   // );

  //   await ApplicationService.instance.saveApplication(
  //     farmer: farmer,
  //     surveys: surveys,
  //   );


Future<void> saveApplication({
  required FarmerModel farmer,
  required List<SurveyDetailModel> surveys,
  bool previewPdf = true,
}) async {

  // Save Firestore
  await firestore.saveSurvey(
    farmer: farmer,
    surveys: surveys,
  );

  // Open PDF Preview
  if (previewPdf) {
    await PdfService.instance.previewReceipt(
      farmer: farmer,
      surveys: surveys,
    );
  }
}

  Future<void> updateApplication({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
    bool previewPdf = true,
  }) async {
    final batch = db.batch();

    //----------------------------------------------------
    // Farmer
    //----------------------------------------------------

    final farmerRef = db.collection("farmers").doc(farmer.id);

    batch.set(farmerRef, farmer.toMap());

    //----------------------------------------------------
    // Delete Old Surveys
    //----------------------------------------------------

    final old = await db
        .collection("surveyDetails")
        .where("farmerId", isEqualTo: farmer.id)
        .get();

    for (final doc in old.docs) {
      batch.delete(doc.reference);
    }

    //----------------------------------------------------
    // Save New Surveys
    //----------------------------------------------------

    for (final survey in surveys) {
      batch.set(
        db.collection("surveyDetails").doc(survey.detailId),
        survey.toMap(),
      );
    }

    await batch.commit();

    if (previewPdf) {
      await PdfService.instance.previewReceipt(
        farmer: farmer,
        surveys: surveys,
      );
    }
  }

  Future<void> printReceipt({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) {
    return PdfService.instance.previewReceipt(farmer: farmer, surveys: surveys);
  }

  Future<void> downloadReceipt({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) {
    return PdfService.instance.shareReceipt(farmer: farmer, surveys: surveys);
  }
}
