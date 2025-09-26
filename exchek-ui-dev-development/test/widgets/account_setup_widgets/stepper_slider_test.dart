import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:exchek/widgets/account_setup_widgets/stepper_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum TestStep { first, second, third }

void main() {
  group('StepperSlider Widget Tests', () {
    // Helper function to create a test widget with proper theme setup
    Widget createTestWidget<T>({
      required T currentStep,
      required List<T> steps,
      required String title,
      bool isShowTitle = true,
      bool isFullSlider = false,
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
            body: StepperSlider<T>(
              currentStep: currentStep,
              steps: steps,
              title: title,
              isShowTitle: isShowTitle,
              isFullSlider: isFullSlider,
            ),
          ),
        ),
      );
    }

    group('Widget Creation Tests', () {
      testWidgets('creates widget with required parameters', (tester) async {
        const steps = [1, 2, 3, 4];
        const currentStep = 2;
        const title = 'Test Stepper';

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: title));

        expect(find.byType(StepperSlider<int>), findsOneWidget);
      });

      testWidgets('creates widget with string steps', (tester) async {
        const steps = ['Step 1', 'Step 2', 'Step 3'];
        const currentStep = 'Step 2';
        const title = 'String Stepper';

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: title));

        expect(find.byType(StepperSlider<String>), findsOneWidget);
      });

      testWidgets('creates widget with enum steps', (tester) async {
        const steps = TestStep.values;
        const currentStep = TestStep.second;
        const title = 'Enum Stepper';

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: title));

        expect(find.byType(StepperSlider<TestStep>), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('has correct widget hierarchy when isShowTitle is true', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test Title';

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: title, isShowTitle: true),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Stack), findsWidgets);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byType(Positioned), findsOneWidget);
        expect(find.byType(FractionallySizedBox), findsOneWidget);
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);

        // Should not show title row when isShowTitle is true
        expect(find.byType(Row), findsNothing);
        expect(find.text(title), findsNothing);
      });

      testWidgets('has correct widget hierarchy when isShowTitle is false', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test Title';

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: title, isShowTitle: false),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(SizedBox), findsNWidgets(2)); // Width and height spacing
        expect(find.byType(Stack), findsWidgets);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Should show title and step counter
        expect(find.text(title), findsOneWidget);
        expect(find.text('2/3'), findsOneWidget);
      });
    });

    group('Progress Calculation Tests', () {
      testWidgets('calculates progress correctly for first step', (tester) async {
        const steps = [1, 2, 3, 4];
        const currentStep = 1;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Progress Test', isShowTitle: false),
        );

        expect(find.text('1/4'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 0.25); // 1/4
      });

      testWidgets('calculates progress correctly for middle step', (tester) async {
        const steps = [1, 2, 3, 4];
        const currentStep = 3;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Progress Test', isShowTitle: false),
        );

        expect(find.text('3/4'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 0.75); // 3/4
      });

      testWidgets('calculates progress correctly for last step', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 3;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Progress Test', isShowTitle: false),
        );

        expect(find.text('3/3'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 1.0); // 3/3
      });

      testWidgets('handles single step correctly', (tester) async {
        const steps = [1];
        const currentStep = 1;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Single Step', isShowTitle: false),
        );

        expect(find.text('1/1'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 1.0); // 1/1
      });
    });

    group('Styling Tests', () {
      testWidgets('applies correct styling when isFullSlider is false', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Style Test', isFullSlider: false),
        );

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.minHeight, 10.0);
        expect(progressIndicator.borderRadius, BorderRadius.circular(10));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxHeight, 10.0);
      });

      testWidgets('applies correct styling when isFullSlider is true', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Style Test', isFullSlider: true),
        );

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.minHeight, 7.0);
        expect(progressIndicator.borderRadius, BorderRadius.circular(0));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxHeight, 7.0);
      });

      testWidgets('applies correct gradient colors', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: 'Color Test'));

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        final gradient = decoration.gradient as LinearGradient;

        expect(gradient.colors.length, 2);
        expect(gradient.colors.first, const Color(0xFF8892FF));
        expect(gradient.colors.last, isA<Color>()); // Theme primary color
      });

      testWidgets('applies correct border radius for ClipRRect', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Border Test', isFullSlider: false),
        );

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, const BorderRadius.horizontal(right: Radius.circular(10)));
      });
    });

    group('Text Styling Tests', () {
      testWidgets('applies correct text styling for title', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test Title';

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: title, isShowTitle: false),
        );

        final titleText = tester.widget<Text>(find.text(title));
        final textStyle = titleText.style!;

        expect(textStyle.fontSize, 22.0); // Mobile size
        expect(textStyle.fontWeight, FontWeight.w600);
        expect(textStyle.letterSpacing, 0.24);
      });

      testWidgets('applies correct text styling for step counter', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Counter Test', isShowTitle: false),
        );

        final counterText = tester.widget<Text>(find.text('2/3'));
        final textStyle = counterText.style!;

        expect(textStyle.fontSize, 22.0); // Mobile size
        expect(textStyle.fontWeight, FontWeight.w600);
        expect(textStyle.letterSpacing, 0.24);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts font size for mobile screens', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Mobile Test';

        await tester.pumpWidget(
          createTestWidget(
            currentStep: currentStep,
            steps: steps,
            title: title,
            isShowTitle: false,
            screenSize: const Size(400, 800), // Mobile size
          ),
        );

        final titleText = tester.widget<Text>(find.text(title));
        final counterText = tester.widget<Text>(find.text('2/3'));

        expect(titleText.style!.fontSize, 22.0);
        expect(counterText.style!.fontSize, 22.0);
      });

      testWidgets('adapts font size for tablet screens', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Tablet Test';

        await tester.pumpWidget(
          createTestWidget(
            currentStep: currentStep,
            steps: steps,
            title: title,
            isShowTitle: false,
            screenSize: const Size(800, 600), // Tablet size
          ),
        );

        final titleText = tester.widget<Text>(find.text(title));
        final counterText = tester.widget<Text>(find.text('2/3'));

        expect(titleText.style!.fontSize, 23.0);
        expect(counterText.style!.fontSize, 23.0);
      });

      testWidgets('adapts font size for desktop screens', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Desktop Test';

        await tester.pumpWidget(
          createTestWidget(
            currentStep: currentStep,
            steps: steps,
            title: title,
            isShowTitle: false,
            screenSize: const Size(1280, 800), // Desktop size
          ),
        );

        final titleText = tester.widget<Text>(find.text(title));
        final counterText = tester.widget<Text>(find.text('2/3'));

        expect(titleText.style!.fontSize, 24.0);
        expect(counterText.style!.fontSize, 24.0);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles step not found in list', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 5; // Not in steps list

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Edge Case Test', isShowTitle: false),
        );

        // When step is not found, indexOf returns -1
        // So stepIndex + 1 = 0, and progress = 0/3 = 0
        expect(find.text('0/3'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 0.0);
      });

      testWidgets('handles very long title text', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const longTitle =
            'This is a very long title that should test the Expanded widget behavior and text wrapping capabilities of the stepper slider widget';

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: longTitle, isShowTitle: false),
        );

        expect(find.text(longTitle), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const specialTitle = 'Title with émojis 🎉 and symbols @#\$%^&*()';

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: specialTitle, isShowTitle: false),
        );

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('handles large number of steps', (tester) async {
        final steps = List.generate(100, (index) => index + 1);
        const currentStep = 50;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Many Steps', isShowTitle: false),
        );

        expect(find.text('50/100'), findsOneWidget);

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.value, 0.5); // 50/100
      });
    });

    group('Widget Properties Tests', () {
      test('widget has correct properties', () {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test';
        const key = Key('test_key');

        final widget = StepperSlider<int>(
          key: key,
          currentStep: currentStep,
          steps: steps,
          title: title,
          isShowTitle: false,
          isFullSlider: true,
        );

        expect(widget.key, key);
        expect(widget.currentStep, currentStep);
        expect(widget.steps, steps);
        expect(widget.title, title);
        expect(widget.isShowTitle, false);
        expect(widget.isFullSlider, true);
      });

      test('widget has correct default values', () {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test';

        final widget = StepperSlider<int>(currentStep: currentStep, steps: steps, title: title);

        expect(widget.isShowTitle, true);
        expect(widget.isFullSlider, false);
      });

      test('widget is StatelessWidget', () {
        const steps = [1, 2, 3];
        const currentStep = 2;
        const title = 'Test';

        final widget = StepperSlider<int>(currentStep: currentStep, steps: steps, title: title);

        expect(widget, isA<StatelessWidget>());
      });
    });

    group('Layout Component Tests', () {
      testWidgets('has correct spacing components', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Spacing Test', isShowTitle: false),
        );

        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsNWidgets(2));

        // Check width spacing
        final widthBox = tester.widget<SizedBox>(sizedBoxes.first);
        expect(widthBox.width, 20.0);
        expect(widthBox.height, isNull);

        // Check height spacing
        final heightBox = tester.widget<SizedBox>(sizedBoxes.last);
        expect(heightBox.height, 25.0);
        expect(heightBox.width, isNull);
      });

      testWidgets('has correct alignment and positioning', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: 'Alignment Test'));

        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, 0);
        expect(positioned.top, 0);
        expect(positioned.right, 0);
        expect(positioned.bottom, 0);

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.centerLeft);
      });

      testWidgets('progress indicator has correct background color', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(createTestWidget(currentStep: currentStep, steps: steps, title: 'Background Test'));

        final progressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
        expect(progressIndicator.backgroundColor, Colors.grey[300]);
        expect(progressIndicator.valueColor?.value, Colors.transparent);
      });
    });

    group('Integration Tests', () {
      testWidgets('works correctly with different data types', (tester) async {
        // Test with double values
        const doubleSteps = [1.0, 2.5, 3.7, 4.2];
        const currentDoubleStep = 2.5;

        await tester.pumpWidget(
          createTestWidget(
            currentStep: currentDoubleStep,
            steps: doubleSteps,
            title: 'Double Test',
            isShowTitle: false,
          ),
        );

        expect(find.text('2/4'), findsOneWidget);
        expect(find.byType(StepperSlider<double>), findsOneWidget);
      });

      testWidgets('maintains state during rebuilds', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        await tester.pumpWidget(
          createTestWidget(currentStep: currentStep, steps: steps, title: 'Rebuild Test', isShowTitle: false),
        );

        expect(find.text('2/3'), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        expect(find.text('2/3'), findsOneWidget);
      });

      testWidgets('works with both isShowTitle and isFullSlider combinations', (tester) async {
        const steps = [1, 2, 3];
        const currentStep = 2;

        // Test all combinations
        final combinations = [(true, true), (true, false), (false, true), (false, false)];

        for (final (showTitle, fullSlider) in combinations) {
          await tester.pumpWidget(
            createTestWidget(
              currentStep: currentStep,
              steps: steps,
              title: 'Combination Test',
              isShowTitle: showTitle,
              isFullSlider: fullSlider,
            ),
          );

          expect(find.byType(StepperSlider<int>), findsOneWidget);

          if (!showTitle) {
            expect(find.text('Combination Test'), findsOneWidget);
            expect(find.text('2/3'), findsOneWidget);
          } else {
            expect(find.text('Combination Test'), findsNothing);
          }
        }
      });
    });
  });
}
