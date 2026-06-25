import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/dashboard_service.dart';

final dashboardProvider =
    FutureProvider<DashboardStats>((ref) async {
  return DashboardService.instance.getStats();
});

final recentApplicationsProvider =
    FutureProvider<List<Map<String, dynamic>>>(
  (ref) async {
    return DashboardService.instance
        .recentApplications();
  },
);