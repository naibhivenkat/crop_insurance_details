// pdf_theme.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfThemeHelper {
  PdfThemeHelper._();

  static pw.TextStyle header() {
    return pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
  }

  static pw.TextStyle normal({bool bold = false}) {
    return pw.TextStyle(
      fontSize: 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: PdfColors.black,
    );
  }
}