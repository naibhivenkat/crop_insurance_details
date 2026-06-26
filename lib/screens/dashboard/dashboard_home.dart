import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:crop_survey/features/widgets/stat_card.dart';
import 'package:crop_survey/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardProvider);
    final recentAsync = ref.watch(recentApplicationsProvider);

    return Column(
      children: [
        const AppHeader(title: "Dashboard"),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Dashboard Cards
                statsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),

                  error: (e, _) => Text(e.toString()),

                  data: (stats) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int columns = 4;

                        if (constraints.maxWidth < 1400) {
                          columns = 3;
                        }

                        if (constraints.maxWidth < 900) {
                          columns = 2;
                        }

                        if (constraints.maxWidth < 600) {
                          columns = 1;
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: columns,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 2.2,
                          children: [
                            StatCard(
                              title: "Applications",
                              value: stats.applications.toString(),
                              icon: Icons.description,
                              color: Colors.blue,
                            ),

                            StatCard(
                              title: "Farmers",
                              value: stats.farmers.toString(),
                              icon: Icons.people,
                              color: Colors.green,
                            ),

                            StatCard(
                              title: "Pending",
                              value: stats.pending.toString(),
                              icon: Icons.pending_actions,
                              color: Colors.orange,
                            ),

                            StatCard(
                              title: "Approved",
                              value: stats.approved.toString(),
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),

                            StatCard(
                              title: "Rejected",
                              value: stats.rejected.toString(),
                              icon: Icons.cancel,
                              color: Colors.red,
                            ),

                            StatCard(
                              title: "Total Amount",
                              value:
                                  "₹${NumberFormat('#,##0').format(stats.totalAmount)}",
                              icon: Icons.currency_rupee,
                              color: Colors.purple,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 35),

                const Text(
                  "Recent Applications",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 2,
                  child: recentAsync.when(
                    loading: () => const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    ),

                    error: (e, _) => SizedBox(
                      height: 200,
                      child: Center(child: Text(e.toString())),
                    ),

                    data: (list) {
                      if (list.isEmpty) {
                        return const SizedBox(
                          height: 250,
                          child: Center(child: Text("No Applications Found")),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Sl No")),

                            DataColumn(label: Text("Name")),

                            DataColumn(label: Text("Mobile")),

                            DataColumn(label: Text("Date")),

                            DataColumn(label: Text("Amount")),

                            DataColumn(label: Text("Status")),
                          ],

                          rows: list.map((data) {
                            return DataRow(
                              cells: [
                                DataCell(Text("${data["slNo"] ?? ""}")),

                                DataCell(Text(data["name"] ?? "")),

                                DataCell(Text(data["mobile"] ?? "")),

                                DataCell(
                                  Text(
                                    data["date"] == null
                                        ? ""
                                        : DateFormat(
                                            "dd-MM-yyyy",
                                          ).format(data["date"].toDate()),
                                  ),
                                ),

                                DataCell(Text("₹${data["totalAmount"] ?? 0}")),

                                DataCell(
                                  Chip(
                                    label: Text(data["status"] ?? "Pending"),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
