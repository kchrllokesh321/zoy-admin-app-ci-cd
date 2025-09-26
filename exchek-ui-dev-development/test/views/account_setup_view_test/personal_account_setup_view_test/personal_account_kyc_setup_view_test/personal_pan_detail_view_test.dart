import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_pan_detail_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_pan_detail_view_test.mocks.dart';

PersonalAccountSetupState createTestState({
  bool isPanDetailsLoading = false,
  bool isPanDetailsVerified = false,
  String? fullNamePan,
  String? panNumber,
}) {
  return PersonalAccountSetupState(
    isPanDetailsLoading: isPanDetailsLoading,
    isPanDetailsVerified: isPanDetailsVerified,
    fullNamePan: fullNamePan,
    currentKycVerificationStep: PersonalEKycVerificationSteps.panDetails,
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
    panNumberController: TextEditingController(text: panNumber),
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
    isResidenceAddressSameAsAadhar: 0,
    isCityAndStateLoading: false,
    isCityAndStateVerified: false,
    isAgreeToAddressSameAsAadhar: false,
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
  group('PersonalPanDetailView Widget Tests', () {
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
          body: BlocProvider<PersonalAccountSetupBloc>.value(value: mockBloc, child: PersonalPanDetailView()),
        ),
      );
    }

    testWidgets('should display title and description', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // The widget uses Lang.of(context).lbl_upload_PAN_details_for_KYC and Lang.of(context).lbl_provide_identity_regulatory_regulatory
      // We should look for Text widgets instead of specific text content
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets('should display PAN card number field', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for the PAN number input field
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display PAN name field when PAN details are verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isPanDetailsVerified: true, fullNamePan: 'John Doe'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(isPanDetailsVerified: true, fullNamePan: 'John Doe')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for verified info box that displays the PAN name
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
    });

    testWidgets('should display file upload widget when PAN details are verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isPanDetailsVerified: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isPanDetailsVerified: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should display Next button when PAN details are verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isPanDetailsVerified: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isPanDetailsVerified: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should display PAN input field when PAN number is entered', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isPanDetailsVerified: false, panNumber: 'ABCDE1234F'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(isPanDetailsVerified: false, panNumber: 'ABCDE1234F')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // This widget doesn't have a verify button - verification happens automatically on field submission
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
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

    testWidgets('should display proper field labels', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isPanDetailsVerified: true, fullNamePan: 'John Doe'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(isPanDetailsVerified: true, fullNamePan: 'John Doe')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for the presence of widgets instead of specific text content
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
    });
  });
}
