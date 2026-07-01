import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../features/widgets/app_header.dart';
import '../../../features/widgets/farmer_information_card.dart';
import '../../../features/widgets/save_button.dart';
import '../../../features/widgets/survey_table.dart';
import '../../../features/widgets/total_amount_card.dart';

import '../../../models/survey_row_controller.dart';
import '../../../services/firestore_service.dart';

class EditApplicationScreen extends StatefulWidget {
  final String farmerId;

  const EditApplicationScreen({super.key, required this.farmerId});

  @override
  State<EditApplicationScreen> createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  final FirestoreService firestore = FirestoreService.instance;

  bool loading = true;
  bool saving = false;

  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final mobileController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  final List<SurveyRowController> surveyRows = [];

  final List<String> crops = [];

  final Map<String, double> cropRates = {};

  String currentStatus = "Pending";

  String ackNo = "";

  String remarks = "";

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();

    for (final row in surveyRows) {
      row.dispose();
    }

    super.dispose();
  }

  Future<void> _loadScreen() async {
    setState(() {
      loading = true;
    });

    await _loadCropRates();

    await _loadFarmer();

    await _loadSurveyRows();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _loadCropRates() async {
    final rates = await firestore.getCropRates();

    cropRates.clear();
    crops.clear();

    for (final rate in rates) {
      cropRates[rate.crop] = rate.ratePerGunte;

      crops.add(rate.crop);
    }
  }

  Future<void> _loadFarmer() async {
    final doc = await FirebaseFirestore.instance
        .collection("farmers")
        .doc(widget.farmerId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    nameController.text = data["name"] ?? "";

    addressController.text = data["address"] ?? "";

    mobileController.text = data["mobile"] ?? "";

    currentStatus = data["status"] ?? "Pending";

    ackNo = data["ackNo"] ?? "";

    remarks = data["remarks"] ?? "";

    final ts = data["date"] as Timestamp?;

    if (ts != null) {
      selectedDate = ts.toDate();
    }
  }

  Future<void> _loadSurveyRows() async {
    surveyRows.clear();

    final snapshot = await FirebaseFirestore.instance
        .collection("surveyDetails")
        .where("farmerId", isEqualTo: widget.farmerId)
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final row = SurveyRowController(
        surveyNo: data["surveyNo"] ?? "",
        crop: data["crop"] ?? crops.first,
      );

      row.acreController.text = "${data["acre"] ?? 0}";

      row.gunteController.text = "${data["gunte"] ?? 0}";

      row.subGunteController.text = "${data["subGunte"] ?? 0}";

      row.amount = (data["amount"] ?? 0).toDouble();

      surveyRows.add(row);
    }
  }

  void addSurvey() {
    surveyRows.add(SurveyRowController(crop: crops.first));

    setState(() {});
  }

  void removeSurvey(int index) {
    surveyRows[index].dispose();

    surveyRows.removeAt(index);

    setState(() {});
  }

  double getRate(String crop) {
    return cropRates[crop] ?? 0;
  }

  void calculateRow(int index) {
    final row = surveyRows[index];

    final totalGunte = (row.acre * 40) + row.gunte + (row.subGunte / 16);

    row.amount = totalGunte * getRate(row.crop);

    setState(() {});
  }

  double get totalAmount {
    double total = 0;

    for (final row in surveyRows) {
      total += row.amount;
    }

    return total;
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: selectedDate,
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: Column(
        children: [
          const AppHeader(
            title: "Edit Application",
            subtitle: "Modify Farmer Survey Details",
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  //-------------------------------------------------
                  // Farmer + Summary
                  //-------------------------------------------------
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final desktop = constraints.maxWidth > 950;

                      if (desktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: FarmerInformationCard(
                                    nameController: nameController,
                                    addressController: addressController,
                                    mobileController: mobileController,
                                    selectedDate: selectedDate,
                                    onSelectDate: pickDate,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(child: _buildSummaryCard()),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: FarmerInformationCard(
                                nameController: nameController,
                                addressController: addressController,
                                mobileController: mobileController,
                                selectedDate: selectedDate,
                                onSelectDate: pickDate,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildSummaryCard(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  //-------------------------------------------------
                  // Survey Details
                  //-------------------------------------------------
                  Card(
                    elevation: 2,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.agriculture,
                                color: Colors.green,
                              ),

                              const SizedBox(width: 10),

                              const Text(
                                "Survey Details",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Spacer(),

                              FilledButton.icon(
                                onPressed: addSurvey,

                                icon: const Icon(Icons.add),

                                label: const Text("Add Survey"),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          SurveyTable(
                            surveyRows: surveyRows,

                            crops: crops,

                            onAddSurvey: addSurvey,

                            onDeleteSurvey: removeSurvey,

                            onCalculate: calculateRow,
                            selectedPaymentMethod: "Cash"
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //-------------------------------------------------
                  // Total
                  //-------------------------------------------------
                  TotalAmountCard(
                    totalAmount: totalAmount,

                    surveyCount: surveyRows.length,
                  ),

                  const SizedBox(height: 30),

                  //-------------------------------------------------
                  // Bottom Buttons
                  //-------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(Icons.close),

                        label: const Text("Cancel"),
                      ),

                      const SizedBox(width: 15),

                      OutlinedButton.icon(
                        onPressed: _loadScreen,

                        icon: const Icon(Icons.refresh),

                        label: const Text("Reset"),
                      ),

                      const SizedBox(width: 15),

                      SizedBox(
                        width: 220,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: saving ? null : updateApplication,
                          icon: saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            saving ? "Updating..." : "Update Application",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.green),

                SizedBox(width: 10),

                Text(
                  "Application Summary",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(height: 30),

            _summaryTile(
              Icons.badge_outlined,
              "Application ID",
              widget.farmerId,
              Colors.blue,
            ),

            const SizedBox(height: 18),

            _summaryTile(
              Icons.pending_actions,
              "Current Status",
              currentStatus,
              _statusColor(currentStatus),
            ),

            const SizedBox(height: 18),

            _summaryTile(
              Icons.list_alt,
              "Survey Count",
              "${surveyRows.length}",
              Colors.deepPurple,
            ),

            const SizedBox(height: 18),

            _summaryTile(
              Icons.currency_rupee,
              "Total Amount",
              "₹ ${totalAmount.toStringAsFixed(2)}",
              Colors.green,
            ),

            const SizedBox(height: 18),

            _summaryTile(
              Icons.calendar_today,
              "Survey Date",
              "${selectedDate.day.toString().padLeft(2, '0')}/"
                  "${selectedDate.month.toString().padLeft(2, '0')}/"
                  "${selectedDate.year}",
              Colors.orange,
            ),

            const SizedBox(height: 18),

            _summaryTile(
              Icons.phone_android,
              "Mobile",
              mobileController.text,
              Colors.teal,
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusColor(currentStatus).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _statusColor(currentStatus)),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      _statusMessage(currentStatus),
                      style: TextStyle(
                        color: _statusColor(currentStatus),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Submitted":
        return Colors.blue;

      case "Payment Released":
        return Colors.purple;

      default:
        return Colors.orange;
    }
  }

  String _statusMessage(String status) {
    switch (status) {
      case "Pending":
        return "This application is waiting for verification.";

      case "Submitted":
        return "Application has been submitted for approval.";

      case "Approved":
        return "Application has been approved.";

      case "Rejected":
        return "Application has been rejected.";

      case "Payment Released":
        return "Payment has been released successfully.";

      default:
        return "";
    }
  }

  Future<void> updateApplication() async {
    if (saving) return;

    setState(() {
      saving = true;
    });

    try {
      final db = FirebaseFirestore.instance;

      final batch = db.batch();

      //----------------------------------------------------------
      // Update Farmer
      //----------------------------------------------------------

      final farmerRef = db.collection("farmers").doc(widget.farmerId);

      batch.update(farmerRef, {
        "name": nameController.text.trim(),
        "address": addressController.text.trim(),
        "mobile": mobileController.text.trim(),
        "date": Timestamp.fromDate(selectedDate),
        "totalAmount": totalAmount,
        "updatedAt": Timestamp.now(),
      });

      //----------------------------------------------------------
      // Delete Old Survey Rows
      //----------------------------------------------------------

      final oldRows = await db
          .collection("surveyDetails")
          .where("farmerId", isEqualTo: widget.farmerId)
          .get();

      for (final row in oldRows.docs) {
        batch.delete(row.reference);
      }

      //----------------------------------------------------------
      // Save New Survey Rows
      //----------------------------------------------------------

      for (final row in surveyRows) {
        final detailRef = db.collection("surveyDetails").doc();

        batch.set(detailRef, {
          "detailId": detailRef.id,
          "farmerId": widget.farmerId,
          "surveyNo": row.surveyNoController.text.trim(),
          "crop": row.crop,
          "acre": row.acre,
          "gunte": row.gunte,
          "subGunte": row.subGunte,
          "amount": row.amount,
        });
      }

      await batch.commit();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("Success"),
              ],
            ),
            content: const Text("Application updated successfully."),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }
}
