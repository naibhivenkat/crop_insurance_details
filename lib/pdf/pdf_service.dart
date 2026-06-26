import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../models/farmer_model.dart';
import '../models/survey_detail_model.dart';

import 'receipt_builder.dart';

class PdfService {
  PdfService._();

  static final PdfService instance = PdfService._();

  Future<Uint8List> generateReceipt({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) {
    return ReceiptBuilder().build(
      farmer: farmer,
      surveys: surveys,
    );
  }

  Future<void> previewReceipt({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) async {
    final pdf = await generateReceipt(
      farmer: farmer,
      surveys: surveys,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf,
    );
  }

  Future<void> shareReceipt({
    required FarmerModel farmer,
    required List<SurveyDetailModel> surveys,
  }) async {
    final pdf = await generateReceipt(
      farmer: farmer,
      surveys: surveys,
    );

    await Printing.sharePdf(
      bytes: pdf,
      filename: "Application_${farmer.slNo}.pdf",
    );
  }
}