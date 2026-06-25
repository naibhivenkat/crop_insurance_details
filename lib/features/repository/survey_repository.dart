import '../../../services/firestore_service.dart';

class SurveyRepository {
  final FirestoreService service;

  SurveyRepository(this.service);

  Future<void> saveSurvey({
    required farmer,
    required surveys,
  }) {
    return service.saveSurvey(
      farmer: farmer,
      surveys: surveys,
    );
  }
}