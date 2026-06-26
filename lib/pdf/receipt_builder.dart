import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

    //--------------------------------------------------------
    // Fonts
    //--------------------------------------------------------

    final regular =
        await PdfGoogleFonts.nunitoRegular();

    final bold =
        await PdfGoogleFonts.nunitoBold();

    //--------------------------------------------------------
    // Optional Logo
    //--------------------------------------------------------

    pw.MemoryImage? logo;

    try {
      final bytes = await rootBundle.load(
        "assets/images/logo.png",
      );

      logo = pw.MemoryImage(
        bytes.buffer.asUint8List(),
      );
    } catch (_) {}

    //--------------------------------------------------------
    // Theme
    //--------------------------------------------------------

    final theme = pw.ThemeData.withFont(
      base: regular,
      bold: bold,
    );

    //--------------------------------------------------------
    // Build PDF
    //--------------------------------------------------------

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.all(30),
        ),

        build: (context) => [

          //----------------------------------------------------
          // Header
          //----------------------------------------------------

          ReceiptHeader(
            logo: logo,
            farmer: farmer,
          ),

          pw.SizedBox(height: 20),

          //----------------------------------------------------
          // Farmer
          //----------------------------------------------------

          ReceiptFarmer(
            farmer: farmer,
            surveys: surveys,
          ),

          pw.SizedBox(height: 25),

          //----------------------------------------------------
          // Survey Table
          //----------------------------------------------------

          ReceiptTable(
            farmer: farmer,
            surveys: surveys,
          ),

          pw.SizedBox(height: 30),

          //----------------------------------------------------
          // Footer
          //----------------------------------------------------

          ReceiptFooter(
            farmer: farmer,
          ),
        ],
      ),
    );

    return pdf.save();
  }
}