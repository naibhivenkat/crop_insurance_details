import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class CropRatesScreen extends StatefulWidget {
  const CropRatesScreen({super.key});

  @override
  State<CropRatesScreen> createState() =>
      _CropRatesScreenState();
}

class _CropRatesScreenState
    extends State<CropRatesScreen> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference get cropRates =>
      firestore.collection("cropRates");

  Future<void> showCropDialog({
    DocumentSnapshot? document,
  }) async {
    final cropController =
        TextEditingController(
      text: document?["crop"] ?? "",
    );

    final rateController =
        TextEditingController(
      text:
          document == null
              ? ""
              : document["ratePerGunte"]
                  .toString(),
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            document == null
                ? "Add Crop"
                : "Edit Crop",
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      cropController,
                  decoration:
                      const InputDecoration(
                    labelText: "Crop",
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller:
                      rateController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Rate Per Gunte",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () =>
                      Navigator.pop(
                        context,
                      ),
              child: const Text(
                "Cancel",
              ),
            ),
            FilledButton(
              onPressed: () async {
                final crop =
                    cropController.text
                        .trim();

                final rate =
                    double.tryParse(
                          rateController
                              .text,
                        ) ??
                        0;

                if (crop.isEmpty) {
                  return;
                }

                if (document == null) {
                  await cropRates.add({
                    "crop": crop,
                    "ratePerGunte":
                        rate,
                  });
                } else {
                  await cropRates
                      .doc(document.id)
                      .update({
                    "crop": crop,
                    "ratePerGunte":
                        rate,
                  });
                }

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text(
                "Save",
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCrop(
    String id,
  ) async {
    await cropRates.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(
          title: "Crop Rates",
          subtitle:
              "Manage crop rate per gunte",
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Crop Rates",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            showCropDialog();
                          },
                          icon: const Icon(
                            Icons.add,
                          ),
                          label: const Text(
                            "Add Crop",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: StreamBuilder<
                        QuerySnapshot>(
                      stream:
                          cropRates
                              .orderBy(
                                "crop",
                              )
                              .snapshots(),
                      builder:
                          (
                            context,
                            snapshot,
                          ) {
                        if (snapshot
                                .connectionState ==
                            ConnectionState
                                .waiting) {
                          return const Center(
                            child:
                                CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot
                            .hasData) {
                          return const Center(
                            child: Text(
                              "No Crop Rates Found",
                            ),
                          );
                        }

                        final docs =
                            snapshot
                                .data!
                                .docs;

                        return SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "Crop",
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Rate / Gunte",
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Actions",
                                ),
                              ),
                            ],
                            rows:
                                docs.map((
                                  doc,
                                ) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      doc["crop"],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "₹${doc["ratePerGunte"]}",
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(
                                            Icons
                                                .edit,
                                            color:
                                                Colors
                                                    .blue,
                                          ),
                                          onPressed:
                                              () {
                                            showCropDialog(
                                              document:
                                                  doc,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(
                                            Icons
                                                .delete,
                                            color:
                                                Colors
                                                    .red,
                                          ),
                                          onPressed:
                                              () {
                                            deleteCrop(
                                              doc.id,
                                            );
                                          },
                                        ),
                                      ],
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
        ),
      ],
    );
  }
}