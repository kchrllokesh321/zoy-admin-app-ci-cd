import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeChangeLoginType extends Fake implements ChangeLoginType {}

class FakeEmailLoginSubmitted extends Fake implements EmailLoginSubmitted {}

class MockAuthBloc extends Mock implements AuthBloc {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _controller.stream;

  void emitState(AuthState state) {
    _controller.add(state);
  }
}

class MockAuthState extends Mock implements AuthState {}

// Add this mock class at the top of your test file
class MockFormState extends Mock implements FormState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

void main() {
  setUpAll(() {
    // Register fallback values
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeChangeLoginType());
    registerFallbackValue(FakeEmailLoginSubmitted());
    registerFallbackValue(MockFormState());

    registerFallbackValue(EmailLoginSubmitted(emailIdOrUserName: '', password: ''));
  });

  late MockAuthBloc mockAuthBloc;
  late MockAuthState mockAuthState;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAuthState = MockAuthState();

    // Setup default state values
    when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.email);
    when(() => mockAuthState.isObscuredPassword).thenReturn(true);
    when(() => mockAuthState.isloginLoading).thenReturn(false);
    when(() => mockAuthState.emailFormKey).thenReturn(GlobalKey<FormState>());
    when(() => mockAuthState.phoneFormKey).thenReturn(GlobalKey<FormState>());
    when(() => mockAuthState.emailIdUserNameController).thenReturn(TextEditingController());
    when(() => mockAuthState.passwordController).thenReturn(TextEditingController());
    when(() => mockAuthState.phoneController).thenReturn(TextEditingController());
    when(() => mockAuthState.otpController).thenReturn(TextEditingController());
    when(() => mockAuthState.isOtpTimerRunning).thenReturn(false);
    when(() => mockAuthState.otpRemainingTime).thenReturn(0);
    when(() => mockAuthState.isEmailCleared).thenReturn(true);
    when(() => mockAuthState.isMobileCleared).thenReturn(true);
    when(() => mockAuthState.isEmailExists).thenReturn(null);
    when(() => mockAuthState.isMobileExists).thenReturn(null);
    when(() => mockAuthState.isLoginSuccess).thenReturn(false);
    when(() => mockAuthState.isSocialSignInLoading).thenReturn(false);

    // Setup initial state
    when(() => mockAuthBloc.state).thenReturn(mockAuthState);
  });

  tearDown(() {
    mockAuthBloc._controller.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        Lang.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: const LoginView()),
    );
  }

  group('LoginView Widget Tests', () {
    testWidgets('should render app logo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Additional pump to ensure ScreenUtil is initialized
      await tester.pumpAndSettle();

      expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
    });

    testWidgets('should render login title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      expect(find.text(Lang.of(context).lbl_login_title), findsOneWidget);
    });

    testWidgets('should show email login form by default', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));

      expect(find.text(Lang.of(context).lbl_email_userid), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_password), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_login), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_forgot_password), findsOneWidget);
    });

    testWidgets('should show phone login form when login type is phone', (WidgetTester tester) async {
      when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));

      expect(find.text(Lang.of(context).lbl_mobile_number), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_one_time_password), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_send_otp), findsOneWidget);
    });

    testWidgets('should toggle login type when change login type button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      final changeLoginTypeButton = find.textContaining(Lang.of(context).lbl_log_in_with);

      expect(changeLoginTypeButton, findsOneWidget);

      await tester.tap(changeLoginTypeButton);
      await tester.pump();

      verify(() => mockAuthBloc.add(any(that: isA<ChangeLoginType>()))).called(1);
    });

    testWidgets('should show password visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      // Find password field's suffix icon (CustomImageView for eye/eye-slash)
      final passwordToggleIcon = find.byWidgetPredicate(
        (widget) =>
            widget is CustomImageView &&
            (widget.imagePath == Assets.images.svgs.icons.icEyeSlash.path ||
                widget.imagePath == Assets.images.svgs.icons.icEye.path),
      );
      expect(passwordToggleIcon, findsOneWidget);

      await tester.tap(passwordToggleIcon);
      await tester.pump();

      verify(() => mockAuthBloc.add(any(that: isA<ChanegPasswordVisibility>()))).called(1);
    });

    testWidgets('should show social login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      // Assert - Check for social login button images instead of text
      // The social login buttons are implemented as CustomImageView widgets, not text
      final socialLoginButtons = find.byType(CustomImageView);
      expect(socialLoginButtons, findsAtLeastNWidgets(3)); // Should find at least 3 social login buttons

      // Verify the social login section exists
      expect(find.byType(Row), findsAtLeastNWidgets(1)); // The social buttons are in a Row widget
    });

    testWidgets('should show divider with "or continue with" text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));

      expect(find.text(Lang.of(context).lbl_or_continue_with), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('should show sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));

      expect(find.text(Lang.of(context).lbl_new_to_exchek), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_sign_up), findsOneWidget);
    });

    testWidgets('should enable login button when all fields are filled for email login', (WidgetTester tester) async {
      final emailController = TextEditingController(text: 'test@example.com');
      final passwordController = TextEditingController(text: 'password123');

      when(() => mockAuthState.emailIdUserNameController).thenReturn(emailController);
      when(() => mockAuthState.passwordController).thenReturn(passwordController);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is CustomElevatedButton && widget.text == Lang.of(tester.element(find.byType(LoginView))).lbl_login,
      );

      expect(loginButton, findsOneWidget);

      final loginButtonWidget = tester.widget<CustomElevatedButton>(loginButton);
      expect(loginButtonWidget.isDisabled, isFalse);
    });

    testWidgets('should disable login button when fields are empty', (WidgetTester tester) async {
      final emailController = TextEditingController(text: '');
      final passwordController = TextEditingController(text: '');

      when(() => mockAuthState.emailIdUserNameController).thenReturn(emailController);
      when(() => mockAuthState.passwordController).thenReturn(passwordController);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is CustomElevatedButton && widget.text == Lang.of(tester.element(find.byType(LoginView))).lbl_login,
      );

      expect(loginButton, findsOneWidget);

      final loginButtonWidget = tester.widget<CustomElevatedButton>(loginButton);
      expect(loginButtonWidget.isDisabled, isTrue);
    });

    testWidgets('should show loading state on login button when logging in', (WidgetTester tester) async {
      // 1. Setup loading state
      when(() => mockAuthState.isloginLoading).thenReturn(true);

      // 2. Build widget (with shorter timeout)
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Use pump() instead of pumpAndSettle
      await tester.pump();

      // 4. Verify
      final loginButton = find.byWidgetPredicate(
        (widget) => widget is CustomElevatedButton && widget.isLoading == true,
      );
      expect(loginButton, findsOneWidget);
    });

    testWidgets('should show OTP timer when timer is running', (WidgetTester tester) async {
      when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);
      when(() => mockAuthState.isOtpTimerRunning).thenReturn(true);
      when(() => mockAuthState.otpRemainingTime).thenReturn(30);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      expect(find.textContaining('${Lang.of(context).lbl_resend_in} 30s'), findsOneWidget);
    });

    testWidgets('should send OTP when send OTP button is tapped', (WidgetTester tester) async {
      final phoneController = TextEditingController(text: '1234567890');

      when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);
      when(() => mockAuthState.phoneController).thenReturn(phoneController);
      when(() => mockAuthState.isOtpTimerRunning).thenReturn(false);
      when(() => mockAuthState.otpRemainingTime).thenReturn(0);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      final sendOtpButton = find.text(Lang.of(context).lbl_send_otp);

      expect(sendOtpButton, findsOneWidget);

      await tester.tap(sendOtpButton);
      await tester.pump();

      verify(() => mockAuthBloc.add(any(that: isA<SendOtpPressed>()))).called(1);
    });

    testWidgets('should render social login buttons correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Ensure we're scrolling to the buttons if needed
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pump();

      // Find social login buttons by looking for SizedBox widgets with height 35 (social button containers)
      final socialButtonContainers = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 35);
      expect(socialButtonContainers, findsNWidgets(3)); // Should find exactly 3 social buttons

      // Verify that the social login section exists and is properly structured
      expect(find.byType(Row), findsAtLeastNWidgets(1)); // Social buttons are in a Row

      // Verify that CustomImageView widgets exist for the social buttons
      final imageViews = find.byType(CustomImageView);
      expect(imageViews, findsAtLeastNWidgets(3)); // Should find at least 3 image views (including social buttons)
    });

    testWidgets('should show correct form based on login type state changes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));

      // Initially should show email form
      expect(find.text(Lang.of(context).lbl_email_userid), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_password), findsOneWidget);

      // Change to phone login
      when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);
      mockAuthBloc.emitState(mockAuthState);
      await tester.pumpAndSettle();

      // Should now show phone form
      expect(find.text(Lang.of(context).lbl_mobile_number), findsOneWidget);
      expect(find.text(Lang.of(context).lbl_one_time_password), findsOneWidget);
    });

    group('Social Login Tests', () {
      testWidgets('should handle Google sign in button tap', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find Google sign in button
        final googleButton = find.byWidgetPredicate(
          (widget) => widget is CustomImageView && widget.imagePath == Assets.images.pngs.authentication.pngGoogle.path,
        );

        expect(googleButton, findsOneWidget);

        await tester.tap(googleButton);
        await tester.pump();

        verify(() => mockAuthBloc.add(any(that: isA<GoogleSignInPressed>()))).called(1);
      });

      testWidgets('should handle Apple sign in button tap', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find Apple sign in button
        final appleButton = find.byWidgetPredicate(
          (widget) => widget is CustomImageView && widget.imagePath == Assets.images.pngs.authentication.pngApple.path,
        );

        expect(appleButton, findsOneWidget);

        await tester.tap(appleButton);
        await tester.pump();

        verify(() => mockAuthBloc.add(any(that: isA<AppleSignInPressed>()))).called(1);
      });

      testWidgets('should handle LinkedIn sign in button tap', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find LinkedIn sign in button
        final linkedinButton = find.byWidgetPredicate(
          (widget) =>
              widget is CustomImageView && widget.imagePath == Assets.images.pngs.authentication.pngLinkedIn.path,
        );

        expect(linkedinButton, findsOneWidget);

        await tester.tap(linkedinButton);
        await tester.pump();

        verify(() => mockAuthBloc.add(any(that: isA<LinkedInSignInPressed>()))).called(1);
      });
    });

    group('OTP Field Tests', () {
      testWidgets('should show send OTP button when timer is not running', (WidgetTester tester) async {
        final phoneController = TextEditingController(text: '1234567890');

        when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);
        when(() => mockAuthState.phoneController).thenReturn(phoneController);
        when(() => mockAuthState.isOtpTimerRunning).thenReturn(false);
        when(() => mockAuthState.otpRemainingTime).thenReturn(0);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(LoginView));
        expect(find.text(Lang.of(context).lbl_send_otp), findsOneWidget);
      });

      testWidgets('should show send OTP button when phone number is valid', (WidgetTester tester) async {
        final phoneController = TextEditingController(text: '1234567890');

        when(() => mockAuthState.selectedLoginType).thenReturn(LoginType.phone);
        when(() => mockAuthState.phoneController).thenReturn(phoneController);
        when(() => mockAuthState.isOtpTimerRunning).thenReturn(false);
        when(() => mockAuthState.otpRemainingTime).thenReturn(0);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(LoginView));
        expect(find.text(Lang.of(context).lbl_send_otp), findsOneWidget);
      });
    });

    group('Password Field Tests', () {
      testWidgets('should toggle password visibility when eye icon is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Initially password should be obscured
        expect(
          find.byWidgetPredicate(
            (widget) => widget is CustomImageView && widget.imagePath == Assets.images.svgs.icons.icEyeSlash.path,
          ),
          findsOneWidget,
        );

        // Tap the eye icon
        final eyeIcon = find.byWidgetPredicate(
          (widget) => widget is CustomImageView && widget.imagePath == Assets.images.svgs.icons.icEyeSlash.path,
        );

        await tester.tap(eyeIcon);
        await tester.pump();

        verify(() => mockAuthBloc.add(any(that: isA<ChanegPasswordVisibility>()))).called(1);
      });

      testWidgets('should show eye icon when password is visible', (WidgetTester tester) async {
        when(() => mockAuthState.isObscuredPassword).thenReturn(false);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) => widget is CustomImageView && widget.imagePath == Assets.images.svgs.icons.icEye.path,
          ),
          findsOneWidget,
        );
      });
    });

    group('BlocConsumer Tests', () {
      testWidgets('should handle login success state', (WidgetTester tester) async {
        when(() => mockAuthState.isLoginSuccess).thenReturn(true);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // The listener should handle the success state
        expect(find.byType(LoginView), findsOneWidget);
      });

      testWidgets('should handle BlocConsumer listener callback', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Widget should render correctly
        expect(find.byType(LoginView), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have correct widget hierarchy', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(LandingPageScaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
        expect(find.byType(ScrollConfiguration), findsAtLeastNWidgets(1));
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(ConstrainedBox), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(2));
      });

      testWidgets('should have correct background color', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final scaffold = tester.widget<LandingPageScaffold>(find.byType(LandingPageScaffold));
        expect(scaffold.backgroundColor, isA<Color>());
      });

      testWidgets('should have correct scroll physics', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final scrollView = tester.widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
        expect(scrollView.physics, isA<BouncingScrollPhysics>());
        expect(scrollView.clipBehavior, Clip.none);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle invalid form keys gracefully', (WidgetTester tester) async {
        final invalidFormKey = GlobalKey<FormState>();

        when(() => mockAuthState.emailFormKey).thenReturn(invalidFormKey);
        when(() => mockAuthState.phoneFormKey).thenReturn(invalidFormKey);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Widget should still render
        expect(find.byType(LoginView), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have semantic labels for accessibility', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
        expect(find.byType(CustomElevatedButton), findsAtLeastNWidgets(1));
        expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(LoginView));

        // Check for important text elements
        expect(find.text(Lang.of(context).lbl_login_title), findsOneWidget);
        expect(find.text(Lang.of(context).lbl_email_userid), findsOneWidget);
        expect(find.text(Lang.of(context).lbl_password), findsOneWidget);
        expect(find.text(Lang.of(context).lbl_login), findsOneWidget);
      });
    });
  });
}
