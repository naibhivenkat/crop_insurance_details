import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/farmer_model.dart';

class ReceiptHeader extends pw.StatelessWidget {
  final FarmerModel farmer;
  final pw.MemoryImage? logo;

  ReceiptHeader({
    required this.farmer,
    this.logo,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.green700,
          width: 2,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [

          //----------------------------------------------------
          // Top Row
          //----------------------------------------------------

          pw.Row(
            children: [

              if (logo != null)
                pw.Container(
                  width: 60,
                  height: 60,
                  child: pw.Image(logo!),
                )
              else
                pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.grey400,
                    ),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "LOGO",
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),

              pw.SizedBox(width: 20),

              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.center,
                  children: [

                    pw.Text(
                      "CROP SURVEY MANAGEMENT SYSTEM",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight:
                            pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    pw.Text(
                      "Government Crop Insurance Survey",
                      style: const pw.TextStyle(
                        fontSize: 13,
                      ),
                    ),

                    pw.SizedBox(height: 8),

                    pw.Container(
                      padding:
                          const pw.EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green700,
                        borderRadius:
                            pw.BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: pw.Text(
                        "APPLICATION RECEIPT",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Divider(),

          pw.SizedBox(height: 10),

          //----------------------------------------------------
          // Details Row
          //----------------------------------------------------

          pw.Row(
            children: [

              pw.Expanded(
                child: _info(
                  "Application No",
                  farmer.slNo.toString(),
                ),
              ),

              pw.Expanded(
                child: _info(
                  "Application Date",
                  DateFormat(
                    "dd MMM yyyy",
                  ).format(
                    farmer.date.toDate(),
                  ),
                ),
              ),

              pw.Expanded(
                child: _statusChip(
                  farmer.status,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            color: PdfColors.grey700,
            fontSize: 10,
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Text(
          value,
          style: pw.TextStyle(
            fontWeight:
                pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  pw.Widget _statusChip(String status) {
    PdfColor color = PdfColors.orange;

    switch (status) {
      case "Approved":
        color = PdfColors.green;
        break;

      case "Rejected":
        color = PdfColors.red;
        break;

      case "Submitted":
        color = PdfColors.blue;
        break;

      case "Payment Released":
        color = PdfColors.purple;
        break;

      default:
        color = PdfColors.orange;
    }

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,
      children: [

        pw.Text(
          "Status",
          style: pw.TextStyle(
            color: PdfColors.grey700,
            fontSize: 10,
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Container(
          padding:
              const pw.EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius:
                pw.BorderRadius.circular(12),
          ),
          child: pw.Text(
            status,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight:
                  pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}