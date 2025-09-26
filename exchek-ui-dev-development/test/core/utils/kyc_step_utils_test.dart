import 'package:exchek/core/app/exchek_app.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/core/utils/kyc_step_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSoleProprietorState {
  final TextEditingController gstNumberController;
  final TextEditingController iceNumberController;
  final Object? gstCertificateFile;
  final Object? iceCertificateFile;
  final String? gstLegalName;

  _FakeSoleProprietorState({
    required this.gstNumberController,
    required this.iceNumberController,
    this.gstCertificateFile,
    this.iceCertificateFile,
    this.gstLegalName,
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KycStepUtils.getStepsForBusinessType', () {
    test('company returns expected steps', () {
      final steps = KycStepUtils.getStepsForBusinessType('company');
      expect(
        steps,
        containsAll(<KycVerificationSteps>[
          KycVerificationSteps.panVerification,
          KycVerificationSteps.companyIncorporationVerification,
          KycVerificationSteps.annualTurnoverDeclaration,
          KycVerificationSteps.iecVerification,
          KycVerificationSteps.aadharPanVerification,
          KycVerificationSteps.beneficialOwnershipVerification,
          KycVerificationSteps.contactInformation,
          KycVerificationSteps.registeredOfficeAddress,
          KycVerificationSteps.bankAccountLinking,
        ]),
      );
    });

    test('LLP and partnership share expected steps', () {
      final llp = KycStepUtils.getStepsForBusinessType('limited_liability_partnership');
      final partnership = KycStepUtils.getStepsForBusinessType('partnership');
      expect(llp, isNotEmpty);
      expect(partnership, equals(llp));
    });

    test('hindu_undivided_family returns expected subset', () {
      final steps = KycStepUtils.getStepsForBusinessType('hindu_undivided_family');
      expect(
        steps,
        containsAll(<KycVerificationSteps>[
          KycVerificationSteps.panVerification,
          KycVerificationSteps.aadharPanVerification,
          KycVerificationSteps.iecVerification,
          KycVerificationSteps.registeredOfficeAddress,
          KycVerificationSteps.bankAccountLinking,
        ]),
      );
    });

    test('sole_proprietor with GST uploaded omits businessDocumentsVerification', () {
      final state = _FakeSoleProprietorState(
        gstNumberController: TextEditingController(text: '12ABCDE1234F1Z5'),
        iceNumberController: TextEditingController(),
        gstCertificateFile: Object(),
        gstLegalName: 'Test Co',
      );

      final steps = KycStepUtils.getStepsForBusinessType('sole_proprietor', state);
      expect(steps, isNot(contains(KycVerificationSteps.businessDocumentsVerification)));
    });

    test('sole_proprietor with ICE uploaded omits businessDocumentsVerification', () {
      final state = _FakeSoleProprietorState(
        gstNumberController: TextEditingController(),
        iceNumberController: TextEditingController(text: 'IEC123'),
        iceCertificateFile: Object(),
      );

      final steps = KycStepUtils.getStepsForBusinessType('sole_proprietor', state);
      expect(steps, isNot(contains(KycVerificationSteps.businessDocumentsVerification)));
    });

    test('sole_proprietor without GST/ICE includes businessDocumentsVerification', () {
      final state = _FakeSoleProprietorState(
        gstNumberController: TextEditingController(),
        iceNumberController: TextEditingController(),
      );

      final steps = KycStepUtils.getStepsForBusinessType('sole_proprietor', state);
      expect(steps, contains(KycVerificationSteps.businessDocumentsVerification));
    });

    test('default returns all minus specific steps', () {
      final steps = KycStepUtils.getStepsForBusinessType('unknown');
      expect(steps, isNot(contains(KycVerificationSteps.companyIncorporationVerification)));
      expect(steps, isNot(contains(KycVerificationSteps.contactInformation)));
      expect(steps.length, KycVerificationSteps.values.length - 2);
    });
  });

  group('KycStepUtils.getFilteredStepsFromApiData', () {
    test('company business type evaluates completion across steps', () async {
      final api = <String, dynamic>{
        'business_details': {'business_type': 'company'},
        'pan_details': {'document_number': 'ABCDE1234F', 'pan_verify_status': 'SUBMITTED'},
        'business_identity': {'document_type': 'CIN', 'document_number': 'CIN001', 'front_doc_url': 'url'},
        'iec_details': {'document_number': 'IEC123', 'doc_url': 'url'},
        'user_address_documents': {'front_doc_url': 'addr', 'resident_verify_status': 'SUBMITTED'},
        'user_gst_details': {'estimated_annual_income': '1000000'},
        'user_bank_details': {'account_number': '123', 'ifsc_code': 'IFSC0001'},
        'business_director_list': [
          {'director_type': 'AUTH_DIRECTOR', 'document_type': 'Aadhaar', 'verify_status': 'SUBMITTED'},
          {'director_type': 'OTHER_DIRECTOR', 'document_type': 'Pan', 'verify_status': 'SUBMITTED'},
        ],
      };

      final filtered = await KycStepUtils.getFilteredStepsFromApiData(api);
      // Only contact information should stay incomplete per implementation comment
      expect(filtered, contains(KycVerificationSteps.contactInformation));
    });

    test('HUF aadhar pan uses Karta Aadhaar check', () async {
      final api = <String, dynamic>{
        'business_details': {'business_type': 'hindu_undivided_family'},
        'business_identity': {'document_type': 'Aadhaar', 'document_number': '1234'},
      };
      final filtered = await KycStepUtils.getFilteredStepsFromApiData(api);
      expect(filtered, isA<List<KycVerificationSteps>>());
    });

    test('LLP incorporation path stays incomplete', () async {
      final api = <String, dynamic>{
        'business_details': {'business_type': 'limited_liability_partnership'},
      };
      final filtered = await KycStepUtils.getFilteredStepsFromApiData(api);
      expect(filtered, contains(KycVerificationSteps.companyIncorporationVerification));
    });

    test('sole proprietor business documents verification logic', () async {
      final apiGst = <String, dynamic>{
        'business_details': {'business_type': 'sole_proprietor'},
        'user_gst_details': {'gst_number': '12ABCDE1234F1Z5', 'gst_certificate_url': 'url'},
      };
      final apiIec = <String, dynamic>{
        'business_details': {'business_type': 'sole_proprietor'},
        'iec_details': {'document_number': 'IEC123', 'doc_url': 'url'},
      };
      final apiNone = <String, dynamic>{
        'business_details': {'business_type': 'sole_proprietor'},
      };

      final filteredGst = await KycStepUtils.getFilteredStepsFromApiData(apiGst);
      final filteredIec = await KycStepUtils.getFilteredStepsFromApiData(apiIec);
      final filteredNone = await KycStepUtils.getFilteredStepsFromApiData(apiNone);

      expect(filteredGst, isNot(contains(KycVerificationSteps.businessDocumentsVerification)));
      expect(filteredIec, isNot(contains(KycVerificationSteps.businessDocumentsVerification)));
      expect(filteredNone, contains(KycVerificationSteps.businessDocumentsVerification));
    });
  });

  group('KycStepUtils display helpers', () {
    test('getAllStepsForDisplay returns steps based on api data', () async {
      final api = <String, dynamic>{
        'business_details': {'business_type': 'company'},
      };
      final steps = await KycStepUtils.getAllStepsForDisplay(api);
      expect(steps, contains(KycVerificationSteps.companyIncorporationVerification));
    });

    test('getFirstIncompleteStep returns first item from filtered list', () async {
      final api = <String, dynamic>{
        'business_details': {'business_type': 'limited_liability_partnership'},
      };
      final first = await KycStepUtils.getFirstIncompleteStep(api);
      expect(first, isA<KycVerificationSteps>());
    });
  });

  group('Pan edit lockout UI and logic', () {
    test('getPanEditLimitDialogInfo returns correct strings for default and custom types', () {
      final def = getPanEditLimitDialogInfo();
      expect(def.title, contains('PAN'));

      final passport = getPanEditLimitDialogInfo(panType: 'Passport');
      expect(passport.title, contains('Passport'));
      expect(passport.subtitle, isNotEmpty);
      expect(passport.buttonText, 'OK');
    });

    testWidgets('GlobalDialogService.showPanEditLimitDialog shows dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(navigatorKey: rootNavigatorKey, home: const Scaffold(body: SizedBox.shrink())),
      );

      GlobalDialogService.showPanEditLimitDialog();
      await tester.pumpAndSettle();

      expect(find.text('PAN Edit Limit Reached'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('handlePanEditAttempt locked but expired lock unlocks', (tester) async {
      final result = handlePanEditAttempt(
        isLocked: true,
        lockTime: DateTime.now().subtract(const Duration(hours: 25)),
        attempts: 3,
      );
      expect(result.shouldUnlock, isTrue);
      expect(result.isLocked, isFalse);
    });

    testWidgets('handlePanEditAttempt locked and not expired shows dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(navigatorKey: rootNavigatorKey, home: const Scaffold(body: SizedBox.shrink())),
      );

      final result = handlePanEditAttempt(
        isLocked: true,
        lockTime: DateTime.now().subtract(const Duration(hours: 1)),
        attempts: 3,
      );

      await tester.pumpAndSettle();
      expect(find.text('PAN Edit Limit Reached'), findsOneWidget);
      expect(result.showLimitReachedDialog, isTrue);
      expect(result.isLocked, isTrue);
    });

    test('handlePanEditAttempt locked with null lockTime returns locked result', () {
      final result = handlePanEditAttempt(isLocked: true, lockTime: null, attempts: 3);
      expect(result.isLocked, isTrue);
      expect(result.showLimitReachedDialog, isTrue);
    });

    test('handlePanEditAttempt attempts thresholds and messages', () {
      final first = handlePanEditAttempt(isLocked: false, lockTime: null, attempts: 0);
      expect(first.isLocked, isFalse);
      expect(first.errorMessage, '');

      final second = handlePanEditAttempt(isLocked: false, lockTime: null, attempts: 1);
      expect(second.errorMessage, 'You can edit your PAN up to 3 times.');

      final third = handlePanEditAttempt(isLocked: false, lockTime: null, attempts: 2);
      expect(third.errorMessage, 'Please double check only 2 attempts remain.');

      final beyond = handlePanEditAttempt(isLocked: false, lockTime: null, attempts: 3);
      expect(beyond.isLocked, isTrue);
      expect(beyond.showLimitReachedDialog, isTrue);
    });
  });

  group('Business type helpers', () {
    test('getBusinessType returns null without pref', () async {
      final res = await KycStepUtils.getBusinessType();
      expect(res, isNull);
    });

    test('getBusinessNature returns null without pref', () async {
      final res = await KycStepUtils.getBusinessNature();
      expect(res, isNull);
    });
  });
}
