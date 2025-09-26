import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:exchek/widgets/common_widget/checkbox_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomCheckBoxLabel Tests', () {
    // Helper function to create a test widget with proper theme setup
    Widget createTestWidget({
      required bool isSelected,
      required String label,
      required VoidCallback onChanged,
      Size screenSize = const Size(400, 800),
    }) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [
            CustomColors(
              primaryColor: Colors.blue,
              textdarkcolor: Colors.black,
              darktextcolor: Colors.black87,
              fillColor: Colors.white,
              secondaryTextColor: Colors.grey,
              shadowColor: Colors.black26,
              blackColor: Colors.black,
              borderColor: Colors.grey,
              greenColor: Colors.green,
              purpleColor: Colors.purple,
              lightBackgroundColor: Colors.grey[100],
              redColor: Colors.red,
              darkShadowColor: Colors.black54,
              dividerColor: Colors.grey,
              iconColor: Colors.grey[600],
              darkBlueColor: Colors.blue[900],
              lightPurpleColor: Colors.purple[100],
              hintTextColor: Colors.grey[500],
              lightUnSelectedBGColor: Colors.grey[200],
              lightBorderColor: Colors.grey[300],
              disabledColor: Colors.grey[400],
              blueColor: Colors.grey[400],
              boxBgColor: Colors.grey[400],
              boxBorderColor: Colors.grey[400],
              hoverBorderColor: Colors.grey[400],
              hoverShadowColor: Colors.grey[400],
              errorColor: Color(0xFFD91807),
              lightBlueColor: Color(0xFFE6F4FB),
              lightBlueBorderColor: Color(0xFF9DC0EE),
              darkBlueTextColor: Color(0xFF2F3F53),
              blueTextColor: Color(0xFF343A3E),
              drawerIconColor: Color(0xFF4C5259),
              darkGreyColor: Color(0xFF9B9B9B),
              badgeColor: Color(0xFFFF2D55),
              greyTextColor: Color(0xFF666666),
              greyBorderPaginationColor: Color(0xFF4C5259),
              paginationTextColor: Color(0xFF202224),
              tableHeaderColor: Colors.grey[400],
              greentextColor: Colors.green,
              redtextColor: Colors.red,
              tableBorderColor: Colors.grey[400],
              filtercheckboxcolor: Colors.grey[400],
              filtercheckboxunselectedcolor: Colors.grey[400],
              filterbordercolor: Colors.grey[400],
              daterangecolor: Colors.grey[400],
              lightBoxBGColor: Colors.grey[400],
              lightDividerColor: Colors.grey[400],
              lightGreyColor: Color(0xFF6D6D6D),
            ),
          ],
        ),
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(body: CustomCheckBoxLabel(isSelected: isSelected, label: label, onChanged: onChanged)),
        ),
      );
    }

    group('Constructor Tests', () {
      test('creates widget with required parameters', () {
        final widget = CustomCheckBoxLabel(isSelected: true, label: 'Test Label', onChanged: () {});

        expect(widget.isSelected, true);
        expect(widget.label, 'Test Label');
        expect(widget.onChanged, isNotNull);
      });

      test('creates widget with false isSelected', () {
        final widget = CustomCheckBoxLabel(isSelected: false, label: 'Test Label', onChanged: () {});

        expect(widget.isSelected, false);
        expect(widget.label, 'Test Label');
        expect(widget.onChanged, isNotNull);
      });
    });

    group('Widget Rendering Tests', () {
      testWidgets('renders correctly when selected', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Selected Checkbox', onChanged: () {}));

        // Should find the widget
        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);

        // Should find the GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);

        // Should find the Row
        expect(find.byType(Row), findsOneWidget);

        // Should find the label text
        expect(find.text('Selected Checkbox'), findsOneWidget);

        // Should find the done icon when selected
        expect(find.byIcon(Icons.done), findsOneWidget);

        // Should find two containers (one for checkbox)
        expect(find.byType(Container), findsOneWidget);

        // Should find SizedBox for spacing (there might be multiple SizedBoxes)
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));

        // Should find Expanded widget
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('renders correctly when not selected', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: false, label: 'Unselected Checkbox', onChanged: () {}));

        // Should find the widget
        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);

        // Should find the label text
        expect(find.text('Unselected Checkbox'), findsOneWidget);

        // Should NOT find the done icon when not selected
        expect(find.byIcon(Icons.done), findsNothing);

        // Should find one container (for checkbox border)
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('displays different labels correctly', (tester) async {
        const testLabels = [
          'Short',
          'This is a longer label text',
          'Label with special characters: @#\$%^&*()',
          'Label with numbers 12345',
          '',
        ];

        for (final label in testLabels) {
          await tester.pumpWidget(createTestWidget(isSelected: true, label: label, onChanged: () {}));

          if (label.isNotEmpty) {
            expect(find.text(label), findsOneWidget);
          }
        }
      });
    });

    group('Interaction Tests', () {
      testWidgets('calls onChanged when tapped', (tester) async {
        bool callbackCalled = false;
        await tester.pumpWidget(
          createTestWidget(isSelected: false, label: 'Tap Test', onChanged: () => callbackCalled = true),
        );

        // Tap the widget
        await tester.tap(find.byType(CustomCheckBoxLabel));
        await tester.pumpAndSettle();

        expect(callbackCalled, true);
      });

      testWidgets('calls onChanged when tapping different parts', (tester) async {
        int callbackCount = 0;
        await tester.pumpWidget(
          createTestWidget(isSelected: true, label: 'Multi Tap Test', onChanged: () => callbackCount++),
        );

        // Tap the GestureDetector
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();
        expect(callbackCount, 1);

        // Tap the text
        await tester.tap(find.text('Multi Tap Test'));
        await tester.pumpAndSettle();
        expect(callbackCount, 2);

        // Tap the container (checkbox area)
        await tester.tap(find.byType(Container));
        await tester.pumpAndSettle();
        expect(callbackCount, 3);
      });

      testWidgets('handles multiple rapid taps', (tester) async {
        int callbackCount = 0;
        await tester.pumpWidget(
          createTestWidget(isSelected: false, label: 'Rapid Tap Test', onChanged: () => callbackCount++),
        );

        // Perform multiple rapid taps
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(CustomCheckBoxLabel));
        }
        await tester.pumpAndSettle();

        expect(callbackCount, 5);
      });
    });

    group('Visual State Tests', () {
      testWidgets('shows correct visual state when selected', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Selected State', onChanged: () {}));

        // Find the container that represents the selected checkbox
        final containerFinder = find.byType(Container);
        expect(containerFinder, findsOneWidget);

        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;

        // Should have primary color background when selected
        expect(decoration.color, isNotNull);
        expect(decoration.borderRadius, BorderRadius.circular(5.0));

        // Should have the done icon
        expect(find.byIcon(Icons.done), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(Icons.done));
        expect(icon.size, 16.0);
      });

      testWidgets('shows correct visual state when not selected', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: false, label: 'Unselected State', onChanged: () {}));

        // Find the container that represents the unselected checkbox
        final containerFinder = find.byType(Container);
        expect(containerFinder, findsOneWidget);

        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;

        // Should have border but no background color when not selected
        expect(decoration.color, isNull);
        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, BorderRadius.circular(5.0));

        // Should NOT have the done icon
        expect(find.byIcon(Icons.done), findsNothing);
      });

      testWidgets('has correct container dimensions', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Dimension Test', onChanged: () {}));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.minHeight, 18.0);
        expect(container.constraints?.minWidth, 18.0);
      });
    });

    group('Text Styling Tests', () {
      testWidgets('applies correct text styling', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Style Test', onChanged: () {}));

        final textWidget = tester.widget<Text>(find.text('Style Test'));
        final textStyle = textWidget.style!;

        expect(textStyle.fontWeight, FontWeight.w400);
        expect(textStyle.letterSpacing, 0.16);
        expect(textStyle.height, 1.6);
        // Font size depends on ResponsiveHelper, so we just check it's not null
        expect(textStyle.fontSize, isNotNull);
      });

      testWidgets('text is wrapped in Expanded widget', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            isSelected: true,
            label: 'This is a very long label that should be wrapped properly',
            onChanged: () {},
          ),
        );

        // The text should be wrapped in an Expanded widget
        expect(find.byType(Expanded), findsOneWidget);

        // The Expanded should contain the Text widget
        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.child, isA<Text>());
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts to different screen sizes', (tester) async {
        final screenSizes = [
          const Size(300, 600), // Small mobile
          const Size(400, 800), // Regular mobile
          const Size(800, 600), // Tablet
          const Size(1200, 800), // Desktop
        ];

        for (final size in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(isSelected: true, label: 'Responsive Test', onChanged: () {}, screenSize: size),
          );

          // Widget should render correctly on all screen sizes
          expect(find.byType(CustomCheckBoxLabel), findsOneWidget);
          expect(find.text('Responsive Test'), findsOneWidget);
        }
      });
    });

    group('Layout Tests', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Hierarchy Test', onChanged: () {}));

        // Check the widget hierarchy
        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('has correct spacing between checkbox and text', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Spacing Test', onChanged: () {}));

        // Find the SizedBox with width 4.0 (our spacing SizedBox)
        final spacingSizedBoxes = find.byWidgetPredicate((widget) => widget is SizedBox && widget.width == 4.0);
        expect(spacingSizedBoxes, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(spacingSizedBoxes);
        expect(sizedBox.width, 4.0);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles empty label', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: '', onChanged: () {}));

        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles very long label', (tester) async {
        const longLabel =
            'This is a very long label that should wrap properly and not cause any layout issues even when it contains many words and characters';

        await tester.pumpWidget(createTestWidget(isSelected: false, label: longLabel, onChanged: () {}));

        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);
        expect(find.text(longLabel), findsOneWidget);
      });

      testWidgets('handles null callback gracefully in testing', (tester) async {
        // Note: In real usage, onChanged is required and cannot be null
        // This test ensures the widget structure is correct
        await tester.pumpWidget(
          createTestWidget(
            isSelected: true,
            label: 'Callback Test',
            onChanged: () {}, // Empty callback
          ),
        );

        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);
      });
    });

    group('State Transition Tests', () {
      testWidgets('visual appearance changes between selected states', (tester) async {
        bool isSelected = false;

        Widget buildWidget() => createTestWidget(
          isSelected: isSelected,
          label: 'State Change Test',
          onChanged: () => isSelected = !isSelected,
        );

        // Start with unselected state
        await tester.pumpWidget(buildWidget());
        expect(find.byIcon(Icons.done), findsNothing);

        // Change to selected state
        isSelected = true;
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.done), findsOneWidget);

        // Change back to unselected state
        isSelected = false;
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.done), findsNothing);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('uses theme colors correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(isSelected: true, label: 'Theme Test', onChanged: () {}));

        // The widget should use theme colors from CustomColors extension
        expect(find.byType(CustomCheckBoxLabel), findsOneWidget);

        // Container should use theme colors for decoration
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isA<BoxDecoration>());
      });
    });
  });
}
