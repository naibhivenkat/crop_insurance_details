import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateStatusScreen extends StatefulWidget {
  final String? farmerId;

  const UpdateStatusScreen({super.key, this.farmerId});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final mobileController = TextEditingController();

  final ackController = TextEditingController();

  final remarksController = TextEditingController();

  bool loading = true;

  DocumentSnapshot<Map<String, dynamic>>? farmer;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> surveys = [];

  String status = "Pending";

  @override
  void initState() {
    super.initState();

    if (widget.farmerId != null) {
      loadFarmer();
    } else {
      loading = false;
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    ackController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> loadFarmer() async {
    if (widget.farmerId == null) return;

    setState(() {
      loading = true;
    });

    try {
      final farmerDoc = await firestore
          .collection("farmers")
          .doc(widget.farmerId)
          .get();

      if (!farmerDoc.exists) {
        setState(() {
          loading = false;
        });

        return;
      }

      farmer = farmerDoc;

      final data = farmerDoc.data()!;

      status = data["status"] ?? "Pending";

      ackController.text = data["ackNo"] ?? "";

      remarksController.text = data["remarks"] ?? "";

      mobileController.text = data["mobile"] ?? "";

      final surveySnapshot = await firestore
          .collection("surveyDetails")
          .where("farmerId", isEqualTo: widget.farmerId)
          .get();

      surveys = surveySnapshot.docs;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> search() async {
    if (mobileController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final result = await firestore
          .collection("farmers")
          .where("mobile", isEqualTo: mobileController.text.trim())
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Application not found")),
          );
        }

        setState(() {
          loading = false;
        });

        return;
      }

      farmer = result.docs.first;

      final data = farmer!.data()!;

      status = data["status"] ?? "Pending";

      ackController.text = data["ackNo"] ?? "";

      remarksController.text = data["remarks"] ?? "";

      final surveySnapshot = await firestore
          .collection("surveyDetails")
          .where("farmerId", isEqualTo: farmer!.id)
          .get();

      surveys = surveySnapshot.docs;
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> update() async {
    if (farmer == null) return;

    await firestore.collection("farmers").doc(farmer!.id).update({
      "status": status,

      "ackNo": ackController.text.trim(),

      "remarks": remarksController.text.trim(),

      "updatedAt": Timestamp.now(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Application Updated Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = farmer?.data();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: Column(
        children: [
          const AppHeader(
            title: "Update Application",
            subtitle: "Review application and update status",
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// Search Card
                        if (widget.farmerId == null)
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: mobileController,

                                      decoration: const InputDecoration(
                                        labelText: "Search by Mobile Number",

                                        prefixIcon: Icon(Icons.phone),

                                        border: OutlineInputBorder(),
                                      ),

                                      onSubmitted: (_) {
                                        search();
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  FilledButton.icon(
                                    onPressed: search,

                                    icon: const Icon(Icons.search),

                                    label: const Text("Search"),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (widget.farmerId == null) const SizedBox(height: 24),

                        if (farmer == null)
                          Container(
                            height: 500,
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment,
                                  size: 80,
                                  color: Colors.grey,
                                ),

                                SizedBox(height: 20),

                                Text(
                                  "Search an application to continue",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              /// Farmer Information
                              _buildFarmerCard(data),

                              const SizedBox(height: 24),

                              /// Survey Details
                              _buildSurveyCard(),

                              const SizedBox(height: 24),

                              /// Status Update
                              _buildStatusCard(),
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

  Widget _buildFarmerCard(Map<String, dynamic>? data) {
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
                Icon(Icons.person, color: Colors.green),

                SizedBox(width: 10),

                Text(
                  "Farmer Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(height: 30),

            Wrap(
              spacing: 50,
              runSpacing: 25,
              children: [
                _infoTile("SL No", "${data?["slNo"]}", Icons.tag),

                _infoTile(
                  "Farmer Name",
                  data?["name"] ?? "",
                  Icons.person_outline,
                ),

                _infoTile("Mobile", data?["mobile"] ?? "", Icons.phone),

                _infoTile(
                  "Address",
                  data?["address"] ?? "",
                  Icons.location_on_outlined,
                ),

                _infoTile(
                  "Application Date",
                  DateFormat(
                    "dd MMM yyyy",
                  ).format((data?["date"] as Timestamp).toDate()),
                  Icons.calendar_month,
                ),

                _infoTile(
                  "Total Amount",
                  "₹${(data?["totalAmount"] ?? 0).toStringAsFixed(2)}",
                  Icons.currency_rupee,
                ),

                _infoTile(
                  "Current Status",
                  data?["status"] ?? "",
                  Icons.verified,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyCard() {
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
                Icon(Icons.agriculture, color: Colors.green),

                SizedBox(width: 10),

                Text(
                  "Survey Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.green.shade50),

                columnSpacing: 35,

                columns: const [
                  DataColumn(label: Text("Survey No")),

                  DataColumn(label: Text("Crop")),

                  DataColumn(numeric: true, label: Text("Acre")),

                  DataColumn(numeric: true, label: Text("Gunte")),

                  DataColumn(numeric: true, label: Text("Sub Gunte")),

                  DataColumn(numeric: true, label: Text("Amount")),
                ],

                rows: surveys.map((survey) {
                  final d = survey.data();

                  return DataRow(
                    cells: [
                      DataCell(Text(d["surveyNo"])),

                      DataCell(Text(d["crop"])),

                      DataCell(Text("${d["acre"]}")),

                      DataCell(Text("${d["gunte"]}")),

                      DataCell(Text("${d["subGunte"]}")),

                      DataCell(
                        Text(
                          "₹${(d["amount"] as num).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return SizedBox(
      width: 280,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green.shade50,
            child: Icon(icon, size: 18, color: Colors.green),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
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
                Icon(Icons.assignment_turned_in, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  "Application Status",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: status,
                    decoration: InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),

                      DropdownMenuItem(
                        value: "Submitted",
                        child: Text("Submitted"),
                      ),

                      DropdownMenuItem(
                        value: "Approved",
                        child: Text("Approved"),
                      ),

                      DropdownMenuItem(
                        value: "Rejected",
                        child: Text("Rejected"),
                      ),

                      DropdownMenuItem(
                        value: "Payment Released",
                        child: Text("Payment Released"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        status = value;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: TextField(
                    controller: ackController,
                    decoration: InputDecoration(
                      labelText: "Acknowledgement Number",
                      prefixIcon: const Icon(Icons.confirmation_number),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: remarksController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Remarks",
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.notes),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

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

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                  ),
                  onPressed: () async {
                    await update();

                    if (!mounted) return;

                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Update Application"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
