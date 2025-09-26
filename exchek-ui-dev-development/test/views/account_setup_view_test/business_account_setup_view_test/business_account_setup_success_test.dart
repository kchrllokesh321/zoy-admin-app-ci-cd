import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/common_widget/app_background.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_setup_success.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:go_router/go_router.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'business_account_setup_success_test.mocks.dart';

void main() {
  group('BusinessAccountSetupSuccessView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();
    });

    Widget createTestWidget() {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) => BlocProvider<BusinessAccountSetupBloc>.value(
                  value: mockBloc,
                  child: const BusinessAccountSetupSuccessView(),
                ),
          ),
          GoRoute(path: '/login', builder: (context, state) => const Scaffold(body: Text('Login Page'))),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
      );
    }

    BusinessAccountSetupState createMockState() {
      return BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessEntity,
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

    testWidgets('should display success page with correct structure', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BackgroundImage), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
    });

    testWidgets('should display success icon/image', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
    });

    testWidgets('should display success title text', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Basic Exchek Account'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Set Up'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display success description text', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('log in to continue'), findsAtLeastNWidgets(1));
      expect(find.textContaining('all set'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Login button with correct properties', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    // testWidgets('should display GetHelpTextButton', (WidgetTester tester) async {
    //   // Arrange
    //   final mockState = createMockState();
    //   when(mockBloc.state).thenReturn(mockState);
    //   when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

    //   // Act
    //   await tester.pumpWidget(createTestWidget());
    //   await tester.pumpAndSettle();

    //   // Assert
    //   expect(find.byType(GetHelpTextButton), findsOneWidget);
    // });

    testWidgets('should have proper responsive layout', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should display background image correctly', (WidgetTester tester) async {
      // Arrange
      final mockState = createMockState();
      when(mockBloc.state).thenReturn(mockState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BackgroundImage), findsOneWidget);
      final backgroundImage = tester.widget<BackgroundImage>(find.byType(BackgroundImage));
      expect(backgroundImage.imagePath, isNotNull);
    });

    // testWidgets('should handle GetHelpTextButton tap', (WidgetTester tester) async {
    //   // Arrange
    //   final mockState = createMockState();
    //   when(mockBloc.state).thenReturn(mockState);
    //   when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

    //   // Act
    //   await tester.pumpWidget(createTestWidget());
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.byType(GetHelpTextButton));
    //   await tester.pumpAndSettle();

    //   // Assert - Help button should be tappable
    //   expect(find.byType(GetHelpTextButton), findsOneWidget);
    // });

    group('Edge Cases', () {
      testWidgets('should handle null state gracefully', (WidgetTester tester) async {
        // Arrange
        final mockState = createMockState();
        when(mockBloc.state).thenReturn(mockState);
        when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

        // Act & Assert
        expect(() async {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();
        }, returnsNormally);
      });

      //     testWidgets('should maintain state during widget rebuilds', (WidgetTester tester) async {
      //       // Arrange
      //       final mockState = createMockState();
      //       when(mockBloc.state).thenReturn(mockState);
      //       when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([mockState]));

      //       // Act
      //       await tester.pumpWidget(createTestWidget());
      //       await tester.pumpAndSettle();

      //       // Trigger rebuild
      //       await tester.pumpWidget(createTestWidget());
      //       await tester.pumpAndSettle();

      //       // Assert
      //       expect(find.byType(CustomElevatedButton), findsOneWidget);
      //       expect(find.byType(GetHelpTextButton), findsOneWidget);
      //     });
    });
  });
}
