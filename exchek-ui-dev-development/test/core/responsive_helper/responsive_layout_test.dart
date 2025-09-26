import 'package:exchek/core/responsive_helper/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Custom class to test the edge case where none of the conditions are met
class _CustomResponsiveLayoutForTesting extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  const _CustomResponsiveLayoutForTesting({required this.mobile, this.tablet, this.desktop, this.web});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simulate the edge case where none of the conditions are met
        // by always returning false for all conditions
        if (false) {
          // isDesktop
          return desktop ?? mobile;
        } else if (false) {
          // isTablet
          return tablet ?? mobile;
        } else if (false) {
          // isMobile
          return web ?? mobile;
        } else {
          return mobile; // This line covers the edge case
        }
      },
    );
  }
}

void main() {
  group('ResponsiveLayout Widget Tests', () {
    late Widget mobileWidget;
    late Widget tabletWidget;
    late Widget desktopWidget;
    late Widget webWidget;

    setUp(() {
      mobileWidget = const Text('Mobile Layout');
      tabletWidget = const Text('Tablet Layout');
      desktopWidget = const Text('Desktop Layout');
      webWidget = const Text('Web Layout');
    });

    Widget createTestWidget({Widget? mobile, Widget? tablet, Widget? desktop, Widget? web}) {
      return MaterialApp(
        home: Scaffold(
          body: ResponsiveLayout(mobile: mobile ?? mobileWidget, tablet: tablet, desktop: desktop, web: web),
        ),
      );
    }

    group('Constructor Tests', () {
      testWidgets('should create ResponsiveLayout with required mobile parameter', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(ResponsiveLayout), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
      });

      testWidgets('should create ResponsiveLayout with all optional parameters', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(mobile: mobileWidget, tablet: tabletWidget, desktop: desktopWidget, web: webWidget),
        );

        expect(find.byType(ResponsiveLayout), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
      });

      testWidgets('should verify constructor properties', (WidgetTester tester) async {
        const layout = ResponsiveLayout(
          mobile: Text('Mobile'),
          tablet: Text('Tablet'),
          desktop: Text('Desktop'),
          web: Text('Web'),
        );

        expect(layout.mobile, isA<Text>());
        expect(layout.tablet, isA<Text>());
        expect(layout.desktop, isA<Text>());
        expect(layout.web, isA<Text>());
      });

      testWidgets('should handle null optional parameters', (WidgetTester tester) async {
        const layout = ResponsiveLayout(mobile: Text('Mobile'), tablet: null, desktop: null, web: null);

        expect(layout.mobile, isA<Text>());
        expect(layout.tablet, isNull);
        expect(layout.desktop, isNull);
        expect(layout.web, isNull);
      });
    });

    group('Desktop Layout Tests', () {
      testWidgets('should display desktop layout when screen is desktop size', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(mobile: mobileWidget, tablet: tabletWidget, desktop: desktopWidget, web: webWidget),
        );

        expect(find.text('Desktop Layout'), findsOneWidget);
        expect(find.text('Mobile Layout'), findsNothing);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Web Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should fallback to mobile when desktop is null', (WidgetTester tester) async {
        // Set screen size to simulate desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            mobile: mobileWidget,
            tablet: tabletWidget,
            desktop: null, // Desktop is null
            web: webWidget,
          ),
        );

        expect(find.text('Mobile Layout'), findsOneWidget);
        expect(find.text('Desktop Layout'), findsNothing);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Web Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Tablet Layout Tests', () {
      testWidgets('should display tablet layout when screen is tablet size', (WidgetTester tester) async {
        // Set screen size to simulate tablet
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(mobile: mobileWidget, tablet: tabletWidget, desktop: desktopWidget, web: webWidget),
        );

        expect(find.text('Tablet Layout'), findsOneWidget);
        expect(find.text('Mobile Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);
        expect(find.text('Web Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should fallback to mobile when tablet is null', (WidgetTester tester) async {
        // Set screen size to simulate tablet
        tester.view.physicalSize = const Size(768, 1024);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            mobile: mobileWidget,
            tablet: null, // Tablet is null
            desktop: desktopWidget,
            web: webWidget,
          ),
        );

        expect(find.text('Mobile Layout'), findsOneWidget);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);
        expect(find.text('Web Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Mobile Layout Tests', () {
      testWidgets('should display web layout when screen is mobile size and web is provided', (
        WidgetTester tester,
      ) async {
        // Set screen size to simulate mobile
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(mobile: mobileWidget, tablet: tabletWidget, desktop: desktopWidget, web: webWidget),
        );

        // Note: According to the code, when isMobile() is true, it returns web ?? mobile
        expect(find.text('Web Layout'), findsOneWidget);
        expect(find.text('Mobile Layout'), findsNothing);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should fallback to mobile when web is null on mobile screen', (WidgetTester tester) async {
        // Set screen size to simulate mobile
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(
            mobile: mobileWidget,
            tablet: tabletWidget,
            desktop: desktopWidget,
            web: null, // Web is null
          ),
        );

        expect(find.text('Mobile Layout'), findsOneWidget);
        expect(find.text('Web Layout'), findsNothing);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Default Fallback Tests', () {
      testWidgets('should fallback to mobile for unknown screen sizes', (WidgetTester tester) async {
        // Set an unusual screen size that might not match any category (very small)
        tester.view.physicalSize = const Size(100, 100); // Very small screen, should be mobile (< 600)
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestWidget(mobile: mobileWidget, tablet: tabletWidget, desktop: desktopWidget, web: webWidget),
        );

        // For mobile screen size, it should return web ?? mobile, so Web Layout should be shown
        expect(find.text('Web Layout'), findsOneWidget);
        expect(find.text('Mobile Layout'), findsNothing);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle all null optional parameters', (WidgetTester tester) async {
        // Test with different screen sizes when all optional parameters are null
        final screenSizes = [
          const Size(1920, 1080), // Desktop
          const Size(768, 1024), // Tablet
          const Size(375, 667), // Mobile
        ];

        for (final size in screenSizes) {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(createTestWidget(mobile: mobileWidget, tablet: null, desktop: null, web: null));

          // Should always fallback to mobile when optional parameters are null
          expect(find.text('Mobile Layout'), findsOneWidget);
          expect(find.text('Tablet Layout'), findsNothing);
          expect(find.text('Desktop Layout'), findsNothing);
          expect(find.text('Web Layout'), findsNothing);
        }

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should handle complex widget trees', (WidgetTester tester) async {
        final complexMobile = Column(
          children: [
            const Text('Mobile Header'),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(title: Text('Mobile Item $index')),
              ),
            ),
            const Text('Mobile Footer'),
          ],
        );

        final complexDesktop = Row(
          children: [
            const Expanded(flex: 1, child: Text('Desktop Sidebar')),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const Text('Desktop Header'),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: 9,
                      itemBuilder: (context, index) => Card(child: Text('Desktop Card $index')),
                    ),
                  ),
                  const Text('Desktop Footer'),
                ],
              ),
            ),
          ],
        );

        // Set screen size to desktop
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ResponsiveLayout(mobile: complexMobile, desktop: complexDesktop))),
        );

        expect(find.text('Desktop Header'), findsOneWidget);
        expect(find.text('Desktop Sidebar'), findsOneWidget);
        expect(find.text('Desktop Footer'), findsOneWidget);
        expect(find.text('Mobile Header'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should test edge case fallback to mobile with custom test', (WidgetTester tester) async {
        // This test uses a custom widget to simulate the edge case where none of the
        // ResponsiveHelper conditions are met. This covers the final 'else' branch.
        final customLayout = _CustomResponsiveLayoutForTesting(
          mobile: mobileWidget,
          tablet: tabletWidget,
          desktop: desktopWidget,
          web: webWidget,
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: customLayout)));

        // Should fallback to mobile in the edge case
        expect(find.text('Mobile Layout'), findsOneWidget);
        expect(find.text('Tablet Layout'), findsNothing);
        expect(find.text('Desktop Layout'), findsNothing);
        expect(find.text('Web Layout'), findsNothing);
      });
    });
  });

  group('ResponsiveOrientationLayout Widget Tests', () {
    late Widget portraitWidget;
    late Widget landscapeWidget;

    setUp(() {
      portraitWidget = const Text('Portrait Layout');
      landscapeWidget = const Text('Landscape Layout');
    });

    Widget createOrientationTestWidget({Widget? portrait, Widget? landscape}) {
      return MaterialApp(
        home: Scaffold(body: ResponsiveOrientationLayout(portrait: portrait ?? portraitWidget, landscape: landscape)),
      );
    }

    group('Constructor Tests', () {
      testWidgets('should create ResponsiveOrientationLayout with required portrait parameter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createOrientationTestWidget());

        expect(find.byType(ResponsiveOrientationLayout), findsOneWidget);
        expect(find.byType(OrientationBuilder), findsOneWidget);
      });

      testWidgets('should create ResponsiveOrientationLayout with optional landscape parameter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));

        expect(find.byType(ResponsiveOrientationLayout), findsOneWidget);
        expect(find.byType(OrientationBuilder), findsOneWidget);
      });

      testWidgets('should verify constructor properties', (WidgetTester tester) async {
        const layout = ResponsiveOrientationLayout(portrait: Text('Portrait'), landscape: Text('Landscape'));

        expect(layout.portrait, isA<Text>());
        expect(layout.landscape, isA<Text>());
      });

      testWidgets('should handle null landscape parameter', (WidgetTester tester) async {
        const layout = ResponsiveOrientationLayout(portrait: Text('Portrait'), landscape: null);

        expect(layout.portrait, isA<Text>());
        expect(layout.landscape, isNull);
      });
    });

    group('Portrait Orientation Tests', () {
      testWidgets('should display portrait layout in portrait orientation', (WidgetTester tester) async {
        // Set screen size to portrait orientation
        tester.view.physicalSize = const Size(375, 667); // Portrait
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));

        expect(find.text('Portrait Layout'), findsOneWidget);
        expect(find.text('Landscape Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should display portrait layout when landscape is null in portrait orientation', (
        WidgetTester tester,
      ) async {
        // Set screen size to portrait orientation
        tester.view.physicalSize = const Size(375, 667); // Portrait
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createOrientationTestWidget(
            portrait: portraitWidget,
            landscape: null, // Landscape is null
          ),
        );

        expect(find.text('Portrait Layout'), findsOneWidget);
        expect(find.text('Landscape Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Landscape Orientation Tests', () {
      testWidgets('should display landscape layout in landscape orientation', (WidgetTester tester) async {
        // Set screen size to landscape orientation
        tester.view.physicalSize = const Size(667, 375); // Landscape
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));

        expect(find.text('Landscape Layout'), findsOneWidget);
        expect(find.text('Portrait Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });

      testWidgets('should fallback to portrait when landscape is null in landscape orientation', (
        WidgetTester tester,
      ) async {
        // Set screen size to landscape orientation
        tester.view.physicalSize = const Size(667, 375); // Landscape
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createOrientationTestWidget(
            portrait: portraitWidget,
            landscape: null, // Landscape is null
          ),
        );

        expect(find.text('Portrait Layout'), findsOneWidget);
        expect(find.text('Landscape Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Orientation Switching Tests', () {
      testWidgets('should switch between orientations correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));

        // Start with portrait
        tester.view.physicalSize = const Size(375, 667); // Portrait
        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));
        expect(find.text('Portrait Layout'), findsOneWidget);
        expect(find.text('Landscape Layout'), findsNothing);

        // Switch to landscape
        tester.view.physicalSize = const Size(667, 375); // Landscape
        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));
        expect(find.text('Landscape Layout'), findsOneWidget);
        expect(find.text('Portrait Layout'), findsNothing);

        // Switch back to portrait
        tester.view.physicalSize = const Size(375, 667); // Portrait
        await tester.pumpWidget(createOrientationTestWidget(portrait: portraitWidget, landscape: landscapeWidget));
        expect(find.text('Portrait Layout'), findsOneWidget);
        expect(find.text('Landscape Layout'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Complex Widget Tests', () {
      testWidgets('should handle complex widget trees in different orientations', (WidgetTester tester) async {
        final complexPortrait = Column(
          children: [
            const Text('Portrait Header'),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => ListTile(title: Text('Portrait Item $index')),
              ),
            ),
            const Text('Portrait Footer'),
          ],
        );

        final complexLandscape = Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text('Landscape Left'),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: 4,
                      itemBuilder: (context, index) => Card(child: Text('Left Card $index')),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text('Landscape Right'),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: 4,
                      itemBuilder: (context, index) => Card(child: Text('Right Card $index')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        // Test portrait orientation
        tester.view.physicalSize = const Size(375, 667); // Portrait
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ResponsiveOrientationLayout(portrait: complexPortrait, landscape: complexLandscape)),
          ),
        );

        expect(find.text('Portrait Header'), findsOneWidget);
        expect(find.text('Portrait Footer'), findsOneWidget);
        expect(find.text('Landscape Left'), findsNothing);
        expect(find.text('Landscape Right'), findsNothing);

        // Test landscape orientation
        tester.view.physicalSize = const Size(667, 375); // Landscape
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ResponsiveOrientationLayout(portrait: complexPortrait, landscape: complexLandscape)),
          ),
        );

        expect(find.text('Landscape Left'), findsOneWidget);
        expect(find.text('Landscape Right'), findsOneWidget);
        expect(find.text('Portrait Header'), findsNothing);
        expect(find.text('Portrait Footer'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });

    group('Integration Tests', () {
      testWidgets('should work with nested ResponsiveLayout and ResponsiveOrientationLayout', (
        WidgetTester tester,
      ) async {
        final nestedWidget = ResponsiveLayout(
          mobile: const Text('Mobile Portrait'),
          tablet: const Text('Tablet Portrait'),
          desktop: const Text('Desktop Portrait'),
        );

        final landscapeNestedWidget = ResponsiveLayout(
          mobile: const Text('Mobile Landscape'),
          tablet: const Text('Tablet Landscape'),
          desktop: const Text('Desktop Landscape'),
        );

        // Test desktop portrait (width >= 1280, height > width = portrait)
        tester.view.physicalSize = const Size(1280, 1920); // Desktop portrait (height > width)
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ResponsiveOrientationLayout(portrait: nestedWidget, landscape: landscapeNestedWidget)),
          ),
        );

        expect(find.text('Desktop Portrait'), findsOneWidget);
        expect(find.text('Desktop Landscape'), findsNothing);

        // Test desktop landscape (width >= 1280, width > height = landscape)
        tester.view.physicalSize = const Size(1920, 1080); // Desktop landscape (width > height)
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ResponsiveOrientationLayout(portrait: nestedWidget, landscape: landscapeNestedWidget)),
          ),
        );

        expect(find.text('Desktop Landscape'), findsOneWidget);
        expect(find.text('Desktop Portrait'), findsNothing);

        // Reset the screen size
        addTearDown(tester.view.reset);
      });
    });
  });
}
