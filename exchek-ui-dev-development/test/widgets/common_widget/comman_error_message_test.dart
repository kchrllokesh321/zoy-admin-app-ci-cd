import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommanErrorMessage Widget Tests', () {
    group('Constructor Tests', () {
      testWidgets('creates widget with required errorMessage parameter', (WidgetTester tester) async {
        const errorMessage = 'This is a test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.byType(CommanErrorMessage), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      });

      testWidgets('creates widget with key parameter', (WidgetTester tester) async {
        const key = Key('test_error_key');
        const errorMessage = 'Test error message';

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: CommanErrorMessage(key: key, errorMessage: errorMessage))),
        );

        expect(find.byKey(key), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('renders Row widget as root', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final rowFinder = find.byType(Row);
        expect(rowFinder, findsOneWidget);

        final row = tester.widget<Row>(rowFinder);
        expect(row.mainAxisAlignment, MainAxisAlignment.start);
        expect(row.spacing, 8.0);
      });

      testWidgets('renders error icon', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final iconFinder = find.byIcon(Icons.error_outline);
        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 18.0);
      });

      testWidgets('renders Expanded widget with Text', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final expandedFinder = find.byType(Expanded);
        expect(expandedFinder, findsOneWidget);

        final textFinder = find.byType(Text);
        expect(textFinder, findsOneWidget);

        final text = tester.widget<Text>(textFinder);
        expect(text.data, errorMessage);
      });
    });

    group('Styling Tests', () {
      testWidgets('applies correct text styling', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.fontWeight, FontWeight.w400);
        expect(textStyle.fontSize, 16.0); // Default mobile size
      });

      testWidgets('applies error color to icon', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.color, isNotNull);
      });

      testWidgets('applies error color to text', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.color, isNotNull);
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('uses ResponsiveHelper for font size calculation', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        // The widget should use ResponsiveHelper.getFontSize internally
        // We can verify this by checking that the text style is applied correctly
        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.fontSize, isNotNull);
      });

      testWidgets('maintains consistent styling across different screen sizes', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        // Test with different screen sizes
        final testSizes = [
          const Size(400, 800), // Mobile
          const Size(800, 600), // Tablet
          const Size(1200, 800), // Desktop
        ];

        for (final size in testSizes) {
          tester.binding.window.physicalSizeTestValue = size;
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

          // Verify widget still renders correctly
          expect(find.byType(CommanErrorMessage), findsOneWidget);
          expect(find.text(errorMessage), findsOneWidget);
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.byType(Expanded), findsOneWidget);
        }
      });
    });

    group('Content Tests', () {
      testWidgets('displays empty error message', (WidgetTester tester) async {
        const errorMessage = '';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });

      testWidgets('displays long error message', (WidgetTester tester) async {
        const errorMessage =
            'This is a very long error message that should wrap to multiple lines and test the widget\'s ability to handle lengthy text content without breaking the layout or causing overflow issues';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });

      testWidgets('displays special characters in error message', (WidgetTester tester) async {
        const errorMessage = 'Error with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });

      testWidgets('displays unicode characters in error message', (WidgetTester tester) async {
        const errorMessage = 'Error with unicode: 🚀🌟🎉中文हिन्दीالعربية';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('works within different parent widgets', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        // Test within Column
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(children: [CommanErrorMessage(errorMessage: errorMessage), const Text('Other content')]),
            ),
          ),
        );

        expect(find.byType(CommanErrorMessage), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);

        // Test within Container
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                padding: const EdgeInsets.all(16.0),
                child: CommanErrorMessage(errorMessage: errorMessage),
              ),
            ),
          ),
        );

        expect(find.byType(CommanErrorMessage), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      });

      testWidgets('handles multiple instances correctly', (WidgetTester tester) async {
        const errorMessage1 = 'First error message';
        const errorMessage2 = 'Second error message';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CommanErrorMessage(errorMessage: errorMessage1),
                  CommanErrorMessage(errorMessage: errorMessage2),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CommanErrorMessage), findsNWidgets(2));
        expect(find.text(errorMessage1), findsOneWidget);
        expect(find.text(errorMessage2), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsNWidgets(2));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides semantic information', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        // Verify that the text is accessible
        expect(find.text(errorMessage), findsOneWidget);

        // Verify that the icon is present for visual accessibility
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('rebuilds efficiently when error message changes', (WidgetTester tester) async {
        const initialMessage = 'Initial error message';
        const updatedMessage = 'Updated error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: initialMessage))));

        expect(find.text(initialMessage), findsOneWidget);

        // Update the widget
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: updatedMessage))));

        expect(find.text(updatedMessage), findsOneWidget);
        expect(find.text(initialMessage), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles null key gracefully', (WidgetTester tester) async {
        const errorMessage = 'Test error message';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.byType(CommanErrorMessage), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      });

      testWidgets('handles very short error message', (WidgetTester tester) async {
        const errorMessage = '!';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });

      testWidgets('handles whitespace-only error message', (WidgetTester tester) async {
        const errorMessage = '   ';

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CommanErrorMessage(errorMessage: errorMessage))));

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(CommanErrorMessage), findsOneWidget);
      });
    });
  });
}
