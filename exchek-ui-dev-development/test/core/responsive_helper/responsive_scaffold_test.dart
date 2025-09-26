import 'package:exchek/core/responsive_helper/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveScaffold Widget Tests', () {
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
        home: ResponsiveScaffold(
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
      );
    }

    group('Basic Widget Creation Tests', () {
      testWidgets('should create ResponsiveScaffold with required body parameter', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });

      testWidgets('should create ResponsiveScaffold with all optional parameters', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
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

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    group('Desktop Layout Tests', () {
      testWidgets('should render desktop layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(appBar: testAppBar, drawer: testDrawer, endDrawer: testEndDrawer));

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.text('Test Drawer'), findsOneWidget);

        // Verify desktop-specific layout structure
        final rowWidget = tester.widget<Row>(find.byType(Row));
        expect(rowWidget.children.length, greaterThan(1)); // Should have drawer and expanded content

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should render desktop layout without drawer', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(appBar: testAppBar));

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(SizedBox), findsNothing); // No drawer container
        expect(find.byType(Expanded), findsOneWidget);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should render desktop layout with all scaffold properties', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
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

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // Verify scaffold properties are applied
        final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
        expect(scaffolds.length, greaterThan(0));

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Tablet Layout Tests', () {
      testWidgets('should render tablet layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate tablet
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
          ),
        );

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify scaffold structure for tablet
        final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
        expect(scaffolds.length, equals(1)); // Only one scaffold for tablet

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should render tablet layout with all properties', (WidgetTester tester) async {
        // Set screen size to simulate tablet
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
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

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Mobile Layout Tests', () {
      testWidgets('should render mobile layout correctly', (WidgetTester tester) async {
        // Set screen size to simulate mobile
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
          ),
        );

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify scaffold structure for mobile
        final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
        expect(scaffolds.length, equals(1)); // Only one scaffold for mobile

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should render mobile layout with all properties', (WidgetTester tester) async {
        // Set screen size to simulate mobile
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
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

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Body'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('should switch between layouts based on screen size', (WidgetTester tester) async {
        // Test desktop layout
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(drawer: testDrawer));
        expect(find.byType(Row), findsOneWidget); // Desktop has Row layout

        // Switch to tablet layout
        tester.view.physicalSize = const Size(768, 1024);
        await tester.pumpWidget(createTestWidget(drawer: testDrawer));
        expect(find.byType(Row), findsNothing); // Tablet doesn't have Row layout

        // Switch to mobile layout
        tester.view.physicalSize = const Size(375, 667);
        await tester.pumpWidget(createTestWidget(drawer: testDrawer));
        expect(find.byType(Row), findsNothing); // Mobile doesn't have Row layout

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should handle drawer width calculation on desktop', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(drawer: testDrawer));

        // Verify desktop layout structure
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.text('Test Drawer'), findsOneWidget);

        // Find SizedBox widgets and verify one has the expected drawer width
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final hasDrawerWidth = sizedBoxes.any((box) => box.width == 300);
        expect(hasDrawerWidth, isTrue, reason: 'Should have a SizedBox with width 300 for desktop drawer');

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should handle tablet drawer width calculation', (WidgetTester tester) async {
        // Set screen size to simulate tablet
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(drawer: testDrawer));

        // For tablet, drawer is handled by standard Scaffold, not custom Row layout
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(Row), findsNothing); // No Row layout for tablet
        expect(find.byType(Scaffold), findsOneWidget);

        // Verify drawer is configured but not visible (drawers are hidden by default)
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.drawer, isNotNull);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should handle mobile drawer correctly', (WidgetTester tester) async {
        // Set screen size to simulate mobile
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(drawer: testDrawer));

        // For mobile, drawer is handled by standard Scaffold, not custom Row layout
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(Row), findsNothing); // No Row layout for mobile
        expect(find.byType(Scaffold), findsOneWidget);

        // Verify drawer is configured but not visible (drawers are hidden by default)
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.drawer, isNotNull);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Edge Cases and Property Tests', () {
      testWidgets('should handle null drawer on desktop', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(drawer: null));

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);

        // Verify no drawer is present
        expect(find.text('Test Drawer'), findsNothing);

        // Verify Row has only one child (Expanded) when no drawer
        final rowWidget = tester.widget<Row>(find.byType(Row));
        expect(rowWidget.children.length, equals(1));

        // Reset the screen size
        addTearDown(tester.view.reset);
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
            createTestWidget(floatingActionButton: testFloatingActionButton, floatingActionButtonLocation: location),
          );

          expect(find.byType(ResponsiveScaffold), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        }
      });

      testWidgets('should handle different background colors', (WidgetTester tester) async {
        final colors = [Colors.red, Colors.green, Colors.blue, Colors.transparent, const Color(0xFF123456)];

        for (final color in colors) {
          await tester.pumpWidget(createTestWidget(backgroundColor: color));

          expect(find.byType(ResponsiveScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
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
              extendBody: combination[0],
              extendBodyBehindAppBar: combination[1],
              resizeToAvoidBottomInset: combination[2],
              primary: combination[3],
              drawerEnableOpenDragGesture: combination[4],
              endDrawerEnableOpenDragGesture: combination[5],
            ),
          );

          expect(find.byType(ResponsiveScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
        }
      });

      testWidgets('should handle different drawerEdgeDragWidth values', (WidgetTester tester) async {
        final widthValues = [null, 0.0, 10.0, 20.0, 50.0, 100.0];

        for (final width in widthValues) {
          await tester.pumpWidget(createTestWidget(drawer: testDrawer, drawerEdgeDragWidth: width));

          expect(find.byType(ResponsiveScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
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
            body: complexBody,
            appBar: testAppBar,
            drawer: testDrawer,
            endDrawer: testEndDrawer,
            bottomNavigationBar: testBottomNavigationBar,
            floatingActionButton: testFloatingActionButton,
          ),
        );

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('should handle drawer interactions on desktop', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(appBar: testAppBar, drawer: testDrawer));

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.text('Test Drawer'), findsOneWidget); // Drawer is always visible on desktop

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should handle all scaffold properties in different layouts', (WidgetTester tester) async {
        final screenSizes = [
          const Size(1920, 1080), // Desktop
          const Size(768, 1024), // Tablet
          const Size(375, 667), // Mobile
        ];

        for (final size in screenSizes) {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            createTestWidget(
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

          expect(find.byType(ResponsiveScaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        }

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Constructor and Default Values Tests', () {
      testWidgets('should use correct default values', (WidgetTester tester) async {
        const scaffold = ResponsiveScaffold(body: Text('Test'));

        expect(scaffold.extendBody, equals(false));
        expect(scaffold.extendBodyBehindAppBar, equals(false));
        expect(scaffold.resizeToAvoidBottomInset, equals(true));
        expect(scaffold.primary, equals(true));
        expect(scaffold.drawerEnableOpenDragGesture, equals(true));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(true));
      });

      testWidgets('should accept custom values for all properties', (WidgetTester tester) async {
        final scaffold = ResponsiveScaffold(
          body: const Text('Test'),
          appBar: testAppBar,
          drawer: testDrawer,
          endDrawer: testEndDrawer,
          bottomNavigationBar: testBottomNavigationBar,
          floatingActionButton: testFloatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          backgroundColor: Colors.red,
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomSheet: testBottomSheet,
          resizeToAvoidBottomInset: false,
          primary: false,
          drawerEdgeDragWidth: 25.0,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
        );

        expect(scaffold.body, isA<Text>());
        expect(scaffold.appBar, equals(testAppBar));
        expect(scaffold.drawer, equals(testDrawer));
        expect(scaffold.endDrawer, equals(testEndDrawer));
        expect(scaffold.bottomNavigationBar, equals(testBottomNavigationBar));
        expect(scaffold.floatingActionButton, equals(testFloatingActionButton));
        expect(scaffold.floatingActionButtonLocation, equals(FloatingActionButtonLocation.endFloat));
        expect(scaffold.backgroundColor, equals(Colors.red));
        expect(scaffold.extendBody, equals(true));
        expect(scaffold.extendBodyBehindAppBar, equals(true));
        expect(scaffold.bottomSheet, equals(testBottomSheet));
        expect(scaffold.resizeToAvoidBottomInset, equals(false));
        expect(scaffold.primary, equals(false));
        expect(scaffold.drawerEdgeDragWidth, equals(25.0));
        expect(scaffold.drawerEnableOpenDragGesture, equals(false));
        expect(scaffold.endDrawerEnableOpenDragGesture, equals(false));
      });
    });
  });
}
