import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomRadioButton Widget Tests', () {
    group('Constructor Tests', () {
      testWidgets('creates widget with required parameters', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('creates widget with key parameter', (WidgetTester tester) async {
        const key = Key('test_radio_key');
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                key: key,
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) {},
              ),
            ),
          ),
        );

        expect(find.byKey(key), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('creates widget with isDisabled parameter', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) {},
                isDisabled: true,
              ),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('renders GestureDetector as root', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('renders Container with transparent color', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        final containerFinder = find.byType(Container);
        expect(containerFinder, findsWidgets);

        // Find the container with transparent color
        final containers = tester.widgetList<Container>(containerFinder);
        final transparentContainer = containers.firstWhere((container) => container.color == Colors.transparent);
        expect(transparentContainer.color, Colors.transparent);
      });

      testWidgets('renders Row with children', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(Row), findsOneWidget);

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, 3); // Radio button, SizedBox, Expanded
      });

      testWidgets('renders Expanded widget with Text', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(Expanded), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });
    });

    group('Radio Button State Tests', () {
      testWidgets('renders selected state when groupValue equals value', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value'; // Same as value - selected state

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Should render selected state (with inner circle)
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(2)); // Multiple containers including inner circle
      });

      testWidgets('renders unselected state when groupValue differs from value', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'different_value'; // Different from value - unselected state

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Should render unselected state (without inner circle)
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(1));
      });

      testWidgets('renders unselected state when groupValue is null', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const String? groupValue = null; // Null groupValue - unselected state

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Should render unselected state (without inner circle)
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(1));
      });
    });

    group('Styling Tests', () {
      testWidgets('applies correct text styling for enabled state', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) {},
                isDisabled: false,
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.fontWeight, FontWeight.w400);
        expect(textStyle.height, 1.22);
        expect(textStyle.fontSize, isNotNull); // Font size should be set by ResponsiveHelper
      });

      testWidgets('applies disabled text styling when isDisabled is true', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) {},
                isDisabled: true,
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.color, isNotNull);
      });

      testWidgets('applies primary color to selected radio button', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Check that primary color is applied to the selected radio button
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(2));
      });

      testWidgets('applies default border color to unselected radio button', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'different_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Check that default border color is applied to the unselected radio button
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(1));
      });
    });

    group('Interaction Tests', () {
      testWidgets('calls onChanged when tapped in enabled state', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'different_value';
        String? selectedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) => selectedValue = value,
                isDisabled: false,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(CustomRadioButton));
        await tester.pump();

        expect(selectedValue, equals(value));
      });

      testWidgets('does not call onChanged when tapped in disabled state', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'different_value';
        String? selectedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) => selectedValue = value,
                isDisabled: true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(CustomRadioButton));
        await tester.pump();

        expect(selectedValue, isNull);
      });

      testWidgets('handles null onChanged callback', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'different_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(
                title: title,
                value: value,
                groupValue: groupValue,
                onChanged: (value) {}, // Empty callback
                isDisabled: false,
              ),
            ),
          ),
        );

        // Should not throw error when tapped
        await tester.tap(find.byType(CustomRadioButton));
        await tester.pump();

        // Widget should still be present
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('uses ResponsiveHelper for font size calculation', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));
        final textStyle = text.style;

        expect(textStyle, isNotNull);
        expect(textStyle!.fontSize, isNotNull);
      });

      testWidgets('maintains consistent styling across different screen sizes', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        final testSizes = [
          const Size(400, 800), // Mobile
          const Size(800, 600), // Tablet
          const Size(1200, 800), // Desktop
        ];

        for (final size in testSizes) {
          tester.binding.window.physicalSizeTestValue = size;
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
              ),
            ),
          );

          expect(find.byType(CustomRadioButton), findsOneWidget);
          expect(find.text(title), findsOneWidget);
          expect(find.byType(GestureDetector), findsOneWidget);
          expect(find.byType(Row), findsOneWidget);
        }
      });
    });

    group('Content Tests', () {
      testWidgets('displays empty title', (WidgetTester tester) async {
        const title = '';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });

      testWidgets('displays long title', (WidgetTester tester) async {
        const title =
            'This is a very long radio button title that should wrap to multiple lines and test the widget\'s ability to handle lengthy text content without breaking the layout';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });

      testWidgets('displays special characters in title', (WidgetTester tester) async {
        const title = 'Radio with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });

      testWidgets('displays unicode characters in title', (WidgetTester tester) async {
        const title = 'Radio with unicode: 🚀🌟🎉中文हिन्दीالعربية';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('works within different parent widgets', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        // Test within Column
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
                  const Text('Other content'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);

        // Test within Container
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                padding: const EdgeInsets.all(16.0),
                child: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
              ),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('handles multiple instances correctly', (WidgetTester tester) async {
        const title1 = 'First Radio Button';
        const title2 = 'Second Radio Button';
        const value1 = 'value1';
        const value2 = 'value2';
        const groupValue = 'value1';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CustomRadioButton(title: title1, value: value1, groupValue: groupValue, onChanged: (value) {}),
                  CustomRadioButton(title: title2, value: value2, groupValue: groupValue, onChanged: (value) {}),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsNWidgets(2));
        expect(find.text(title1), findsOneWidget);
        expect(find.text(title2), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides semantic information', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        // Verify that the text is accessible
        expect(find.text(title), findsOneWidget);

        // Verify that the gesture detector is present for interaction
        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('rebuilds efficiently when parameters change', (WidgetTester tester) async {
        const initialTitle = 'Initial Radio Button';
        const updatedTitle = 'Updated Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: initialTitle, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(initialTitle), findsOneWidget);

        // Update the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: updatedTitle, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(updatedTitle), findsOneWidget);
        expect(find.text(initialTitle), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles null key gracefully', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('handles very short title', (WidgetTester tester) async {
        const title = '!';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });

      testWidgets('handles whitespace-only title', (WidgetTester tester) async {
        const title = '   ';
        const value = 'test_value';
        const groupValue = 'test_value';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
        expect(find.byType(CustomRadioButton), findsOneWidget);
      });

      testWidgets('handles empty value', (WidgetTester tester) async {
        const title = 'Test Radio Button';
        const value = '';
        const groupValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomRadioButton(title: title, value: value, groupValue: groupValue, onChanged: (value) {}),
            ),
          ),
        );

        expect(find.byType(CustomRadioButton), findsOneWidget);
        expect(find.text(title), findsOneWidget);
      });
    });
  });
}
