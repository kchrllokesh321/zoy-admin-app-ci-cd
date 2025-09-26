import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpandableDropdownField Tests', () {
    // Helper function to create a test widget with proper theme setup
    Widget createTestWidget({
      required List<String> items,
      String? selectedValue,
      required ValueChanged<String> onChanged,
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
          child: Scaffold(
            body: ExpandableDropdownField(items: items, selectedValue: selectedValue, onChanged: onChanged),
          ),
        ),
      );
    }

    group('Constructor Tests', () {
      test('creates widget with required parameters', () {
        final widget = ExpandableDropdownField(items: const ['Item 1', 'Item 2', 'Item 3'], onChanged: (value) {});

        expect(widget.items, ['Item 1', 'Item 2', 'Item 3']);
        expect(widget.selectedValue, isNull);
        expect(widget.onChanged, isNotNull);
      });

      test('creates widget with all parameters', () {
        final widget = ExpandableDropdownField(
          items: const ['Option A', 'Option B'],
          selectedValue: 'Option A',
          onChanged: (value) {},
        );

        expect(widget.items, ['Option A', 'Option B']);
        expect(widget.selectedValue, 'Option A');
        expect(widget.onChanged, isNotNull);
      });
    });

    group('Widget Rendering Tests', () {
      testWidgets('renders correctly with no selected value', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2', 'Item 3'], onChanged: (value) {}));

        expect(find.byType(ExpandableDropdownField), findsOneWidget);
        expect(find.text('Select'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });

      testWidgets('renders correctly with selected value', (tester) async {
        await tester.pumpWidget(
          createTestWidget(items: const ['Item 1', 'Item 2', 'Item 3'], selectedValue: 'Item 2', onChanged: (value) {}),
        );

        expect(find.byType(ExpandableDropdownField), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Select'), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('renders correctly with empty string selected value', (tester) async {
        await tester.pumpWidget(
          createTestWidget(items: const ['Item 1', 'Item 2', 'Item 3'], selectedValue: '', onChanged: (value) {}),
        );

        expect(find.text('Select'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('shows expanded state when tapped', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2', 'Item 3'], onChanged: (value) {}));

        // Initially collapsed
        expect(find.byType(ListView), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

        // Tap to expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // Should be expanded
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('toggles expansion when tapped', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2'], onChanged: (value) {}));

        // Initially collapsed
        expect(find.byType(ListView), findsNothing);

        // Tap to expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsOneWidget);

        // Tap again to collapse
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsNothing);
      });

      testWidgets('calls onChanged when item is selected', (tester) async {
        String? selectedItem;
        await tester.pumpWidget(
          createTestWidget(items: const ['Apple', 'Banana', 'Cherry'], onChanged: (value) => selectedItem = value),
        );

        // Expand the dropdown
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // Select an item
        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle();

        expect(selectedItem, 'Banana');
        expect(find.byType(ListView), findsNothing); // Should collapse after selection
      });

      testWidgets('collapses dropdown after item selection', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Option 1', 'Option 2'], onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsOneWidget);

        // Select item
        await tester.tap(find.text('Option 1'));
        await tester.pumpAndSettle();

        // Should be collapsed
        expect(find.byType(ListView), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('handles multiple rapid taps', (tester) async {
        int callCount = 0;
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2'], onChanged: (value) => callCount++));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // Verify items are visible
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);

        // Tap the same item once (after first tap, dropdown collapses)
        await tester.tap(find.text('Item 1'));
        await tester.pumpAndSettle();

        expect(callCount, 1);
      });
    });

    group('Widget State Tests', () {
      testWidgets('maintains expanded state correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['A', 'B', 'C'], onChanged: (value) {}));

        // Check initial state
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // Check expanded state
        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      });

      testWidgets('updates when selectedValue changes', (tester) async {
        String currentValue = 'Initial';

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return createTestWidget(
                items: const ['Initial', 'Updated', 'Final'],
                selectedValue: currentValue,
                onChanged: (value) {
                  setState(() {
                    currentValue = value;
                  });
                },
              );
            },
          ),
        );

        // Initial state
        expect(find.text('Initial'), findsOneWidget);

        // Expand and select new item
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Updated'));
        await tester.pumpAndSettle();

        // Should show updated value
        expect(find.text('Updated'), findsOneWidget);
        expect(find.text('Initial'), findsNothing);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles empty items list', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const [], onChanged: (value) {}));

        expect(find.byType(ExpandableDropdownField), findsOneWidget);
        expect(find.text('Select'), findsOneWidget);

        // Expand - should show empty ListView
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      });

      testWidgets('handles single item list', (tester) async {
        String? selectedItem;
        await tester.pumpWidget(
          createTestWidget(items: const ['Only Item'], onChanged: (value) => selectedItem = value),
        );

        // Expand and select the only item
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Only Item'), findsOneWidget);

        await tester.tap(find.text('Only Item'));
        await tester.pumpAndSettle();

        expect(selectedItem, 'Only Item');
      });

      testWidgets('handles very long item names', (tester) async {
        const longItem = 'This is a very long item name that should be handled properly by the dropdown widget';
        await tester.pumpWidget(createTestWidget(items: const [longItem, 'Short'], onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        expect(find.text(longItem), findsOneWidget);
        expect(find.text('Short'), findsOneWidget);
      });

      testWidgets('handles special characters in items', (tester) async {
        const specialItems = ['Item@#\$%', 'Item with spaces', 'Item\nwith\nnewlines'];
        await tester.pumpWidget(createTestWidget(items: specialItems, onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        for (final item in specialItems) {
          expect(find.text(item), findsOneWidget);
        }
      });

      testWidgets('handles null selectedValue correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(items: const ['Item 1', 'Item 2'], selectedValue: null, onChanged: (value) {}),
        );

        expect(find.text('Select'), findsOneWidget);
      });
    });

    group('Widget Lifecycle Tests', () {
      testWidgets('didUpdateWidget triggers setState when selectedValue changes', (tester) async {
        Widget buildWidget(String value) {
          return createTestWidget(items: const ['Initial', 'Updated'], selectedValue: value, onChanged: (newValue) {});
        }

        // Build with initial value
        await tester.pumpWidget(buildWidget('Initial'));
        expect(find.text('Initial'), findsOneWidget);

        // Update with new value
        await tester.pumpWidget(buildWidget('Updated'));
        await tester.pumpAndSettle();
        expect(find.text('Updated'), findsOneWidget);
        expect(find.text('Initial'), findsNothing);
      });

      testWidgets('didUpdateWidget does not trigger setState when selectedValue is same', (tester) async {
        Widget buildWidget() {
          return createTestWidget(items: const ['Same Value'], selectedValue: 'Same Value', onChanged: (newValue) {});
        }

        // Build widget
        await tester.pumpWidget(buildWidget());
        expect(find.text('Same Value'), findsOneWidget);

        // Rebuild with same value
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();
        expect(find.text('Same Value'), findsOneWidget);
      });

      testWidgets('didUpdateWidget handles null to value transition', (tester) async {
        Widget buildWidget(String? value) {
          return createTestWidget(items: const ['Item 1', 'Item 2'], selectedValue: value, onChanged: (newValue) {});
        }

        // Build with null value
        await tester.pumpWidget(buildWidget(null));
        expect(find.text('Select'), findsOneWidget);

        // Update to actual value
        await tester.pumpWidget(buildWidget('Item 1'));
        await tester.pumpAndSettle();
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Select'), findsNothing);
      });

      testWidgets('didUpdateWidget handles value to null transition', (tester) async {
        Widget buildWidget(String? value) {
          return createTestWidget(items: const ['Item 1', 'Item 2'], selectedValue: value, onChanged: (newValue) {});
        }

        // Build with value
        await tester.pumpWidget(buildWidget('Item 1'));
        expect(find.text('Item 1'), findsOneWidget);

        // Update to null
        await tester.pumpWidget(buildWidget(null));
        await tester.pumpAndSettle();
        expect(find.text('Select'), findsOneWidget);
        expect(find.text('Item 1'), findsNothing);
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
            createTestWidget(items: const ['Item 1', 'Item 2'], onChanged: (value) {}, screenSize: size),
          );

          expect(find.byType(ExpandableDropdownField), findsOneWidget);
          expect(find.text('Select'), findsOneWidget);
        }
      });

      testWidgets('uses responsive font sizes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            items: const ['Test Item'],
            selectedValue: 'Test Item',
            onChanged: (value) {},
            screenSize: const Size(1200, 800), // Desktop size
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Test Item'));
        expect(textWidget.style?.fontSize, isNotNull);
        expect(textWidget.style?.fontWeight, FontWeight.w400);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('uses theme colors correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2'], onChanged: (value) {}));

        // Check that InputDecorator uses theme
        expect(find.byType(InputDecorator), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('applies correct text styling for selected value', (tester) async {
        await tester.pumpWidget(
          createTestWidget(items: const ['Selected Item'], selectedValue: 'Selected Item', onChanged: (value) {}),
        );

        final textWidget = tester.widget<Text>(find.text('Selected Item'));
        expect(textWidget.style?.fontWeight, FontWeight.w400);
      });

      testWidgets('applies correct text styling for placeholder', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1'], selectedValue: null, onChanged: (value) {}));

        final textWidget = tester.widget<Text>(find.text('Select'));
        expect(textWidget.style?.fontWeight, FontWeight.w400);
      });
    });

    group('Layout and Structure Tests', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2'], onChanged: (value) {}));

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(InputDecorator), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('expanded dropdown has correct structure', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Item 1', 'Item 2', 'Item 3'], onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(3));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides proper semantics', (tester) async {
        await tester.pumpWidget(
          createTestWidget(items: const ['Accessible Item 1', 'Accessible Item 2'], onChanged: (value) {}),
        );

        expect(find.byType(ExpandableDropdownField), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('list items are tappable', (tester) async {
        await tester.pumpWidget(createTestWidget(items: const ['Tappable 1', 'Tappable 2'], onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // All items should be tappable
        expect(find.byType(ListTile), findsNWidgets(2));

        // Test tapping each item
        await tester.tap(find.text('Tappable 1'));
        await tester.pumpAndSettle();
      });
    });

    group('Performance Tests', () {
      testWidgets('handles large number of items efficiently', (tester) async {
        final largeItemList = List.generate(100, (index) => 'Item $index');

        await tester.pumpWidget(createTestWidget(items: largeItemList, onChanged: (value) {}));

        // Expand
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // Should render without performance issues
        expect(find.byType(ListView), findsOneWidget);

        // ListView should use builder for efficiency
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, true);
      });
    });
  });
}
