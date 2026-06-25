import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int surveyCount;
  final double totalAmount;

  const SummaryCard({
    super.key,
    this.surveyCount = 0,
    this.totalAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(
                  Icons.description,
                  color: Colors.green,
                ),
                title: const Text("Survey Entries"),
                subtitle: Text(
                  surveyCount.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                  color: Colors.blue,
                ),
                title: const Text("Total Amount"),
                subtitle: Text(
                  "₹${totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}