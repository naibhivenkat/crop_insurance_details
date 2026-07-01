// receipt_header.dart
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';
import 'pdf_theme.dart';

class ReceiptHeader extends pw.StatelessWidget {
  final FarmerModel farmer;

  ReceiptHeader({
    required this.farmer,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            "Crop Insurance - Average Proposal",
            style: PdfThemeHelper.header(),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          "Receipt No: ${farmer.ackNo}",
          style: PdfThemeHelper.normal(),
        ),
         pw.Text(
          "Payment Method: ${farmer.paymentMethod}",
          style: PdfThemeHelper.normal(),
        ),
        pw.Text(
          "Serial No: ${farmer.slNo}",
          style: PdfThemeHelper.normal(),
        ),
          pw.Text(
          "Mobile No: ${farmer.mobile}",
          style: PdfThemeHelper.normal(),
        ),
        pw.Text(
          "Date: ${DateFormat("dd MMM yyyy").format(farmer.date.toDate())}",
          style: PdfThemeHelper.normal(),
        ),
      ],
    );
  }
}