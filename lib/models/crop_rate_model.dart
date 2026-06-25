class CropRateModel {
  final String crop;

  final double ratePerGunte;

  CropRateModel({
    required this.crop,
    required this.ratePerGunte,
  });

  Map<String, dynamic> toMap() {
    return {
      "crop": crop,
      "ratePerGunte": ratePerGunte,
    };
  }

  factory CropRateModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return CropRateModel(
      crop: map["crop"],
      ratePerGunte:
          (map["ratePerGunte"] as num)
              .toDouble(),
    );
  }
}