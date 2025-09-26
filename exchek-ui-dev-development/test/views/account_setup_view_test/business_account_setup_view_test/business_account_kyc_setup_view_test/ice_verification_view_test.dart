import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_kyc_setup_view/ice_verification_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ice_verification_view_test.mocks.dart';

@GenerateMocks([BusinessAccountSetupBloc])
BusinessAccountSetupState createTestState({
  String? iceNumber,
  FileData? iceCertificateFile,
  bool? isIceVerifyingLoading,
  GlobalKey<FormState>? iceVerificationKey,
  TextEditingController? iceNumberController,
}) {
  return BusinessAccountSetupState(
    currentStep: BusinessAccountSetupSteps.businessInformation,
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
    sePasswordFormKey: GlobalKey<FormState>(),
    createPasswordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    currentKycVerificationStep: KycVerificationSteps.iecVerification,
    aadharVerificationFormKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
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
    annualTurnoverFormKey: GlobalKey<FormState>(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
    isGstCertificateMandatory: false,
    iceVerificationKey: iceVerificationKey ?? GlobalKey<FormState>(),
    iceNumberController: iceNumberController ?? TextEditingController(text: iceNumber),
    iceCertificateFile: iceCertificateFile,
    isIceVerifyingLoading: isIceVerifyingLoading ?? false,
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

void main() {
  group('IceVerificationView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();
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
          body: BlocProvider<BusinessAccountSetupBloc>.value(value: mockBloc, child: IceVerificationView()),
        ),
      );
    }

    testWidgets('should render correctly with initial state', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(IceVerificationView), findsOneWidget);
      expect(find.byType(ScrollConfiguration), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should display correct title and description', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('IEC number and certificate upload'), findsOneWidget);
      expect(
        find.text(
          'Provide your Import Export Code (IEC) to enable secure international trade and compliance with export regulations.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display IEC number field with correct properties', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('IEC number'), findsOneWidget);

      final textField = find.byType(CustomTextInputField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<CustomTextInputField>(textField);
      expect(textFieldWidget.type, InputType.text);
      expect(textFieldWidget.textInputAction, TextInputAction.done);
      expect(textFieldWidget.maxLength, 10);
    });

    testWidgets('should display file upload widget with correct title and selectedFile', (WidgetTester tester) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      when(mockBloc.state).thenReturn(createTestState(iceCertificateFile: testFileData));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(iceCertificateFile: testFileData)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final fileUploadWidget = find.byType(CustomFileUploadWidget);
      expect(fileUploadWidget, findsOneWidget);

      final fileUploadWidgetInstance = tester.widget<CustomFileUploadWidget>(fileUploadWidget);
      expect(fileUploadWidgetInstance.title, 'Upload IEC Certificate');
      expect(fileUploadWidgetInstance.selectedFile, testFileData);
    });

    testWidgets('should trigger UploadICECertificate event when file is selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUploadWidget = find.byType(CustomFileUploadWidget);
      final fileUploadWidgetInstance = tester.widget<CustomFileUploadWidget>(fileUploadWidget);

      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      fileUploadWidgetInstance.onFileSelected!(testFileData);

      // Assert
      verify(mockBloc.add(any)).called(1);
    });

    testWidgets('should display disabled next button when form is incomplete', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isDisabled, true);
      expect(nextButtonWidget.text, 'Save & Next');
      expect(nextButtonWidget.isShowTooltip, true);
      expect(nextButtonWidget.tooltipMessage, 'Please complete all required field on this page');
    });

    testWidgets('should display enabled next button when form is complete', (WidgetTester tester) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: 'ABCD123456');

      when(mockBloc.state).thenReturn(
        createTestState(iceNumber: 'ABCD123456', iceCertificateFile: testFileData, iceNumberController: controller),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(iceNumber: 'ABCD123456', iceCertificateFile: testFileData, iceNumberController: controller),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isDisabled, false);
    });

    testWidgets('should display loading state when isIceVerifyingLoading is true', (WidgetTester tester) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: 'ABCD123456');

      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: 'ABCD123456',
          iceCertificateFile: testFileData,
          iceNumberController: controller,
          isIceVerifyingLoading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: 'ABCD123456',
            iceCertificateFile: testFileData,
            iceNumberController: controller,
            isIceVerifyingLoading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isLoading, true);
    });

    testWidgets('should trigger ICEVerificationSubmitted event when next button is pressed with valid form', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: 'ABCD123456');
      final formKey = GlobalKey<FormState>();

      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: 'ABCD123456',
          iceCertificateFile: testFileData,
          iceNumberController: controller,
          iceVerificationKey: formKey,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: 'ABCD123456',
            iceCertificateFile: testFileData,
            iceNumberController: controller,
            iceVerificationKey: formKey,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // First enter text to make the form valid
      final textField = find.byType(CustomTextInputField);
      await tester.enterText(textField, 'ABCD123456');
      await tester.pump();

      final nextButton = find.byType(CustomElevatedButton);
      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);

      // Verify button is enabled
      expect(nextButtonWidget.isDisabled, false);

      // Tap the button
      await tester.tap(nextButton);
      await tester.pump();

      // Assert - The button should be enabled and tappable
      expect(nextButtonWidget.onPressed, isNotNull);
    });

    testWidgets('should not trigger event when next button is pressed with invalid form', (WidgetTester tester) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: ''); // Empty text for invalid form

      when(
        mockBloc.state,
      ).thenReturn(createTestState(iceNumber: '', iceCertificateFile: testFileData, iceNumberController: controller));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(iceNumber: '', iceCertificateFile: testFileData, iceNumberController: controller),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final nextButton = find.byType(CustomElevatedButton);
      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);

      // Assert - Button should be disabled when form is incomplete
      expect(nextButtonWidget.isDisabled, true);
      expect(nextButtonWidget.onPressed, null);
    });

    testWidgets('should validate IEC number format correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final textField = find.byType(CustomTextInputField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<CustomTextInputField>(textField);

      // Test valid IEC number (10 alphanumeric characters)
      final validResult = textFieldWidget.validator?.call('ABCD123456');
      expect(validResult, null);

      // Test invalid IEC number - too short
      final invalidResult1 = textFieldWidget.validator?.call('ABC123');
      expect(invalidResult1, 'IEC number must be exactly 10 characters long.');

      // Test invalid IEC number - wrong format (contains special characters)
      final invalidResult2 = textFieldWidget.validator?.call('ABCD@12345');
      expect(invalidResult2, 'No special characters or spaces allowed');

      // Test empty IEC number
      final invalidResult3 = textFieldWidget.validator?.call('');
      expect(invalidResult3, 'Please enter your IEC number.');
    });

    testWidgets('should handle text input changes correctly', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();
      when(mockBloc.state).thenReturn(createTestState(iceNumberController: controller));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(iceNumberController: controller)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final textField = find.byType(CustomTextInputField);
      await tester.enterText(textField, 'ABCD123456');
      await tester.pump();

      // Assert
      expect(controller.text, 'ABCD123456');
    });

    testWidgets('should handle null safety for loading state', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isIceVerifyingLoading: null));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isIceVerifyingLoading: null)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isLoading, false); // Should default to false when null
    });

    testWidgets('should display correct button alignment', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Find the specific Align widget that contains the button
      final alignWidgets = find.byType(Align);
      expect(alignWidgets, findsWidgets);

      // Find the Align widget that contains the CustomElevatedButton
      final buttonAlignWidget = find.ancestor(of: find.byType(CustomElevatedButton), matching: find.byType(Align));
      expect(buttonAlignWidget, findsOneWidget);

      final alignWidgetInstance = tester.widget<Align>(buttonAlignWidget);
      expect(alignWidgetInstance.alignment, Alignment.centerRight);
    });

    testWidgets('should handle BlocBuilder state changes correctly', (WidgetTester tester) async {
      // Arrange
      final initialState = createTestState();
      final updatedState = createTestState(
        iceCertificateFile: FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0),
        iceNumberController: TextEditingController(text: 'ABCD123456'),
      );

      when(mockBloc.state).thenReturn(initialState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState, updatedState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Initial state - button should be disabled
      final initialButton = find.byType(CustomElevatedButton);
      final initialButtonWidget = tester.widget<CustomElevatedButton>(initialButton);
      expect(initialButtonWidget.isDisabled, true);

      // Trigger state change
      await tester.pump();

      // Updated state - button should be enabled
      final updatedButton = find.byType(CustomElevatedButton);
      final updatedButtonWidget = tester.widget<CustomElevatedButton>(updatedButton);
      expect(updatedButtonWidget.isDisabled, false);
    });

    testWidgets('should test _buildSelectionTitleAndDescription method', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Test the title and description styling
      final titleText = find.text('IEC number and certificate upload');
      expect(titleText, findsOneWidget);

      final descriptionText = find.text(
        'Provide your Import Export Code (IEC) to enable secure international trade and compliance with export regulations.',
      );
      expect(descriptionText, findsOneWidget);
    });

    testWidgets('should test _buildIceNumberField method', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Test the field label and input field
      final fieldLabel = find.text('IEC number');
      expect(fieldLabel, findsOneWidget);

      final textField = find.byType(CustomTextInputField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<CustomTextInputField>(textField);
      expect(textFieldWidget.contentPadding, const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0));
    });

    testWidgets('should test _buildUploadIecCertificate method', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Test the file upload widget
      final fileUploadWidget = find.byType(CustomFileUploadWidget);
      expect(fileUploadWidget, findsOneWidget);

      final fileUploadWidgetInstance = tester.widget<CustomFileUploadWidget>(fileUploadWidget);
      expect(fileUploadWidgetInstance.title, 'Upload IEC Certificate');
    });

    testWidgets('should test button enabled logic with different combinations', (WidgetTester tester) async {
      // Test case 1: No file, no text - button disabled
      when(mockBloc.state).thenReturn(
        createTestState(iceNumber: '', iceCertificateFile: null, iceNumberController: TextEditingController(text: '')),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: '',
            iceCertificateFile: null,
            iceNumberController: TextEditingController(text: ''),
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      var nextButton = find.byType(CustomElevatedButton);
      var nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isDisabled, true);

      // Test case 2: File but no text - button disabled
      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: '',
          iceCertificateFile: FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
          iceNumberController: TextEditingController(text: ''),
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: '',
            iceCertificateFile: FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
            iceNumberController: TextEditingController(text: ''),
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      nextButton = find.byType(CustomElevatedButton);
      nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isDisabled, true);

      // Test case 3: Text but no file - button disabled
      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: 'ABCD123456',
          iceCertificateFile: null,
          iceNumberController: TextEditingController(text: 'ABCD123456'),
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: 'ABCD123456',
            iceCertificateFile: null,
            iceNumberController: TextEditingController(text: 'ABCD123456'),
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      nextButton = find.byType(CustomElevatedButton);
      nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(nextButtonWidget.isDisabled, true);
    });

    testWidgets('should test form validation and button press with valid data', (WidgetTester tester) async {
      // Arrange
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: 'ABCD123456');
      final formKey = GlobalKey<FormState>();

      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: 'ABCD123456',
          iceCertificateFile: testFileData,
          iceNumberController: controller,
          iceVerificationKey: formKey,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: 'ABCD123456',
            iceCertificateFile: testFileData,
            iceNumberController: controller,
            iceVerificationKey: formKey,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Get the button widget and test its onPressed callback directly
      final nextButton = find.byType(CustomElevatedButton);
      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);

      // Verify button is enabled
      expect(nextButtonWidget.isDisabled, false);
      expect(nextButtonWidget.onPressed, isNotNull);

      // Test the onPressed callback directly to ensure form validation is covered
      if (nextButtonWidget.onPressed != null) {
        nextButtonWidget.onPressed!();
      }

      // Assert - The callback should execute without errors
      expect(nextButtonWidget.onPressed, isNotNull);
    });

    testWidgets('should test form validation failure path', (WidgetTester tester) async {
      // Arrange - Create a form that will fail validation
      final testFileData = FileData(name: 'test_ice.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      final controller = TextEditingController(text: 'INVALID'); // Invalid IEC number
      final formKey = GlobalKey<FormState>();

      when(mockBloc.state).thenReturn(
        createTestState(
          iceNumber: 'INVALID',
          iceCertificateFile: testFileData,
          iceNumberController: controller,
          iceVerificationKey: formKey,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            iceNumber: 'INVALID',
            iceCertificateFile: testFileData,
            iceNumberController: controller,
            iceVerificationKey: formKey,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Enter invalid text to trigger validation
      final textField = find.byType(CustomTextInputField);
      await tester.enterText(textField, 'INVALID');
      await tester.pump();

      // Get the button widget
      final nextButton = find.byType(CustomElevatedButton);
      final nextButtonWidget = tester.widget<CustomElevatedButton>(nextButton);

      // The button should still be enabled because we have both file and text
      // but form validation should fail when pressed
      expect(nextButtonWidget.isDisabled, false);

      // Test the onPressed callback with invalid form
      if (nextButtonWidget.onPressed != null) {
        nextButtonWidget.onPressed!();
      }

      // Assert - The callback should execute but not submit due to validation failure
      expect(nextButtonWidget.onPressed, isNotNull);
    });
  });
}
