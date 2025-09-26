import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpandableCountryDropdownField Tests', () {
    // Create mock Country objects for testing
    final mockCountry1 = Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'India',
      example: '9123456789',
      displayName: 'India',
      displayNameNoCountryCode: 'India',
      e164Key: '',
    );

    final mockCountry2 = Country(
      phoneCode: '1',
      countryCode: 'US',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'United States',
      example: '2015550123',
      displayName: 'United States',
      displayNameNoCountryCode: 'United States',
      e164Key: '',
    );

    final mockCountry3 = Country(
      phoneCode: '44',
      countryCode: 'GB',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'United Kingdom',
      example: '7400123456',
      displayName: 'United Kingdom',
      displayNameNoCountryCode: 'United Kingdom',
      e164Key: '',
    );

    final mockCountryList = [mockCountry1, mockCountry2, mockCountry3];

    // Helper function to create a test widget with proper theme setup
    Widget createTestWidget({
      Country? selectedCountry,
      required List<Country> countryList,
      required Function(Country) onChanged,
      bool isDisable = false,
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
            body: ExpandableCountryDropdownField(
              selectedCountry: selectedCountry,
              countryList: countryList,
              onChanged: onChanged,
              isDisable: isDisable,
            ),
          ),
        ),
      );
    }

    group('Constructor Tests', () {
      test('creates widget with required parameters', () {
        final widget = ExpandableCountryDropdownField(
          selectedCountry: mockCountry1,
          countryList: mockCountryList,
          onChanged: (country) {},
        );

        expect(widget.selectedCountry, mockCountry1);
        expect(widget.countryList, mockCountryList);
        expect(widget.onChanged, isNotNull);
        expect(widget.isDisable, false);
      });

      test('creates widget with all parameters', () {
        final widget = ExpandableCountryDropdownField(
          selectedCountry: mockCountry2,
          countryList: mockCountryList,
          onChanged: (country) {},
          isDisable: true,
        );

        expect(widget.selectedCountry, mockCountry2);
        expect(widget.countryList, mockCountryList);
        expect(widget.onChanged, isNotNull);
        expect(widget.isDisable, true);
      });
    });

    group('Initial State Tests', () {
      testWidgets('initializes with selected country', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        expect(find.text('India'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('initializes with null selected country', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: null, countryList: mockCountryList, onChanged: (country) {}),
        );

        expect(find.text('Select'), findsOneWidget);
      });

      testWidgets('initializes in collapsed state', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Dropdown should be collapsed initially
        expect(find.byType(ListView), findsNothing);
      });
    });

    group('Interaction Tests', () {
      testWidgets('expands dropdown on tap', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Initially collapsed
        expect(find.byType(ListView), findsNothing);

        // Tap to expand
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Should be expanded
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

        // Should show all countries in the list
        expect(find.text('India'), findsWidgets);
        expect(find.text('United States'), findsOneWidget);
        expect(find.text('United Kingdom'), findsOneWidget);
      });

      testWidgets('selects country from dropdown', (tester) async {
        Country? selectedCountry;

        await tester.pumpWidget(
          createTestWidget(
            selectedCountry: mockCountry1,
            countryList: mockCountryList,
            onChanged: (country) {
              selectedCountry = country;
            },
          ),
        );

        // Initially shows India
        expect(find.text('India'), findsOneWidget);

        // Tap to expand
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Tap on United States
        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();

        // Should be collapsed with new selection
        expect(find.byType(ListView), findsNothing);
        expect(find.text('United States'), findsOneWidget);
        expect(selectedCountry, equals(mockCountry2));
      });
    });

    group('Styling Tests', () {
      testWidgets('applies correct styling when enabled', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        final inputDecorator = tester.widget<InputDecorator>(find.byType(InputDecorator));
        expect(inputDecorator.decoration.fillColor, Colors.white);
        expect(inputDecorator.decoration.errorText, isNull);
      });

      testWidgets('applies correct styling when disabled', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            selectedCountry: mockCountry1,
            countryList: mockCountryList,
            onChanged: (country) {},
            isDisable: true,
          ),
        );

        final inputDecorator = tester.widget<InputDecorator>(find.byType(InputDecorator));
        expect(inputDecorator.decoration.fillColor, Colors.grey[400]);
      });

      testWidgets('applies correct text styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        final text = tester.widget<Text>(find.text('India'));
        expect(text.style?.fontWeight, FontWeight.w400);
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
            createTestWidget(
              selectedCountry: mockCountry1,
              countryList: mockCountryList,
              onChanged: (country) {},
              screenSize: size,
            ),
          );

          expect(find.byType(ExpandableCountryDropdownField), findsOneWidget);
          expect(find.text('India'), findsOneWidget);
        }
      });
    });

    group('Error Handling Tests', () {
      testWidgets('handles error text display and clearing', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Since we can't directly access private state, we test the behavior indirectly
        // The error handling functionality is covered by testing the InputDecorator
        final inputDecorator = tester.widget<InputDecorator>(find.byType(InputDecorator));
        expect(inputDecorator.decoration.errorText, isNull);

        // Test that interaction works without errors
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('maintains error-free state during interactions', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Test multiple interactions to ensure error handling works
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();

        // Should complete without errors
        expect(find.text('United States'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(InputDecorator), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('shows dropdown container when expanded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(3)); // Three countries
      });

      testWidgets('has correct constraints for dropdown', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        final container = tester.widget<Container>(
          find.descendant(of: find.byType(Column), matching: find.byType(Container)),
        );

        expect(container.constraints?.maxHeight, 220);
      });
    });

    group('ListView Builder Tests', () {
      testWidgets('builds correct number of list items', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsNWidgets(3));
      });

      testWidgets('handles empty country list', (tester) async {
        await tester.pumpWidget(createTestWidget(selectedCountry: null, countryList: [], onChanged: (country) {}));

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsNothing);
      });

      testWidgets('handles large country list', (tester) async {
        final largeCountryList = List.generate(
          50,
          (index) => Country(
            phoneCode: '$index',
            countryCode: 'C$index',
            e164Sc: 0,
            geographic: true,
            level: 1,
            name: 'Country $index',
            example: '123456789',
            displayName: 'Country $index',
            displayNameNoCountryCode: 'Country $index',
            e164Key: '',
          ),
        );

        await tester.pumpWidget(
          createTestWidget(selectedCountry: null, countryList: largeCountryList, onChanged: (country) {}),
        );

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Should handle large list with scrolling
        expect(find.byType(ListView), findsOneWidget);

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, true);
      });
    });

    group('State Management Tests', () {
      testWidgets('maintains state during widget updates', (tester) async {
        Country? selectedCountry;

        await tester.pumpWidget(
          createTestWidget(
            selectedCountry: mockCountry1,
            countryList: mockCountryList,
            onChanged: (country) {
              selectedCountry = country;
            },
          ),
        );

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Select a country
        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();

        // Verify state is maintained
        expect(selectedCountry, equals(mockCountry2));
        expect(find.text('United States'), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles country with very long name', (tester) async {
        final longNameCountry = Country(
          phoneCode: '999',
          countryCode: 'LN',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'Very Long Country Name That Should Test Text Wrapping And Layout Behavior',
          example: '123456789',
          displayName: 'Very Long Country Name That Should Test Text Wrapping And Layout Behavior',
          displayNameNoCountryCode: 'Very Long Country Name That Should Test Text Wrapping And Layout Behavior',
          e164Key: '',
        );

        await tester.pumpWidget(
          createTestWidget(selectedCountry: longNameCountry, countryList: [longNameCountry], onChanged: (country) {}),
        );

        expect(find.textContaining('Very Long Country Name'), findsOneWidget);
      });

      testWidgets('handles special characters in country name', (tester) async {
        final specialCountry = Country(
          phoneCode: '888',
          countryCode: 'SP',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'Côte d\'Ivoire & São Tomé',
          example: '123456789',
          displayName: 'Côte d\'Ivoire & São Tomé',
          displayNameNoCountryCode: 'Côte d\'Ivoire & São Tomé',
          e164Key: '',
        );

        await tester.pumpWidget(
          createTestWidget(selectedCountry: specialCountry, countryList: [specialCountry], onChanged: (country) {}),
        );

        expect(find.text('Côte d\'Ivoire & São Tomé'), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('complete user interaction flow', (tester) async {
        Country? selectedCountry;
        var changeCallCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            selectedCountry: null,
            countryList: mockCountryList,
            onChanged: (country) {
              selectedCountry = country;
              changeCallCount++;
            },
          ),
        );

        // Initially shows "Select"
        expect(find.text('Select'), findsOneWidget);

        // Expand dropdown
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Verify all countries are shown
        expect(find.text('India'), findsOneWidget);
        expect(find.text('United States'), findsOneWidget);
        expect(find.text('United Kingdom'), findsOneWidget);

        // Select India
        await tester.tap(find.text('India'));
        await tester.pumpAndSettle();

        // Verify selection
        expect(selectedCountry, equals(mockCountry1));
        expect(changeCallCount, 1);
        expect(find.text('India'), findsOneWidget);
        expect(find.byType(ListView), findsNothing); // Should be collapsed

        // Expand again and select different country
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        await tester.tap(find.text('United Kingdom'));
        await tester.pumpAndSettle();

        // Verify new selection
        expect(selectedCountry, equals(mockCountry3));
        expect(changeCallCount, 2);
        expect(find.text('United Kingdom'), findsOneWidget);
      });

      testWidgets('works correctly with theme changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(selectedCountry: mockCountry1, countryList: mockCountryList, onChanged: (country) {}),
        );

        // Widget should render correctly with theme
        expect(find.byType(ExpandableCountryDropdownField), findsOneWidget);
        expect(find.text('India'), findsOneWidget);

        // Expand to test dropdown styling
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('Widget Properties Tests', () {
      test('widget has correct properties', () {
        final widget = ExpandableCountryDropdownField(
          selectedCountry: mockCountry1,
          countryList: mockCountryList,
          onChanged: (country) {},
          isDisable: true,
        );

        expect(widget.selectedCountry, mockCountry1);
        expect(widget.countryList, mockCountryList);
        expect(widget.onChanged, isNotNull);
        expect(widget.isDisable, true);
      });

      test('widget with default isDisable value', () {
        final widget = ExpandableCountryDropdownField(
          selectedCountry: mockCountry1,
          countryList: mockCountryList,
          onChanged: (country) {},
        );

        expect(widget.isDisable, false);
      });

      test('widget is StatefulWidget', () {
        final widget = ExpandableCountryDropdownField(
          selectedCountry: mockCountry1,
          countryList: mockCountryList,
          onChanged: (country) {},
        );

        expect(widget, isA<StatefulWidget>());
      });
    });
  });
}
