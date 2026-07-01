// receipt_table.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/survey_detail_model.dart';
import 'pdf_theme.dart';

class ReceiptTable extends pw.StatelessWidget {
  final List<SurveyDetailModel> surveys;

  ReceiptTable({
    required this.surveys,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table(
      border: pw.TableBorder.all(
        color: PdfColors.black,
        width: 1,
      ),
      children: [
        pw.TableRow(
          children: [
            _cell("Survey No", bold: true),
            _cell("Survey Details", bold: true),
            _cell("Crop", bold: true),
            _cell("Amount", bold: true),
          ],
        ),
        ...surveys.map(
          (survey) => pw.TableRow(
            children: [
              _cell(survey.surveyNo),
              _cell("${survey.acre}.${survey.gunte}.${survey.subGunte}"),
              _cell(survey.crop),
              _cell(survey.amount.toStringAsFixed(2)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: PdfThemeHelper.normal(bold: bold),
      ),
    );
  }
}