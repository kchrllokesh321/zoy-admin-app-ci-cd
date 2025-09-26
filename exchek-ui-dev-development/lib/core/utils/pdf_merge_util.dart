import 'package:exchek/core/utils/exports.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart' as pw_core;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;

typedef MergeProgressCallback = void Function(double progress, String status);

class PdfMergeUtil {
  static const double maxMergedSizeMB = 1.9;

  // Public API: merge two files (pdf/jpg/png combinations) into a single PDF FileData (<2MB if possible)
  static Future<FileData> mergeFrontBackToSinglePdf({
    required FileData front,
    required FileData back,
    String outputName = 'merged.pdf',
    MergeProgressCallback? onProgress,
    bool useBackground = false,
  }) async {
    onProgress?.call(0.0, 'Preparing to merge');
    // Use efficient PDF merging similar to pypdf approach
    final result = await _mergeWithEfficientPdfLibraries(
      front,
      back,
      outputName,
      onProgress: onProgress,
      useBackground: useBackground,
    );
    onProgress?.call(1.0, 'Merge complete');
    return result;
  }

  // Merge using efficient PDF libraries (Flutter equivalent of pypdf)
  static Future<FileData> _mergeWithEfficientPdfLibraries(
    FileData front,
    FileData back,
    String outputName, {
    MergeProgressCallback? onProgress,
    bool useBackground = false,
  }) async {
    // Check if both files are PDFs for direct merging
    final String frontExt = _extOf(front).toLowerCase();
    final String backExt = _extOf(back).toLowerCase();

    if (frontExt == 'pdf' && backExt == 'pdf') {
      // Direct PDF to PDF merging (most efficient)
      return await _mergePdfToPdf(front, back, outputName, onProgress: onProgress, useBackground: useBackground);
    } else {
      // Mixed content merging (images + PDFs)
      return await _mergeMixedContent(front, back, outputName, onProgress: onProgress, useBackground: useBackground);
    }
  }

  // Direct PDF to PDF merging (most efficient, similar to pypdf)
  static Future<FileData> _mergePdfToPdf(
    FileData front,
    FileData back,
    String outputName, {
    MergeProgressCallback? onProgress,
    bool useBackground = false,
  }) async {
    // Prepare payload for background processing
    final Map<String, Object> payload = {
      'front': {'name': front.name, 'bytes': front.bytes},
      'back': {'name': back.name, 'bytes': back.bytes},
      'outputName': outputName,
    };

    // Run PDF merging with optional background processing
    final bool runInBackground = useBackground && !foundation.kIsWeb;
    final Uint8List pdfBytes =
        runInBackground
            ? await foundation.compute(_mergePdfToPdfBackgroundCompute, payload)
            : await _mergePdfToPdfBackground(payload, onProgress: onProgress);

    return FileData(
      name: outputName,
      bytes: pdfBytes,
      sizeInMB: _bytesToMB(pdfBytes.length),
      path: null,
      webPath: null,
    );
  }

  // Background PDF to PDF merging (raster-based to ensure compatibility)
  static Future<Uint8List> _mergePdfToPdfBackground(
    Map<String, Object> payload, {
    MergeProgressCallback? onProgress,
  }) async {
    final Map frontMap = (payload['front'] as Map);
    final Map backMap = (payload['back'] as Map);

    final Uint8List frontBytes = frontMap['bytes'] as Uint8List;
    final Uint8List backBytes = backMap['bytes'] as Uint8List;

    final doc = pw.Document();

    // Add pages from front PDF (0% -> 50%)
    await _addPdfPagesToDocument(
      doc,
      frontBytes,
      base: 0.0,
      span: 0.5,
      onProgress: onProgress,
      stageLabel: 'Merging front',
    );

    // Add pages from back PDF (50% -> 100%)
    await _addPdfPagesToDocument(
      doc,
      backBytes,
      base: 0.5,
      span: 0.5,
      onProgress: onProgress,
      stageLabel: 'Merging back',
    );

    final Uint8List mergedBytes = Uint8List.fromList(await doc.save());

    if (_bytesToMB(mergedBytes.length) <= maxMergedSizeMB) {
      return mergedBytes;
    }

    // If too large, compress adaptively to target size
    onProgress?.call(0.9, 'Compressing PDF');
    final result = await _compressPdfToTarget(
      mergedBytes,
      targetMB: maxMergedSizeMB,
      onProgress: (p, s) => onProgress?.call(0.9 + p * 0.1, s),
    );
    onProgress?.call(1.0, 'Compression complete');
    return result;
  }

  // Compute wrapper for PDF to PDF merging
  static Future<Uint8List> _mergePdfToPdfBackgroundCompute(Map<String, Object> payload) {
    return PdfMergeUtil._mergePdfToPdfBackground(payload);
  }

  // Wrapper for mixed content merging
  static Future<FileData> _mergeMixedContent(
    FileData front,
    FileData back,
    String outputName, {
    MergeProgressCallback? onProgress,
    bool useBackground = false,
  }) async {
    final Map<String, Object> payload = {
      'front': {'name': front.name, 'bytes': front.bytes},
      'back': {'name': back.name, 'bytes': back.bytes},
      'outputName': outputName,
    };

    final bool runInBackground = useBackground && !foundation.kIsWeb;
    final Uint8List pdfBytes =
        runInBackground
            ? await foundation.compute(_mergeMixedContentBackgroundCompute, payload)
            : await _mergeMixedContentBackground(payload, onProgress: onProgress);

    return FileData(
      name: outputName,
      bytes: pdfBytes,
      sizeInMB: _bytesToMB(pdfBytes.length),
      path: null,
      webPath: null,
    );
  }

  // Background mixed content merging
  static Future<Uint8List> _mergeMixedContentBackground(
    Map<String, Object> payload, {
    MergeProgressCallback? onProgress,
  }) async {
    final Map frontMap = (payload['front'] as Map);
    final Map backMap = (payload['back'] as Map);

    final FileData front = FileData(
      name: frontMap['name'] as String,
      bytes: frontMap['bytes'] as Uint8List,
      sizeInMB: _bytesToMB((frontMap['bytes'] as Uint8List).length),
    );
    final FileData back = FileData(
      name: backMap['name'] as String,
      bytes: backMap['bytes'] as Uint8List,
      sizeInMB: _bytesToMB((backMap['bytes'] as Uint8List).length),
    );

    // Extract images from both files
    onProgress?.call(0.05, 'Reading front');
    final List<Uint8List> frontImages = await _extractImagesFromFile(
      front,
      onProgress: (p, s) {
        onProgress?.call(0.05 + p * 0.25, 'Extracting front images');
      },
    );
    onProgress?.call(0.35, 'Reading back');
    final List<Uint8List> backImages = await _extractImagesFromFile(
      back,
      onProgress: (p, s) {
        onProgress?.call(0.35 + p * 0.25, 'Extracting back images');
      },
    );
    final List<Uint8List> allImages = [...frontImages, ...backImages];

    // Build PDF from images
    onProgress?.call(0.6, 'Building PDF');
    final out = await _buildPdfFromImages(
      allImages,
      onProgress: (p, s) {
        onProgress?.call(0.6 + p * 0.4, 'Building PDF');
      },
    );
    // Ensure under size cap
    if (_bytesToMB(out.length) <= maxMergedSizeMB) {
      onProgress?.call(1.0, 'Done');
      return out;
    }

    onProgress?.call(0.95, 'Compressing PDF');
    final compressed = await _compressPdfToTarget(
      out,
      targetMB: maxMergedSizeMB,
      onProgress: (p, s) => onProgress?.call(0.95 + p * 0.05, s),
    );
    onProgress?.call(1.0, 'Done');
    return compressed;
  }

  // Compute wrapper for mixed content merging
  static Future<Uint8List> _mergeMixedContentBackgroundCompute(Map<String, Object> payload) {
    return PdfMergeUtil._mergeMixedContentBackground(payload);
  }

  // Add PDF pages to document efficiently
  static Future<void> _addPdfPagesToDocument(
    pw.Document doc,
    Uint8List pdfBytes, {
    double base = 0.0,
    double span = 1.0,
    MergeProgressCallback? onProgress,
    String stageLabel = 'Merging',
  }) async {
    final pdfx.PdfDocument pdfDoc = await pdfx.PdfDocument.openData(pdfBytes);

    for (int i = 1; i <= pdfDoc.pagesCount; i++) {
      final pdfx.PdfPage page = await pdfDoc.getPage(i);

      // Render page at optimal resolution
      final double targetWidth = page.width * 2.0;
      final double targetHeight = page.height * 2.0;
      final pdfx.PdfPageImage? pageImage = await page.render(
        width: targetWidth,
        height: targetHeight,
        format: pdfx.PdfPageImageFormat.png,
      );
      await page.close();

      if (pageImage != null && pageImage.bytes.isNotEmpty) {
        final img.Image? decoded = img.decodeImage(pageImage.bytes);
        if (decoded != null) {
          final pw.ImageProvider provider = pw.MemoryImage(pageImage.bytes);
          // Dynamic page size to avoid cropping
          final double a4Width = pw_core.PdfPageFormat.a4.width;
          final double aspect = decoded.height / decoded.width;
          final double pageHeight = a4Width * aspect;
          final pw_core.PdfPageFormat pageFormat = pw_core.PdfPageFormat(a4Width, pageHeight);

          doc.addPage(
            pw.Page(
              pageFormat: pageFormat,
              margin: pw.EdgeInsets.zero,
              build: (context) {
                return pw.Center(child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(provider)));
              },
            ),
          );
        }
      }

      if (onProgress != null && pdfDoc.pagesCount > 0) {
        final double local = i / pdfDoc.pagesCount;
        onProgress(base + local * span, '$stageLabel (${(local * 100).toStringAsFixed(0)}%)');
      }
    }

    await pdfDoc.close();
  }

  // Extract images from file
  static Future<List<Uint8List>> _extractImagesFromFile(FileData file, {MergeProgressCallback? onProgress}) async {
    final String ext = _extOf(file).toLowerCase();
    if (ext == 'pdf') {
      return await _extractImagesFromPdf(file, onProgress: onProgress);
    } else {
      return await _extractImagesFromImageFile(file, onProgress: onProgress);
    }
  }

  // Extract images from PDF
  static Future<List<Uint8List>> _extractImagesFromPdf(FileData file, {MergeProgressCallback? onProgress}) async {
    final pdfx.PdfDocument doc = await pdfx.PdfDocument.openData(file.bytes);
    final List<Uint8List> images = [];

    for (int i = 1; i <= doc.pagesCount; i++) {
      final pdfx.PdfPage page = await doc.getPage(i);

      final double targetWidth = page.width * 2.0;
      final double targetHeight = page.height * 2.0;
      final pdfx.PdfPageImage? pageImage = await page.render(
        width: targetWidth,
        height: targetHeight,
        format: pdfx.PdfPageImageFormat.png,
      );
      await page.close();

      if (pageImage != null && pageImage.bytes.isNotEmpty) {
        images.add(pageImage.bytes);
      }

      if (onProgress != null && doc.pagesCount > 0) {
        onProgress(i / doc.pagesCount, 'Extracting pages');
      }
    }

    await doc.close();
    return images;
  }

  // Extract images from image file
  static Future<List<Uint8List>> _extractImagesFromImageFile(FileData file, {MergeProgressCallback? onProgress}) async {
    final img.Image? decoded = img.decodeImage(file.bytes);
    if (decoded != null) {
      // Optimize image size while preserving aspect ratio
      final img.Image scaled = _scaleDownIfNeeded(decoded, maxWidth: 1000, maxHeight: 1000);
      onProgress?.call(1.0, 'Image prepared');
      return [Uint8List.fromList(img.encodePng(scaled, level: 6))];
    }
    return [file.bytes];
  }

  // Build PDF from images
  static Future<Uint8List> _buildPdfFromImages(List<Uint8List> imageBytes, {MergeProgressCallback? onProgress}) async {
    final doc = pw.Document();

    for (int index = 0; index < imageBytes.length; index++) {
      final bytes = imageBytes[index];
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded != null) {
        final img.Image scaled = _scaleDownIfNeeded(decoded, maxWidth: 1000, maxHeight: 1000);
        final Uint8List encoded = Uint8List.fromList(img.encodePng(scaled, level: 6));
        final pw.ImageProvider provider = pw.MemoryImage(encoded);

        // Dynamic page size to avoid cropping
        final double a4Width = pw_core.PdfPageFormat.a4.width;
        final double aspect = scaled.height / scaled.width;
        final double pageHeight = a4Width * aspect;
        final pw_core.PdfPageFormat pageFormat = pw_core.PdfPageFormat(a4Width, pageHeight);

        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            margin: pw.EdgeInsets.zero,
            build: (context) {
              return pw.Center(child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(provider)));
            },
          ),
        );
      }

      if (onProgress != null && imageBytes.isNotEmpty) {
        onProgress((index + 1) / imageBytes.length, 'Adding images');
      }
    }

    return Uint8List.fromList(await doc.save());
  }

  // Compress PDF adaptively to target size (raster fallback)
  static Future<Uint8List> _compressPdfToTarget(
    Uint8List pdfBytes, {
    required double targetMB,
    MergeProgressCallback? onProgress,
  }) async {
    final List<double> scaleFactors = [1.2, 1.0, 0.9, 0.8, 0.7];
    final List<int> qualities = [70, 65, 60, 55, 50];

    Uint8List best = pdfBytes;
    double bestSize = _bytesToMB(best.length);

    for (int attempt = 0; attempt < scaleFactors.length; attempt++) {
      final scale = scaleFactors[attempt];
      final quality = qualities[attempt.clamp(0, qualities.length - 1)];

      onProgress?.call(attempt / scaleFactors.length, 'Compressing (q=$quality, s=${scale.toStringAsFixed(1)})');

      final pdfx.PdfDocument doc = await pdfx.PdfDocument.openData(best);
      final pw.Document compressedDoc = pw.Document();

      for (int i = 1; i <= doc.pagesCount; i++) {
        final pdfx.PdfPage page = await doc.getPage(i);

        final double targetWidth = page.width * scale;
        final double targetHeight = page.height * scale;
        final pdfx.PdfPageImage? pageImage = await page.render(
          width: targetWidth,
          height: targetHeight,
          format: pdfx.PdfPageImageFormat.png,
        );
        await page.close();

        if (pageImage != null && pageImage.bytes.isNotEmpty) {
          final img.Image? decoded = img.decodeImage(pageImage.bytes);
          if (decoded != null) {
            // Further scale down if needed to keep A4 width reasonable
            final img.Image resized = _scaleDownIfNeeded(decoded, maxWidth: 900, maxHeight: 900);
            final Uint8List jpegBytes = Uint8List.fromList(img.encodePng(resized, level: 6));
            final pw.ImageProvider provider = pw.MemoryImage(jpegBytes);

            final double a4Width = pw_core.PdfPageFormat.a4.width;
            final double aspect = resized.height / resized.width;
            final double pageHeight = a4Width * aspect;
            final pw_core.PdfPageFormat pageFormat = pw_core.PdfPageFormat(a4Width, pageHeight);

            compressedDoc.addPage(
              pw.Page(
                pageFormat: pageFormat,
                margin: pw.EdgeInsets.zero,
                build: (context) {
                  return pw.Center(child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(provider)));
                },
              ),
            );
          }
        }

        if (onProgress != null && doc.pagesCount > 0) {
          onProgress(attempt / scaleFactors.length + (i / doc.pagesCount) * (1.0 / scaleFactors.length), 'Compressing');
        }
      }

      await doc.close();
      final Uint8List candidate = Uint8List.fromList(await compressedDoc.save());
      final double sizeMB = _bytesToMB(candidate.length);
      if (sizeMB < bestSize) {
        best = candidate;
        bestSize = sizeMB;
      }
      if (sizeMB <= targetMB) {
        return candidate;
      }
    }

    // Return best-effort if we couldn't reach the target
    return best;
  }

  static img.Image _scaleDownIfNeeded(img.Image src, {required int maxWidth, required int maxHeight}) {
    if (src.width <= maxWidth && src.height <= maxHeight) return src;
    final double widthRatio = maxWidth / src.width;
    final double heightRatio = maxHeight / src.height;
    final double ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
    final int w = (src.width * ratio).round();
    final int h = (src.height * ratio).round();
    return img.copyResize(src, width: w, height: h, interpolation: img.Interpolation.average);
  }

  static String _extOf(FileData f) {
    if (f.name.contains('.')) return f.name.split('.').last;
    if ((f.path ?? '').contains('.')) return f.path!.split('.').last;
    return '';
  }

  static double _bytesToMB(int bytes) => bytes / (1024 * 1024);
}
