// receipt_farmer.dart
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';
import 'pdf_theme.dart';

class ReceiptFarmer extends pw.StatelessWidget {
  final FarmerModel farmer;

  ReceiptFarmer({
    required this.farmer,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Name: ${farmer.name}",
          style: PdfThemeHelper.normal(),
        ),
        pw.Text(
          "Application No: ${farmer.mobile}",
          style: PdfThemeHelper.normal(),
        ),
        pw.Text(
          "Former Id: ${farmer.id}",
          style: PdfThemeHelper.normal(),
        ),
      ],
    );
  }
}