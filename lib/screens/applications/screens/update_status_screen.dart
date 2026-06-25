import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:flutter/material.dart';

class UpdateStatusScreen extends StatefulWidget {
  const UpdateStatusScreen({super.key});

  @override
  State<UpdateStatusScreen> createState() =>
      _UpdateStatusScreenState();
}

class _UpdateStatusScreenState
    extends State<UpdateStatusScreen> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final mobileController =
      TextEditingController();

  final ackController =
      TextEditingController();

  final remarksController =
      TextEditingController();

  bool loading = false;

  DocumentSnapshot<Map<String, dynamic>>? farmer;

  String status = "Pending";

  Future<void> search() async {
    setState(() {
      loading = true;
      farmer = null;
    });

    try {
      final snapshot = await firestore
          .collection("farmers")
          .where(
            "mobile",
            isEqualTo: mobileController.text.trim(),
          )
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        farmer = snapshot.docs.first;

        final data = farmer!.data()!;

        status =
            (data["status"] as String?) ??
                "Pending";

        ackController.text =
            (data["ackNo"] as String?) ??
                "";

        remarksController.text =
            (data["remarks"] as String?) ??
                "";
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                "Farmer not found",
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> update() async {
    if (farmer == null) return;

    await firestore
        .collection("farmers")
        .doc(farmer!.id)
        .update({
      "status": status,
      "ackNo": ackController.text.trim(),
      "remarks":
          remarksController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Application Updated Successfully",
        ),
      ),
    );
  }

  @override
  void dispose() {
    mobileController.dispose();
    ackController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = farmer?.data();

    return Column(
      children: [
        const AppHeader(
          title: "Update Status",
          subtitle:
              "Update Farmer Application Status",
        ),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                mobileController,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Mobile Number",
                              prefixIcon:
                                  Icon(Icons.phone),
                            ),
                            onSubmitted:
                                (_) => search(),
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        FilledButton.icon(
                          onPressed:
                              loading
                                  ? null
                                  : search,
                          icon:
                              const Icon(
                                  Icons.search),
                          label:
                              const Text(
                                  "Search"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                if (loading)
                  const Expanded(
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  )
                else if (farmer == null)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Search an Application",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                24),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              data?["name"] ??
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
                                height: 8),

                            Text(
                              data?["mobile"] ??
                                  "",
                            ),

                            Text(
                              data?["address"] ??
                                  "",
                            ),

                            const SizedBox(
                                height: 30),

                            DropdownButtonFormField<
                                String>(
                              value: status,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    "Application Status",
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value:
                                      "Pending",
                                  child: Text(
                                      "Pending"),
                                ),
                                DropdownMenuItem(
                                  value:
                                      "Submitted",
                                  child: Text(
                                      "Submitted"),
                                ),
                                DropdownMenuItem(
                                  value:
                                      "Approved",
                                  child: Text(
                                      "Approved"),
                                ),
                                DropdownMenuItem(
                                  value:
                                      "Rejected",
                                  child: Text(
                                      "Rejected"),
                                ),
                                DropdownMenuItem(
                                  value:
                                      "Payment Released",
                                  child: Text(
                                      "Payment Released"),
                                ),
                              ],
                              onChanged: (value) {
                                if (value ==
                                    null) return;

                                setState(() {
                                  status =
                                      value;
                                });
                              },
                            ),

                            const SizedBox(
                                height: 20),

                            TextField(
                              controller:
                                  ackController,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    "Acknowledgement Number",
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            TextField(
                              controller:
                                  remarksController,
                              maxLines: 4,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    "Remarks",
                              ),
                            ),

                            const Spacer(),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,
                              child:
                                  FilledButton.icon(
                                onPressed:
                                    update,
                                icon:
                                    const Icon(
                                        Icons
                                            .save),
                                label:
                                    const Text(
                                        "Update"),
                              ),
                            ),
                          ],
                        ),
                      ),
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