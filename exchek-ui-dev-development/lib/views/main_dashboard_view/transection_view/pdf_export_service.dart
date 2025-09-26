import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/transaction_models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Conditional import for web-specific functionality
import 'pdf_export_service_web.dart' if (dart.library.io) 'pdf_export_service_mobile.dart';

class PdfExportService {
  /// Export transactions to PDF
  static Future<File?> exportTransactionsToPdf(List<TransactionModel> transactions) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [_buildHeader(), _buildTransactionsTable(transactions)];
          },
        ),
      );

      final pdfBytes = await pdf.save();

      if (kIsWeb) {
        // For web, use web-specific implementation
        return await PdfExportServiceWeb.exportToWeb(pdfBytes);
      } else {
        // For mobile platforms
        final output = await getTemporaryDirectory();
        final file = File('${output.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(pdfBytes);
        return file;
      }
    } catch (e) {
      Logger.error('Error generating PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(color: PdfColors.grey100, border: pw.Border.all(color: PdfColors.grey300)),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Transaction Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
          ),
          pw.Text(
            'Generated: ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTransactionsTable(List<TransactionModel> transactions) {
    final headers = [
      'Reference ID',
      'Client Name',
      'Invoice Number',
      'Purpose',
      'Payment Method',
      'Fees',
      'Initiated Date',
      'Completed Date',
      'Status',
      'Currency',
      'Gross Amount',
      'Settled Amount',
      'Additional Notes',
    ];

    final data =
        transactions
            .map(
              (transaction) => <String>[
                transaction.referenceId.isEmpty ? '-' : transaction.referenceId,
                transaction.clientName,
                transaction.invoiceNumber,
                transaction.purpose,
                transaction.paymentMethod,
                transaction.fees,
                transaction.initiatedDate,
                transaction.completedDate.isEmpty ? '-' : transaction.completedDate,
                transaction.status,
                transaction.receivingCurrency,
                transaction.grossAmount,
                transaction.settledAmount,
                transaction.additionalNotes.isEmpty ? '-' : transaction.additionalNotes,
              ],
            )
            .toList();

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
        columnWidths: {
          0: const pw.FixedColumnWidth(110), // Reference ID
          1: const pw.FixedColumnWidth(100), // Client Name
          2: const pw.FixedColumnWidth(100), // Invoice Number
          3: const pw.FixedColumnWidth(120), // Purpose
          4: const pw.FixedColumnWidth(100), // Payment Method
          5: const pw.FixedColumnWidth(70), // Fees
          6: const pw.FixedColumnWidth(100), // Initiated Date
          7: const pw.FixedColumnWidth(120), // Completed Date
          8: const pw.FixedColumnWidth(100), // Status
          9: const pw.FixedColumnWidth(110), // Currency
          10: const pw.FixedColumnWidth(100), // Gross Amount
          11: const pw.FixedColumnWidth(100), // Settled Amount
          12: const pw.FixedColumnWidth(120), // Additional Notes
        },
        children: [
          // Header row
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.grey200),
            children:
                headers
                    .map(
                      (header) => pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          header,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.black),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
          ),
          // Data rows
          ...data.map(
            (row) => pw.TableRow(
              children:
                  row
                      .map(
                        (cell) => pw.Container(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Text(
                            cell,
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
                            textAlign: pw.TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
