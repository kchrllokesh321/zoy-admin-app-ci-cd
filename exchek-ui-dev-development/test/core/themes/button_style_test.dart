import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/button_style.dart';
import 'package:exchek/core/themes/custom_color_extension.dart';

void main() {
  group('ButtonThemeHelper Tests', () {
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        theme: ThemeData(extensions: const [CustomColors.light]),
        home: Scaffold(body: Builder(builder: (context) => child)),
      );
    }

    group('borderElevatedButtonStyle Tests', () {
      testWidgets('should create border elevated button style with correct properties', (WidgetTester tester) async {
        late ButtonStyle buttonStyle;

        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                buttonStyle = ButtonThemeHelper.borderElevatedButtonStyle(context);
                return ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Test'));
              },
            ),
          ),
        );

        // Test elevation
        expect(buttonStyle.elevation?.resolve({}), 6);

        // Test shadow color
        final shadowColor = buttonStyle.shadowColor?.resolve({});
        expect(shadowColor, isNotNull);

        // Test shape
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(50.0));
        expect(shape.side.color, const Color(0xFF4E55F4)); // CustomColors.light.primaryColor
        expect(shape.side.width, 1);

        // Test padding
        final padding = buttonStyle.padding?.resolve({}) as EdgeInsets;
        expect(padding, isNotNull);

        // Test text style
        final textStyle = buttonStyle.textStyle?.resolve({});
        expect(textStyle?.fontWeight, FontWeight.w500);
      });

      testWidgets('should render border elevated button correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  style: ButtonThemeHelper.borderElevatedButtonStyle(context),
                  onPressed: () {},
                  child: const Text('Border Button'),
                );
              },
            ),
          ),
        );

        expect(find.text('Border Button'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('outlineBorderElevatedButtonStyle Tests', () {
      testWidgets('should create outline border elevated button style with correct properties', (
        WidgetTester tester,
      ) async {
        late ButtonStyle buttonStyle;

        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                buttonStyle = ButtonThemeHelper.outlineBorderElevatedButtonStyle(context);
                return ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Test'));
              },
            ),
          ),
        );

        // Test elevation (should be 0 for outline style)
        expect(buttonStyle.elevation?.resolve({}), 0);

        // Test shadow color
        final shadowColor = buttonStyle.shadowColor?.resolve({});
        expect(shadowColor, isNotNull);

        // Test shape
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(12.0));
        expect(shape.side.color, const Color(0xFF4E55F4)); // CustomColors.light.primaryColor
        expect(shape.side.width, 1);

        // Test background color
        expect(buttonStyle.backgroundColor?.resolve({}), const Color(0xFFFFFFFF)); // CustomColors.light.fillColor

        // Test overlay color
        expect(buttonStyle.overlayColor?.resolve({}), Colors.transparent);

        // Test padding
        final padding = buttonStyle.padding?.resolve({}) as EdgeInsets;
        expect(padding, isNotNull);

        // Test text style
        final textStyle = buttonStyle.textStyle?.resolve({});
        expect(textStyle?.fontWeight, FontWeight.w500);
      });

      testWidgets('should render outline border elevated button correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  style: ButtonThemeHelper.outlineBorderElevatedButtonStyle(context),
                  onPressed: () {},
                  child: const Text('Outline Button'),
                );
              },
            ),
          ),
        );

        expect(find.text('Outline Button'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('authElevatedButtonStyle Tests', () {
      testWidgets('should create auth elevated button style with correct properties', (WidgetTester tester) async {
        late ButtonStyle buttonStyle;

        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                buttonStyle = ButtonThemeHelper.authElevatedButtonStyle(context);
                return ElevatedButton(style: buttonStyle, onPressed: () {}, child: const Text('Test'));
              },
            ),
          ),
        );

        // Test shape
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(12.0));

        // Test padding
        final padding = buttonStyle.padding?.resolve({}) as EdgeInsets;
        expect(padding, isNotNull);

        // Test text style
        final textStyle = buttonStyle.textStyle?.resolve({});
        expect(textStyle?.fontWeight, FontWeight.w500);
        expect(textStyle?.color, const Color(0xFFFFFFFF)); // CustomColors.light.fillColor
      });

      testWidgets('should render auth elevated button correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  style: ButtonThemeHelper.authElevatedButtonStyle(context),
                  onPressed: () {},
                  child: const Text('Auth Button'),
                );
              },
            ),
          ),
        );

        expect(find.text('Auth Button'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('textButtonStyle Tests', () {
      testWidgets('should create text button style with correct properties', (WidgetTester tester) async {
        late ButtonStyle buttonStyle;

        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                buttonStyle = ButtonThemeHelper.textButtonStyle(context);
                return TextButton(style: buttonStyle, onPressed: () {}, child: const Text('Test'));
              },
            ),
          ),
        );

        // Test shape
        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(50.0));

        // Test padding
        final padding = buttonStyle.padding?.resolve({}) as EdgeInsets;
        expect(padding, isNotNull);

        // Test elevation (should be 0 for text button)
        expect(buttonStyle.elevation?.resolve({}), 0.0);

        // Test background color (should be transparent)
        expect(buttonStyle.backgroundColor?.resolve({}), Colors.transparent);

        // Test overlay color
        final overlayColor = buttonStyle.overlayColor?.resolve({});
        expect(overlayColor, isNotNull);

        // Test foreground color
        expect(buttonStyle.foregroundColor?.resolve({}), const Color(0xFF4E55F4)); // CustomColors.light.primaryColor

        // Test text style
        final textStyle = buttonStyle.textStyle?.resolve({});
        expect(textStyle?.fontWeight, FontWeight.w500);
      });

      testWidgets('should render text button correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                return TextButton(
                  style: ButtonThemeHelper.textButtonStyle(context),
                  onPressed: () {},
                  child: const Text('Text Button'),
                );
              },
            ),
          ),
        );

        expect(find.text('Text Button'), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('should handle button state changes correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                final buttonStyle = ButtonThemeHelper.textButtonStyle(context);

                // Test different button states
                final normalState = <WidgetState>{};
                final pressedState = <WidgetState>{WidgetState.pressed};
                final hoveredState = <WidgetState>{WidgetState.hovered};
                final disabledState = <WidgetState>{WidgetState.disabled};

                // Test background color for different states
                expect(buttonStyle.backgroundColor?.resolve(normalState), Colors.transparent);
                expect(buttonStyle.backgroundColor?.resolve(pressedState), Colors.transparent);
                expect(buttonStyle.backgroundColor?.resolve(hoveredState), Colors.transparent);
                expect(buttonStyle.backgroundColor?.resolve(disabledState), Colors.transparent);

                return TextButton(style: buttonStyle, onPressed: () {}, child: const Text('State Test'));
              },
            ),
          ),
        );

        expect(find.text('State Test'), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt to different screen sizes', (WidgetTester tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile size

        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) {
                final borderStyle = ButtonThemeHelper.borderElevatedButtonStyle(context);
                final outlineStyle = ButtonThemeHelper.outlineBorderElevatedButtonStyle(context);
                final authStyle = ButtonThemeHelper.authElevatedButtonStyle(context);
                final textStyle = ButtonThemeHelper.textButtonStyle(context);

                // All styles should have padding that adapts to screen size
                expect(borderStyle.padding?.resolve({}), isNotNull);
                expect(outlineStyle.padding?.resolve({}), isNotNull);
                expect(authStyle.padding?.resolve({}), isNotNull);
                expect(textStyle.padding?.resolve({}), isNotNull);

                return const Column(children: [Text('Responsive Test')]);
              },
            ),
          ),
        );

        expect(find.text('Responsive Test'), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should work with different theme configurations', (WidgetTester tester) async {
        // Test with dark theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(extensions: const [CustomColors.dark]),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        style: ButtonThemeHelper.borderElevatedButtonStyle(context),
                        onPressed: () {},
                        child: const Text('Border'),
                      ),
                      ElevatedButton(
                        style: ButtonThemeHelper.outlineBorderElevatedButtonStyle(context),
                        onPressed: () {},
                        child: const Text('Outline'),
                      ),
                      ElevatedButton(
                        style: ButtonThemeHelper.authElevatedButtonStyle(context),
                        onPressed: () {},
                        child: const Text('Auth'),
                      ),
                      TextButton(
                        style: ButtonThemeHelper.textButtonStyle(context),
                        onPressed: () {},
                        child: const Text('Text'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Border'), findsOneWidget);
        expect(find.text('Outline'), findsOneWidget);
        expect(find.text('Auth'), findsOneWidget);
        expect(find.text('Text'), findsOneWidget);
      });
    });
  });
}
