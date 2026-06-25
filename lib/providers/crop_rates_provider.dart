import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/crop_rate_model.dart';
import '../../../services/firestore_service.dart';

final cropRatesProvider =
    FutureProvider<List<CropRateModel>>((ref) async {
  return FirestoreService.instance.getCropRates();
});

final cropRateMapProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final rates =
      await FirestoreService.instance.getCropRates();

  final Map<String, double> map = {};

  for (final rate in rates) {
    map[rate.crop] = rate.ratePerGunte;
  }

  return map;
});