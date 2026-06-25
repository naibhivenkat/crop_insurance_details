import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crop_survey/models/crop_rate_model.dart';
import 'package:crop_survey/models/farmer_model.dart';
import 'package:crop_survey/models/survey_detail_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance =
      FirestoreService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get farmers =>
          _firestore.collection('farmers');

  CollectionReference<Map<String, dynamic>>
      get cropRates =>
          _firestore.collection('cropRates');

  /// -------------------------------
  /// Save Farmer + Survey Details
  /// -------------------------------
  // Future<void> saveSurvey({
  //   required FarmerModel farmer,
  //   required List<SurveyDetailModel> surveys,
  // }) async {
  //   final batch = _firestore.batch();

  //   final farmerRef =
  //       farmers.doc(farmer.id);

  //   batch.set(
  //     farmerRef,
  //     farmer.toMap(),
  //   );

  //   for (final survey in surveys) {
  //     final surveyRef = farmerRef
  //         .collection("surveyDetails")
  //         .doc(survey.detailId);

  //     batch.set(
  //       surveyRef,
  //       survey.toMap(),
  //     );
  //   }

  //   await batch.commit();
  // }

  Future<void> saveSurvey({
  required FarmerModel farmer,
  required List<SurveyDetailModel> surveys,
}) async {
  final batch = _firestore.batch();

  final farmerRef =
      farmers.doc(farmer.id);

  batch.set(
    farmerRef,
    farmer.toMap(),
  );

  final surveyCollection =
      _firestore.collection(
        "surveyDetails",
      );

  for (final survey in surveys) {
    batch.set(
      surveyCollection.doc(
        survey.detailId,
      ),
      survey.toMap(),
    );
  }

  await batch.commit();
}

  /// -------------------------------
  /// Next Serial Number
  /// -------------------------------
  Future<int> getNextSlNo() async {
    final snapshot =
        await farmers.get();

    if (snapshot.docs.isEmpty) {
      return 1;
    }

    int max = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final sl =
          (data["slNo"] ?? 0) as int;

      if (sl > max) {
        max = sl;
      }
    }

    return max + 1;
  }

  /// -------------------------------
  /// Get Crop List
  /// -------------------------------
  Future<List<CropRateModel>>
      getCropRates() async {
    final snapshot =
        await cropRates.get();

    return snapshot.docs
        .map(
          (doc) => CropRateModel.fromMap(
            doc.data(),
          ),
        )
        .toList();
  }

  /// -------------------------------
  /// Get Crop Names
  /// -------------------------------
  Future<List<String>>
      getCropNames() async {
    final crops =
        await getCropRates();

    return crops
        .map((e) => e.crop)
        .toList();
  }

  /// -------------------------------
  /// Get Rate by Crop
  /// -------------------------------
  Future<double> getRate(
    String crop,
  ) async {
    final doc =
        await cropRates.doc(crop).get();

    if (!doc.exists) {
      return 0;
    }

    return (doc.data()!["ratePerGunte"]
            as num)
        .toDouble();
  }

  /// -------------------------------
  /// Add / Update Crop Rate
  /// -------------------------------
  Future<void> saveCropRate(
    CropRateModel crop,
  ) async {
    await cropRates
        .doc(crop.crop)
        .set(crop.toMap());
  }

  /// -------------------------------
  /// Delete Crop
  /// -------------------------------
  Future<void> deleteCrop(
    String crop,
  ) async {
    await cropRates
        .doc(crop)
        .delete();
  }

  Future<int> getFarmerCount() async {
  final snapshot =
      await farmers.get();

  return snapshot.docs.length;
}

Future<int> getSurveyCount() async {
  final snapshot =
      await _firestore
          .collection(
            "surveyDetails",
          )
          .get();

  return snapshot.docs.length;
}

Future<double> getGrandTotal() async {
  final snapshot =
      await farmers.get();

  double total = 0;

  for (final doc in snapshot.docs) {
    total +=
        (doc["totalAmount"] as num)
            .toDouble();
  }

  return total;
}
}