import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_residential_address.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/common_widget/app_loader_widget.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_residential_address_test.mocks.dart';

PersonalAccountSetupState createTestState({
  IDVerificationDocType? selectedIDVerificationDocType,
  int isResidenceAddressSameAsAadhar = 0,
  bool isAgreeToAddressSameAsAadhar = false,
  bool isCityAndStateLoading = false,
  bool isCityAndStateVerified = false,
  Country? selectedCountry,
  String? selectedAddressVerificationDocType,
  bool? isAddressVerificationLoading,
}) {
  return PersonalAccountSetupState(
    selectedIDVerificationDocType: selectedIDVerificationDocType,
    isResidenceAddressSameAsAadhar: isResidenceAddressSameAsAadhar,
    isAgreeToAddressSameAsAadhar: isAgreeToAddressSameAsAadhar,
    isCityAndStateLoading: isCityAndStateLoading,
    isCityAndStateVerified: isCityAndStateVerified,
    selectedCountry: selectedCountry,
    selectedAddressVerificationDocType: selectedAddressVerificationDocType,
    isAddressVerificationLoading: isAddressVerificationLoading,
    currentKycVerificationStep: PersonalEKycVerificationSteps.residentialAddress,
    scrollController: ScrollController(),
    professionOtherController: TextEditingController(),
    productServiceDescriptionController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    personalInfoKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    aadharVerificationFormKey: GlobalKey<FormState>(),
    drivingVerificationFormKey: GlobalKey<FormState>(),
    drivingLicenceController: TextEditingController(),
    voterVerificationFormKey: GlobalKey<FormState>(),
    voterIdNumberController: TextEditingController(),
    passportVerificationFormKey: GlobalKey<FormState>(),
    passportNumberController: TextEditingController(),
    panVerificationKey: GlobalKey<FormState>(),
    panNameController: TextEditingController(),
    panNumberController: TextEditingController(),
    registerAddressFormKey: GlobalKey<FormState>(),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    annualTurnoverFormKey: GlobalKey<FormState>(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
    personalBankAccountVerificationFormKey: GlobalKey<FormState>(),
    bankAccountNumberController: TextEditingController(),
    reEnterbankAccountNumberController: TextEditingController(),
    ifscCodeController: TextEditingController(),
    sePasswordFormKey: GlobalKey<FormState>(),
    captchaInputController: TextEditingController(),
    fullNameController: TextEditingController(),
    websiteController: TextEditingController(),
    mobileController: TextEditingController(),
    otpController: TextEditingController(),
    captchaInput: '',
    isCaptchaValid: false,
    isCaptchaSubmitting: false,
    isCaptchaSend: false,
    isOtpLoading: false,
    isPanDetailsLoading: false,
    isPanDetailsVerified: false,
    isLoading: false,
    isReady: false,
    hasPermission: false,
    isImageCaptured: false,
    isImageSubmitted: false,
    navigateNext: false,
    isOTPSent: false,
    isOtpVerified: false,
    canResendOTP: false,
    timeLeft: 0,
    obscurePassword: false,
    obscureConfirmPassword: false,
    familyAndFriendsDescriptionController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    personalDbaController: TextEditingController(),
  );
}

void main() {
  group('PersonalResidentialAddress Widget Tests', () {
    late MockPersonalAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockPersonalAccountSetupBloc();
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider<PersonalAccountSetupBloc>.value(
            value: mockBloc,
            child: const PersonalResidentialAddress(),
          ),
        ),
      );
    }

    testWidgets('should display Aadhar address verification options when Aadhar is selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('residential address the same'), findsOneWidget);
      expect(find.textContaining('If yes, it will used for'), findsOneWidget);
    });

    testWidgets('should display Yes/No options for Aadhar address verification', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('should display agree checkbox when No is selected for Aadhar address', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: IDVerificationDocType.aadharCard,
          isResidenceAddressSameAsAadhar: 0, // No selected
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            selectedIDVerificationDocType: IDVerificationDocType.aadharCard,
            isResidenceAddressSameAsAadhar: 0,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(find.textContaining('I agree'), findsOneWidget);
    });

    testWidgets('should display country picker field', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ExpandableCountryDropdownField), findsOneWidget);
      expect(find.textContaining('Country'), findsOneWidget);
    });

    testWidgets('should display address form fields', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('PIN code'), findsOneWidget);
      expect(find.textContaining('Address line 1'), findsOneWidget);
      expect(find.textContaining('Address line 2'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(3));
    });

    testWidgets('should display loader when city and state are loading', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isCityAndStateLoading: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isCityAndStateLoading: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(AppLoaderWidget), findsOneWidget);
    });

    testWidgets('should display address verification document type dropdown', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isCityAndStateVerified: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isCityAndStateVerified: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ExpandableDropdownField), findsAtLeastNWidgets(1));
      expect(find.textContaining('Choose document to upload'), findsOneWidget);
    });

    testWidgets('should display file upload widget when document type is selected', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isCityAndStateVerified: true, selectedAddressVerificationDocType: 'Bank Statement'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isCityAndStateVerified: true, selectedAddressVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Next button when address verification is complete', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isCityAndStateVerified: true, selectedAddressVerificationDocType: 'Bank Statement'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isCityAndStateVerified: true, selectedAddressVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Save & Next'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should have form with proper validation key', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display different document types based on ID verification type', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(selectedIDVerificationDocType: IDVerificationDocType.passport, isCityAndStateVerified: true),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedIDVerificationDocType: IDVerificationDocType.passport, isCityAndStateVerified: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Choose document to upload'), findsOneWidget);
      // Should not show Aadhar-specific options when passport is selected
      expect(find.textContaining('residential address the same'), findsNothing);
    });
  });
}
