import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';
import '../models/survey_detail_model.dart';

class ReceiptFarmer extends pw.StatelessWidget {
  final FarmerModel farmer;
  final List<SurveyDetailModel> surveys;

  ReceiptFarmer({
    required this.farmer,
    required this.surveys,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [

        //--------------------------------------------------------
        // Section Title
        //--------------------------------------------------------

        pw.Text(
          "Farmer Information",
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 12),

        //--------------------------------------------------------
        // Farmer Card
        //--------------------------------------------------------

        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.grey400,
            ),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [

              pw.Row(
                children: [

                  pw.Expanded(
                    child: _info(
                      "Farmer Name",
                      farmer.name,
                    ),
                  ),

                  pw.Expanded(
                    child: _info(
                      "Mobile Number",
                      farmer.mobile,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 15),

              pw.Row(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [

                  pw.Expanded(
                    flex: 2,
                    child: _info(
                      "Address",
                      farmer.address,
                    ),
                  ),

                  pw.Expanded(
                    child: _info(
                      "Application ID",
                      farmer.id,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        //--------------------------------------------------------
        // Summary Cards
        //--------------------------------------------------------

        pw.Row(
          children: [

            pw.Expanded(
              child: _summaryCard(
                title: "Survey Count",
                value: surveys.length.toString(),
                color: PdfColors.blue50,
              ),
            ),

            pw.SizedBox(width: 10),

            pw.Expanded(
              child: _summaryCard(
                title: "Total Amount",
                value:
                    "₹ ${farmer.totalAmount.toStringAsFixed(2)}",
                color: PdfColors.green50,
              ),
            ),

            pw.SizedBox(width: 10),

            pw.Expanded(
              child: _summaryCard(
                title: "Current Status",
                value: farmer.status,
                color: PdfColors.orange50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //------------------------------------------------------------
  // Farmer Info Widget
  //------------------------------------------------------------

  pw.Widget _info(
    String title,
    String value,
  ) {
    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [

        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Text(
          value.isEmpty ? "-" : value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------
  // Summary Card
  //------------------------------------------------------------

  pw.Widget _summaryCard({
    required String title,
    required String value,
    required PdfColor color,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius:
            pw.BorderRadius.circular(8),
        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
      ),
      child: pw.Column(
        children: [

          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}