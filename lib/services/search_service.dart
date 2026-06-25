import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  SearchService._();

  static final SearchService instance =
      SearchService._();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get farmers =>
          firestore.collection("farmers");

  CollectionReference<Map<String, dynamic>>
      get surveyDetails =>
          firestore.collection("surveyDetails");

  Future<List<Map<String, dynamic>>> search({
    required String field,
    required String value,
  }) async {
    value = value.trim();

    if (value.isEmpty) {
      return [];
    }

    switch (field) {
      case "mobile":
        return _searchFarmers(
          "mobile",
          value,
        );

      case "name":
        return _searchFarmers(
          "name",
          value,
        );

      case "ackNo":
        return _searchFarmers(
          "ackNo",
          value,
        );

      case "status":
        return _searchFarmers(
          "status",
          value,
        );

      case "surveyNo":
        return _searchSurvey(value);

      default:
        return [];
    }
  }

  Future<List<Map<String, dynamic>>> _searchFarmers(
    String field,
    String value,
  ) async {
    final snapshot = await farmers
        .where(
          field,
          isEqualTo: value,
        )
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // Keep Firestore document id
      data["documentId"] = doc.id;

      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _searchSurvey(
    String surveyNo,
  ) async {
    final surveySnapshot =
        await surveyDetails
            .where(
              "surveyNo",
              isEqualTo: surveyNo,
            )
            .get();

    if (surveySnapshot.docs.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> farmersList =
        [];

    for (final survey
        in surveySnapshot.docs) {
      final farmerId =
          survey["farmerId"];

      final farmer =
          await farmers
              .doc(farmerId)
              .get();

      if (farmer.exists) {
        final data = farmer.data()!;

        data["documentId"] = farmer.id;

        farmersList.add(data);
      }
    }

    return farmersList;
  }
}