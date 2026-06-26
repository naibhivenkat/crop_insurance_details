// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:crop_survey/models/crop_rate_model.dart';
// import 'package:crop_survey/models/farmer_model.dart';
// import 'package:crop_survey/models/survey_detail_model.dart';

// class FirestoreService {
//   FirestoreService._();

//   static final FirestoreService instance = FirestoreService._();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   CollectionReference<Map<String, dynamic>> get farmers =>
//       _firestore.collection('farmers');

//   CollectionReference<Map<String, dynamic>> get cropRates =>
//       _firestore.collection('cropRates');

//   Future<void> saveSurvey({
//     required FarmerModel farmer,
//     required List<SurveyDetailModel> surveys,
//   }) async {
//     final batch = _firestore.batch();

//     final farmerRef = farmers.doc(farmer.id);

//     batch.set(farmerRef, farmer.toMap());

//     final surveyCollection = _firestore.collection("surveyDetails");

//     for (final survey in surveys) {
//       batch.set(surveyCollection.doc(survey.detailId), survey.toMap());
//     }

//     await batch.commit();
//   }

//   /// -------------------------------
//   /// Next Serial Number
//   /// -------------------------------
//   Future<int> getNextSlNo() async {
//     final snapshot = await farmers.get();

//     if (snapshot.docs.isEmpty) {
//       return 1;
//     }

//     int max = 0;

//     for (final doc in snapshot.docs) {
//       final data = doc.data();

//       final sl = (data["slNo"] ?? 0) as int;

//       if (sl > max) {
//         max = sl;
//       }
//     }

//     return max + 1;
//   }

//   /// -------------------------------
//   /// Get Crop List
//   /// -------------------------------
//   Future<List<CropRateModel>> getCropRates() async {
//     final snapshot = await cropRates.get();

//     return snapshot.docs
//         .map((doc) => CropRateModel.fromMap(doc.data()))
//         .toList();
//   }

//   /// -------------------------------
//   /// Get Crop Names
//   /// -------------------------------
//   Future<List<String>> getCropNames() async {
//     final crops = await getCropRates();

//     return crops.map((e) => e.crop).toList();
//   }

//   /// -------------------------------
//   /// Get Rate by Crop
//   /// -------------------------------
//   Future<double> getRate(String crop) async {
//     final doc = await cropRates.doc(crop).get();

//     if (!doc.exists) {
//       return 0;
//     }

//     return (doc.data()!["ratePerGunte"] as num).toDouble();
//   }

//   /// -------------------------------
//   /// Add / Update Crop Rate
//   /// -------------------------------
//   Future<void> saveCropRate(CropRateModel crop) async {
//     await cropRates.doc(crop.crop).set(crop.toMap());
//   }

//   /// -------------------------------
//   /// Delete Crop
//   /// -------------------------------
//   Future<void> deleteCrop(String crop) async {
//     await cropRates.doc(crop).delete();
//   }

//   Future<int> getFarmerCount() async {
//     final snapshot = await farmers.get();

//     return snapshot.docs.length;
//   }

//   Future<int> getSurveyCount() async {
//     final snapshot = await _firestore.collection("surveyDetails").get();

//     return snapshot.docs.length;
//   }

//   Future<double> getGrandTotal() async {
//     final snapshot = await farmers.get();

//     double total = 0;

//     for (final doc in snapshot.docs) {
//       total += (doc["totalAmount"] as num).toDouble();
//     }

//     return total;
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_survey/models/application_view_model.dart';

import 'package:crop_survey/models/crop_rate_model.dart';
import 'package:crop_survey/models/farmer_model.dart';
import 'package:crop_survey/models/survey_detail_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get farmers =>
      _firestore.collection("farmers");

  CollectionReference<Map<String, dynamic>> get cropRates =>
      _firestore.collection("cropRates");

  CollectionReference<Map<String, dynamic>> get surveyDetails =>
      _firestore.collection("surveyDetails");

  /// ==========================================================
  /// SAVE SURVEY
  /// ==========================================================

  Future<void> saveSurvey({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) async {
    final batch = _firestore.batch();

    batch.set(farmers.doc(farmer.id), farmer.toMap());

    for (final survey in surveys) {
      batch.set(
        surveyDetails.doc(survey.detailId),
        survey.toMap(),
      );
    }

    await batch.commit();
  }

  /// ==========================================================
  /// DASHBOARD
  /// ==========================================================

  Future<int> getFarmerCount() async {
    final snapshot = await farmers.get();
    return snapshot.docs.length;
  }

  Future<int> getSurveyCount() async {
    final snapshot = await surveyDetails.get();
    return snapshot.docs.length;
  }

  Future<double> getGrandTotal() async {
    final snapshot = await farmers.get();

    double total = 0;

    for (final doc in snapshot.docs) {
      total += (doc["totalAmount"] as num).toDouble();
    }

    return total;
  }

  /// ==========================================================
  /// SERIAL NUMBER
  /// ==========================================================

  Future<int> getNextSlNo() async {
    final snapshot = await farmers.get();

    if (snapshot.docs.isEmpty) {
      return 1;
    }

    int max = 0;

    for (final doc in snapshot.docs) {
      final sl = (doc["slNo"] ?? 0) as int;

      if (sl > max) {
        max = sl;
      }
    }

    return max + 1;
  }

  /// ==========================================================
  /// CROPS
  /// ==========================================================

  Future<List<CropRateModel>> getCropRates() async {
    final snapshot = await cropRates.get();

    return snapshot.docs
        .map((e) => CropRateModel.fromMap(e.data()))
        .toList();
  }

  Future<List<String>> getCropNames() async {
    final list = await getCropRates();

    return list.map((e) => e.crop).toList();
  }

  Future<double> getRate(String crop) async {
    final doc = await cropRates.doc(crop).get();

    if (!doc.exists) {
      return 0;
    }

    return (doc["ratePerGunte"] as num).toDouble();
  }

  Future<void> saveCropRate(CropRateModel crop) async {
    await cropRates.doc(crop.crop).set(crop.toMap());
  }

  Future<void> deleteCrop(String crop) async {
    await cropRates.doc(crop).delete();
  }

  /// ==========================================================
  /// APPLICATIONS
  /// ==========================================================

  Future<List<FarmerModel>> getAllFarmers() async {
    final snapshot = await farmers
        .orderBy("slNo", descending: true)
        .get();

    return snapshot.docs
        .map((e) => FarmerModel.fromMap(e.data()))
        .toList();
  }

  Future<FarmerModel?> getFarmer(String farmerId) async {
    final doc = await farmers.doc(farmerId).get();

    if (!doc.exists) return null;

    return FarmerModel.fromMap(doc.data()!);
  }

  Future<List<SurveyDetailModel>> getSurveyDetails(
    String farmerId,
  ) async {
    final snapshot = await surveyDetails
        .where("farmerId", isEqualTo: farmerId)
        .get();

    return snapshot.docs
        .map((e) => SurveyDetailModel.fromMap(e.data()))
        .toList();
  }

  Future<void> updateApplicationStatus({
    required String farmerId,
    required String status,
    String remarks = "",
    String ackNo = "",
  }) async {
    await farmers.doc(farmerId).update({
      "status": status,
      "remarks": remarks,
      "ackNo": ackNo,
    });
  }

  Future<void> deleteApplication(String farmerId) async {
    final batch = _firestore.batch();

    batch.delete(farmers.doc(farmerId));

    final surveySnapshot = await surveyDetails
        .where("farmerId", isEqualTo: farmerId)
        .get();

    for (final doc in surveySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<List<FarmerModel>> searchFarmers(String keyword) async {
    final all = await getAllFarmers();

    final query = keyword.toLowerCase();

    return all.where((farmer) {
      return farmer.name.toLowerCase().contains(query) ||
          farmer.mobile.contains(query) ||
          farmer.slNo.toString().contains(query);
    }).toList();
  }

  Future<List<FarmerModel>> getApplicationsByStatus(
    String status,
  ) async {
    final snapshot = await farmers
        .where("status", isEqualTo: status)
        .orderBy("slNo", descending: true)
        .get();

    return snapshot.docs
        .map((e) => FarmerModel.fromMap(e.data()))
        .toList();
  }

  /// ==========================================================
  /// REALTIME STREAM
  /// ==========================================================

  Stream<List<FarmerModel>> applicationsStream() {
    return farmers
        .orderBy("slNo", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => FarmerModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
Future<List<ApplicationViewModel>> getAllApplications() async {
  final farmerList = await getAllFarmers();

  final List<ApplicationViewModel> list = [];

  for (final farmer in farmerList) {
    final surveys = await getSurveyDetails(farmer.id);

    list.add(
      ApplicationViewModel(
        farmer: farmer,
        surveys: surveys,
      ),
    );
  }

  return list;
}
  
}