// receipt_builder.dart
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/farmer_model.dart';
import '../models/survey_detail_model.dart';

import 'receipt_footer.dart';
import 'receipt_header.dart';
import 'receipt_farmer.dart';
import 'receipt_table.dart';

class ReceiptBuilder {
  Future<Uint8List> build({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) async {
    final pdf = pw.Document();

    final regular = await PdfGoogleFonts.nunitoRegular();
    final bold = await PdfGoogleFonts.nunitoBold();

    final theme = pw.ThemeData.withFont(
      base: regular,
      bold: bold,
    );

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a5,
          theme: theme,
          margin: const pw.EdgeInsets.all(10),
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            ReceiptHeader(farmer: farmer),
            pw.SizedBox(height: 10),
            ReceiptFarmer(farmer: farmer),
            pw.SizedBox(height: 10),
            ReceiptTable(surveys: surveys),
            pw.SizedBox(height: 10),
            ReceiptFooter(farmer: farmer),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}