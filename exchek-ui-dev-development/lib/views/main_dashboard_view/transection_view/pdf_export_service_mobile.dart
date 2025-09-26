import 'dart:typed_data';

class PdfExportServiceWeb {
  /// Stub implementation for mobile platforms
  /// This class is never actually used on mobile, but provides the interface
  static Future<dynamic> exportToWeb(Uint8List pdfBytes) async {
    // This should never be called on mobile platforms
    throw UnsupportedError('Web export not supported on mobile platforms');
  }
}
