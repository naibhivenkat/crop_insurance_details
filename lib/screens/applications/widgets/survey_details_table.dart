import 'package:flutter/material.dart';

import '../../../models/survey_row_controller.dart';

class SurveyDetailsTable extends StatefulWidget {
  const SurveyDetailsTable({
    super.key,
  });

  @override
  State<SurveyDetailsTable> createState() =>
      _SurveyDetailsTableState();
}

class _SurveyDetailsTableState
    extends State<SurveyDetailsTable> {

  final List<SurveyRowController> rows = [];

  final List<String> crops = const [
    "Arecanut",
    "Pepper",
    "Paddy",
  ];

  @override
  void initState() {
    super.initState();
    addRow();
  }

  @override
  void dispose() {

    for (final row in rows) {
      row.dispose();
    }

    super.dispose();
  }

  void addRow() {

    rows.add(
      SurveyRowController(),
    );

    setState(() {});
  }

  void removeRow(int index) {

    rows[index].dispose();

    rows.removeAt(index);

    setState(() {});
  }

  double getRate(String crop) {

    switch (crop) {

      case "Pepper":
        return 300;

      case "Paddy":
        return 200;

      default:
        return 500;
    }
  }

  void calculate(int index) {

    final row = rows[index];

    final totalGunte =
        (row.acre * 40) +
        row.gunte +
        (row.subGunte / 16);

    row.amount =
        totalGunte *
        getRate(row.crop);

    setState(() {});
  }

  double get totalAmount {

    double total = 0;

    for (final row in rows) {
      total += row.amount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                const Text(

                  "Survey Details",

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Spacer(),

                FilledButton.icon(

                  onPressed: addRow,

                  icon:
                      const Icon(Icons.add),

                  label:
                      const Text(
                    "Add Survey",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(

              scrollDirection:
                  Axis.horizontal,

              child: DataTable(

                headingRowColor:
                    WidgetStateProperty.all(
                  Colors.green.shade50,
                ),

                columns: const [

                  DataColumn(
                    label:
                        Text("Survey No"),
                  ),

                  DataColumn(
                    label:
                        Text("Crop"),
                  ),

                  DataColumn(
                    label:
                        Text("Acre"),
                  ),

                  DataColumn(
                    label:
                        Text("Gunte"),
                  ),

                  DataColumn(
                    label:
                        Text("Sub"),
                  ),

                  DataColumn(
                    label:
                        Text("Amount"),
                  ),

                  DataColumn(
                    label:
                        Text(""),
                  ),
                ],

                rows:
                    List.generate(

                  rows.length,

                  (index) {

                    final row =
                        rows[index];

                    return DataRow(

                      cells: [

                        DataCell(

                          SizedBox(

                            width: 90,

                            child: TextField(

                              controller:
                                  row
                                      .surveyNoController,

                              decoration:
                                  const InputDecoration(
                                isDense:
                                    true,
                              ),
                            ),
                          ),
                        ),

                        DataCell(

                          DropdownButton<String>(

                            value:
                                row.crop,

                            items:
                                crops.map((crop) {

                              return DropdownMenuItem(

                                value:
                                    crop,

                                child:
                                    Text(crop),
                              );

                            }).toList(),

                            onChanged:
                                (value) {

                              row.crop =
                                  value!;

                              calculate(
                                index,
                              );
                            },
                          ),
                        ),

                        DataCell(

                          SizedBox(

                            width: 70,

                            child: TextField(

                              controller:
                                  row
                                      .acreController,

                              keyboardType:
                                  TextInputType.number,

                              onChanged:
                                  (_) {
                                calculate(
                                  index,
                                );
                              },
                            ),
                          ),
                        ),

                        DataCell(

                          SizedBox(

                            width: 70,

                            child: TextField(

                              controller:
                                  row
                                      .gunteController,

                              keyboardType:
                                  TextInputType.number,

                              onChanged:
                                  (_) {
                                calculate(
                                  index,
                                );
                              },
                            ),
                          ),
                        ),

                        DataCell(

                          SizedBox(

                            width: 70,

                            child: TextField(

                              controller:
                                  row
                                      .subGunteController,

                              keyboardType:
                                  TextInputType.number,

                              onChanged:
                                  (_) {
                                calculate(
                                  index,
                                );
                              },
                            ),
                          ),
                        ),

                        DataCell(

                          Text(

                            "₹${row.amount.toStringAsFixed(0)}",
                          ),
                        ),

                        DataCell(

                          IconButton(

                            onPressed: () {

                              if (rows.length ==
                                  1) {
                                return;
                              }

                              removeRow(
                                index,
                              );
                            },

                            icon:
                                const Icon(
                              Icons.delete,
                              color:
                                  Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const Divider(height: 40),

            Align(

              alignment:
                  Alignment.centerRight,

              child: Text(

                "Total Amount : ₹${totalAmount.toStringAsFixed(0)}",

                style: const TextStyle(

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}