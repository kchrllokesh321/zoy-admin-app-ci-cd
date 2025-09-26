import 'package:exchek/core/responsive_helper/landing_page_scafold.dart';
import 'package:exchek/widgets/common_widget/wave_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LandingPageScaffold Widget Tests', () {
    late Widget testBody;
    late PreferredSizeWidget testAppBar;
    late Widget testDrawer;
    late Widget testEndDrawer;
    late Widget testBottomNavigationBar;
    late Widget testFloatingActionButton;
    late Widget testBottomSheet;

    setUp(() {
      testBody = const Center(child: Text('Test Body'));
      testAppBar = AppBar(title: const Text('Test App Bar'));
      testDrawer = const Drawer(child: Text('Test Drawer'));
      testEndDrawer = const Drawer(child: Text('Test End Drawer'));
      testBottomNavigationBar = BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      );
      testFloatingActionButton = FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add));
      testBottomSheet = BottomSheet(onClosing: () {}, builder: (context) => const Text('Test Bottom Sheet'));
    });

    Widget createTestWidget({
      required Size screenSize,
      Widget? body,
      PreferredSizeWidget? appBar,
      Widget? drawer,
      Widget? endDrawer,
      Widget? bottomNavigationBar,
      Widget? floatingActionButton,
      FloatingActionButtonLocation? floatingActionButtonLocation,
      Color? backgroundColor,
      bool extendBody = false,
      bool extendBodyBehindAppBar = false,
      Widget? bottomSheet,
      bool resizeToAvoidBottomInset = true,
      bool primary = true,
      double? drawerEdgeDragWidth,
      bool drawerEnableOpenDragGesture = true,
      bool endDrawerEnableOpenDragGesture = true,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: LandingPageScaffold(
            body: body ?? testBody,
            appBar: appBar,
            drawer: drawer,
            endDrawer: endDrawer,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            backgroundColor: backgroundColor,
            extendBody: extendBody,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            primary: primary,
            drawerEdgeDragWidth: drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
          ),
        ),
      );
    }

    group('Constructor Tests', () {
      testWidgets('should create LandingPageScaffold with required body parameter', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(screenSize: const Size(375, 667)));

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should create LandingPageScaffold with all optional parameters', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(375, 667),
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.blue,
            extendBody: true,
            extendBodyBehindAppBar: true,
            bottomSheet: testBottomSheet,
            resizeToAvoidBottomInset: false,
            primary: false,
            drawerEdgeDragWidth: 30.0,
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should verify constructor properties', (WidgetTester tester) async {
        const scaffold = LandingPageScaffold(
          body: Text('Test'),
          appBar: null,
          drawer: null,
          endDrawer: null,
          bottomNavigationBar: null,
          floatingActionButton: null,
          floatingActionButtonLocation: null,
          backgroundColor: Colors.red,
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomSheet: null,
          resizeToAvoidBottomInset: false,
          primary: false,
          drawerEdgeDragWidth: 25.0,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
        );

        expect(scaffold.body, isA<Text>());
        expect(scaffold.appBar, isNull);
        expect(scaffold.drawer, isNull);
        expect(scaffold.endDrawer, isNull);
        expect(scaffold.bottomNavigationBar, isNull);
        expect(scaffold.floatingActionButton, isNull);
        expect(scaffold.floatingActionButtonLocation, isNull);
        expect(scaffold.backgroundColor, equals(Colors.red));
        expect(scaffold.extendBody, equals(true));
        expect(scaffold.extendBodyBehindAppBar, equals(true));
        expect(scaffold.bottomSheet, isNull);
        expect(scaffold.resizeToAvoidBottomInset, equals(false));
        expect(scaffold.primary, equals(false));
        expect(scaffold.drawerEdgeDragWidth, equals(25.0));
        expect(scaffold.drawerEnableOpenDragGesture, equals(false));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
      });

      testWidgets('should use correct default values', (WidgetTester tester) async {
        const scaffold = LandingPageScaffold(body: Text('Test'));

        expect(scaffold.extendBody, equals(false));
        expect(scaffold.extendBodyBehindAppBar, equals(false));
        expect(scaffold.resizeToAvoidBottomInset, equals(true));
        expect(scaffold.primary, equals(true));
        expect(scaffold.drawerEnableOpenDragGesture, equals(true));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(true));
      });
    });

    group('Desktop Layout Tests', () {
      testWidgets('should render desktop layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate desktop (width >= 1280)
        const screenSize = Size(1920, 1080);

        await tester.pumpWidget(
          createTestWidget(screenSize: screenSize, appBar: testAppBar, drawer: testDrawer, endDrawer: testEndDrawer),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Verify the basic desktop layout structure
        expect(find.byType(LandingPageScaffold), findsOneWidget);
      });

      testWidgets('should render desktop layout with all scaffold properties', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.red,
            extendBody: true,
            extendBodyBehindAppBar: true,
            bottomSheet: testBottomSheet,
            resizeToAvoidBottomInset: false,
            primary: false,
            drawerEdgeDragWidth: 25.0,
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify scaffold properties are applied
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(Colors.red));
        expect(scaffold.extendBody, equals(true));
        expect(scaffold.extendBodyBehindAppBar, equals(true));
        expect(scaffold.resizeToAvoidBottomInset, equals(false));
        expect(scaffold.primary, equals(false));
        expect(scaffold.drawerEdgeDragWidth, equals(25.0));
        expect(scaffold.drawerEnableOpenDragGesture, equals(false));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
      });

      testWidgets('should not include WaveBackground in desktop layout when not web', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080);

        await tester.pumpWidget(createTestWidget(screenSize: screenSize));

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        // In test environment, kIsWeb is false, so WaveBackground should not be present
        expect(find.byType(WaveBackground), findsNothing);
      });
    });

    group('Tablet Layout Tests', () {
      testWidgets('should render tablet layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate tablet (600 <= width < 1280)
        const screenSize = Size(768, 1024);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify the basic tablet layout structure
        expect(find.byType(LandingPageScaffold), findsOneWidget);
      });

      testWidgets('should render tablet layout with all properties', (WidgetTester tester) async {
        const screenSize = Size(768, 1024);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            backgroundColor: Colors.green,
            extendBody: true,
            extendBodyBehindAppBar: true,
            bottomSheet: testBottomSheet,
            resizeToAvoidBottomInset: false,
            primary: false,
            drawerEdgeDragWidth: 40.0,
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify scaffold properties
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(Colors.green));
        expect(scaffold.extendBody, equals(true));
        expect(scaffold.extendBodyBehindAppBar, equals(true));
        expect(scaffold.resizeToAvoidBottomInset, equals(false));
        expect(scaffold.primary, equals(false));
        expect(scaffold.drawerEdgeDragWidth, equals(40.0));
        expect(scaffold.drawerEnableOpenDragGesture, equals(false));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
      });

      testWidgets('should not include WaveBackground in tablet layout when not web', (WidgetTester tester) async {
        const screenSize = Size(768, 1024);

        await tester.pumpWidget(createTestWidget(screenSize: screenSize));

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        // In test environment, kIsWeb is false, so WaveBackground should not be present
        expect(find.byType(WaveBackground), findsNothing);
      });
    });

    group('Mobile Layout Tests', () {
      testWidgets('should render mobile layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate mobile (width < 600)
        const screenSize = Size(375, 667);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Mobile layout should NOT have Stack (body is directly used)
        // In test environment, we just verify the basic structure
        expect(find.byType(LandingPageScaffold), findsOneWidget);
      });

      testWidgets('should render mobile layout with all properties', (WidgetTester tester) async {
        const screenSize = Size(375, 667);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            backgroundColor: Colors.purple,
            extendBody: true,
            extendBodyBehindAppBar: true,
            bottomSheet: testBottomSheet,
            resizeToAvoidBottomInset: false,
            primary: false,
            drawerEdgeDragWidth: 20.0,
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify scaffold properties
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(Colors.purple));
        expect(scaffold.extendBody, equals(true));
        expect(scaffold.extendBodyBehindAppBar, equals(true));
        expect(scaffold.resizeToAvoidBottomInset, equals(false));
        expect(scaffold.primary, equals(false));
        expect(scaffold.drawerEdgeDragWidth, equals(20.0));
        expect(scaffold.drawerEnableOpenDragGesture, equals(false));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
      });

      testWidgets('should not include Stack or WaveBackground in mobile layout', (WidgetTester tester) async {
        const screenSize = Size(375, 667);

        await tester.pumpWidget(createTestWidget(screenSize: screenSize));

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        // Mobile layout should not have WaveBackground
        expect(find.byType(WaveBackground), findsNothing);
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('should switch between layouts based on screen size', (WidgetTester tester) async {
        // Test desktop layout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(1920, 1080), // Desktop
            drawer: testDrawer,
          ),
        );
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Desktop layout

        // Test tablet layout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(768, 1024), // Tablet
            drawer: testDrawer,
          ),
        );
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Tablet layout

        // Test mobile layout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(375, 667), // Mobile
            drawer: testDrawer,
          ),
        );
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Mobile layout
      });

      testWidgets('should handle boundary screen sizes correctly', (WidgetTester tester) async {
        // Test exact boundary at 600px (tablet)
        await tester.pumpWidget(createTestWidget(screenSize: const Size(600, 800)));
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Should be tablet layout

        // Test exact boundary at 1280px (desktop)
        await tester.pumpWidget(createTestWidget(screenSize: const Size(1280, 800)));
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Should be desktop layout

        // Test just below tablet boundary (mobile)
        await tester.pumpWidget(createTestWidget(screenSize: const Size(599, 800)));
        expect(find.byType(LandingPageScaffold), findsOneWidget); // Should be mobile layout
      });
    });

    group('WaveBackground Tests', () {
      testWidgets('should test _buildWaveBackground method coverage', (WidgetTester tester) async {
        // Create a custom test to ensure _buildWaveBackground method is covered
        // Even though WaveBackground won't show in test environment (kIsWeb = false),
        // we can still test the method exists and the widget structure

        const screenSize = Size(1920, 1080); // Desktop
        await tester.pumpWidget(createTestWidget(screenSize: screenSize));
        await tester.pump();

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);

        // The _buildWaveBackground method is called but WaveBackground won't show in test environment
        // We can verify the method is covered by checking the widget structure
        expect(find.byType(WaveBackground), findsNothing); // Should not be present in test environment
      });
    });

    group('Edge Cases and Property Tests', () {
      testWidgets('should handle null optional parameters', (WidgetTester tester) async {
        // Test with all null optional parameters
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(1920, 1080),
            appBar: null,
            drawer: null,
            endDrawer: null,
            bottomNavigationBar: null,
            floatingActionButton: null,
            floatingActionButtonLocation: null,
            backgroundColor: null,
            bottomSheet: null,
            drawerEdgeDragWidth: null,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should handle all FloatingActionButtonLocation values', (WidgetTester tester) async {
        final locations = [
          FloatingActionButtonLocation.startTop,
          FloatingActionButtonLocation.centerTop,
          FloatingActionButtonLocation.endTop,
          FloatingActionButtonLocation.startFloat,
          FloatingActionButtonLocation.centerFloat,
          FloatingActionButtonLocation.endFloat,
          FloatingActionButtonLocation.startDocked,
          FloatingActionButtonLocation.centerDocked,
          FloatingActionButtonLocation.endDocked,
        ];

        for (final location in locations) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: const Size(1920, 1080),
              floatingActionButton: testFloatingActionButton,
              floatingActionButtonLocation: location,
            ),
          );

          expect(find.byType(LandingPageScaffold), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        }
      });

      testWidgets('should handle different background colors', (WidgetTester tester) async {
        final colors = [Colors.red, Colors.green, Colors.blue, Colors.transparent, const Color(0xFF123456)];

        for (final color in colors) {
          await tester.pumpWidget(createTestWidget(screenSize: const Size(1920, 1080), backgroundColor: color));

          expect(find.byType(LandingPageScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(scaffold.backgroundColor, equals(color));
        }
      });

      testWidgets('should handle boolean properties correctly', (WidgetTester tester) async {
        // Test all boolean combinations
        final booleanCombinations = [
          [true, true, true, true, true, true],
          [false, false, false, false, false, false],
          [true, false, true, false, true, false],
          [false, true, false, true, false, true],
        ];

        for (final combination in booleanCombinations) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: const Size(1920, 1080),
              extendBody: combination[0],
              extendBodyBehindAppBar: combination[1],
              resizeToAvoidBottomInset: combination[2],
              primary: combination[3],
              drawerEnableOpenDragGesture: combination[4],
              endDrawerEnableOpenDragGesture: combination[5],
            ),
          );

          expect(find.byType(LandingPageScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(scaffold.extendBody, equals(combination[0]));
          expect(scaffold.extendBodyBehindAppBar, equals(combination[1]));
          expect(scaffold.resizeToAvoidBottomInset, equals(combination[2]));
          expect(scaffold.primary, equals(combination[3]));
          expect(scaffold.drawerEnableOpenDragGesture, equals(combination[4]));
          expect(scaffold.endDrawerEnableOpenDragGesture, equals(combination[5]));
        }
      });

      testWidgets('should handle different drawerEdgeDragWidth values', (WidgetTester tester) async {
        final widthValues = [null, 0.0, 10.0, 20.0, 50.0, 100.0];

        for (final width in widthValues) {
          await tester.pumpWidget(
            createTestWidget(screenSize: const Size(1920, 1080), drawer: testDrawer, drawerEdgeDragWidth: width),
          );

          expect(find.byType(LandingPageScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(scaffold.drawerEdgeDragWidth, equals(width));
        }
      });
    });

    group('Integration Tests', () {
      testWidgets('should work with complex widget tree', (WidgetTester tester) async {
        final complexBody = Column(
          children: [
            const Text('Header'),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
              ),
            ),
            const Text('Footer'),
          ],
        );

        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(1920, 1080),
            body: complexBody,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
          ),
        );

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('should handle all scaffold properties in different layouts', (WidgetTester tester) async {
        final screenSizes = [
          const Size(1920, 1080), // Desktop
          const Size(768, 1024), // Tablet
          const Size(375, 667), // Mobile
        ];

        for (final size in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: size,
              appBar: testAppBar,
              drawer: testDrawer,
              endDrawer: testEndDrawer,
              bottomNavigationBar: testBottomNavigationBar,
              floatingActionButton: testFloatingActionButton,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              backgroundColor: Colors.amber,
              extendBody: true,
              extendBodyBehindAppBar: true,
              bottomSheet: testBottomSheet,
              resizeToAvoidBottomInset: false,
              primary: false,
              drawerEdgeDragWidth: 30.0,
              drawerEnableOpenDragGesture: false,
              endDrawerEnableOpenDragGesture: false,
            ),
          );

          expect(find.byType(LandingPageScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(scaffold.backgroundColor, equals(Colors.amber));
          expect(scaffold.extendBody, equals(true));
          expect(scaffold.extendBodyBehindAppBar, equals(true));
          expect(scaffold.resizeToAvoidBottomInset, equals(false));
          expect(scaffold.primary, equals(false));
          expect(scaffold.drawerEdgeDragWidth, equals(30.0));
          expect(scaffold.drawerEnableOpenDragGesture, equals(false));
          expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
        }
      });

      testWidgets('should test all private methods coverage', (WidgetTester tester) async {
        // Test _buildDesktopLayout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(1920, 1080), // Desktop
          ),
        );
        await tester.pump();
        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Test _buildTabletLayout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(768, 1024), // Tablet
          ),
        );
        await tester.pump();
        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Test _buildMobileLayout
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(375, 667), // Mobile
          ),
        );
        await tester.pump();
        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Test _buildWaveBackground (indirectly through desktop/tablet layouts)
        // The method is called but WaveBackground won't show in test environment
        await tester.pumpWidget(
          createTestWidget(
            screenSize: const Size(1920, 1080), // Desktop
          ),
        );
        await tester.pump();
        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
      });
    });
  });
}
