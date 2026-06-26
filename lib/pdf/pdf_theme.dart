import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfThemeHelper {
  PdfThemeHelper._();

  //==========================
  // Colors
  //==========================

  static const PdfColor primary = PdfColors.green700;

  static const PdfColor secondary = PdfColors.green50;

  static const PdfColor border = PdfColors.grey400;

  static const PdfColor textGrey = PdfColors.grey700;

  //==========================
  // Text Styles
  //==========================

  static pw.TextStyle title(pw.Font font) {
    return pw.TextStyle(
      font: font,
      fontSize: 22,
      fontWeight: pw.FontWeight.bold,
    );
  }

  static pw.TextStyle heading(pw.Font font) {
    return pw.TextStyle(
      font: font,
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );
  }

  static pw.TextStyle subHeading(pw.Font font) {
    return pw.TextStyle(
      font: font,
      fontSize: 13,
      fontWeight: pw.FontWeight.bold,
    );
  }

  static pw.TextStyle normal(pw.Font font) {
    return pw.TextStyle(
      font: font,
      fontSize: 11,
    );
  }

  static pw.TextStyle small(pw.Font font) {
    return pw.TextStyle(
      font: font,
      fontSize: 9,
      color: textGrey,
    );
  }

  //==========================
  // Decorations
  //==========================

  static pw.BoxDecoration cardDecoration() {
    return pw.BoxDecoration(
      border: pw.Border.all(
        color: border,
      ),
      borderRadius:
          pw.BorderRadius.circular(6),
    );
  }

  static pw.BoxDecoration summaryDecoration() {
    return pw.BoxDecoration(
      color: secondary,
      borderRadius:
          pw.BorderRadius.circular(6),
    );
  }

  static pw.BoxDecoration headerDecoration() {
    return pw.BoxDecoration(
      color: primary,
      borderRadius:
          pw.BorderRadius.circular(20),
    );
  }

  //==========================
  // Common SizedBoxes
  //==========================

  static final gap5 = pw.SizedBox(height: 5);

  static final gap10 = pw.SizedBox(height: 10);

  static final gap15 = pw.SizedBox(height: 15);

  static final gap20 = pw.SizedBox(height: 20);

  static final gap30 = pw.SizedBox(height: 30);

  //==========================
  // Divider
  //==========================

  static pw.Widget divider() {
    return pw.Divider(
      color: border,
      thickness: .6,
    );
  }
}