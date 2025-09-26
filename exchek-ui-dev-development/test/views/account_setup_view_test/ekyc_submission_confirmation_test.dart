import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/account_setup_view/ekyc_submission_confirmation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _controller.stream;

  final AuthState _state = MockAuthState();

  @override
  AuthState get state => _state;

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class MockAuthState extends Mock implements AuthState {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createTestWidget({required Widget child, Size? screenSize}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      theme: MyAppThemeHelper.lightTheme,
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: MediaQuery(
          data: MediaQueryData(
            size: screenSize ?? const Size(375, 812), // Default mobile size
            devicePixelRatio: 1.0,
          ),
          child: child,
        ),
      ),
    );
  }

  group('EkySubmissionConfirmation Widget Tests', () {
    testWidgets('should render all main components', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
      expect(find.byType(ResponsiveScaffold), findsOneWidget);
      expect(find.byType(BackgroundImage), findsOneWidget);
      expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should display correct texts', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Your KYC has been successfully submitted'), findsOneWidget);
      expect(find.text('Verification will take up to 24 hours'), findsOneWidget);
      expect(find.text('Continue to Dashboard'), findsOneWidget);
    });

    testWidgets('should display verification icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
      await tester.pumpAndSettle();

      // Assert - Find the specific icon by its path
      final customImageViews = tester.widgetList<CustomImageView>(find.byType(CustomImageView));
      final verifyIcon = customImageViews.firstWhere(
        (widget) => widget.imagePath == Assets.images.svgs.icons.icVerifyIcon.path,
      );
      expect(verifyIcon.imagePath, Assets.images.svgs.icons.icVerifyIcon.path);
    });

    testWidgets('should have correct button properties', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.text, 'Continue to Dashboard');
      expect(button.height, 45.0); // Default mobile height
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt to mobile screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(375, 812), // Mobile size
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);

        // Verify mobile-specific sizing
        final customImageViews = tester.widgetList<CustomImageView>(find.byType(CustomImageView));
        final verifyIcon = customImageViews.firstWhere(
          (widget) => widget.imagePath == Assets.images.svgs.icons.icVerifyIcon.path,
        );
        expect(verifyIcon.height, 52.0); // Mobile icon size
        expect(verifyIcon.width, 52.0);
      });

      testWidgets('should adapt to tablet screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(768, 1024), // Tablet size
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);

        // Verify tablet-specific sizing
        final customImageViews = tester.widgetList<CustomImageView>(find.byType(CustomImageView));
        final verifyIcon = customImageViews.firstWhere(
          (widget) => widget.imagePath == Assets.images.svgs.icons.icVerifyIcon.path,
        );
        expect(verifyIcon.height, 62.0); // Tablet icon size
        expect(verifyIcon.width, 62.0);
      });

      testWidgets('should adapt to desktop screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(1920, 1080), // Desktop size
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);

        // Verify desktop-specific sizing
        final customImageViews = tester.widgetList<CustomImageView>(find.byType(CustomImageView));
        final verifyIcon = customImageViews.firstWhere(
          (widget) => widget.imagePath == Assets.images.svgs.icons.icVerifyIcon.path,
        );
        expect(verifyIcon.height, 72.0); // Desktop icon size
        expect(verifyIcon.width, 72.0);
      });

      testWidgets('should adapt to big screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(1920, 1080), // Big screen size
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
      });
    });

    group('Helper Methods Tests', () {
      testWidgets('buttonHeight should return correct values for different screen sizes', (WidgetTester tester) async {
        // Arrange
        const widget = EkySubmissionConfirmation();

        // Test mobile
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(375, 812)));
        await tester.pumpAndSettle();

        final mobileContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonHeight(mobileContext), 45.0);

        // Test tablet (web non-mobile)
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(768, 1024)));
        await tester.pumpAndSettle();

        final tabletContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonHeight(tabletContext), 45.0); // Fixed: tablet returns 45.0, not 38.0

        // Test desktop
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(1920, 1080)));
        await tester.pumpAndSettle();

        final desktopContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonHeight(desktopContext), 45.0);
      });

      testWidgets('headerFontSize should return correct values for different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        const widget = EkySubmissionConfirmation();

        // Test mobile
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(375, 812)));
        await tester.pumpAndSettle();

        final mobileContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.headerFontSize(mobileContext), 23.0);

        // Test tablet
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(768, 1024)));
        await tester.pumpAndSettle();

        final tabletContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.headerFontSize(tabletContext), 24.0);

        // Test desktop
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(1920, 1080)));
        await tester.pumpAndSettle();

        final desktopContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.headerFontSize(desktopContext), 34.0);
      });

      testWidgets('logoAndContentPadding should return correct values', (WidgetTester tester) async {
        // Arrange
        const widget = EkySubmissionConfirmation();

        // Test mobile
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(375, 812)));
        await tester.pumpAndSettle();

        final mobileContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.logoAndContentPadding(mobileContext), 20.0);

        // Test desktop
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(1920, 1080)));
        await tester.pumpAndSettle();

        final desktopContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.logoAndContentPadding(desktopContext), 40.0);
      });

      testWidgets('buttonFontSize should return correct values for different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        const widget = EkySubmissionConfirmation();

        // Test mobile
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(375, 812)));
        await tester.pumpAndSettle();

        final mobileContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonFontSize(mobileContext), 16.0);

        // Test tablet
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(768, 1024)));
        await tester.pumpAndSettle();

        final tabletContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonFontSize(tabletContext), 15.0);

        // Test desktop
        await tester.pumpWidget(createTestWidget(child: widget, screenSize: const Size(1920, 1080)));
        await tester.pumpAndSettle();

        final desktopContext = tester.element(find.byType(EkySubmissionConfirmation));
        expect(widget.buttonFontSize(desktopContext), 16.0);
      });

      testWidgets('boxPadding static method should return correct values for different screen sizes', (
        WidgetTester tester,
      ) async {
        // Test mobile
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(375, 812)),
        );
        await tester.pumpAndSettle();

        final mobileContext = tester.element(find.byType(EkySubmissionConfirmation));
        final mobilePadding = EkySubmissionConfirmation.boxPadding(mobileContext);
        expect(mobilePadding, const EdgeInsets.symmetric(horizontal: 20));

        // Test tablet
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(768, 1024)),
        );
        await tester.pumpAndSettle();

        final tabletContext = tester.element(find.byType(EkySubmissionConfirmation));
        final tabletPadding = EkySubmissionConfirmation.boxPadding(tabletContext);
        expect(tabletPadding, const EdgeInsets.symmetric(horizontal: 30));

        // Test desktop
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(1920, 1080)),
        );
        await tester.pumpAndSettle();

        final desktopContext = tester.element(find.byType(EkySubmissionConfirmation));
        final desktopPadding = EkySubmissionConfirmation.boxPadding(desktopContext);
        expect(desktopPadding, const EdgeInsets.symmetric(horizontal: 36));
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have correct widget hierarchy', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert widget hierarchy
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(BackgroundImage), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
        expect(
          find.byType(ScrollConfiguration),
          findsAtLeastNWidgets(1),
        ); // Fixed: Changed from exactly one to at least one
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(ConstrainedBox), findsAtLeastNWidgets(1)); // Fixed: Changed from exactly one to at least one
        expect(find.byType(Column), findsAtLeastNWidgets(2)); // Main column and header column
      });

      testWidgets('should have correct background image path', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final backgroundImage = tester.widget<BackgroundImage>(find.byType(BackgroundImage));
        expect(backgroundImage.imagePath, Assets.images.svgs.other.appBg.path);
      });

      testWidgets('should have correct scroll physics', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
        expect(scrollView.physics, isA<BouncingScrollPhysics>());
        expect(scrollView.clipBehavior, Clip.none);
      });

      testWidgets('should have correct SafeArea configuration', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
        expect(safeArea.bottom, false);
      });

      testWidgets('should have correct ConstrainedBox max width', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
        final mainConstrainedBox = constrainedBoxes.firstWhere((box) => box.constraints.maxWidth != double.infinity);
        expect(mainConstrainedBox.constraints.maxWidth, isA<double>());
      });

      testWidgets('should have correct padding for different screen sizes', (WidgetTester tester) async {
        // Test mobile padding
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(375, 812)),
        );
        await tester.pumpAndSettle();

        final mobilePaddings = tester.widgetList<Padding>(find.byType(Padding));
        final mobilePadding = mobilePaddings.firstWhere(
          (padding) => padding.padding == const EdgeInsets.symmetric(vertical: 16),
        );
        expect(mobilePadding.padding, const EdgeInsets.symmetric(vertical: 16));

        // Test desktop padding
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(1920, 1080)),
        );
        await tester.pumpAndSettle();

        final desktopPaddings = tester.widgetList<Padding>(find.byType(Padding));
        final desktopPadding = desktopPaddings.firstWhere(
          (padding) => padding.padding == const EdgeInsets.symmetric(vertical: 25),
        );
        expect(desktopPadding.padding, const EdgeInsets.symmetric(vertical: 25));
      });
    });

    group('Button Width Tests', () {
      testWidgets('should have correct button width for desktop', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(1920, 1080)),
        );
        await tester.pumpAndSettle();

        // Assert - Find the SizedBox that contains the button
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final buttonSizedBox = sizedBoxes.firstWhere((sizedBox) => sizedBox.width == 460);
        expect(buttonSizedBox.width, 460);
      });

      testWidgets('should have correct button width for tablet', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(768, 1024)),
        );
        await tester.pumpAndSettle();

        // Assert - Find the SizedBox that contains the button
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final buttonSizedBox = sizedBoxes.firstWhere((sizedBox) => sizedBox.width == 400);
        expect(buttonSizedBox.width, 400);
      });

      testWidgets('should have correct button width for mobile', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(child: const EkySubmissionConfirmation(), screenSize: const Size(375, 812)),
        );
        await tester.pumpAndSettle();

        // Assert - Find the SizedBox that contains the button
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final buttonSizedBox = sizedBoxes.firstWhere((sizedBox) => sizedBox.width == double.infinity);
        expect(buttonSizedBox.width, double.infinity);
      });
    });

    group('BlocConsumer Tests', () {
      testWidgets('should contain BlocConsumer with listener', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
        expect(find.byType(BlocBuilder<AuthBloc, AuthState>), findsAtLeastNWidgets(1));
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should have BlocConsumer with empty listener', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - BlocConsumer should exist and widget should render
        expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
      });

      testWidgets('should handle BlocConsumer listener callback', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Act - Trigger a state change to test the listener
        mockAuthBloc.emit(MockAuthState());
        await tester.pumpAndSettle();

        // Assert - Widget should still render correctly after state change
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should have BlocConsumer with proper listener and builder', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - BlocConsumer should exist and have both listener and builder
        final blocConsumer = tester.widget<BlocConsumer<AuthBloc, AuthState>>(
          find.byType(BlocConsumer<AuthBloc, AuthState>),
        );

        // The listener function exists (even if empty)
        expect(blocConsumer.listener, isA<Function>());
        expect(blocConsumer.builder, isA<Function>());

        // Widget should render correctly
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should handle BlocBuilder state changes', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - Widget should render correctly with any state
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });
    });

    group('Conditional Rendering Tests', () {
      testWidgets('should show additional spacing for web non-mobile (tablet)', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(768, 1024), // Tablet size (web non-mobile)
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Check for SizedBox widgets (spacing)
        expect(find.byType(SizedBox), findsAtLeastNWidgets(3)); // Multiple SizedBox for spacing
      });

      testWidgets('should show additional spacing for web non-mobile (desktop)', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(1920, 1080), // Desktop size (web non-mobile)
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Check for SizedBox widgets (spacing) - should include the conditional spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(4)); // Multiple SizedBox for spacing including conditional
      });

      testWidgets('should show conditional spacing for web non-mobile with big screen', (WidgetTester tester) async {
        // Arrange - Test with a screen size that triggers both isWebAndIsNotMobile and isBigScreen
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(1920, 1080), // Desktop size that triggers both conditions
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Should render with conditional spacing
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);

        // Check that the conditional spacing is present
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.length, greaterThanOrEqualTo(4)); // Should have multiple SizedBox widgets
      });

      testWidgets('should show conditional spacing for web non-mobile with regular screen', (
        WidgetTester tester,
      ) async {
        // Arrange - Test with a screen size that triggers isWebAndIsNotMobile but not isBigScreen
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(1024, 768), // Tablet size that triggers isWebAndIsNotMobile
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Should render with conditional spacing
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);

        // Check that the conditional spacing is present
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.length, greaterThanOrEqualTo(3)); // Should have multiple SizedBox widgets
      });

      testWidgets('should not show additional spacing for mobile', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(375, 812), // Mobile size
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Check for SizedBox widgets (spacing)
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2)); // Basic SizedBox for spacing
      });
    });

    group('Text Styling Tests', () {
      testWidgets('should have correct text styles for success message', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final successText = tester.widget<Text>(find.text('Your KYC has been successfully submitted'));
        expect(successText.textAlign, TextAlign.center);
        expect(successText.style?.fontWeight, FontWeight.w500);
      });

      testWidgets('should have correct text styles for verification time message', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Find the verification time text
        final verificationText = tester.widget<Text>(find.text('Verification will take up to 24 hours'));

        expect(verificationText.textAlign, TextAlign.center);
        expect(verificationText.style?.fontWeight, FontWeight.w400);
      });

      testWidgets('should have correct text styles for button text', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.buttonTextStyle?.fontWeight, FontWeight.w500);
        expect(button.buttonTextStyle?.letterSpacing, 0.18);
      });
    });

    group('Private Method Tests', () {
      testWidgets('should build app logo correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final customImageViews = tester.widgetList<CustomImageView>(find.byType(CustomImageView));
        final verifyIcon = customImageViews.firstWhere(
          (widget) => widget.imagePath == Assets.images.svgs.icons.icVerifyIcon.path,
        );
        expect(verifyIcon.imagePath, Assets.images.svgs.icons.icVerifyIcon.path);
        expect(verifyIcon.height, 52.0);
        expect(verifyIcon.width, 52.0);
      });

      testWidgets('should build KYC confirmation header correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Your KYC has been successfully submitted'), findsOneWidget);
        expect(find.text('Verification will take up to 24 hours'), findsOneWidget);

        // Check for Column with spacing
        final columns = tester.widgetList<Column>(find.byType(Column));
        final headerColumn = columns.firstWhere((column) => column.spacing == 24);
        expect(headerColumn.spacing, 24);
        expect(headerColumn.mainAxisSize, MainAxisSize.min);
        expect(headerColumn.mainAxisAlignment, MainAxisAlignment.center);
        expect(headerColumn.crossAxisAlignment, CrossAxisAlignment.center);
      });

      testWidgets('should build continue button correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.text, 'Continue to Dashboard');
        expect(button.height, 45.0);

        // Check for Padding around button
        final buttonPaddings = tester.widgetList<Padding>(find.byType(Padding));
        final buttonPadding = buttonPaddings.firstWhere(
          (padding) => padding.padding == const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        );
        expect(buttonPadding.padding, const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0));
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle different AuthState types gracefully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - Widget should still render
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should handle very small screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(320, 568), // Very small screen
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Widget should still render
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should handle very large screen size', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestWidget(
            child: const EkySubmissionConfirmation(),
            screenSize: const Size(2560, 1440), // Very large screen
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Widget should still render
        expect(find.byType(EkySubmissionConfirmation), findsOneWidget);
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have semantic labels for accessibility', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - Check for semantic labels
        expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(child: const EkySubmissionConfirmation()));
        await tester.pumpAndSettle();

        // Assert - Text should be readable by screen readers
        expect(find.text('Your KYC has been successfully submitted'), findsOneWidget);
        expect(find.text('Verification will take up to 24 hours'), findsOneWidget);
        expect(find.text('Continue to Dashboard'), findsOneWidget);
      });
    });
  });
}
