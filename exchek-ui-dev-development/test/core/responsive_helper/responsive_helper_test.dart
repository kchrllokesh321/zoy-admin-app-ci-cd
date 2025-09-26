import 'package:exchek/core/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveHelper Tests', () {
    Widget createTestWidget({required Size screenSize, required Widget child}) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: Builder(builder: (context) => Scaffold(body: child)),
        ),
      );
    }

    group('Screen Type Detection Tests', () {
      testWidgets('isMobile should return true for width < 600', (WidgetTester tester) async {
        const screenSize = Size(599, 800);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), isTrue);
                expect(ResponsiveHelper.isTablet(context), isFalse);
                expect(ResponsiveHelper.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isMobile should return false for width >= 600', (WidgetTester tester) async {
        const screenSize = Size(600, 800);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isTablet should return true for 600 <= width < 1280', (WidgetTester tester) async {
        const screenSizes = [
          Size(600, 800), // Lower bound
          Size(900, 800), // Middle
          Size(1279, 800), // Upper bound
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  expect(ResponsiveHelper.isTablet(context), isTrue);
                  expect(ResponsiveHelper.isMobile(context), isFalse);
                  expect(ResponsiveHelper.isDesktop(context), isFalse);
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('isTablet should return false for width < 600 or width >= 1280', (WidgetTester tester) async {
        const screenSizes = [
          Size(599, 800), // Below lower bound
          Size(1280, 800), // At upper bound
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  expect(ResponsiveHelper.isTablet(context), isFalse);
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('isDesktop should return true for width >= 1280', (WidgetTester tester) async {
        const screenSizes = [
          Size(1280, 800), // Lower bound
          Size(1920, 1080), // Common desktop
          Size(2560, 1440), // Large desktop
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  expect(ResponsiveHelper.isDesktop(context), isTrue);
                  expect(ResponsiveHelper.isMobile(context), isFalse);
                  expect(ResponsiveHelper.isTablet(context), isFalse);
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('isDesktop should return false for width < 1280', (WidgetTester tester) async {
        const screenSize = Size(1279, 800);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Screen Dimensions Tests', () {
      testWidgets('getScreenWidth should return correct width', (WidgetTester tester) async {
        const screenSize = Size(1024, 768);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.getScreenWidth(context), equals(1024.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('getScreenHeight should return correct height', (WidgetTester tester) async {
        const screenSize = Size(1024, 768);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.getScreenHeight(context), equals(768.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Big Screen Detection Tests', () {
      testWidgets('isBigScreen should return true for width >= 1780', (WidgetTester tester) async {
        const screenSizes = [
          Size(1780, 800), // Lower bound
          Size(1920, 1080), // Common big screen
          Size(2560, 1440), // Large screen
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  expect(ResponsiveHelper.isBigScreen(context), isTrue);
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('isBigScreen should return false for width < 1780', (WidgetTester tester) async {
        const screenSizes = [
          Size(1779, 800), // Just below boundary
          Size(1280, 800), // Desktop but not big
          Size(768, 1024), // Tablet
          Size(375, 667), // Mobile
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  expect(ResponsiveHelper.isBigScreen(context), isFalse);
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });
    });

    group('Responsive Padding Tests', () {
      testWidgets('getScreenPadding should return desktop padding for big desktop screen', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080); // Big screen (>= 1780)

        await tester.pumpWidget(createTestWidget(screenSize: screenSize, child: const SizedBox()));

        final BuildContext context = tester.element(find.byType(SizedBox));

        // Test default desktop padding (1920 >= 1780, so big screen = 80)
        final defaultPadding = ResponsiveHelper.getScreenPadding(context);
        expect(defaultPadding, equals(const EdgeInsets.symmetric(horizontal: 80)));

        // Test custom desktop padding
        final customPadding = ResponsiveHelper.getScreenPadding(context, desktop: 100);
        expect(customPadding, equals(const EdgeInsets.symmetric(horizontal: 100)));
      });

      testWidgets('getScreenPadding should return desktop padding for small desktop screen', (
        WidgetTester tester,
      ) async {
        const screenSize = Size(1400, 800); // Small desktop screen (< 1780)

        await tester.pumpWidget(createTestWidget(screenSize: screenSize, child: const SizedBox()));

        final BuildContext context = tester.element(find.byType(SizedBox));

        // Test default desktop padding (1400 < 1780, so small screen = 65)
        final defaultPadding = ResponsiveHelper.getScreenPadding(context);
        expect(defaultPadding, equals(const EdgeInsets.symmetric(horizontal: 65)));

        // Test custom desktop padding
        final customPadding = ResponsiveHelper.getScreenPadding(context, desktop: 90);
        expect(customPadding, equals(const EdgeInsets.symmetric(horizontal: 90)));
      });

      testWidgets('getScreenPadding should return tablet padding for tablet screen', (WidgetTester tester) async {
        const screenSize = Size(768, 1024);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                // Test default tablet padding (5% of screen width)
                final defaultPadding = ResponsiveHelper.getScreenPadding(context);
                final expectedDefault = EdgeInsets.symmetric(horizontal: 768 * 0.05);
                expect(defaultPadding, equals(expectedDefault));

                // Test custom tablet padding
                final customPadding = ResponsiveHelper.getScreenPadding(context, tablet: 50);
                expect(customPadding, equals(const EdgeInsets.symmetric(horizontal: 50)));

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('getScreenPadding should return mobile padding for mobile screen', (WidgetTester tester) async {
        const screenSize = Size(375, 667);

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                // Test default mobile padding
                final defaultPadding = ResponsiveHelper.getScreenPadding(context);
                expect(defaultPadding, equals(const EdgeInsets.symmetric(horizontal: 30)));

                // Test custom mobile padding
                final customPadding = ResponsiveHelper.getScreenPadding(context, mobile: 20);
                expect(customPadding, equals(const EdgeInsets.symmetric(horizontal: 20)));

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Responsive Font Size Tests', () {
      testWidgets('getFontSize should return correct sizes for different screen types', (WidgetTester tester) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 18.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 16.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': 14.0, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final fontSize = ResponsiveHelper.getFontSize(context);
                  expect(fontSize, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getFontSize should use custom values when provided', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080); // Desktop

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                final customFontSize = ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 15, desktop: 20);
                expect(customFontSize, equals(20.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Responsive Widget Size Tests', () {
      testWidgets('getWidgetSize should return correct sizes for different screen types', (WidgetTester tester) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 100.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 80.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': 60.0, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final widgetSize = ResponsiveHelper.getWidgetSize(context);
                  expect(widgetSize, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getWidgetSize should use custom values when provided', (WidgetTester tester) async {
        const screenSize = Size(768, 1024); // Tablet

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                final customWidgetSize = ResponsiveHelper.getWidgetSize(context, mobile: 50, tablet: 90, desktop: 120);
                expect(customWidgetSize, equals(90.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Responsive Widget Height Tests', () {
      testWidgets('getWidgetHeight should return correct heights for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 100.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 80.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': 60.0, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final widgetHeight = ResponsiveHelper.getWidgetHeight(context);
                  expect(widgetHeight, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getWidgetHeight should use custom values when provided', (WidgetTester tester) async {
        const screenSize = Size(375, 667); // Mobile

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                final customWidgetHeight = ResponsiveHelper.getWidgetHeight(
                  context,
                  mobile: 70,
                  tablet: 90,
                  desktop: 110,
                );
                expect(customWidgetHeight, equals(70.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Max Width Methods Tests', () {
      testWidgets('getMaxFormWidth should return correct values for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 650.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 650.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': double.infinity, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final maxFormWidth = ResponsiveHelper.getMaxFormWidth(context);
                  expect(maxFormWidth, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getMaxDialogWidth should return correct values for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 670.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 670.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': double.infinity, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final maxDialogWidth = ResponsiveHelper.getMaxDialogWidth(context);
                  expect(maxDialogWidth, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getMaxAuthFormWidth should return correct values for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop (big screen: 1920 >= 1780)
          {'size': const Size(1920, 1080), 'expected': 700.0, 'type': 'desktop'},
          // Tablet (not big screen: 768 < 1780)
          {'size': const Size(768, 1024), 'expected': 500.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': double.infinity, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(createTestWidget(screenSize: testCase['size'] as Size, child: const SizedBox()));

          final BuildContext context = tester.element(find.byType(SizedBox));
          final maxAuthFormWidth = ResponsiveHelper.getMaxAuthFormWidth(context);
          expect(maxAuthFormWidth, equals(testCase['expected']));
        }
      });

      testWidgets('getMaxTileWidth should return correct values for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 520.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 520.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': double.infinity, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final maxTileWidth = ResponsiveHelper.getMaxTileWidth(context);
                  expect(maxTileWidth, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getMaxSliderWidthWidth should return correct values for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 740.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 580.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': double.infinity, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final maxSliderWidth = ResponsiveHelper.getMaxSliderWidthWidth(context);
                  expect(maxSliderWidth, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });
    });

    group('Screen Margin Tests', () {
      testWidgets('getScreenMargin should return correct margins for different screen widths', (
        WidgetTester tester,
      ) async {
        // Test case 1: Width in range 600-759 (should return horizontal margin based on kIsWeb)
        const screenSize1 = Size(700, 800);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize1,
            child: Builder(
              builder: (context) {
                final margin = ResponsiveHelper.getScreenMargin(context);
                // In test environment, kIsWeb is false, so should return EdgeInsets.zero
                expect(margin, equals(const EdgeInsets.symmetric(horizontal: 0.0)));
                return const SizedBox();
              },
            ),
          ),
        );

        // Test case 2: Width outside range 600-759 (should return EdgeInsets.zero)
        const screenSizes = [
          Size(599, 800), // Below range
          Size(760, 800), // Above range
          Size(375, 667), // Mobile
          Size(1920, 1080), // Desktop
        ];

        for (final screenSize in screenSizes) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: screenSize,
              child: Builder(
                builder: (context) {
                  final margin = ResponsiveHelper.getScreenMargin(context);
                  expect(margin, equals(EdgeInsets.zero));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });
    });

    group('Auth Box Radius Tests', () {
      testWidgets('getAuthBoxRadius should return correct radius for different screen types', (
        WidgetTester tester,
      ) async {
        final testCases = [
          // Desktop
          {'size': const Size(1920, 1080), 'expected': 60.0, 'type': 'desktop'},
          // Tablet
          {'size': const Size(768, 1024), 'expected': 60.0, 'type': 'tablet'},
          // Mobile
          {'size': const Size(375, 667), 'expected': 40.0, 'type': 'mobile'},
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            createTestWidget(
              screenSize: testCase['size'] as Size,
              child: Builder(
                builder: (context) {
                  final authBoxRadius = ResponsiveHelper.getAuthBoxRadius(context);
                  expect(authBoxRadius, equals(testCase['expected']));
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      });

      testWidgets('getAuthBoxRadius should use custom values when provided', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080); // Desktop

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                final customAuthBoxRadius = ResponsiveHelper.getAuthBoxRadius(
                  context,
                  mobile: 30,
                  tablet: 50,
                  desktop: 80,
                );
                expect(customAuthBoxRadius, equals(80.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Web Detection Tests', () {
      testWidgets('isWebAndIsNotMobile should return correct values', (WidgetTester tester) async {
        // Test with mobile screen (width < 600)
        const mobileScreenSize = Size(375, 667);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: mobileScreenSize,
            child: Builder(
              builder: (context) {
                final isWebAndNotMobile = ResponsiveHelper.isWebAndIsNotMobile(context);
                // In test environment, kIsWeb is false, so this should always be false
                expect(isWebAndNotMobile, isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        // Test with non-mobile screen (width >= 600)
        const desktopScreenSize = Size(1920, 1080);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: desktopScreenSize,
            child: Builder(
              builder: (context) {
                final isWebAndNotMobile = ResponsiveHelper.isWebAndIsNotMobile(context);
                // In test environment, kIsWeb is false, so this should always be false
                expect(isWebAndNotMobile, isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Edge Cases and Boundary Tests', () {
      testWidgets('should handle exact boundary values correctly', (WidgetTester tester) async {
        // Test exact boundary at 600px
        const boundary600 = Size(600, 800);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: boundary600,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), isFalse);
                expect(ResponsiveHelper.isTablet(context), isTrue);
                expect(ResponsiveHelper.isDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );

        // Test exact boundary at 1280px
        const boundary1280 = Size(1280, 800);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: boundary1280,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), isFalse);
                expect(ResponsiveHelper.isTablet(context), isFalse);
                expect(ResponsiveHelper.isDesktop(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should handle extreme screen sizes', (WidgetTester tester) async {
        // Test very small screen
        const verySmallScreen = Size(1, 1);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: verySmallScreen,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), isTrue);
                expect(ResponsiveHelper.getScreenWidth(context), equals(1.0));
                expect(ResponsiveHelper.getScreenHeight(context), equals(1.0));
                return const SizedBox();
              },
            ),
          ),
        );

        // Test very large screen
        const veryLargeScreen = Size(5000, 3000);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: veryLargeScreen,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isDesktop(context), isTrue);
                expect(ResponsiveHelper.getScreenWidth(context), equals(5000.0));
                expect(ResponsiveHelper.getScreenHeight(context), equals(3000.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
      testWidgets('should handle null parameters correctly', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080); // Desktop

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: screenSize),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        // Get the context after the widget is built
        final BuildContext context = tester.element(find.byType(SizedBox));

        // Test methods with null parameters (should use defaults)
        final padding = ResponsiveHelper.getScreenPadding(context);
        expect(padding, equals(const EdgeInsets.symmetric(horizontal: 80))); // 1920 >= 1780, so big screen = 80

        final fontSize = ResponsiveHelper.getFontSize(context);
        expect(fontSize, equals(18.0));

        final widgetSize = ResponsiveHelper.getWidgetSize(context);
        expect(widgetSize, equals(100.0));

        final widgetHeight = ResponsiveHelper.getWidgetHeight(context);
        expect(widgetHeight, equals(100.0));

        final authBoxRadius = ResponsiveHelper.getAuthBoxRadius(context);
        expect(authBoxRadius, equals(60.0));
      });
    });

    group('Logo Height Tests', () {
      testWidgets('getLogoHeight should return correct heights for different screen types', (
        WidgetTester tester,
      ) async {
        // Test desktop big screen (width >= 1780)
        const bigDesktopScreen = Size(1920, 1080);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: bigDesktopScreen,
            child: Builder(
              builder: (context) {
                final logoHeight = ResponsiveHelper.getLogoHeight(context);
                expect(logoHeight, equals(65.0)); // Big screen default
                return const SizedBox();
              },
            ),
          ),
        );

        // Test desktop small screen (width < 1780)
        const smallDesktopScreen = Size(1400, 800);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: smallDesktopScreen,
            child: Builder(
              builder: (context) {
                final logoHeight = ResponsiveHelper.getLogoHeight(context);
                expect(logoHeight, equals(46.0)); // Small screen default
                return const SizedBox();
              },
            ),
          ),
        );

        // Test tablet big screen (width >= 1780) - edge case
        const bigTabletScreen = Size(1780, 800); // This is actually desktop, but testing edge case
        await tester.pumpWidget(
          createTestWidget(
            screenSize: bigTabletScreen,
            child: Builder(
              builder: (context) {
                final logoHeight = ResponsiveHelper.getLogoHeight(context);
                expect(logoHeight, equals(65.0)); // Big screen default
                return const SizedBox();
              },
            ),
          ),
        );

        // Test tablet small screen (width < 1780)
        const smallTabletScreen = Size(768, 1024);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: smallTabletScreen,
            child: Builder(
              builder: (context) {
                final logoHeight = ResponsiveHelper.getLogoHeight(context);
                expect(logoHeight, equals(46.0)); // Small screen default
                return const SizedBox();
              },
            ),
          ),
        );

        // Test mobile (kIsWeb is false in test environment)
        const mobileScreen = Size(375, 667);
        await tester.pumpWidget(
          createTestWidget(
            screenSize: mobileScreen,
            child: Builder(
              builder: (context) {
                final logoHeight = ResponsiveHelper.getLogoHeight(context);
                expect(logoHeight, equals(65.0)); // Mobile default when not web
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('getLogoHeight should use custom values when provided', (WidgetTester tester) async {
        const screenSize = Size(1920, 1080); // Desktop big screen

        await tester.pumpWidget(
          createTestWidget(
            screenSize: screenSize,
            child: Builder(
              builder: (context) {
                final customLogoHeight = ResponsiveHelper.getLogoHeight(context, mobile: 50, tablet: 60, desktop: 80);
                expect(customLogoHeight, equals(80.0));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
