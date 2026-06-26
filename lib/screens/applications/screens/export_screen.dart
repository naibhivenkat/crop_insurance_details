import 'dart:typed_data';

import 'package:crop_survey/features/widgets/app_header.dart';
import 'package:crop_survey/services/excel_export_service.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool exporting = false;

  Future<void> exportExcel() async {
    setState(() {
      exporting = true;
    });

    try {
      final Excel excel = await ExcelExportService.instance.buildWorkbook();

      final List<int>? bytes = excel.encode();

      if (bytes == null) {
        throw Exception("Failed to generate Excel file.");
      }

      await FileSaver.instance.saveFile(
        name: "Crop_Insurance_Report_${DateTime.now().millisecondsSinceEpoch}",
        bytes: Uint8List.fromList(bytes),
        ext: "xlsx",
        mimeType: MimeType.microsoftExcel,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Excel exported successfully.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          exporting = false;
        });
      }
    }
  }

  Widget exportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            CircleAvatar(
              radius: 34,

              backgroundColor: color..withValues(alpha: 0.15),

              child: Icon(icon, size: 34, color: color),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(subtitle, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: exporting ? null : onPressed,

              icon: const Icon(Icons.download),

              label: const Text("Export"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: "Export Excel", subtitle: "Download Reports"),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Wrap(
              spacing: 20,

              runSpacing: 20,

              children: [
                SizedBox(
                  width: 340,
                  child: exportCard(
                    icon: Icons.people,

                    title: "Farmers",

                    subtitle: "Export all farmer records",

                    color: Colors.green,

                    onPressed: exportExcel,
                  ),
                ),

                SizedBox(
                  width: 340,
                  child: exportCard(
                    icon: Icons.grass,

                    title: "Survey Details",

                    subtitle: "Export all survey details",

                    color: Colors.orange,

                    onPressed: exportExcel,
                  ),
                ),

                SizedBox(
                  width: 340,
                  child: exportCard(
                    icon: Icons.table_chart,

                    title: "Complete Report",

                    subtitle: "Export Farmers + Surveys + Summary",

                    color: Colors.blue,

                    onPressed: exportExcel,
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
