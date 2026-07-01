import 'package:flutter/material.dart';
import 'package:crop_survey/models/survey_row_controller.dart';
import 'survey_row_widget.dart';

class SurveyTable extends StatelessWidget {
  final List<SurveyRowController> surveyRows;
  final List<String> crops;

  final VoidCallback onAddSurvey;
  final void Function(int index) onDeleteSurvey;
  final void Function(int index) onCalculate;

  static const double surveyCharge = 200;

 final String selectedPaymentMethod;
  

  const SurveyTable({
    super.key,
    required this.surveyRows,
    required this.crops,
    required this.onAddSurvey,
    required this.onDeleteSurvey,
    required this.onCalculate,
    required this.selectedPaymentMethod,
  });


//String selectedPaymentMethod = "Cash";
  double get totalAmount {
    double total = 0;

    for (final row in surveyRows) {
      total += row.amount + surveyCharge;
    }

    return total;
  }
  
//String selectedPaymentMethod = "Cash";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------
            // Header
            //----------------------------------------------------
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Survey Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Manage survey information for this application",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //----------------------------------------------------
            // Summary Chips
            //----------------------------------------------------
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Chip(
                  avatar: const Icon(Icons.list_alt, size: 18),
                  label: Text("${surveyRows.length} Survey(s)"),
                ),
                Chip(
                  avatar: const Icon(Icons.currency_rupee, size: 18),
                  label: Text("₹ ${totalAmount.toStringAsFixed(2)}"),
                ),
                Chip(
                  avatar: const Icon(Icons.check_circle, size: 18),
                  backgroundColor: Colors.green.shade50,
                  label: const Text("Ready"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //----------------------------------------------------
            // Empty State
            //----------------------------------------------------
            if (surveyRows.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  children: [
                    Icon(
                      Icons.agriculture,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No Survey Added",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Click 'Add Survey' to start entering survey details.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 240,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: onAddSurvey,
                        icon: const Icon(Icons.add),
                        label: const Text("Add First Survey"),
                      ),
                    ),
                  ],
                ),
              )
            //----------------------------------------------------
            // Survey Rows
            //----------------------------------------------------
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(surveyRows.length, (index) {
                    final row = surveyRows[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SurveyRowWidget(
                        index: index,
                        surveyNoController: row.surveyNoController,
                        acreController: row.acreController,
                        gunteController: row.gunteController,
                        subGunteController: row.subGunteController,
                        crop: row.crop,
                        crops: crops,
                        amount: row.amount + surveyCharge,
                        onCropChanged: (value) {
                          row.crop = value!;
                          onCalculate(index);
                        },
                        onDelete: () {
                          onDeleteSurvey(index);
                        },
                        onValueChanged: () {
                          onCalculate(index);
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 4),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: onAddSurvey,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Another Survey",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //--------------------------------------------------
                  // Footer Summary
                  //--------------------------------------------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.analytics,
                            color: Colors.green.shade700,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Survey Summary",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${surveyRows.length} Survey(s) Added",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),

                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Grand Total",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "₹ ${totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 14),

                Text(
  "Payment Method : $selectedPaymentMethod",
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          "Amount is calculated automatically using the selected crop rate and total area.",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
