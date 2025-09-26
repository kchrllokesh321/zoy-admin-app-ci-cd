import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock widget to test the web behavior
class MockGetHelpTextButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isWeb;

  const MockGetHelpTextButton({super.key, this.onTap, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    // Simulate web behavior
    if (isWeb && ResponsiveHelper.getScreenWidth(context) >= 1200) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSizedBoxH(10.0),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Get Help',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 13.0, desktop: 14.0),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
            ),
          ),
        ),
        buildSizedBoxH(20.0),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to create test widget with different screen sizes
  Widget createTestWidget({
    VoidCallback? onTap,
    Size screenSize = const Size(400, 800), // Default mobile size
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme ?? ThemeData.light(),
      localizationsDelegates: const [
        Lang.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: MediaQuery(data: MediaQueryData(size: screenSize), child: Scaffold(body: GetHelpTextButton(onTap: onTap))),
    );
  }

  group('GetHelpTextButton Tests', () {
    testWidgets('renders GetHelpTextButton on mobile screen', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the main widget structure
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders normal widget on desktop screen in test environment', (tester) async {
      // In test environment, kIsWeb is false, so it will render normally
      await tester.pumpWidget(createTestWidget(screenSize: const Size(1400, 800)));
      await tester.pumpAndSettle();

      // In test environment, it should render the button normally
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('renders GetHelpTextButton on web mobile screen', (tester) async {
      // Create a mobile-sized screen even on web (width < 600)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(500, 800)));
      await tester.pumpAndSettle();

      // On web mobile, it should render the button
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('renders GetHelpTextButton on tablet screen', (tester) async {
      // Create a tablet-sized screen (600 <= width < 1200)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();

      // On tablet, it should render the button
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('displays correct help text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the help text is displayed (using byType since localization might vary)
      expect(find.byType(Text), findsOneWidget);

      // Verify the text widget contains some content
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.data, isNotNull);
      expect(textWidget.data!.isNotEmpty, isTrue);
    });

    testWidgets('has correct Column properties', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      expect(column.children.length, 3); // Two SizedBox and one GestureDetector
    });

    testWidgets('has correct SizedBox spacing', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find SizedBox widgets with specific heights
      final sizedBox10 = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 10.0);
      final sizedBox20 = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 20.0);

      expect(sizedBox10, findsOneWidget);
      expect(sizedBox20, findsOneWidget);
    });

    testWidgets('text has correct styling on mobile', (tester) async {
      await tester.pumpWidget(createTestWidget(screenSize: const Size(400, 800)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 12.0); // Mobile font size
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.decoration, TextDecoration.underline);
      expect(text.style?.decorationThickness, 1.5);
    });

    testWidgets('text has correct styling on tablet', (tester) async {
      await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 13.0); // Tablet font size
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.decoration, TextDecoration.underline);
      expect(text.style?.decorationThickness, 1.5);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        createTestWidget(
          onTap: () {
            wasTapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tap the help text
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('handles null onTap callback', (tester) async {
      await tester.pumpWidget(createTestWidget(onTap: null));
      await tester.pumpAndSettle();

      // Should not throw when tapping with null callback
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Widget should still be present
      expect(find.byType(GetHelpTextButton), findsOneWidget);
    });

    testWidgets('works with custom theme', (tester) async {
      final customTheme = ThemeData(textTheme: const TextTheme(labelSmall: TextStyle(color: Colors.red)));

      await tester.pumpWidget(createTestWidget(theme: customTheme));
      await tester.pumpAndSettle();

      // Verify widget renders with custom theme
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('widget key is properly set', (tester) async {
      const testKey = Key('test_help_button');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            Lang.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Scaffold(body: GetHelpTextButton(key: testKey, onTap: () {})),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(testKey), findsOneWidget);
    });
  });

  group('Responsive Behavior Tests', () {
    testWidgets('responsive behavior on different screen sizes', (tester) async {
      // Test mobile (< 600px)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(500, 800)));
      await tester.pumpAndSettle();
      expect(find.byType(Column), findsOneWidget);

      // Test tablet (600-1199px)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();
      expect(find.byType(Column), findsOneWidget);

      // Test desktop (>= 1200px) - in test environment, still shows normal widget
      await tester.pumpWidget(createTestWidget(screenSize: const Size(1400, 800)));
      await tester.pumpAndSettle();
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GetHelpTextButton), findsOneWidget);
    });

    testWidgets('font size changes based on screen size', (tester) async {
      // Mobile font size
      await tester.pumpWidget(createTestWidget(screenSize: const Size(400, 800)));
      await tester.pumpAndSettle();
      Text mobileText = tester.widget<Text>(find.byType(Text));
      expect(mobileText.style?.fontSize, 12.0);

      // Tablet font size
      await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 600)));
      await tester.pumpAndSettle();
      Text tabletText = tester.widget<Text>(find.byType(Text));
      expect(tabletText.style?.fontSize, 13.0);
    });
  });

  group('Edge Cases Tests', () {
    testWidgets('handles very small screen sizes', (tester) async {
      await tester.pumpWidget(createTestWidget(screenSize: const Size(200, 400)));
      await tester.pumpAndSettle();

      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('handles very large screen sizes', (tester) async {
      await tester.pumpWidget(createTestWidget(screenSize: const Size(2000, 1200)));
      await tester.pumpAndSettle();

      // In test environment, should render normally even on large screens
      expect(find.byType(GetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('multiple taps work correctly', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(
        createTestWidget(
          onTap: () {
            tapCount++;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tap multiple times
      await tester.tap(find.byType(GestureDetector));
      await tester.tap(find.byType(GestureDetector));
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(tapCount, 3);
    });
  });

  group('Web Behavior Simulation Tests', () {
    Widget createMockTestWidget({VoidCallback? onTap, Size screenSize = const Size(400, 800), bool isWeb = false}) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Scaffold(body: MockGetHelpTextButton(onTap: onTap, isWeb: isWeb)),
        ),
      );
    }

    testWidgets('simulates web desktop behavior with SizedBox.shrink', (tester) async {
      await tester.pumpWidget(createMockTestWidget(screenSize: const Size(1400, 800), isWeb: true));
      await tester.pumpAndSettle();

      // Should render SizedBox.shrink on web desktop
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Column), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('simulates web mobile behavior with normal widget', (tester) async {
      await tester.pumpWidget(createMockTestWidget(screenSize: const Size(500, 800), isWeb: true));
      await tester.pumpAndSettle();

      // Should render normally on web mobile
      expect(find.byType(MockGetHelpTextButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('desktop font size in mock widget', (tester) async {
      await tester.pumpWidget(
        createMockTestWidget(
          screenSize: const Size(1400, 800),
          isWeb: false, // Non-web desktop
        ),
      );
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Get Help'));
      expect(text.style?.fontSize, 14.0); // Desktop font size
    });
  });

  group('Coverage Completion Tests', () {
    testWidgets('tests all constructor parameters', (tester) async {
      // Test with null onTap
      await tester.pumpWidget(createTestWidget(onTap: null));
      await tester.pumpAndSettle();
      expect(find.byType(GetHelpTextButton), findsOneWidget);

      // Test with non-null onTap
      bool tapped = false;
      await tester.pumpWidget(createTestWidget(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('tests buildSizedBoxH function coverage', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify both SizedBox widgets are created by buildSizedBoxH
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, 2);

      // Check heights
      final heights = sizedBoxes.map((box) => box.height).toList();
      expect(heights, containsAll([10.0, 20.0]));
    });

    testWidgets('tests all responsive breakpoints', (tester) async {
      // Test exact breakpoint boundaries based on ResponsiveHelper implementation
      // Mobile: < 600, Tablet: 600-1279, Desktop: >= 1280

      // Mobile (< 600)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(599, 800)));
      await tester.pumpAndSettle();
      Text mobileText = tester.widget<Text>(find.byType(Text));
      expect(mobileText.style?.fontSize, 12.0);

      // Tablet (600-1279)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(600, 800)));
      await tester.pumpAndSettle();
      Text tabletText = tester.widget<Text>(find.byType(Text));
      expect(tabletText.style?.fontSize, 13.0);

      // Desktop (>= 1280)
      await tester.pumpWidget(createTestWidget(screenSize: const Size(1280, 800)));
      await tester.pumpAndSettle();
      Text desktopText = tester.widget<Text>(find.byType(Text));
      expect(desktopText.style?.fontSize, 14.0);
    });

    testWidgets('tests theme integration', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.byType(Text));

      // Verify style properties are applied
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.decoration, TextDecoration.underline);
      expect(text.style?.decorationThickness, 1.5);
    });
  });
}
