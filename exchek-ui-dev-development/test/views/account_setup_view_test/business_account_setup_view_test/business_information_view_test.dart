import 'package:exchek/core/utils/exports.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'business_information_view_test.mocks.dart';

// Minimal fakes for dependencies
class FakeApiClient extends ApiClient {
  FakeApiClient() : super();
  @override
  Future<Map<String, dynamic>> request(
    RequestType type,
    String path, {
    dynamic data,
    Map<String, dynamic>? multipartData,
    bool isShowToast = true,
  }) async {
    return {};
  }
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(apiClient: FakeApiClient(), oauth2Config: OAuth2Config());
  @override
  Future<CommonSuccessModel> sendOtp({required String mobile, required String type}) async {
    return CommonSuccessModel(success: true, message: "OTP sent");
  }
}

void main() {
  setUpAll(() async {
    dotenv.testLoad(
      fileInput: '''
GOOGLE_AUTHORIZE_URL=https://dummy
GOOGLE_TOKEN_URL=https://dummy
GOOGLE_CLIENT_ID=dummy
GOOGLE_CLIENT_SECRET=dummy
GOOGLE_REDIRECT_URI=dummy
GOOGLE_REDIRECT_URI_WEB=dummy
APPLE_AUTHORIZE_URL=https://dummy
APPLE_TOKEN_URL=https://dummy
APPLE_CLIENT_ID=dummy
APPLE_CLIENT_SECRET=dummy
APPLE_REDIRECT_URI=dummy
APPLE_REDIRECT_URI_WEB=dummy
LINKEDIN_AUTHORIZE_URL=https://dummy
LINKEDIN_TOKEN_URL=https://dummy
LINKEDIN_CLIENT_ID=dummy
LINKEDIN_CLIENT_SECRET=dummy
LINKEDIN_REDIRECT_URI=dummy
LINKEDIN_REDIRECT_URI_WEB=dummy
APP_NAME=dummy
''',
    );
  });

  group('BusinessInformationView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();
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
          body: BlocProvider<BusinessAccountSetupBloc>.value(value: mockBloc, child: const BusinessInformationView()),
        ),
      );
    }

    BusinessAccountSetupState createMockState({
      TextEditingController? businessLegalNameController,
      TextEditingController? professionalWebsiteUrl,
      TextEditingController? phoneController,
      TextEditingController? otpController,
      bool isBusinessInfoOtpSent = false,
      bool isOtpTimerRunning = false,
      int otpRemainingTime = 0,
    }) {
      return BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessInformation,
        goodsAndServiceExportDescriptionController: TextEditingController(),
        goodsExportOtherController: TextEditingController(),
        serviceExportOtherController: TextEditingController(),
        businessActivityOtherController: TextEditingController(),
        scrollController: ScrollController(),
        formKey: GlobalKey<FormState>(),
        businessLegalNameController: businessLegalNameController ?? TextEditingController(),
        professionalWebsiteUrl: professionalWebsiteUrl ?? TextEditingController(),
        phoneController: phoneController ?? TextEditingController(),
        otpController: otpController ?? TextEditingController(),
        sePasswordFormKey: GlobalKey<FormState>(),
        createPasswordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
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
        isBusinessInfoOtpSent: isBusinessInfoOtpSent,
        isOtpTimerRunning: isOtpTimerRunning,
        otpRemainingTime: otpRemainingTime,
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
      expect(find.textContaining('Verify your business identity and contact information'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display all form fields', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Name, Website, Phone
      expect(find.textContaining('Business legal name'), findsOneWidget);
      expect(find.textContaining('Professional website URL'), findsOneWidget);
      expect(find.textContaining('Mobile Number'), findsOneWidget);
    });

    testWidgets('should display Send OTP button when OTP not sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createMockState());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('should display OTP field and Confirm button when OTP sent', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createMockState(isBusinessInfoOtpSent: true, isOtpTimerRunning: false, otpRemainingTime: 0));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('OTP'), findsAtLeastNWidgets(1));
      expect(find.text('Confirm and Continue'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNWidgets(4)); // Including OTP field
    });

    testWidgets('should disable form fields when OTP timer is running', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createMockState(isBusinessInfoOtpSent: true, isOtpTimerRunning: true, otpRemainingTime: 60));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Check that there's at least one AbsorbPointer that is absorbing
      final absorbPointers = find.byType(AbsorbPointer);
      expect(absorbPointers, findsAtLeastNWidgets(1));

      // Verify that at least one AbsorbPointer is absorbing
      final absorbingPointer = tester
          .widgetList<AbsorbPointer>(absorbPointers)
          .any((widget) => widget.absorbing == true);
      expect(absorbingPointer, isTrue);
    });

    testWidgets('should display resend OTP timer when timer is running', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createMockState(isBusinessInfoOtpSent: true, isOtpTimerRunning: true, otpRemainingTime: 120));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('02:00'), findsOneWidget);
    });

    testWidgets('should enable Send OTP button when phone number is valid', (WidgetTester tester) async {
      // Arrange
      final phoneController = TextEditingController(text: '9876543210');
      when(mockBloc.state).thenReturn(createMockState(phoneController: phoneController));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.widgetWithText(CustomElevatedButton, 'Send OTP'));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should disable Send OTP button when phone number is invalid', (WidgetTester tester) async {
      // Arrange
      final phoneController = TextEditingController(text: '123');
      when(mockBloc.state).thenReturn(createMockState(phoneController: phoneController));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.widgetWithText(CustomElevatedButton, 'Send OTP'));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Confirm button when all fields are filled', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createMockState(
          businessLegalNameController: TextEditingController(text: 'Test Company'),
          professionalWebsiteUrl: TextEditingController(text: 'https://test.com'),
          phoneController: TextEditingController(text: '9876543210'),
          otpController: TextEditingController(text: '123456'),
          isBusinessInfoOtpSent: true,
          isOtpTimerRunning: false,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(
        find.widgetWithText(CustomElevatedButton, 'Confirm and Continue'),
      );
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should have enabled Confirm button when all fields are filled', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createMockState(
          businessLegalNameController: TextEditingController(text: 'Test Company'),
          professionalWebsiteUrl: TextEditingController(text: 'https://test.com'),
          phoneController: TextEditingController(text: '9876543210'),
          otpController: TextEditingController(text: '123456'),
          isBusinessInfoOtpSent: true,
          isOtpTimerRunning: false,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Button should be enabled when all fields are filled
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(find.text('Confirm and Continue'), findsOneWidget);
    });
  });
}
