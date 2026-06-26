import 'package:crop_survey/models/farmer_model.dart';
import 'package:crop_survey/models/survey_detail_model.dart';

class ApplicationViewModel {
  final FarmerModel farmer;
  final List<SurveyDetailModel> surveys;

  const ApplicationViewModel({
    required this.farmer,
    required this.surveys,
  });

  double get totalAreaGunte {
    double total = 0;

    for (final survey in surveys) {
      total +=
          (survey.acre * 40) +
          survey.gunte +
          (survey.subGunte / 16);
    }

    return total;
  }

  int get totalAcres => totalAreaGunte ~/ 40;

  double get remainingGunte =>
      totalAreaGunte - (totalAcres * 40);

  String get areaText =>
      "$totalAcres Acre ${remainingGunte.toStringAsFixed(2)} Gunte";

  String get crops =>
      surveys.map((e) => e.crop).toSet().join(", ");

  String get surveyNumbers =>
      surveys.map((e) => e.surveyNo).join(", ");

  int get surveyCount => surveys.length;

  double get totalAmount => farmer.totalAmount;
}