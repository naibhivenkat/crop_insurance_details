// import 'package:flutter/material.dart';

// class SurveyRowWidget extends StatelessWidget {
//   final int index;

//   final TextEditingController surveyNoController;

//   final TextEditingController acreController;

//   final TextEditingController gunteController;

//   final TextEditingController subGunteController;

//   final String crop;

//   final List<String> crops;

//   final double amount;

//   final ValueChanged<String?> onCropChanged;

//   final VoidCallback onDelete;

//   final VoidCallback onValueChanged;

//   const SurveyRowWidget({
//     super.key,
//     required this.index,
//     required this.surveyNoController,
//     required this.acreController,
//     required this.gunteController,
//     required this.subGunteController,
//     required this.crop,
//     required this.crops,
//     required this.amount,
//     required this.onCropChanged,
//     required this.onDelete,
//     required this.onValueChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),

//       child: Padding(
//         padding: const EdgeInsets.all(16),

//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "Survey ${index + 1}",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),

//                 const Spacer(),

//                 IconButton(
//                   onPressed: onDelete,
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     controller: surveyNoController,
//                     decoration: const InputDecoration(labelText: "Survey No"),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   flex: 2,
//                   child: DropdownButtonFormField<String>(
//                     value: crop,

//                     items: crops
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),

//                     onChanged: onCropChanged,

//                     decoration: const InputDecoration(labelText: "Crop"),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: TextField(
//                     controller: acreController,
//                     keyboardType: TextInputType.number,

//                     decoration: const InputDecoration(labelText: "Acre"),

//                     onChanged: (_) => onValueChanged(),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: TextField(
//                     controller: gunteController,
//                     keyboardType: TextInputType.number,

//                     decoration: const InputDecoration(labelText: "Gunte"),

//                     onChanged: (_) => onValueChanged(),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: TextField(
//                     controller: subGunteController,
//                     keyboardType: TextInputType.number,

//                     decoration: const InputDecoration(labelText: "Sub Gunte"),

//                     onChanged: (_) => onValueChanged(),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             Align(
//               alignment: Alignment.centerRight,

//               child: Text(
//                 "Amount : ₹ ${amount.toStringAsFixed(2)}",

//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      padding: const EdgeInsets.all(20),

      child: Column(
        children: [

          //----------------------------------------------------------
          // Header
          //----------------------------------------------------------

          Row(
            children: [

              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green.shade50,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "Survey ${index + 1}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Tooltip(
                message: "Delete Survey",
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------------
          // Input Row
          //----------------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 2,
                child: _textField(
                  controller: surveyNoController,
                  label: "Survey No",
                  icon: Icons.tag,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: crop,

                  isExpanded: true,

                  decoration: InputDecoration(
                    labelText: "Crop",
                    prefixIcon:
                        const Icon(Icons.grass),

                    filled: true,
                    fillColor:
                        Colors.grey.shade50,

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),

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
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _numberField(
                  acreController,
                  "Acre",
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _numberField(
                  gunteController,
                  "Gunte",
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _numberField(
                  subGunteController,
                  "Sub Gunte",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
                    //----------------------------------------------------------
          // Amount Card
          //----------------------------------------------------------

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.green.shade200,
              ),
            ),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.currency_rupee,
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(width: 14),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Calculated Amount",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "₹ ${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Icon(
                  Icons.calculate,
                  color: Colors.green.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => onValueChanged(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(
        decimal: true,
      ),
      onChanged: (_) => onValueChanged(),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}