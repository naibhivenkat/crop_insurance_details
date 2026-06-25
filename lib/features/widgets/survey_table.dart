import 'package:crop_survey/models/survey_row_controller.dart';
import 'package:flutter/material.dart';


import 'survey_row_widget.dart';

class SurveyTable extends StatelessWidget {
  final List<SurveyRowController> surveyRows;

  final List<String> crops;

  final VoidCallback onAddSurvey;

  final void Function(int index) onDeleteSurvey;

  final void Function(int index) onCalculate;

  const SurveyTable({
    super.key,
    required this.surveyRows,
    required this.crops,
    required this.onAddSurvey,
    required this.onDeleteSurvey,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Text(
                  "Survey Details",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: onAddSurvey,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Add Survey",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (surveyRows.isEmpty)

              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    "No Survey Added",
                  ),
                ),
              )

            else

              ...List.generate(
                surveyRows.length,
                (index) {

                  final row =
                      surveyRows[index];

                  return SurveyRowWidget(
                    index: index,

                    surveyNoController:
                        row.surveyNoController,

                    acreController:
                        row.acreController,

                    gunteController:
                        row.gunteController,

                    subGunteController:
                        row.subGunteController,

                    crop: row.crop,

                    crops: crops,

                    amount: row.amount,

                    onCropChanged:
                        (value) {

                      row.crop =
                          value!;

                      onCalculate(
                        index,
                      );
                    },

                    onDelete: () {
                      onDeleteSurvey(
                        index,
                      );
                    },

                    onValueChanged: () {
                      onCalculate(
                        index,
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}