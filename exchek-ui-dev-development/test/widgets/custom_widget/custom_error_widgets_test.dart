import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Constants used across all test groups
  const testErrorMessage = 'Test error message';
  const longErrorMessage =
      'This is a very long error message that should be displayed properly in the center of the screen with proper text alignment and styling';
  const emptyErrorMessage = '';

  // Helper function used across all test groups
  Widget createTestWidget({required String errorMessage, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(body: CustomErrorWidget(errorMessage: errorMessage)),
    );
  }

  // Helper function for isolated widget testing
  Widget createIsolatedTestWidget({required String errorMessage, ThemeData? theme}) {
    return Theme(data: theme ?? ThemeData.light(), child: CustomErrorWidget(errorMessage: errorMessage));
  }

  group('CustomErrorWidget Tests', () {
    testWidgets('renders CustomErrorWidget with required properties', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      // Verify the main widget structure
      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.byType(Directionality), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('displays error message correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      // Verify the error message is displayed
      expect(find.text(testErrorMessage), findsOneWidget);
    });

    testWidgets('displays long error message correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: longErrorMessage));

      // Verify the long error message is displayed
      expect(find.text(longErrorMessage), findsOneWidget);
    });

    testWidgets('displays empty error message correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: emptyErrorMessage));

      // Verify the empty error message is handled
      expect(find.text(emptyErrorMessage), findsOneWidget);
    });

    testWidgets('has correct Directionality', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      final directionality = tester.widget<Directionality>(find.byType(Directionality));
      expect(directionality.textDirection, TextDirection.ltr);
    });

    testWidgets('has correct Container properties', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, Colors.white);
    });

    testWidgets('has correct Padding properties', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.all(16.0));
    });

    testWidgets('has correct Column properties', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisSize, MainAxisSize.min);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.children.length, 3); // Icon, SizedBox, Text
    });

    testWidgets('displays error icon correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      // Verify the error icon is displayed
      expect(find.byIcon(Icons.error), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(icon.size, 48);
    });

    testWidgets('error icon uses theme error color', (tester) async {
      final customTheme = ThemeData(colorScheme: const ColorScheme.light().copyWith(error: Colors.red));

      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage, theme: customTheme));

      final icon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(icon.color, Colors.red);
    });

    testWidgets('has correct SizedBox spacing', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      // Find the SizedBox with height 16 (the spacing between icon and text)
      final spacingSizedBox = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 16);
      expect(spacingSizedBox, findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(spacingSizedBox);
      expect(sizedBox.height, 16);
    });

    testWidgets('error text has correct properties', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      final text = tester.widget<Text>(find.text(testErrorMessage));
      expect(text.textAlign, TextAlign.center);
      expect(text.data, testErrorMessage);
    });

    testWidgets('error text uses correct styling', (tester) async {
      final customTheme = ThemeData(
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16, color: Colors.grey)),
      );

      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage, theme: customTheme));

      final text = tester.widget<Text>(find.text(testErrorMessage));
      expect(text.style?.color, Colors.black);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders correctly with different theme configurations', (tester) async {
      final darkTheme = ThemeData.dark();

      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage, theme: darkTheme));

      // Verify widget still renders correctly with dark theme
      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('widget layout is properly centered', (tester) async {
      await tester.pumpWidget(createIsolatedTestWidget(errorMessage: testErrorMessage));

      // Verify that Center widgets exist and at least one has a Padding child
      final centerWidgets = find.byType(Center);
      expect(centerWidgets, findsAtLeastNWidgets(1));

      // Find the specific Center widget that contains Padding
      final centerWithPadding = find.byWidgetPredicate((widget) => widget is Center && widget.child is Padding);
      expect(centerWithPadding, findsOneWidget);
    });

    testWidgets('handles special characters in error message', (tester) async {
      const specialCharMessage = 'Error: 特殊字符 & symbols! @#\$%^&*()';

      await tester.pumpWidget(createTestWidget(errorMessage: specialCharMessage));

      expect(find.text(specialCharMessage), findsOneWidget);
    });

    testWidgets('handles newlines in error message', (tester) async {
      const multilineMessage = 'Line 1\nLine 2\nLine 3';

      await tester.pumpWidget(createTestWidget(errorMessage: multilineMessage));

      expect(find.text(multilineMessage), findsOneWidget);
    });

    testWidgets('widget key is properly set', (tester) async {
      const testKey = Key('test_error_widget');

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CustomErrorWidget(key: testKey, errorMessage: testErrorMessage))),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });
  });

  group('Private Widget Integration Tests', () {
    testWidgets('error icon is rendered with correct properties through CustomErrorWidget', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      // Test the icon through the main widget
      final icon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(icon.icon, Icons.error);
      expect(icon.size, 48);
    });

    testWidgets('error icon uses theme error color through CustomErrorWidget', (tester) async {
      final customTheme = ThemeData(colorScheme: const ColorScheme.light().copyWith(error: Colors.purple));

      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage, theme: customTheme));

      final icon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(icon.color, Colors.purple);
    });

    testWidgets('error text properties are correct through CustomErrorWidget', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      final text = tester.widget<Text>(find.text(testErrorMessage));
      expect(text.data, testErrorMessage);
      expect(text.textAlign, TextAlign.center);
      expect(text.style?.color, Colors.black);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('error text styling with custom theme through CustomErrorWidget', (tester) async {
      final customTheme = ThemeData(
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 20, color: Colors.blue)),
      );

      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage, theme: customTheme));

      final text = tester.widget<Text>(find.text(testErrorMessage));
      // The style should still override with black color and bold weight
      expect(text.style?.color, Colors.black);
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('handles empty message through private ErrorText widget', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: ''));

      // Verify empty text is handled correctly
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('private widgets are properly integrated in widget tree', (tester) async {
      await tester.pumpWidget(createTestWidget(errorMessage: testErrorMessage));

      // Verify the complete widget tree structure
      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);

      // Find the specific SizedBox with height 16 (spacing between icon and text)
      final spacingSizedBox = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 16);
      expect(spacingSizedBox, findsOneWidget);

      // Verify the icon and text are both present
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);
    });
  });
}
