import 'dart:typed_data';

import 'package:exchek/core/utils/pdf_merge_util.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

Uint8List _makePng({required int w, required int h, int r = 10, int g = 20, int b = 30}) {
  final canvas = img.Image(width: w, height: h, numChannels: 3);
  final color = img.ColorRgb8(r, g, b);
  img.fill(canvas, color: color);
  return Uint8List.fromList(img.encodePng(canvas));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PdfMergeUtil.mergeFrontBackToSinglePdf', () {
    test('merges two small PNG images into a single PDF under 2MB', () async {
      final front = FileData(name: 'front.png', bytes: _makePng(w: 200, h: 200), sizeInMB: 0.0);
      final back = FileData(name: 'back.png', bytes: _makePng(w: 200, h: 200, r: 80, g: 90, b: 100), sizeInMB: 0.0);

      final merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(front: front, back: back);

      expect(merged.name, 'merged.pdf');
      expect(merged.bytes.isNotEmpty, isTrue);
      expect(merged.sizeInMB, lessThanOrEqualTo(PdfMergeUtil.maxMergedSizeMB));
    });

    test('merges large images and stays within size budget', () async {
      // Large images to exercise scaling/compression paths
      final front = FileData(name: 'front.png', bytes: _makePng(w: 4000, h: 3000), sizeInMB: 0.0);
      final back = FileData(name: 'back.png', bytes: _makePng(w: 3500, h: 2800, r: 120, g: 50, b: 60), sizeInMB: 0.0);

      final merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(front: front, back: back);

      expect(merged.name, 'merged.pdf');
      expect(merged.bytes.isNotEmpty, isTrue);
      expect(merged.sizeInMB, lessThanOrEqualTo(PdfMergeUtil.maxMergedSizeMB));
    });

    test('uses path extension when name has no extension', () async {
      // Name without extension, but path contains extension => code path in _extOf
      final front = FileData(
        name: 'front',
        bytes: _makePng(w: 300, h: 300),
        sizeInMB: 0.0,
        path: '/tmp/front_image.png',
      );
      final back = FileData(
        name: 'back',
        bytes: _makePng(w: 300, h: 300, r: 200, g: 100, b: 50),
        sizeInMB: 0.0,
        path: '/tmp/back_image.png',
      );

      final merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(front: front, back: back);

      expect(merged.bytes.isNotEmpty, isTrue);
      expect(merged.sizeInMB, lessThanOrEqualTo(PdfMergeUtil.maxMergedSizeMB));
    });

    test('very large images trigger deeper compression and still return <= 2MB', () async {
      // Use very large images to increase likelihood of hitting deeper compression levels
      final front = FileData(name: 'front.png', bytes: _makePng(w: 6000, h: 4000, r: 150, g: 10, b: 10), sizeInMB: 0.0);
      final back = FileData(name: 'back.png', bytes: _makePng(w: 6000, h: 4000, r: 10, g: 150, b: 10), sizeInMB: 0.0);

      final merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(front: front, back: back);

      expect(merged.name, 'merged.pdf');
      expect(merged.bytes.isNotEmpty, isTrue);
      expect(merged.sizeInMB, lessThanOrEqualTo(PdfMergeUtil.maxMergedSizeMB));
    });
  });
}
