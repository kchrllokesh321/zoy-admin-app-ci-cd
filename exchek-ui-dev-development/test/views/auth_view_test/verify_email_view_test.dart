import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock class for ResendEmailLink event
class MockResendEmailLink extends Mock implements ResendEmailLink {}

class MockAuthBloc extends Mock implements AuthBloc {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _controller.stream;

  @override
  Future<void> close() {
    _controller.close();
    return Future.value();
  }

  @override
  AuthState get state => mockAuthState;
}

// Create a global variable to hold the mock state
late MockAuthState mockAuthState;

class MockAuthState extends Mock implements AuthState {
  final TextEditingController _signupEmailController = TextEditingController(text: 'test@example.com');
  bool _isVerifyEmail = false;
  bool _isVerifyEmailLoading = false;
  bool _isOtpTimerRunningForverifyEmail = false;
  int _otpRemainingTimeForverifyEmail = 0;

  @override
  TextEditingController? get signupEmailIdController => _signupEmailController;

  @override
  bool get isVerifyEmail => _isVerifyEmail;

  @override
  bool get isVerifyEmailLoading => _isVerifyEmailLoading;

  @override
  bool get isOtpTimerRunningForverifyEmail => _isOtpTimerRunningForverifyEmail;

  @override
  int get otpRemainingTimeForverifyEmail => _otpRemainingTimeForverifyEmail;

  void setVerifyEmail(bool value) => _isVerifyEmail = value;
  void setVerifyEmailLoading(bool value) => _isVerifyEmailLoading = value;
  void setOtpTimerRunningForverifyEmail(bool value) => _isOtpTimerRunningForverifyEmail = value;
  void setOtpRemainingTimeForverifyEmail(int value) => _otpRemainingTimeForverifyEmail = value;
}

void main() {
  late MockAuthBloc mockAuthBloc;
  final Map<String, String> mockStorage = {};

  setUpAll(() {
    // Initialize Flutter binding for tests
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock flutter_secure_storage plugin
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            mockStorage[key] = value;
            return null;
          case 'read':
            final String key = methodCall.arguments['key'];
            return mockStorage[key];
          case 'delete':
            final String key = methodCall.arguments['key'];
            mockStorage.remove(key);
            return null;
          case 'deleteAll':
            mockStorage.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(mockStorage);
          case 'containsKey':
            final String key = methodCall.arguments['key'];
            return mockStorage.containsKey(key);
          default:
            return null;
        }
      },
    );

    // Register fallback values for mocktail
    registerFallbackValue(MockResendEmailLink());
  });

  setUp(() {
    mockAuthState = MockAuthState();
    mockAuthBloc = MockAuthBloc();

    // Initialize with default values
    mockAuthState.setVerifyEmail(false);
    mockAuthState.setVerifyEmailLoading(false);
    mockAuthState.setOtpTimerRunningForverifyEmail(false);
    mockAuthState.setOtpRemainingTimeForverifyEmail(0);
  });

  tearDown(() async {
    mockAuthBloc.close();
    // Clean up preferences after each test
    await Prefobj.preferences.put(Prefkeys.emailId, '');
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
      home: BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: const VerifyEmailView()),
    );
  }

  group('VerifyEmailView Widget Tests', () {
    testWidgets('renders app logo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final logoFinder = find.byWidgetPredicate(
        (widget) => widget is CustomImageView && (widget.imagePath as String).contains('app_logo'),
      );
      expect(logoFinder, findsOneWidget);
    });

    testWidgets('renders check email title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Get the context to access localized strings
      final context = tester.element(find.byType(VerifyEmailView));
      expect(find.text(Lang.of(context).lbl_check_your_email), findsOneWidget);
    });

    testWidgets('displays email verification message', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Wait for FutureBuilder to complete
      await tester.pumpAndSettle();

      // Get the context to access localized strings
      final context = tester.element(find.byType(VerifyEmailView));

      // Check for the verification message text parts
      // The message format is: "lbl_verify_email_send $emailId - lbl_follow_link"
      // Since the FutureBuilder might return empty email, just check for the basic structure
      expect(find.textContaining(Lang.of(context).lbl_verify_email_send), findsOneWidget);
      expect(find.textContaining(Lang.of(context).lbl_follow_link), findsOneWidget);
    });

    testWidgets('shows resend email button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find the button by its type
      final buttonFinder = find.byType(CustomElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Get the button widget
      final button = tester.widget<CustomElevatedButton>(buttonFinder);
      expect(button.text, Lang.of(tester.element(find.byType(VerifyEmailView))).lbl_resend_email);
    });

    testWidgets('resend email button triggers verify email event', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find the button by its type
      final buttonFinder = find.byType(CustomElevatedButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockAuthBloc.add(any(that: isA<ResendEmailLink>()))).called(1);
    });

    testWidgets('shows loading state when verifying email', (WidgetTester tester) async {
      mockAuthState.setVerifyEmailLoading(true);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find the button by its type
      final buttonFinder = find.byType(CustomElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // Get the button widget
      final buttonWidget = tester.widget<CustomElevatedButton>(buttonFinder);

      expect(buttonWidget.isLoading, isTrue);
      expect(buttonWidget.isDisabled, isTrue);
    });

    testWidgets('shows timer when OTP timer is running', (WidgetTester tester) async {
      mockAuthState.setOtpTimerRunningForverifyEmail(true);
      mockAuthState.setOtpRemainingTimeForverifyEmail(30);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Get the context to access localized strings
      final context = tester.element(find.byType(VerifyEmailView));

      // Check for timer text
      final timerText = '${Lang.of(context).lbl_resend_email_in} 30 ${Lang.of(context).lbl_seconds}';
      expect(find.textContaining(timerText), findsOneWidget);
    });
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
