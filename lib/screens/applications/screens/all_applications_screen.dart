import 'package:crop_survey/models/farmer_model.dart';
import 'package:crop_survey/screens/applications/screens/edit_application_screen.dart';
import 'package:crop_survey/screens/applications/screens/update_status_screen.dart';
import 'package:crop_survey/screens/applications/screens/view_application_screen.dart';
import 'package:crop_survey/screens/applications/widgets/delete_application_dialog.dart';
import 'package:crop_survey/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AllApplicationsScreen extends StatefulWidget {
  const AllApplicationsScreen({super.key});

  @override
  State<AllApplicationsScreen> createState() => _AllApplicationsScreenState();
}

class _AllApplicationsScreenState extends State<AllApplicationsScreen> {
  final FirestoreService firestore = FirestoreService.instance;

  final TextEditingController searchController = TextEditingController();

  List<FarmerModel> allFarmers = [];
  List<FarmerModel> filteredFarmers = [];

  bool loading = true;

  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadApplications() async {
    setState(() {
      loading = true;
    });

    final farmers = await firestore.getAllFarmers();

    setState(() {
      allFarmers = farmers;
      filteredFarmers = farmers;
      loading = false;
    });
  }

  void filterApplications() {
    final keyword = searchController.text.toLowerCase();

    filteredFarmers = allFarmers.where((farmer) {
      final matchesSearch =
          farmer.name.toLowerCase().contains(keyword) ||
          farmer.mobile.contains(keyword) ||
          farmer.slNo.toString().contains(keyword);

      final matchesStatus =
          selectedStatus == "All" || farmer.status == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    setState(() {});
  }

  Color statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Pending":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "All Applications",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      _summaryCard(
                        "Total",
                        allFarmers.length.toString(),
                        Colors.blue,
                        Icons.description,
                      ),

                      const SizedBox(width: 15),

                      _summaryCard(
                        "Pending",
                        allFarmers
                            .where((e) => e.status == "Pending")
                            .length
                            .toString(),
                        Colors.orange,
                        Icons.pending_actions,
                      ),

                      const SizedBox(width: 15),

                      _summaryCard(
                        "Approved",
                        allFarmers
                            .where((e) => e.status == "Approved")
                            .length
                            .toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),

                      const SizedBox(width: 15),

                      _summaryCard(
                        "Rejected",
                        allFarmers
                            .where((e) => e.status == "Rejected")
                            .length
                            .toString(),
                        Colors.red,
                        Icons.cancel,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,

                          onChanged: (_) => filterApplications(),

                          decoration: InputDecoration(
                            hintText: "Search farmer / mobile / SL No",

                            prefixIcon: const Icon(Icons.search),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      SizedBox(
                        width: 180,

                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          items: const [
                            DropdownMenuItem(value: "All", child: Text("All")),

                            DropdownMenuItem(
                              value: "Pending",
                              child: Text("Pending"),
                            ),

                            DropdownMenuItem(
                              value: "Approved",
                              child: Text("Approved"),
                            ),

                            DropdownMenuItem(
                              value: "Rejected",
                              child: Text("Rejected"),
                            ),
                          ],

                          onChanged: (value) {
                            selectedStatus = value!;

                            filterApplications();
                          },
                        ),
                      ),

                      const SizedBox(width: 15),

                      FilledButton.icon(
                        onPressed: loadApplications,

                        icon: const Icon(Icons.refresh),

                        label: const Text("Refresh"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: Card(
                      elevation: 3,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: filteredFarmers.isEmpty
                          ? const Center(
                              child: Text(
                                "No Applications Found",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,

                              child: SingleChildScrollView(
                                child: DataTable(
                                  headingRowHeight: 56,
                                  dataRowMinHeight: 60,
                                  dataRowMaxHeight: 60,
                                  columnSpacing: 30,
                                  horizontalMargin: 20,

                                  headingRowColor: WidgetStateProperty.all(
                                    Colors.green.shade50,
                                  ),

                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        "SL No",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        "Farmer Name",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        "Mobile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        "Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      numeric: true,
                                      label: Text(
                                        "Amount",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    DataColumn(
                                      label: Text(
                                        "Actions",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],

                                  rows: filteredFarmers.map((farmer) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            farmer.slNo.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        DataCell(Text(farmer.name)),

                                        DataCell(Text(farmer.mobile)),

                                        DataCell(
                                          Text(
                                            farmer.date
                                                .toDate()
                                                .toString()
                                                .split(" ")
                                                .first,
                                          ),
                                        ),

                                        DataCell(
                                          Text(
                                            "₹ ${farmer.totalAmount.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor(
                                                farmer.status,
                                              ).withAlpha(38),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              farmer.status,
                                              style: TextStyle(
                                                color: statusColor(
                                                  farmer.status,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // DataCell(
                                        //   Row(
                                        //     children: [
                                        //       Tooltip(
                                        //         message: "View",
                                        //         child: IconButton(
                                        //           icon: const Icon(
                                        //             Icons.visibility,
                                        //             color: Colors.blue,
                                        //           ),
                                        //           onPressed: () {
                                        //             Navigator.of(context).push(
                                        //               MaterialPageRoute(
                                        //                 builder: (_) =>
                                        //                     ViewApplicationScreen(
                                        //                       farmerId:
                                        //                           farmer.id,
                                        //                     ),
                                        //               ),
                                        //             );
                                        //           },
                                        //         ),
                                        //       ),

                                        //       Tooltip(
                                        //         message: "Update Status",
                                        //         child: IconButton(
                                        //           icon: const Icon(
                                        //             Icons.edit,
                                        //             color: Colors.orange,
                                        //           ),
                                        //           onPressed: () {
                                        //             Navigator.of(context).push(
                                        //               MaterialPageRoute(
                                        //                 builder: (_) =>
                                        //                     UpdateStatusScreen(
                                        //                       //  farmerId:
                                        //                       //      farmer.id,
                                        //                     ),
                                        //               ),
                                        //             );
                                        //           },
                                        //         ),
                                        //       ),

                                        //       Tooltip(
                                        //         message: "Delete",
                                        //         child: IconButton(
                                        //           icon: const Icon(
                                        //             Icons.delete,
                                        //             color: Colors.red,
                                        //           ),
                                        //           onPressed: () async {
                                        //             final deleted =
                                        //                 await showDialog<bool>(
                                        //                   context: context,
                                        //                   builder: (_) =>
                                        //                       DeleteApplicationDialog(
                                        //                         farmerId:
                                        //                             farmer.id,

                                        //                         farmerName:
                                        //                             farmer.name,
                                        //                       ),
                                        //                 );

                                        //             if (deleted == true) {
                                        //               loadApplications();
                                        //             }
                                        //           },
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),

                                        DataCell(
  Row(
    children: [

      /// VIEW
      Tooltip(
        message: "View",
        child: IconButton(
          icon: const Icon(
            Icons.visibility,
            color: Colors.blue,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewApplicationScreen(
                  farmerId: farmer.id,
                ),
              ),
            );

            loadApplications();
          },
        ),
      ),

      /// EDIT
      Tooltip(
        message: "Edit Application",
        child: IconButton(
          icon: const Icon(
            Icons.edit_document,
            color: Colors.green,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditApplicationScreen(
                  farmerId: farmer.id,
                ),
              ),
            );

            loadApplications();
          },
        ),
      ),

      /// UPDATE STATUS
      Tooltip(
        message: "Update Status",
        child: IconButton(
          icon: const Icon(
            Icons.assignment_turned_in,
            color: Colors.orange,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateStatusScreen(
                  farmerId: farmer.id,
                ),
              ),
            );

            loadApplications();
          },
        ),
      ),

      /// DELETE
      Tooltip(
        message: "Delete",
        child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            final deleted =
                await showDialog<bool>(
              context: context,
              builder: (_) => DeleteApplicationDialog(
                farmerId: farmer.id,
                farmerName: farmer.name,
              ),
            );

            if (deleted == true) {
              loadApplications();
            }
          },
        ),
      ),
    ],
  ),
),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _summaryCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(title, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
