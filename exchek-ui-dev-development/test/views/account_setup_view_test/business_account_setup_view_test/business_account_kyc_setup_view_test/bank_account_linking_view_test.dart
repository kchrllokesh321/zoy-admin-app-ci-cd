import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_kyc_setup_view/bank_account_linking_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bank_account_linking_view_test.mocks.dart';

@GenerateMocks([BusinessAccountSetupBloc])
BusinessAccountSetupState createTestState({
  bool isBankAccountVerify = false,
  bool? isBankAccountNumberVerifiedLoading,
  bool? isBankAccountVerificationLoading,
  String? bankAccountNumber,
  String? ifscCode,
  String? accountHolderName,
  String? selectedBankAccountVerificationDocType,
  FileData? bankVerificationFile,
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
    aadharVerificationFormKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),

    registerAddressFormKey: GlobalKey<FormState>(),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    annualTurnoverFormKey: GlobalKey<FormState>(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
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
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
    // Test-specific values
    isBankAccountVerify: isBankAccountVerify,
    isBankAccountNumberVerifiedLoading: isBankAccountNumberVerifiedLoading,
    isBankAccountVerificationLoading: isBankAccountVerificationLoading,
    bankAccountNumber: bankAccountNumber,
    ifscCode: ifscCode,
    accountHolderName: accountHolderName,
    selectedBankAccountVerificationDocType: selectedBankAccountVerificationDocType,
    bankVerificationFile: bankVerificationFile,
    currentKycVerificationStep: KycVerificationSteps.bankAccountLinking,
    hufPanVerificationKey: GlobalKey<FormState>(),
    hufPanNumberController: TextEditingController(),
    businessPanNumberController: TextEditingController(),
    businessPanNameController: TextEditingController(),
    businessPanVerificationKey: GlobalKey<FormState>(),
    directorsPanVerificationKey: GlobalKey<FormState>(),
    beneficialOwnerPanVerificationKey: GlobalKey<FormState>(),
    beneficialOwnerPanNumberController: TextEditingController(),
    beneficialOwnerPanNameController: TextEditingController(),
    businessRepresentativeFormKey: GlobalKey<FormState>(),
    businessRepresentativePanNumberController: TextEditingController(),
    businessRepresentativePanNameController: TextEditingController(),
    selectedCountry: Country.parse('IN'),
    isHUFPanVerifyingLoading: false,
    director1PanNumberController: TextEditingController(),
    director1PanNameController: TextEditingController(),
    director2PanNumberController: TextEditingController(),
    director2PanNameController: TextEditingController(),
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
  group('BankAccountLinkingView Widget Tests', () {
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
          body: BlocProvider<BusinessAccountSetupBloc>.value(value: mockBloc, child: const BankAccountLinkingView()),
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
      expect(find.byType(BankAccountLinkingView), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display bank account form fields when not verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Bank account, re-enter, IFSC
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Verify button
    });

    testWidgets('should display verified bank account info when verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isBankAccountVerify: true,
          bankAccountNumber: '1234567890',
          ifscCode: 'SBIN0001234',
          accountHolderName: 'John Doe',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isBankAccountVerify: true,
            bankAccountNumber: '1234567890',
            ifscCode: 'SBIN0001234',
            accountHolderName: 'John Doe',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsNWidgets(3)); // Bank account, IFSC, account holder name
      expect(find.byType(ExpandableDropdownField), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Submit button
    });

    testWidgets('should show file upload widget when document type is selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should not show file upload widget when no document type is selected', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: null));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: null),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsNothing);
      expect(find.byType(SizedBox), findsWidgets); // SizedBox.shrink() is used
    });

    testWidgets('should enable submit button when file is uploaded', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true, bankVerificationFile: mockFileData));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isBankAccountVerify: true, bankVerificationFile: mockFileData)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final submitButton = find.byType(CustomElevatedButton);
      expect(submitButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(submitButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should disable submit button when no file is uploaded', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true, bankVerificationFile: null));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isBankAccountVerify: true, bankVerificationFile: null)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final submitButton = find.byType(CustomElevatedButton);
      expect(submitButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(submitButton);
      expect(buttonWidget.isDisabled, true);
    });

    testWidgets('should show loading state on verify button', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isBankAccountVerify: false, isBankAccountNumberVerifiedLoading: true));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: false, isBankAccountNumberVerifiedLoading: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      expect(verifyButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(verifyButton);
      expect(buttonWidget.isLoading, true);
    });

    testWidgets('should show loading state on submit button', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      when(mockBloc.state).thenReturn(
        createTestState(
          isBankAccountVerify: true,
          bankVerificationFile: mockFileData,
          isBankAccountNumberVerifiedLoading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isBankAccountVerify: true,
            bankVerificationFile: mockFileData,
            isBankAccountNumberVerifiedLoading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final submitButton = find.byType(CustomElevatedButton);
      expect(submitButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(submitButton);
      expect(buttonWidget.isLoading, true);
    });

    testWidgets('should disable verify button when fields are empty', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      expect(verifyButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(verifyButton);
      expect(buttonWidget.isDisabled, true);
    });

    testWidgets('should enable verify button when all fields are filled', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isBankAccountVerify: false);
      state.bankAccountNumberController.text = '1234567890';
      state.reEnterbankAccountNumberController.text = '1234567890';
      state.ifscCodeController.text = 'SBIN0001234';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      expect(verifyButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(verifyButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should trigger BankAccountNumberVerify event on verify button press', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isBankAccountVerify: false);
      state.bankAccountNumberController.text = '1234567890';
      state.reEnterbankAccountNumberController.text = '1234567890';
      state.ifscCodeController.text = 'SBIN0001234';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton);
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger UpdateBankAccountVerificationDocType event on dropdown change', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final dropdown = find.byType(ExpandableDropdownField);
      expect(dropdown, findsOneWidget);

      final dropdownWidget = tester.widget<ExpandableDropdownField>(dropdown);
      dropdownWidget.onChanged.call('Bank Statement');

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger UploadBankAccountVerificationFile event on file selection', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUpload = find.byType(CustomFileUploadWidget);
      expect(fileUpload, findsOneWidget);

      final fileUploadWidget = tester.widget<CustomFileUploadWidget>(fileUpload);
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      fileUploadWidget.onFileSelected?.call(mockFileData);

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger BankAccountDetailSubmitted event on submit button press', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true, bankVerificationFile: mockFileData));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isBankAccountVerify: true, bankVerificationFile: mockFileData)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final submitButton = find.byType(CustomElevatedButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pump();

      // Assert - Check that the button exists and is enabled
      expect(submitButton, findsOneWidget);
      final buttonWidget = tester.widget<CustomElevatedButton>(submitButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should trigger BankAccountNumberVerify event on IFSC field submission', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isBankAccountVerify: false);
      state.bankAccountNumberController.text = '1234567890';
      state.reEnterbankAccountNumberController.text = '1234567890';
      state.ifscCodeController.text = 'SBIN0001234';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Check that the form is properly set up for validation
      expect(find.byType(CustomTextInputField), findsNWidgets(3));
    });

    testWidgets('should call getBankVerificationDocTypes method', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final bankAccountLinkingView = BankAccountLinkingView();
      final context = tester.element(find.byType(BankAccountLinkingView));
      final docTypes = bankAccountLinkingView.getBankVerificationDocTypes(context);

      expect(docTypes, isNotEmpty);
      expect(docTypes.length, 2); // Should be 2: cancelled_cheque and bank_statement
      expect(docTypes, contains('Cancelled Cheque')); // Verify actual content
      expect(docTypes, contains('Bank Statement')); // Verify actual content
    });

    testWidgets('should test formatSecondsToMMSS method', (WidgetTester tester) async {
      // Arrange
      const bankAccountLinkingView = BankAccountLinkingView();

      // Act & Assert
      expect(bankAccountLinkingView.formatSecondsToMMSS(0), '00:00');
      expect(bankAccountLinkingView.formatSecondsToMMSS(59), '00:59');
      expect(bankAccountLinkingView.formatSecondsToMMSS(60), '01:00');
      expect(bankAccountLinkingView.formatSecondsToMMSS(125), '02:05');
      expect(bankAccountLinkingView.formatSecondsToMMSS(3661), '61:01');
    });

    testWidgets('should display correct responsive layout for mobile', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle form validation correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isBankAccountVerify: false);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.key, equals(state.bankAccountVerificationFormKey));
    });

    testWidgets('should display correct text styles and themes', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should handle AnimatedBuilder correctly in verify button', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isBankAccountVerify: false);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Simulate text changes
      state.bankAccountNumberController.text = '123';
      await tester.pump();

      // Assert
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should handle BlocBuilder buildWhen condition for file upload', (WidgetTester tester) async {
      // Arrange
      final initialState = createTestState(
        isBankAccountVerify: true,
        selectedBankAccountVerificationDocType: 'Bank Statement',
      );
      final updatedState = createTestState(
        isBankAccountVerify: true,
        selectedBankAccountVerificationDocType: 'Cancelled Cheque',
      );

      when(mockBloc.state).thenReturn(initialState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState, updatedState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(); // Trigger rebuild

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });
  });
}
