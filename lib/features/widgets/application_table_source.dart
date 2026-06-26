import 'package:crop_survey/models/farmer_model.dart';
import 'package:flutter/material.dart';

class ApplicationTableSource extends DataTableSource {
  ApplicationTableSource({
    required this.farmers,
    required this.onView,
    required this.onEditStatus,
    required this.onDelete,
  });

  final List<FarmerModel> farmers;

  final void Function(FarmerModel farmer) onView;
  final void Function(FarmerModel farmer) onEditStatus;
  final void Function(FarmerModel farmer) onDelete;

  Color _statusColor(String status) {
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
  DataRow getRow(int index) {
    final farmer = farmers[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(farmer.slNo.toString())),

        DataCell(
          Text(
            farmer.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

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
            "₹${farmer.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        DataCell(
          Chip(
            label: Text(farmer.status),
            backgroundColor:
                _statusColor(farmer.status).withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: _statusColor(farmer.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        DataCell(
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "view":
                  onView(farmer);
                  break;

                case "status":
                  onEditStatus(farmer);
                  break;

                case "delete":
                  onDelete(farmer);
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: "view",
                child: Text("View"),
              ),
              PopupMenuItem(
                value: "status",
                child: Text("Update Status"),
              ),
              PopupMenuItem(
                value: "delete",
                child: Text("Delete"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => farmers.length;

  @override
  int get selectedRowCount => 0;
}