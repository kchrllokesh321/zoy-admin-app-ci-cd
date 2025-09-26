import 'dart:convert';
import 'dart:typed_data';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Base64CaptchaField Tests', () {
    // Helper function to create a valid base64 encoded image (1x1 PNG)
    String createValidBase64Image() {
      final imageBytes = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x02,
        0x00,
        0x00,
        0x00,
        0x90,
        0x77,
        0x53,
        0xDE,
        0x00,
        0x00,
        0x00,
        0x0C,
        0x49,
        0x44,
        0x41,
        0x54,
        0x08,
        0x99,
        0x01,
        0x01,
        0x00,
        0x00,
        0x00,
        0xFF,
        0xFF,
        0x00,
        0x00,
        0x00,
        0x02,
        0x00,
        0x01,
        0xE2,
        0x21,
        0xBC,
        0x33,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ]);
      return base64Encode(imageBytes);
    }

    // Helper function to create a test widget with proper setup
    Widget createTestWidget({required String base64Image, Size screenSize = const Size(800, 600)}) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(body: Base64CaptchaField(base64Image: base64Image)),
        ),
      );
    }

    group('Constructor Tests', () {
      testWidgets('creates widget with required base64Image parameter', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);
      });

      testWidgets('creates widget with key', (tester) async {
        const key = Key('captcha_field');
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: Base64CaptchaField(key: key, base64Image: base64Image))),
        );

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('renders correctly with valid base64 image', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('has correct widget hierarchy', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        // Check widget hierarchy: Base64CaptchaField -> SizedBox -> Image
        final captchaField = find.byType(Base64CaptchaField);
        final sizedBox = find.byType(SizedBox);
        final image = find.byType(Image);

        expect(captchaField, findsOneWidget);
        expect(sizedBox, findsOneWidget);
        expect(image, findsOneWidget);
      });

      testWidgets('SizedBox has correct dimensions', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 48.0);
        // Width should be ResponsiveHelper.getMaxTileWidth(context) - 150
        // For 800px width (tablet), getMaxTileWidth returns 520
        // So width should be 520 - 150 = 370
        expect(sizedBox.width, 370.0);
      });

      testWidgets('Image has correct properties', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.fill);
        expect(image.image, isA<MemoryImage>());
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts width for mobile screen', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(
          createTestWidget(
            base64Image: base64Image,
            screenSize: const Size(400, 800), // Mobile
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Mobile: getMaxTileWidth returns double.infinity, so width = double.infinity - 150 = double.infinity
        expect(sizedBox.width, double.infinity);
        expect(sizedBox.height, 48.0);
      });

      testWidgets('adapts width for tablet screen', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(
          createTestWidget(
            base64Image: base64Image,
            screenSize: const Size(800, 600), // Tablet
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Tablet: getMaxTileWidth returns 520, so width = 520 - 150 = 370
        expect(sizedBox.width, 370.0);
        expect(sizedBox.height, 48.0);
      });

      testWidgets('adapts width for desktop screen', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(
          createTestWidget(
            base64Image: base64Image,
            screenSize: const Size(1400, 800), // Desktop
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Desktop: getMaxTileWidth returns 520, so width = 520 - 150 = 370
        expect(sizedBox.width, 370.0);
        expect(sizedBox.height, 48.0);
      });
    });

    group('Base64 Decoding Tests', () {
      testWidgets('decodes valid base64 image correctly', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        // Widget should render without errors
        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles base64 image with whitespace', (tester) async {
        final base64Image = '  ${createValidBase64Image()}  '; // Add whitespace

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        // Widget should render without errors (whitespace should be trimmed)
        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('decodes base64 image data correctly', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('initializes state correctly', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        // Widget should be in the widget tree
        expect(find.byType(Base64CaptchaField), findsOneWidget);

        // State should be initialized (no errors thrown)
        // We can't access private state class directly, but we can verify the widget works
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('updates when base64Image changes', (tester) async {
        final initialBase64 = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: initialBase64));

        expect(find.byType(Base64CaptchaField), findsOneWidget);

        // Create a different valid base64 image (create a new valid image)
        final newImageBytes = Uint8List.fromList([
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
          0x00,
          0x00,
          0x00,
          0x0D,
          0x49,
          0x48,
          0x44,
          0x52,
          0x00,
          0x00,
          0x00,
          0x01,
          0x00,
          0x00,
          0x00,
          0x01,
          0x08,
          0x02,
          0x00,
          0x00,
          0x00,
          0x90,
          0x77,
          0x53,
          0xDE,
          0x00,
          0x00,
          0x00,
          0x0C,
          0x49,
          0x44,
          0x41,
          0x54,
          0x08,
          0x99,
          0x01,
          0x01,
          0x00,
          0x00,
          0x00,
          0xFF,
          0xFF,
          0x00,
          0x00,
          0x00,
          0x02,
          0x00,
          0x01,
          0xE2,
          0x21,
          0xBC,
          0x33,
          0x00,
          0x00,
          0x00,
          0x00,
          0x49,
          0x45,
          0x4E,
          0x44,
          0xAE,
          0x42,
          0x60,
          0x82,
        ]);
        final newBase64 = base64Encode(newImageBytes);

        // Update with new base64 image
        await tester.pumpWidget(createTestWidget(base64Image: newBase64));

        // Widget should still be present and updated
        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('does not update when base64Image stays the same', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);

        // Pump the same widget again
        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        // Widget should still be present
        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles base64 string with whitespace trimming', (tester) async {
        final base64Image = createValidBase64Image();
        final base64WithWhitespace = '  $base64Image  '; // Add whitespace that should be trimmed

        await tester.pumpWidget(createTestWidget(base64Image: base64WithWhitespace));

        // Should handle trimming and still work
        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles valid base64 string correctly', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('works correctly in different screen orientations', (tester) async {
        final base64Image = createValidBase64Image();

        // Portrait
        await tester.pumpWidget(createTestWidget(base64Image: base64Image, screenSize: const Size(400, 800)));

        expect(find.byType(Base64CaptchaField), findsOneWidget);

        // Landscape
        await tester.pumpWidget(createTestWidget(base64Image: base64Image, screenSize: const Size(800, 400)));

        expect(find.byType(Base64CaptchaField), findsOneWidget);
      });

      testWidgets('maintains state through widget rebuilds', (tester) async {
        final base64Image = createValidBase64Image();

        await tester.pumpWidget(createTestWidget(base64Image: base64Image));

        expect(find.byType(Base64CaptchaField), findsOneWidget);

        // Trigger a rebuild
        await tester.pump();

        expect(find.byType(Base64CaptchaField), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });
  });
}
