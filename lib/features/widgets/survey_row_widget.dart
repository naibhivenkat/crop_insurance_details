import 'package:flutter/material.dart';

class SurveyRowWidget extends StatelessWidget {
  final int index;

  final TextEditingController surveyNoController;

  final TextEditingController acreController;

  final TextEditingController gunteController;

  final TextEditingController subGunteController;

  final String crop;

  final List<String> crops;

  final double amount;

  final ValueChanged<String?> onCropChanged;

  final VoidCallback onDelete;

  final VoidCallback onValueChanged;

  const SurveyRowWidget({
    super.key,
    required this.index,
    required this.surveyNoController,
    required this.acreController,
    required this.gunteController,
    required this.subGunteController,
    required this.crop,
    required this.crops,
    required this.amount,
    required this.onCropChanged,
    required this.onDelete,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Row(
              children: [

                Text(
                  "Survey ${index + 1}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const Spacer(),

                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Expanded(
                  flex: 2,
                  child: TextField(
                    controller:
                        surveyNoController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Survey No",
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child:
                      DropdownButtonFormField<
                          String>(
                    value: crop,

                    items: crops
                        .map(
                          (e) =>
                              DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),

                    onChanged: onCropChanged,

                    decoration:
                        const InputDecoration(
                      labelText: "Crop",
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller:
                        acreController,
                    keyboardType:
                        TextInputType.number,

                    decoration:
                        const InputDecoration(
                      labelText: "Acre",
                    ),

                    onChanged: (_) =>
                        onValueChanged(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller:
                        gunteController,
                    keyboardType:
                        TextInputType.number,

                    decoration:
                        const InputDecoration(
                      labelText: "Gunte",
                    ),

                    onChanged: (_) =>
                        onValueChanged(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller:
                        subGunteController,
                    keyboardType:
                        TextInputType.number,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Sub Gunte",
                    ),

                    onChanged: (_) =>
                        onValueChanged(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Align(
              alignment:
                  Alignment.centerRight,

              child: Text(
                "Amount : ₹ ${amount.toStringAsFixed(2)}",

                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}