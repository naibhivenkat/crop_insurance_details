import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:crop_survey/screens/applications/screens/edit_application_screen.dart';
import 'package:crop_survey/screens/applications/screens/view_application_screen.dart';
import 'package:crop_survey/screens/applications/widgets/delete_application_dialog.dart';
import 'package:crop_survey/services/search_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  final SearchService searchService = SearchService.instance;

  String selectedField = "mobile";

  bool loading = false;

  List<Map<String, dynamic>> results = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> search() async {
    setState(() {
      loading = true;
    });

    results = await searchService.search(
      field: selectedField,
      value: searchController.text,
    );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(
          title: "Search Applications",
          subtitle: "Search Farmer Applications",
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Row(
                      children: [
                        SizedBox(
                          width: 220,
                          child: DropdownButtonFormField<String>(
                            value: selectedField,
                            decoration: const InputDecoration(
                              labelText: "Search By",
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "mobile",
                                child: Text("Mobile"),
                              ),

                              DropdownMenuItem(
                                value: "name",
                                child: Text("Farmer Name"),
                              ),

                              DropdownMenuItem(
                                value: "surveyNo",
                                child: Text("Survey No"),
                              ),

                              DropdownMenuItem(
                                value: "ackNo",
                                child: Text("ACK No"),
                              ),

                              DropdownMenuItem(
                                value: "status",
                                child: Text("Status"),
                              ),
                            ],
                            onChanged: (v) {
                              setState(() {
                                selectedField = v!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (_) => search(),
                            decoration: const InputDecoration(
                              hintText: "Enter value...",
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        FilledButton.icon(
                          onPressed: loading ? null : search,
                          icon: const Icon(Icons.search),
                          label: const Text("Search"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Card(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : results.isEmpty
                        ? const Center(
                            child: Text(
                              "No Applications Found",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Sl No")),

                                DataColumn(label: Text("Name")),

                                DataColumn(label: Text("Mobile")),

                                DataColumn(label: Text("Status")),

                                DataColumn(label: Text("Amount")),

                                DataColumn(label: Text("Actions")),
                              ],

                              rows: results.map((data) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text("${data["slNo"] ?? ""}")),

                                    DataCell(Text(data["name"] ?? "")),

                                    DataCell(Text(data["mobile"] ?? "")),

                                    DataCell(
                                      Chip(
                                        label: Text(
                                          data["status"] ?? "Pending",
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Text("₹${data["totalAmount"] ?? 0}"),
                                    ),

                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            tooltip: "View",
                                            icon: const Icon(
                                              Icons.visibility,
                                              color: Colors.blue,
                                            ),

                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ViewApplicationScreen(
                                                        farmerId:
                                                            data["documentId"],
                                                      ),
                                                ),
                                              );
                                            },
                                          ),

                                          IconButton(
                                            tooltip: "Edit",
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditApplicationScreen(
                                                        farmerId:
                                                            data["documentId"],
                                                      ),
                                                ),
                                              );
                                            },
                                          ),

                                          IconButton(
                                            tooltip: "Delete",
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              final deleted =
                                                  await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) =>
                                                        DeleteApplicationDialog(
                                                          farmerId:
                                                              data["documentId"],
                                                          farmerName:
                                                              data["name"] ??
                                                              "",
                                                        ),
                                                  );

                                              if (deleted == true) {
                                                search();
                                              }
                                            },
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
