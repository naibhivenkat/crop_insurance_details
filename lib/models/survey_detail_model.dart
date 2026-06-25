class SurveyDetailModel {
  final String detailId;

  final String farmerId;

  final String surveyNo;

  final String crop;

  final double acre;

  final double gunte;

  final double subGunte;

  final double amount;

  SurveyDetailModel({
    required this.detailId,
    required this.farmerId,
    required this.surveyNo,
    required this.crop,
    required this.acre,
    required this.gunte,
    required this.subGunte,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      "detailId": detailId,
      "farmerId": farmerId,
      "surveyNo": surveyNo,
      "crop": crop,
      "acre": acre,
      "gunte": gunte,
      "subGunte": subGunte,
      "amount": amount,
    };
  }

  factory SurveyDetailModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return SurveyDetailModel(
      detailId: map["detailId"],
      farmerId: map["farmerId"],
      surveyNo: map["surveyNo"],
      crop: map["crop"],
      acre:
          (map["acre"] as num)
              .toDouble(),
      gunte:
          (map["gunte"] as num)
              .toDouble(),
      subGunte:
          (map["subGunte"] as num)
              .toDouble(),
      amount:
          (map["amount"] as num)
              .toDouble(),
    );
  }

  Map<String, dynamic> toExcelMap() {
  return {
    "DetailID": detailId,
    "FarmerID": farmerId,
    "Survey No": surveyNo,
    "Crop": crop,
    "Acre": acre,
    "Gunte": gunte,
    "SubGunte": subGunte,
    "Amount": amount,
  };
}
}