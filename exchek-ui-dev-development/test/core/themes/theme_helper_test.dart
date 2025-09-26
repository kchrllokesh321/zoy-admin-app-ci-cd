import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/theme_helper.dart';

void main() {
  group('MyAppThemeHelper Tests', () {
    group('Light Theme Tests', () {
      late ThemeData lightTheme;

      setUpAll(() {
        lightTheme = MyAppThemeHelper.lightTheme;
      });

      testWidgets('should create light theme with correct properties', (WidgetTester tester) async {
        // Test basic theme properties
        expect(lightTheme.useMaterial3, true);
        expect(lightTheme.brightness, Brightness.light);
        expect(lightTheme.scaffoldBackgroundColor, const Color(0xffFAF9FA));
        expect(lightTheme.splashColor, Colors.transparent);
        expect(lightTheme.highlightColor, Colors.transparent);
        expect(lightTheme.hoverColor, Colors.transparent);
      });

      testWidgets('should have correct color scheme for light theme', (WidgetTester tester) async {
        final colorScheme = lightTheme.colorScheme;

        expect(colorScheme.brightness, Brightness.light);
        expect(colorScheme.primary, const Color(0xff424AF3));
        expect(colorScheme.error, const Color(0xffFF5D5F));
        expect(colorScheme.onError, const Color(0xffFF5D5F));
      });

      testWidgets('should have correct text theme for light theme', (WidgetTester tester) async {
        final textTheme = lightTheme.textTheme;

        // Test display styles
        expect(textTheme.displayLarge?.fontSize, 57);
        expect(textTheme.displayLarge?.fontWeight, FontWeight.w400);
        expect(textTheme.displayLarge?.color, const Color(0xff0A0A0C));

        expect(textTheme.displayMedium?.fontSize, 45);
        expect(textTheme.displayMedium?.fontWeight, FontWeight.w400);

        expect(textTheme.displaySmall?.fontSize, 36);
        expect(textTheme.displaySmall?.fontWeight, FontWeight.w400);

        // Test headline styles
        expect(textTheme.headlineLarge?.fontSize, 32);
        expect(textTheme.headlineLarge?.fontWeight, FontWeight.w600);
        expect(textTheme.headlineLarge?.color, const Color(0xff0A0A0C));

        expect(textTheme.headlineMedium?.fontSize, 28);
        expect(textTheme.headlineMedium?.fontWeight, FontWeight.w400);

        expect(textTheme.headlineSmall?.fontSize, 24);
        expect(textTheme.headlineSmall?.fontWeight, FontWeight.w600);

        // Test title styles
        expect(textTheme.titleLarge?.fontSize, 22);
        expect(textTheme.titleLarge?.fontWeight, FontWeight.w500);

        expect(textTheme.titleMedium?.fontSize, 16);
        expect(textTheme.titleMedium?.fontWeight, FontWeight.w400);

        expect(textTheme.titleSmall?.fontSize, 14);
        expect(textTheme.titleSmall?.fontWeight, FontWeight.w400);

        // Test body styles
        expect(textTheme.bodyLarge?.fontSize, 16);
        expect(textTheme.bodyLarge?.fontWeight, FontWeight.w400);
        expect(textTheme.bodyLarge?.color, const Color(0xff0A0A0C));

        expect(textTheme.bodyMedium?.fontSize, 14);
        expect(textTheme.bodyMedium?.fontWeight, FontWeight.w400);

        expect(textTheme.bodySmall?.fontSize, 12);
        expect(textTheme.bodySmall?.fontWeight, FontWeight.w400);

        // Test label styles
        expect(textTheme.labelLarge?.fontSize, 14);
        expect(textTheme.labelLarge?.fontWeight, FontWeight.w500);

        expect(textTheme.labelMedium?.fontSize, 12);
        expect(textTheme.labelMedium?.fontWeight, FontWeight.w500);

        expect(textTheme.labelSmall?.fontSize, 11);
        expect(textTheme.labelSmall?.fontWeight, FontWeight.w500);
      });

      testWidgets('should have correct radio theme for light theme', (WidgetTester tester) async {
        final radioTheme = lightTheme.radioTheme;

        expect(radioTheme.fillColor?.resolve({}), const Color(0xff424AF3));
        expect(radioTheme.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
        expect(radioTheme.visualDensity, VisualDensity.compact);
      });

      testWidgets('should have correct app bar theme for light theme', (WidgetTester tester) async {
        final appBarTheme = lightTheme.appBarTheme;

        expect(appBarTheme.backgroundColor, const Color(0xffFFFFFF));
        expect(appBarTheme.titleTextStyle?.fontSize, 20);
        expect(appBarTheme.titleTextStyle?.fontWeight, FontWeight.bold);
        expect(appBarTheme.titleTextStyle?.color, const Color(0xff2E2E2E));
      });

      testWidgets('should have correct input decoration theme for light theme', (WidgetTester tester) async {
        final inputTheme = lightTheme.inputDecorationTheme;

        expect(inputTheme.errorStyle?.fontSize, 16);
        expect(inputTheme.errorStyle?.fontWeight, FontWeight.w400);
        expect(inputTheme.errorStyle?.color, const Color(0xffFF5D5F));
        expect(inputTheme.errorMaxLines, 2);
        expect(inputTheme.fillColor, const Color(0xffFFFFFF));
        expect(inputTheme.filled, true);

        // Test border styles
        final border = inputTheme.border as OutlineInputBorder;
        expect(border.borderRadius, BorderRadius.circular(12.0));
        expect(border.borderSide.color, const Color(0xffD4D7E3));
        expect(border.borderSide.width, 1.5);

        final enabledBorder = inputTheme.enabledBorder as OutlineInputBorder;
        expect(enabledBorder.borderRadius, BorderRadius.circular(12.0));
        expect(enabledBorder.borderSide.color, const Color(0xffD4D7E3));
        expect(enabledBorder.borderSide.width, 1.5);

        final focusedBorder = inputTheme.focusedBorder as OutlineInputBorder;
        expect(focusedBorder.borderRadius, BorderRadius.circular(12.0));
        expect(focusedBorder.borderSide.color, const Color(0xff4E55F4));
        expect(focusedBorder.borderSide.width, 1.5);

        final errorBorder = inputTheme.errorBorder as OutlineInputBorder;
        expect(errorBorder.borderRadius, BorderRadius.circular(12.0));
        expect(errorBorder.borderSide.color, const Color(0xffFF5D5F));
        expect(errorBorder.borderSide.width, 1.5);
      });

      testWidgets('should have correct elevated button theme for light theme', (WidgetTester tester) async {
        final buttonTheme = lightTheme.elevatedButtonTheme;
        final buttonStyle = buttonTheme.style!;

        expect(buttonStyle.backgroundColor?.resolve({}), const Color(0xff4E55F4));
        expect(buttonStyle.backgroundColor?.resolve({WidgetState.disabled}), const Color(0xffB5B7F8));

        final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(16.0));

        final textStyle = buttonStyle.textStyle?.resolve({});
        expect(textStyle?.fontSize, 16);
        expect(textStyle?.fontWeight, FontWeight.w500);
        expect(textStyle?.color, const Color(0xffFFFFFF));
      });

      testWidgets('should have correct checkbox theme for light theme', (WidgetTester tester) async {
        final checkboxTheme = lightTheme.checkboxTheme;

        final shape = checkboxTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(4));

        expect(checkboxTheme.checkColor?.resolve({WidgetState.selected}), Colors.white);
        expect(checkboxTheme.checkColor?.resolve({}), const Color(0xff5C5C5C));

        expect(checkboxTheme.side?.color, const Color(0xff5C5C5C));
        expect(checkboxTheme.side?.width, 2);

        expect(checkboxTheme.fillColor?.resolve({WidgetState.selected}), const Color(0xff4E55F4));
        expect(checkboxTheme.fillColor?.resolve({}), Colors.white);
      });
    });

    group('Dark Theme Tests', () {
      late ThemeData darkTheme;

      setUpAll(() {
        darkTheme = MyAppThemeHelper.darkTheme;
      });

      testWidgets('should create dark theme with correct properties', (WidgetTester tester) async {
        // Test basic theme properties
        expect(darkTheme.useMaterial3, true);
        expect(darkTheme.brightness, Brightness.dark);
        expect(darkTheme.scaffoldBackgroundColor, const Color(0xff121212));
        expect(darkTheme.splashColor, Colors.transparent);
        expect(darkTheme.highlightColor, Colors.transparent);
        expect(darkTheme.hoverColor, Colors.transparent);
      });

      testWidgets('should have correct color scheme for dark theme', (WidgetTester tester) async {
        final colorScheme = darkTheme.colorScheme;

        expect(colorScheme.brightness, Brightness.dark);
        expect(colorScheme.primary, const Color(0xff424AF3));
        expect(colorScheme.error, const Color(0xffFF5D5F));
        expect(colorScheme.onError, const Color(0xffFF5D5F));
      });

      testWidgets('should have correct text theme for dark theme', (WidgetTester tester) async {
        final textTheme = darkTheme.textTheme;

        // Test that dark theme uses white text color
        expect(textTheme.displayLarge?.color, const Color(0xffFFFFFF));
        expect(textTheme.headlineLarge?.color, const Color(0xffFFFFFF));
        expect(textTheme.bodyLarge?.color, const Color(0xffFFFFFF));
      });

      testWidgets('should have correct app bar theme for dark theme', (WidgetTester tester) async {
        final appBarTheme = darkTheme.appBarTheme;

        expect(appBarTheme.backgroundColor, const Color(0xff121212));
        expect(appBarTheme.titleTextStyle?.color, const Color(0xffFFFFFF));
      });
    });

    group('Text Theme Builder Tests', () {
      testWidgets('should build text theme with custom colors', (WidgetTester tester) async {
        // Create a test widget to access the private _buildTextTheme method indirectly
        await tester.pumpWidget(
          MaterialApp(
            theme: MyAppThemeHelper.lightTheme,
            home: Builder(
              builder: (context) {
                final textTheme = Theme.of(context).textTheme;

                // Verify that the text theme is built with correct colors
                expect(textTheme.bodyLarge?.color, const Color(0xff0A0A0C));
                expect(textTheme.displayLarge?.color, const Color(0xff0A0A0C));

                return const Scaffold(body: Text('Test'));
              },
            ),
          ),
        );
      });
    });
  });
}
