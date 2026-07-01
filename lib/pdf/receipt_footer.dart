// receipt_footer.dart
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';
import 'pdf_theme.dart';

class ReceiptFooter extends pw.StatelessWidget {
  final FarmerModel farmer;

  ReceiptFooter({
    required this.farmer,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      "TOTAL ₹${farmer.totalAmount.toStringAsFixed(2)}",
      style: PdfThemeHelper.normal(bold: true),
    );
  }
}