import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStats {
  final int applications;
  final int farmers;
  final int pending;
  final int approved;
  final int rejected;
  final double totalAmount;

  const DashboardStats({
    required this.applications,
    required this.farmers,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.totalAmount,
  });
}

class DashboardService {
  DashboardService._();

  static final DashboardService instance =
      DashboardService._();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get farmersCollection =>
          firestore.collection("farmers");

  Future<DashboardStats> getStats() async {
    final snapshot =
        await farmersCollection.get();

    final totalApplications =
        snapshot.docs.length;

    int pending = 0;
    int approved = 0;
    int rejected = 0;

    double totalAmount = 0;

    final Set<String> uniqueFarmers = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      uniqueFarmers.add(
        data["mobile"]?.toString() ?? "",
      );

      final status =
          data["status"]?.toString() ??
              "Pending";

      switch (status) {
        case "Approved":
          approved++;
          break;

        case "Rejected":
          rejected++;
          break;

        default:
          pending++;
      }

      final amount =
          (data["totalAmount"] ?? 0);

      if (amount is int) {
        totalAmount += amount.toDouble();
      } else if (amount is double) {
        totalAmount += amount;
      }
    }

    return DashboardStats(
      applications: totalApplications,
      farmers: uniqueFarmers.length,
      pending: pending,
      approved: approved,
      rejected: rejected,
      totalAmount: totalAmount,
    );
  }

  Future<List<Map<String, dynamic>>>
      recentApplications() async {
    final snapshot =
        await farmersCollection
            .orderBy(
              "slNo",
              descending: true,
            )
            .limit(10)
            .get();

    return snapshot.docs
        .map((e) => e.data())
        .toList();
  }
}