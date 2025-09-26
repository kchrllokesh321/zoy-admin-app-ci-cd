import 'dart:html' as html;
import 'dart:typed_data';

class PdfExportServiceWeb {
  /// Export PDF bytes to web browser download
  static Future<dynamic> exportToWeb(Uint8List pdfBytes) async {
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute('download', 'transactions_${DateTime.now().millisecondsSinceEpoch}.pdf')
          ..click();
    html.Url.revokeObjectUrl(url);
    return null; // No file object needed for web
  }
}
