import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../features/widgets/app_header.dart';

class ViewApplicationScreen extends StatelessWidget {
  final String farmerId;

  const ViewApplicationScreen({
    super.key,
    required this.farmerId,
  });

  @override
Widget build(BuildContext context) {
  final firestore = FirebaseFirestore.instance;

  return Material(
    color: Colors.grey.shade100,
    child: Column(
      children: [
        const AppHeader(
          title: "View Application",
          subtitle: "Farmer Application Details",
        ),

        Expanded(
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: firestore
                .collection("farmers")
                .doc(farmerId)
                .get(),
            builder: (context, farmerSnapshot) {
              if (farmerSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!farmerSnapshot.hasData ||
                  !farmerSnapshot.data!.exists) {
                return const Center(
                  child: Text("Application not found"),
                );
              }

              final farmer =
                  farmerSnapshot.data!.data()!;

              return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: firestore
                    .collection("surveyDetails")
                    .where(
                      "farmerId",
                      isEqualTo: farmerId,
                    )
                    .get(),
                builder: (context, surveySnapshot) {
                  if (surveySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final surveys =
                      surveySnapshot.data?.docs ?? [];

                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                                    20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  farmer["name"] ??
                                      "",
                                  style:
                                      const TextStyle(
                                    fontSize: 26,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                    "Mobile : ${farmer["mobile"] ?? ""}"),

                                Text(
                                    "Address : ${farmer["address"] ?? ""}"),

                                Text(
                                    "Status : ${farmer["status"] ?? "Pending"}"),

                                Text(
                                    "ACK No : ${farmer["ackNo"] ?? ""}"),

                                Text(
                                    "Total Amount : ₹${farmer["totalAmount"] ?? 0}"),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                                    20),
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text(
                                        "Survey No")),
                                DataColumn(
                                    label:
                                        Text("Crop")),
                                DataColumn(
                                    label:
                                        Text("Acre")),
                                DataColumn(
                                    label:
                                        Text("Gunte")),
                                DataColumn(
                                    label: Text(
                                        "Sub")),
                                DataColumn(
                                    label: Text(
                                        "Amount")),
                              ],
                              rows: surveys.map((doc) {
                                final s =
                                    doc.data();

                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                        s["surveyNo"]
                                                ?.toString() ??
                                            "")),
                                    DataCell(Text(
                                        s["crop"] ??
                                            "")),
                                    DataCell(Text(
                                        "${s["acre"]}")),
                                    DataCell(Text(
                                        "${s["gunte"]}")),
                                    DataCell(Text(
                                        "${s["subGunte"]}")),
                                    DataCell(Text(
                                        "₹${s["amount"]}")),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}