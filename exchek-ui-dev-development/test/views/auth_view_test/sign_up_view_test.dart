import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  AuthState _state = MockAuthState();

  @override
  AuthState get state => _state;

  @override
  Stream<AuthState> get stream => _controller.stream;

  final _controller = StreamController<AuthState>.broadcast();
}

class MockAuthState extends Mock implements AuthState {
  final TextEditingController _signupEmailIdController = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _issignupLoading = false;
  bool _issignupSuccess = false;
  bool _isAgreeTermsAndServiceAndPrivacyPolicy = false;

  @override
  TextEditingController get signupEmailIdController => _signupEmailIdController;

  @override
  GlobalKey<FormState> get signupFormKey => _signupFormKey;

  @override
  bool get issignupLoading => _issignupLoading;
  set issignupLoading(bool value) => _issignupLoading = value;

  @override
  bool get issignupSuccess => _issignupSuccess;
  set issignupSuccess(bool value) => _issignupSuccess = value;

  @override
  bool get isAgreeTermsAndServiceAndPrivacyPolicy => _isAgreeTermsAndServiceAndPrivacyPolicy;
  set isAgreeTermsAndServiceAndPrivacyPolicy(bool value) => _isAgreeTermsAndServiceAndPrivacyPolicy = value;
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAuthState mockAuthState;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    registerFallbackValue(MockRoute());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAuthState = MockAuthState();
    mockGoRouter = MockGoRouter();

    // Set the state directly instead of using when()
    mockAuthBloc._state = mockAuthState;
  });

  tearDown(() {
    mockAuthBloc._controller.close();
  });

  Future<void> pumpSignUpView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        home: InheritedGoRouter(
          goRouter: mockGoRouter,
          child: BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: const SignUpView()),
        ),
      ),
    );
    // Add a small delay to allow animations to start
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('SignUpView Widget Tests', () {
    testWidgets('renders app logo', (WidgetTester tester) async {
      await pumpSignUpView(tester);

      final logoFinder = find.byWidgetPredicate(
        (widget) => widget is CustomImageView && (widget.imagePath as String).contains('app_logo'),
      );
      expect(logoFinder, findsOneWidget);
    });

    testWidgets('renders create account title', (WidgetTester tester) async {
      await pumpSignUpView(tester);

      expect(find.text(Lang.of(tester.element(find.byType(SignUpView))).lbl_create_account_title), findsOneWidget);
    });

    group('Email Input Form', () {
      testWidgets('shows email input field', (WidgetTester tester) async {
        await pumpSignUpView(tester);

        expect(find.text(Lang.of(tester.element(find.byType(SignUpView))).lbl_email_address), findsOneWidget);
      });

      testWidgets('allows text input in email field', (WidgetTester tester) async {
        await pumpSignUpView(tester);

        await tester.enterText(find.byType(CustomTextInputField), 'test@example.com');
        await tester.pump();

        expect(find.text('test@example.com'), findsOneWidget);
      });
    });

    group('Next Button', () {
      testWidgets('next button is disabled initially', (WidgetTester tester) async {
        await pumpSignUpView(tester);

        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isDisabled, isTrue);
      });

      testWidgets('next button is enabled when form is valid and terms accepted', (WidgetTester tester) async {
        // Set the required state directly on mockAuthState
        mockAuthState.signupEmailIdController.text = 'test@example.com';
        mockAuthState.isAgreeTermsAndServiceAndPrivacyPolicy = true;
        mockAuthState.issignupLoading = false;

        await pumpSignUpView(tester);

        // Find and verify the button is enabled
        final buttonFinder = find.byType(CustomElevatedButton);
        expect(buttonFinder, findsOneWidget);

        final button = tester.widget<CustomElevatedButton>(buttonFinder);
        expect(button.isDisabled, isFalse);
      });

      testWidgets('shows loading indicator when signing up', (WidgetTester tester) async {
        // Set loading state directly
        mockAuthState._issignupLoading = true;

        await pumpSignUpView(tester);

        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isLoading, isTrue);
      });
    });

    group('Social Login Options', () {
      testWidgets('shows social login buttons', (WidgetTester tester) async {
        await pumpSignUpView(tester);

        // Assert - Check for social login button images instead of text
        // The social login buttons are implemented as CustomImageView widgets, not text
        final socialLoginButtons = find.byType(CustomImageView);
        expect(socialLoginButtons, findsAtLeastNWidgets(3)); // Should find at least 3 social login buttons

        // Verify the social login section exists with proper structure
        expect(find.byType(Row), findsAtLeastNWidgets(1)); // The social buttons are in a Row widget

        // Verify social button containers (SizedBox with height 35)
        final socialButtonContainers = find.byWidgetPredicate((widget) => widget is SizedBox && widget.height == 35);
        expect(socialButtonContainers, findsNWidgets(3)); // Should find exactly 3 social button containers
      });

      testWidgets('shows divider with text', (WidgetTester tester) async {
        await pumpSignUpView(tester);

        final context = tester.element(find.byType(SignUpView));
        expect(find.text(Lang.of(context).lbl_or_continue_with), findsOneWidget);
        expect(find.byType(Divider), findsNWidgets(2));
      });
    });
  });
}
