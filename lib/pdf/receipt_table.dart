import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';
import '../models/survey_detail_model.dart';

class ReceiptTable extends pw.StatelessWidget {
  final FarmerModel farmer;
  final List<SurveyDetailModel> surveys;

  ReceiptTable({
    required this.farmer,
    required this.surveys,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [

        //--------------------------------------------------------
        // Title
        //--------------------------------------------------------

        pw.Text(
          "Survey Details",
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 12),

        //--------------------------------------------------------
        // Table
        //--------------------------------------------------------

        pw.Table(
          border: pw.TableBorder.all(
            color: PdfColors.grey400,
            width: .5,
          ),

          columnWidths: {
            0: const pw.FlexColumnWidth(2.3),
            1: const pw.FlexColumnWidth(2.3),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(1.2),
            5: const pw.FlexColumnWidth(2),
          },

          children: [

            //----------------------------------------------------
            // Header
            //----------------------------------------------------

            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.green100,
              ),
              children: [

                _header("Survey No"),

                _header("Crop"),

                _header("Acre"),

                _header("Gunte"),

                _header("Sub"),

                _header("Amount"),
              ],
            ),

            //----------------------------------------------------
            // Survey Rows
            //----------------------------------------------------

            ...surveys.map(
              (survey) => pw.TableRow(
                children: [

                  _cell(
                    survey.surveyNo,
                  ),

                  _cell(
                    survey.crop,
                  ),

                  _cell(
                    survey.acre.toString(),
                  ),

                  _cell(
                    survey.gunte.toString(),
                  ),

                  _cell(
                    survey.subGunte.toString(),
                  ),

                  _cell(
                    "₹ ${survey.amount.toStringAsFixed(2)}",
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
            ),

            //----------------------------------------------------
            // Grand Total
            //----------------------------------------------------

            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              children: [

                pw.Container(),

                pw.Container(),

                pw.Container(),

                pw.Container(),

                pw.Padding(
                  padding:
                      const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    "Grand Total",
                    textAlign:
                        pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),
                ),

                pw.Padding(
                  padding:
                      const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    "₹ ${farmer.totalAmount.toStringAsFixed(2)}",
                    textAlign:
                        pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,
                      color:
                          PdfColors.green700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        //--------------------------------------------------------
        // Summary
        //--------------------------------------------------------

        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            width: 230,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius:
                  pw.BorderRadius.circular(6),
              border: pw.Border.all(
                color: PdfColors.green200,
              ),
            ),
            child: pw.Column(
              children: [

                _summaryRow(
                  "Total Surveys",
                  surveys.length.toString(),
                ),

                pw.SizedBox(height: 6),

                _summaryRow(
                  "Total Amount",
                  "₹ ${farmer.totalAmount.toStringAsFixed(2)}",
                  bold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------
  // Table Header
  //----------------------------------------------------------

  pw.Widget _header(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  //----------------------------------------------------------
  // Table Cell
  //----------------------------------------------------------

  pw.Widget _cell(
    String text, {
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: const pw.TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  //----------------------------------------------------------
  // Summary Row
  //----------------------------------------------------------

  pw.Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
  }) {
    return pw.Row(
      children: [

        pw.Expanded(
          child: pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),

        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: bold
                ? pw.FontWeight.bold
                : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}