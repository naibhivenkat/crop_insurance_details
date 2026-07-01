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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------------------------------------
          // Header
          //----------------------------------------------------------
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green.shade50,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  "Survey ${index + 1}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Tooltip(
                message: "Delete Survey",
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  splashRadius: 20,
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: crop,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Crop",
                    prefixIcon: const Icon(Icons.grass),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: crops
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onCropChanged,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _numberField(
                  acreController,
                  "Acre",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _numberField(
                  gunteController,
                  "Gunte",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _numberField(
                  subGunteController,
                  "Sub Gunte",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),

          const SizedBox(height: 12),

          //----------------------------------------------------------
          // Compact Amount Row
          //----------------------------------------------------------
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 20,
                color: Colors.green.shade700,
              ),

              const SizedBox(width: 8),

              Text(
                "Calculated Amount",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              Text(
                "₹ ${amount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Divider(
            color: Colors.grey.shade300,
            height: 1,
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
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      textAlign: TextAlign.center,
      onChanged: (_) => onValueChanged(),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}