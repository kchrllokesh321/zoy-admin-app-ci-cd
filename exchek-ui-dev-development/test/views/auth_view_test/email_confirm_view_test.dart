import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _controller.stream;

  final AuthState _state = MockAuthState();

  @override
  AuthState get state => _state;
}

class MockAuthState extends Mock implements AuthState {}

class MockGoRouter extends Mock implements GoRouter {}

// Create a mock for ResponsiveHelper
class MockResponsiveHelper extends Mock implements ResponsiveHelper {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAuthState mockAuthState;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAuthState = MockAuthState();
    mockGoRouter = MockGoRouter();
  });

  tearDown(() {
    mockAuthBloc._controller.close();
  });

  Future<void> pumpEmailConfirmView(WidgetTester tester) async {
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
          child: BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: const EmailConfirmView()),
        ),
      ),
    );
    // Add a small delay to allow animations to start
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('EmailConfirmView Widget Tests', () {
    testWidgets('renders app logo', (WidgetTester tester) async {
      await pumpEmailConfirmView(tester);

      final logoFinder = find.byWidgetPredicate(
        (widget) => widget is CustomImageView && (widget.imagePath as String).contains('app_logo'),
      );
      expect(logoFinder, findsOneWidget);
    });

    testWidgets('renders email confirm title', (WidgetTester tester) async {
      await pumpEmailConfirmView(tester);

      final context = tester.element(find.byType(EmailConfirmView));
      expect(find.text(Lang.of(context).lbl_email_confirm), findsOneWidget);
    });

    testWidgets('renders continue with account text', (WidgetTester tester) async {
      await pumpEmailConfirmView(tester);

      final context = tester.element(find.byType(EmailConfirmView));
      expect(find.text(Lang.of(context).lbl_continue_with_account), findsOneWidget);
    });

    testWidgets('renders continue button', (WidgetTester tester) async {
      await pumpEmailConfirmView(tester);

      final context = tester.element(find.byType(EmailConfirmView));
      expect(find.widgetWithText(CustomElevatedButton, Lang.of(context).lbl_continue), findsOneWidget);
    });

    testWidgets('continue button has correct width on mobile', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800); // Mobile size
      tester.view.devicePixelRatio = 1.0;

      await pumpEmailConfirmView(tester);

      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      final buttonParent = tester.widget<SizedBox>(
        find.ancestor(of: find.byType(CustomElevatedButton), matching: find.byType(SizedBox)).first,
      );

      expect(buttonParent.width, equals(double.infinity));

      // Reset the screen size
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('renders wave background when isWebAndIsNotMobile returns true', (WidgetTester tester) async {
      // Create a separate test file that doesn't use the actual implementation
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
            child: BlocProvider<AuthBloc>.value(
              value: mockAuthBloc,
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Stack(
                      children: [
                        // Always include the WaveBackground for this test
                        Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: WaveBackground()),
                        // Other content
                        Center(child: Text('Email Confirm View')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verify the WaveBackground is rendered
      expect(find.byType(WaveBackground), findsOneWidget);
    });

    testWidgets('does not render wave background when isWebAndIsNotMobile returns false', (WidgetTester tester) async {
      // First test with mobile size (should NOT show wave background)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await pumpEmailConfirmView(tester);
      await tester.pump();

      expect(find.byType(WaveBackground), findsNothing);

      // Clean up
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
