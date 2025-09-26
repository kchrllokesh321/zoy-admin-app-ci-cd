import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/common_widget/password_checklist_item.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'business_account_set_password_test.mocks.dart';

void main() {
  group('BusinessAccountSetPassword Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();

      // Set up default stub for stream property
      when(mockBloc.stream).thenAnswer((_) => Stream<BusinessAccountSetupState>.empty());
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        locale: const Locale('en'),
        home: Scaffold(
          body: BlocProvider<BusinessAccountSetupBloc>.value(
            value: mockBloc,
            child: const BusinessAccountSetPassword(),
          ),
        ),
      );
    }

    BusinessAccountSetupState createMockState({
      GlobalKey<FormState>? sePasswordFormKey,
      TextEditingController? createPasswordController,
      TextEditingController? confirmPasswordController,
      bool isCreatePasswordObscure = true,
      bool isConfirmPasswordObscure = true,
      bool isSignupSuccess = false,
      bool isSignupLoading = false,
    }) {
      return BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.setPassword,
        goodsAndServiceExportDescriptionController: TextEditingController(),
        goodsExportOtherController: TextEditingController(),
        serviceExportOtherController: TextEditingController(),
        businessActivityOtherController: TextEditingController(),
        scrollController: ScrollController(),
        formKey: GlobalKey<FormState>(),
        businessLegalNameController: TextEditingController(),
        professionalWebsiteUrl: TextEditingController(),
        phoneController: TextEditingController(),
        otpController: TextEditingController(),
        sePasswordFormKey: sePasswordFormKey ?? GlobalKey<FormState>(),
        createPasswordController: createPasswordController ?? TextEditingController(),
        confirmPasswordController: confirmPasswordController ?? TextEditingController(),
        isCreatePasswordObscure: isCreatePasswordObscure,
        isConfirmPasswordObscure: isConfirmPasswordObscure,
        isSignupLoading: isSignupLoading,
        isSignupSuccess: isSignupSuccess,
        currentKycVerificationStep: KycVerificationSteps.panVerification,
        aadharNumberController: TextEditingController(),
        aadharOtpController: TextEditingController(),
        aadharVerificationFormKey: GlobalKey<FormState>(),
        kartaAadharNumberController: TextEditingController(),
        kartaAadharOtpController: TextEditingController(),
        kartaAadharVerificationFormKey: GlobalKey<FormState>(),
        hufPanVerificationKey: GlobalKey<FormState>(),
        hufPanNumberController: TextEditingController(),
        isHUFPanVerifyingLoading: false,
        businessPanNumberController: TextEditingController(),
        businessPanNameController: TextEditingController(),
        businessPanVerificationKey: GlobalKey<FormState>(),
        directorsPanVerificationKey: GlobalKey<FormState>(),
        director1PanNumberController: TextEditingController(),
        director1PanNameController: TextEditingController(),
        director2PanNumberController: TextEditingController(),
        director2PanNameController: TextEditingController(),
        beneficialOwnerPanVerificationKey: GlobalKey<FormState>(),
        beneficialOwnerPanNumberController: TextEditingController(),
        beneficialOwnerPanNameController: TextEditingController(),
        businessRepresentativeFormKey: GlobalKey<FormState>(),
        businessRepresentativePanNumberController: TextEditingController(),
        businessRepresentativePanNameController: TextEditingController(),
        registerAddressFormKey: GlobalKey<FormState>(),
        selectedCountry: Country(
          phoneCode: '91',
          countryCode: 'IN',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'India',
          example: '9123456789',
          displayName: 'India',
          displayNameNoCountryCode: 'India',
          e164Key: '',
        ),
        pinCodeController: TextEditingController(),
        stateNameController: TextEditingController(),
        cityNameController: TextEditingController(),
        address1NameController: TextEditingController(),
        address2NameController: TextEditingController(),
        turnOverController: TextEditingController(),
        gstNumberController: TextEditingController(),
        annualTurnoverFormKey: GlobalKey<FormState>(),
        isGstCertificateMandatory: false,
        iceVerificationKey: GlobalKey<FormState>(),
        iceNumberController: TextEditingController(),
        cinVerificationKey: GlobalKey<FormState>(),
        cinNumberController: TextEditingController(),
        llpinNumberController: TextEditingController(),
        bankAccountVerificationFormKey: GlobalKey<FormState>(),
        bankAccountNumberController: TextEditingController(),
        reEnterbankAccountNumberController: TextEditingController(),
        ifscCodeController: TextEditingController(),
        directorCaptchaInputController: TextEditingController(),
        kartaCaptchaInputController: TextEditingController(),
        partnerAadharNumberController: TextEditingController(),
        partnerAadharOtpController: TextEditingController(),
        partnerAadharVerificationFormKey: GlobalKey<FormState>(),
        partnerCaptchaInputController: TextEditingController(),
        proprietorAadharNumberController: TextEditingController(),
        proprietorAadharOtpController: TextEditingController(),
        proprietorAadharVerificationFormKey: GlobalKey<FormState>(),
        proprietorCaptchaInputController: TextEditingController(),
        directorEmailIdNumberController: TextEditingController(),
        directorMobileNumberController: TextEditingController(),
        directorContactInformationKey: GlobalKey<FormState>(),
        otherDirectorsPanVerificationKey: GlobalKey<FormState>(),
        otherDirectorVerificationFormKey: GlobalKey<FormState>(),
        otherDirectorAadharNumberController: TextEditingController(),
        otherDirectoraadharOtpController: TextEditingController(),
        otherDirectorCaptchaInputController: TextEditingController(),
        directorKycStep: DirectorKycSteps.panDetails,
        companyPanVerificationKey: GlobalKey<FormState>(),
        companyPanCardFile: null,
        isCompanyPanDetailsLoading: false,
        isCompanyPanDetailsVerified: false,
        fullCompanyNamePan: null,
        isCompanyPanVerifyingLoading: false,
        companyPanNumberController: TextEditingController(),
        llpPanVerificationKey: GlobalKey<FormState>(),
        llpPanNumberController: TextEditingController(),
        isLLPPanVerifyingLoading: false,
        partnershipFirmPanVerificationKey: GlobalKey<FormState>(),
        partnershipFirmPanNumberController: TextEditingController(),
        isPartnershipFirmPanVerifyingLoading: false,
        soleProprietorShipPanVerificationKey: GlobalKey<FormState>(),
        soleProprietorShipPanNumberController: TextEditingController(),
        isSoleProprietorShipPanVerifyingLoading: false,
        kartaPanVerificationKey: GlobalKey<FormState>(),
        kartaPanNumberController: TextEditingController(),
        isKartaPanVerifyingLoading: false,
        authorizedPinCodeController: TextEditingController(),
        authorizedStateNameController: TextEditingController(),
        authorizedCityNameController: TextEditingController(),
        authorizedAddress1NameController: TextEditingController(),
        authorizedAddress2NameController: TextEditingController(),
        otherDirectorPinCodeController: TextEditingController(),
        otherDirectorStateNameController: TextEditingController(),
        otherDirectorCityNameController: TextEditingController(),
        otherDirectorAddress1NameController: TextEditingController(),
        otherDirectorAddress2NameController: TextEditingController(),
        beneficialOwnerPinCodeController: TextEditingController(),
        beneficialOwnerStateNameController: TextEditingController(),
        beneficialOwnerCityNameController: TextEditingController(),
        beneficialOwnerAddress1NameController: TextEditingController(),
        beneficialOwnerAddress2NameController: TextEditingController(),
        dbaController: TextEditingController(),
      );
    }

    testWidgets('should display title and description', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('Create a strong password to keep your account safe'), findsOneWidget);
      expect(find.textContaining('secure handling of your incoming funds'), findsOneWidget);
    });

    testWidgets('should display password fields', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('Create password'), findsOneWidget);
      expect(find.textContaining('Confirm Password'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNWidgets(2));
    });

    testWidgets('should display password checklist when password is entered', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createMockState(createPasswordController: TextEditingController(text: 'Test123!')));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PasswordChecklistItem), findsNWidgets(5));
      expect(find.textContaining('One lowercase character'), findsOneWidget);
      expect(find.textContaining('One number'), findsOneWidget);
      expect(find.textContaining('One uppercase character'), findsOneWidget);
      expect(find.textContaining('One special character'), findsOneWidget);
      expect(find.textContaining('8 characters minimum'), findsOneWidget);
    });

    testWidgets('should not display password checklist when password is empty', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PasswordChecklistItem), findsNothing);
    });

    testWidgets('should display Sign Up button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should disable Sign Up button when fields are empty', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Sign Up button when both fields are filled', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createMockState(
          createPasswordController: TextEditingController(text: 'Test123!'),
          confirmPasswordController: TextEditingController(text: 'Test123!'),
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should show loading state when signup is loading', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createMockState(
          createPasswordController: TextEditingController(text: 'Test123!'),
          confirmPasswordController: TextEditingController(text: 'Test123!'),
          isSignupLoading: true,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isLoading, isTrue);
    });

    testWidgets('should toggle password visibility when eye icon tapped', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byType(CustomImageView).first);

      // Assert
      verify(mockBloc.add(ChangeCreatePasswordVisibility(obscuredText: false))).called(1);
    });

    testWidgets('should have enabled Sign Up button when form is valid', (WidgetTester tester) async {
      // Arrange
      final createPasswordController = TextEditingController(text: 'Test123!@');
      final confirmPasswordController = TextEditingController(text: 'Test123!@');

      when(mockBloc.state).thenReturn(
        createMockState(
          createPasswordController: createPasswordController,
          confirmPasswordController: confirmPasswordController,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Button should be enabled when both fields have valid text
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should display widget when signup is successful', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState(isSignupSuccess: true));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Just verify the widget renders without errors when isSignupSuccess is true
      expect(find.byType(BusinessAccountSetPassword), findsOneWidget);
    });
  });
}
