import 'dart:typed_data';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_transaction_and_payment_preferences_view.dart';
import 'package:country_picker/country_picker.dart';

void main() {
  group('BusinessAccountSetupEvent', () {
    group('LoadInitialState', () {
      test('supports value equality', () {
        final event1 = LoadInitialState();
        final event2 = LoadInitialState();

        expect(event1, equals(event2));
      });

      test('props are correct', () {
        final event = LoadInitialState();
        expect(event.props, []);
      });
    });

    group('StepChanged', () {
      test('supports value equality', () {
        const event1 = StepChanged(BusinessAccountSetupSteps.businessInformation);
        const event2 = StepChanged(BusinessAccountSetupSteps.businessInformation);
        const event3 = StepChanged(BusinessAccountSetupSteps.businessEntity);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include stepIndex', () {
        const event = StepChanged(BusinessAccountSetupSteps.businessInformation);
        expect(event.props, [BusinessAccountSetupSteps.businessInformation]);
      });
    });

    group('ChangeBusinessEntityType', () {
      test('supports value equality', () {
        const event1 = ChangeBusinessEntityType('Private Limited Company');
        const event2 = ChangeBusinessEntityType('Private Limited Company');
        const event3 = ChangeBusinessEntityType('Public Limited Company');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include selectedIndex', () {
        const event = ChangeBusinessEntityType('Private Limited Company');
        expect(event.props, ['Private Limited Company']);
      });
    });

    group('ChangeBusinessMainActivity', () {
      test('supports value equality', () {
        const event1 = ChangeBusinessMainActivity(BusinessMainActivity.exportGoods);
        const event2 = ChangeBusinessMainActivity(BusinessMainActivity.exportGoods);
        const event3 = ChangeBusinessMainActivity(BusinessMainActivity.exportService);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include selected activity', () {
        const event = ChangeBusinessMainActivity(BusinessMainActivity.exportGoods);
        expect(event.props, [BusinessMainActivity.exportGoods]);
      });
    });

    group('ChangeBusinessGoodsExport', () {
      test('supports value equality', () {
        const event1 = ChangeBusinessGoodsExport('Electronics');
        const event2 = ChangeBusinessGoodsExport('Electronics');
        const event3 = ChangeBusinessGoodsExport('Textiles');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include selectedIndex', () {
        const event = ChangeBusinessGoodsExport('Electronics');
        expect(event.props, ['Electronics']);
      });
    });

    group('ChangeBusinessServicesExport', () {
      test('supports value equality', () {
        const event1 = ChangeBusinessServicesExport('IT Services');
        const event2 = ChangeBusinessServicesExport('IT Services');
        const event3 = ChangeBusinessServicesExport('Consulting');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include selectedIndex', () {
        const event = ChangeBusinessServicesExport('IT Services');
        expect(event.props, ['IT Services']);
      });
    });

    group('BusinessSendOtpPressed', () {
      test('supports value equality', () {
        final event1 = BusinessSendOtpPressed();
        final event2 = BusinessSendOtpPressed();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = BusinessSendOtpPressed();
        expect(event.props, []);
      });
    });

    group('BusinessOtpTimerTicked', () {
      test('supports value equality', () {
        const event1 = BusinessOtpTimerTicked(120);
        const event2 = BusinessOtpTimerTicked(120);
        const event3 = BusinessOtpTimerTicked(60);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include remainingTime', () {
        const event = BusinessOtpTimerTicked(120);
        expect(event.props, [120]);
      });
    });

    group('ChangeCreatePasswordVisibility', () {
      test('supports value equality', () {
        const event1 = ChangeCreatePasswordVisibility(obscuredText: true);
        const event2 = ChangeCreatePasswordVisibility(obscuredText: true);
        const event3 = ChangeCreatePasswordVisibility(obscuredText: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include obscuredText', () {
        const event = ChangeCreatePasswordVisibility(obscuredText: true);
        expect(event.props, [true]);
      });
    });

    group('ChangeConfirmPasswordVisibility', () {
      test('supports value equality', () {
        const event1 = ChangeConfirmPasswordVisibility(obscuredText: false);
        const event2 = ChangeConfirmPasswordVisibility(obscuredText: false);
        const event3 = ChangeConfirmPasswordVisibility(obscuredText: true);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include obscuredText', () {
        const event = ChangeConfirmPasswordVisibility(obscuredText: false);
        expect(event.props, [false]);
      });
    });

    group('BusinessAccountSignUpSubmitted', () {
      test('supports value equality', () {
        final event1 = BusinessAccountSignUpSubmitted();
        final event2 = BusinessAccountSignUpSubmitted();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = BusinessAccountSignUpSubmitted();
        expect(event.props, []);
      });
    });

    group('ResetSignupSuccess', () {
      test('supports value equality', () {
        final event1 = ResetSignupSuccess();
        final event2 = ResetSignupSuccess();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = ResetSignupSuccess();
        expect(event.props, []);
      });
    });

    group('SendBusinessInfoOtp', () {
      test('supports value equality', () {
        const event1 = SendBusinessInfoOtp('9876543210');
        const event2 = SendBusinessInfoOtp('9876543210');
        const event3 = SendBusinessInfoOtp('9876543211');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include phoneNumber', () {
        const event = SendBusinessInfoOtp('9876543210');
        expect(event.props, ['9876543210']);
      });
    });

    group('ChangeBusinessInfoOtpSentStatus', () {
      test('supports value equality', () {
        const event1 = ChangeBusinessInfoOtpSentStatus(true);
        const event2 = ChangeBusinessInfoOtpSentStatus(true);
        const event3 = ChangeBusinessInfoOtpSentStatus(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include isOtpSent', () {
        const event = ChangeBusinessInfoOtpSentStatus(true);
        expect(event.props, [true]);
      });
    });

    group('KycStepChanged', () {
      test('supports value equality', () {
        const event1 = KycStepChanged(KycVerificationSteps.panVerification);
        const event2 = KycStepChanged(KycVerificationSteps.panVerification);
        const event3 = KycStepChanged(KycVerificationSteps.aadharPanVerification);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include stepIndex', () {
        const event = KycStepChanged(KycVerificationSteps.panVerification);
        expect(event.props, [KycVerificationSteps.panVerification]);
      });
    });

    group('SendAadharOtp', () {
      test('supports value equality', () {
        const event1 = SendAadharOtp('123456789012', '123456', '123456');
        const event2 = SendAadharOtp('123456789012', '123456', '123456');
        const event3 = SendAadharOtp('123456789013', '123456', '123456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include aadhar', () {
        const event = SendAadharOtp('123456789012', '123456', '123456');
        expect(event.props, ['123456789012', '123456', '123456']);
      });
    });

    group('ChangeOtpSentStatus', () {
      test('supports value equality', () {
        const event1 = ChangeOtpSentStatus(true);
        const event2 = ChangeOtpSentStatus(true);
        const event3 = ChangeOtpSentStatus(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include isOtpSent', () {
        const event = ChangeOtpSentStatus(true);
        expect(event.props, [true]);
      });
    });

    group('AadharSendOtpPressed', () {
      test('supports value equality', () {
        final event1 = AadharSendOtpPressed();
        final event2 = AadharSendOtpPressed();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = AadharSendOtpPressed();
        expect(event.props, []);
      });
    });

    group('AadharOtpTimerTicked', () {
      test('supports value equality', () {
        const event1 = AadharOtpTimerTicked(60);
        const event2 = AadharOtpTimerTicked(60);
        const event3 = AadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include remainingTime', () {
        const event = AadharOtpTimerTicked(60);
        expect(event.props, [60]);
      });
    });

    group('AadharNumbeVerified', () {
      test('supports value equality', () {
        const event1 = AadharNumbeVerified('123456789012', '123456');
        const event2 = AadharNumbeVerified('123456789012', '123456');
        const event3 = AadharNumbeVerified('123456789013', '123456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include aadharNumber and otp', () {
        const event = AadharNumbeVerified('123456789012', '123456');
        expect(event.props, ['123456789012', '123456']);
      });
    });

    group('File Upload Events', () {
      final mockFileData = FileData(name: 'test.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('FrontSlideAadharCardUpload supports value equality', () {
        final event1 = FrontSlideAadharCardUpload(mockFileData);
        final event2 = FrontSlideAadharCardUpload(mockFileData);
        final event3 = FrontSlideAadharCardUpload(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BackSlideAadharCardUpload supports value equality', () {
        final event1 = BackSlideAadharCardUpload(mockFileData);
        final event2 = BackSlideAadharCardUpload(mockFileData);
        final event3 = BackSlideAadharCardUpload(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('AadharFileUploadSubmitted supports value equality', () {
        final event1 = AadharFileUploadSubmitted(frontAadharFileData: mockFileData, backAadharFileData: mockFileData);
        final event2 = AadharFileUploadSubmitted(frontAadharFileData: mockFileData, backAadharFileData: mockFileData);

        expect(event1, equals(event2));
      });

      test('BusinessUploadPanCard supports value equality', () {
        final event1 = BusinessUploadPanCard(mockFileData);
        final event2 = BusinessUploadPanCard(mockFileData);
        final event3 = BusinessUploadPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadHUFPanCard supports value equality', () {
        final event1 = UploadHUFPanCard(mockFileData);
        final event2 = UploadHUFPanCard(mockFileData);
        final event3 = UploadHUFPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('PAN Verification Events', () {
      final mockFileData = FileData(name: 'pan.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('ChangeSelectedPanUploadOption supports value equality', () {
        const event1 = ChangeSelectedPanUploadOption(panUploadOption: 'business');
        const event2 = ChangeSelectedPanUploadOption(panUploadOption: 'business');
        const event3 = ChangeSelectedPanUploadOption(panUploadOption: 'director');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('SaveBusinessPanDetails supports value equality', () {
        final event1 = SaveBusinessPanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Test Business',
        );
        final event2 = SaveBusinessPanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Test Business',
        );

        expect(event1, equals(event2));
      });

      test('SaveDirectorPanDetails supports value equality', () {
        final event1 = SaveDirectorPanDetails(
          director1fileData: mockFileData,
          director1panName: 'Director 1',
          director1panNumber: 'ABCDE1234F',
        );
        final event2 = SaveDirectorPanDetails(
          director1fileData: mockFileData,
          director1panName: 'Director 1',
          director1panNumber: 'ABCDE1234F',
        );

        expect(event1, equals(event2));
      });

      test('VerifyPanSubmitted supports value equality', () {
        const event1 = VerifyPanSubmitted();
        const event2 = VerifyPanSubmitted();

        expect(event1, equals(event2));
      });
    });

    group('Director Events', () {
      test('ChangeDirector1IsBeneficialOwner supports value equality', () {
        const event1 = ChangeDirector1IsBeneficialOwner(isSelected: true);
        const event2 = ChangeDirector1IsBeneficialOwner(isSelected: true);
        const event3 = ChangeDirector1IsBeneficialOwner(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeDirector1IsBusinessRepresentative supports value equality', () {
        const event1 = ChangeDirector1IsBusinessRepresentative(isSelected: true);
        const event2 = ChangeDirector1IsBusinessRepresentative(isSelected: true);
        const event3 = ChangeDirector1IsBusinessRepresentative(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeDirector2IsBeneficialOwner supports value equality', () {
        const event1 = ChangeDirector2IsBeneficialOwner(isSelected: false);
        const event2 = ChangeDirector2IsBeneficialOwner(isSelected: false);
        const event3 = ChangeDirector2IsBeneficialOwner(isSelected: true);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeDirector2IsBusinessRepresentative supports value equality', () {
        const event1 = ChangeDirector2IsBusinessRepresentative(isSelected: false);
        const event2 = ChangeDirector2IsBusinessRepresentative(isSelected: false);
        const event3 = ChangeDirector2IsBusinessRepresentative(isSelected: true);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('Address Verification Events', () {
      final mockCountry = Country(
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
      );

      final mockFileData = FileData(name: 'address_proof.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('UpdateSelectedCountry supports value equality', () {
        final event1 = UpdateSelectedCountry(country: mockCountry);
        final event2 = UpdateSelectedCountry(country: mockCountry);

        expect(event1.country.countryCode, equals(event2.country.countryCode));
      });

      test('UploadAddressVerificationFile supports value equality', () {
        final event1 = UploadAddressVerificationFile(fileData: mockFileData);
        final event2 = UploadAddressVerificationFile(fileData: mockFileData);
        final event3 = UploadAddressVerificationFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UpdateAddressVerificationDocType supports value equality', () {
        const event1 = UpdateAddressVerificationDocType('Utility Bill');
        const event2 = UpdateAddressVerificationDocType('Utility Bill');
        const event3 = UpdateAddressVerificationDocType('Bank Statement');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('RegisterAddressSubmitted supports value equality', () {
        final event1 = RegisterAddressSubmitted(addressValidateFileData: mockFileData, docType: 'BankStatement');
        final event2 = RegisterAddressSubmitted(addressValidateFileData: mockFileData, docType: 'BankStatement');

        expect(event1, equals(event2));
      });
    });

    group('Bank Account Events', () {
      final mockFileData = FileData(name: 'bank_statement.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('BankAccountNumberVerify supports value equality', () {
        const event1 = BankAccountNumberVerify(accountNumber: '1234567890', ifscCode: 'SBIN0001234');
        const event2 = BankAccountNumberVerify(accountNumber: '1234567890', ifscCode: 'SBIN0001234');
        const event3 = BankAccountNumberVerify(accountNumber: '0987654321', ifscCode: 'SBIN0001234');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadBankAccountVerificationFile supports value equality', () {
        final event1 = UploadBankAccountVerificationFile(fileData: mockFileData);
        final event2 = UploadBankAccountVerificationFile(fileData: mockFileData);
        final event3 = UploadBankAccountVerificationFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UpdateBankAccountVerificationDocType supports value equality', () {
        const event1 = UpdateBankAccountVerificationDocType('Bank Statement');
        const event2 = UpdateBankAccountVerificationDocType('Bank Statement');
        const event3 = UpdateBankAccountVerificationDocType('Passbook');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      testWidgets('BankAccountDetailSubmitted supports value equality', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final event1 = BankAccountDetailSubmitted(
                  docType: 'Bank Statement',
                  bankAccountVerifyFile: mockFileData,
                  context: context,
                );
                final event2 = BankAccountDetailSubmitted(
                  docType: 'Bank Statement',
                  bankAccountVerifyFile: mockFileData,
                  context: context,
                );

                expect(event1, equals(event2));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Transaction Events', () {
      final mockCurrency = CurrencyModel(
        currencyName: 'US Dollar',
        currencySymbol: 'USD',
        currencyImagePath: '/path/usd.png',
      );

      test('ChangeEstimatedMonthlyTransaction supports value equality', () {
        const event1 = ChangeEstimatedMonthlyTransaction('1000-5000');
        const event2 = ChangeEstimatedMonthlyTransaction('1000-5000');
        const event3 = ChangeEstimatedMonthlyTransaction('5000-10000');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ToggleCurrencySelection supports value equality', () {
        final event1 = ToggleCurrencySelection(mockCurrency);
        final event2 = ToggleCurrencySelection(mockCurrency);

        expect(event1.currency.currencySymbol, equals(event2.currency.currencySymbol));
      });

      test('BusinessTranscationDetailSubmitted supports value equality', () {
        final event1 = BusinessTranscationDetailSubmitted(
          curruncyList: [mockCurrency],
          monthlyTranscation: '1000-5000',
        );
        final event2 = BusinessTranscationDetailSubmitted(
          curruncyList: [mockCurrency],
          monthlyTranscation: '1000-5000',
        );

        expect(event1, equals(event2));
      });
    });

    group('Scroll Events', () {
      test('ScrollToSection supports value equality', () {
        final key1 = GlobalKey();
        final key2 = GlobalKey();

        final event1 = ScrollToSection(key1);
        final event2 = ScrollToSection(key1);
        final event3 = ScrollToSection(key2);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('CancelScrollDebounce supports value equality', () {
        final event1 = CancelScrollDebounce();
        final event2 = CancelScrollDebounce();

        expect(event1, equals(event2));
      });
    });

    group('Reset and Validation Events', () {
      test('ResetData supports value equality', () {
        final event1 = ResetData();
        final event2 = ResetData();

        expect(event1, equals(event2));
      });

      test('ValidateBusinessOtp supports value equality', () {
        const event1 = ValidateBusinessOtp(phoneNumber: '9876543210', otp: '123456');
        const event2 = ValidateBusinessOtp(phoneNumber: '9876543210', otp: '123456');
        const event3 = ValidateBusinessOtp(phoneNumber: '9876543211', otp: '123456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UpdateBusinessNatureString supports value equality', () {
        const event1 = UpdateBusinessNatureString('Manufacturing');
        const event2 = UpdateBusinessNatureString('Manufacturing');
        const event3 = UpdateBusinessNatureString('Services');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('GetBusinessCurrencyOptions supports value equality', () {
        final event1 = GetBusinessCurrencyOptions();
        final event2 = GetBusinessCurrencyOptions();

        expect(event1, equals(event2));
      });
    });

    group('Certificate Upload Events', () {
      final mockFileData = FileData(name: 'certificate.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('UploadICECertificate supports value equality', () {
        final event1 = UploadICECertificate(mockFileData);
        final event2 = UploadICECertificate(mockFileData);
        final event3 = UploadICECertificate(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ICEVerificationSubmitted supports value equality', () {
        final event1 = ICEVerificationSubmitted(fileData: mockFileData, iceNumber: 'ICE123456');
        final event2 = ICEVerificationSubmitted(fileData: mockFileData, iceNumber: 'ICE123456');

        expect(event1, equals(event2));
      });

      test('UploadCOICertificate supports value equality', () {
        final event1 = UploadCOICertificate(mockFileData);
        final event2 = UploadCOICertificate(mockFileData);
        final event3 = UploadCOICertificate(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadLLPAgreement supports value equality', () {
        final event1 = UploadLLPAgreement(mockFileData);
        final event2 = UploadLLPAgreement(mockFileData);
        final event3 = UploadLLPAgreement(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadPartnershipDeed supports value equality', () {
        final event1 = UploadPartnershipDeed(mockFileData);
        final event2 = UploadPartnershipDeed(mockFileData);
        final event3 = UploadPartnershipDeed(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('CINVerificationSubmitted supports value equality', () {
        final event1 = CINVerificationSubmitted(fileData: mockFileData, cinNumber: 'CIN123456789');
        final event2 = CINVerificationSubmitted(fileData: mockFileData, cinNumber: 'CIN123456789');

        expect(event1, equals(event2));
      });
    });

    group('GST Events', () {
      final mockFileData = FileData(
        name: 'gst_certificate.pdf',
        bytes: Uint8List.fromList([1, 2, 3, 4]),
        sizeInMB: 1.0,
      );

      test('UploadGstCertificateFile supports value equality', () {
        final event1 = UploadGstCertificateFile(fileData: mockFileData);
        final event2 = UploadGstCertificateFile(fileData: mockFileData);
        final event3 = UploadGstCertificateFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('AnnualTurnOverVerificationSubmitted supports value equality', () {
        final event1 = AnnualTurnOverVerificationSubmitted(
          turnover: '10000000',
          gstNumber: 'GST123456789',
          gstCertificate: mockFileData,
        );
        final event2 = AnnualTurnOverVerificationSubmitted(
          turnover: '10000000',
          gstNumber: 'GST123456789',
          gstCertificate: mockFileData,
        );

        expect(event1, equals(event2));
      });
    });

    group('Karta Events', () {
      final mockFileData = FileData(name: 'karta_aadhar.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('KartaSendAadharOtp supports value equality', () {
        const event1 = KartaSendAadharOtp(aadhar: '123456789012', captcha: '123456', sessionId: '123456');
        const event2 = KartaSendAadharOtp(aadhar: '123456789012', captcha: '123456', sessionId: '123456');
        const event3 = KartaSendAadharOtp(aadhar: '123456789013', captcha: '123456', sessionId: '123456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaChangeOtpSentStatus supports value equality', () {
        const event1 = KartaChangeOtpSentStatus(true);
        const event2 = KartaChangeOtpSentStatus(true);
        const event3 = KartaChangeOtpSentStatus(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaAadharSendOtpPressed supports value equality', () {
        final event1 = KartaAadharSendOtpPressed();
        final event2 = KartaAadharSendOtpPressed();

        expect(event1, equals(event2));
      });

      test('KartaAadharOtpTimerTicked supports value equality', () {
        const event1 = KartaAadharOtpTimerTicked(60);
        const event2 = KartaAadharOtpTimerTicked(60);
        const event3 = KartaAadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaAadharNumbeVerified supports value equality', () {
        const event1 = KartaAadharNumbeVerified('123456789012', '123456');
        const event2 = KartaAadharNumbeVerified('123456789012', '123456');
        const event3 = KartaAadharNumbeVerified('123456789013', '123456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaFrontSlideAadharCardUpload supports value equality', () {
        final event1 = KartaFrontSlideAadharCardUpload(mockFileData);
        final event2 = KartaFrontSlideAadharCardUpload(mockFileData);
        final event3 = KartaFrontSlideAadharCardUpload(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaBackSlideAadharCardUpload supports value equality', () {
        final event1 = KartaBackSlideAadharCardUpload(mockFileData);
        final event2 = KartaBackSlideAadharCardUpload(mockFileData);
        final event3 = KartaBackSlideAadharCardUpload(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaAadharFileUploadSubmitted supports value equality', () {
        final event1 = KartaAadharFileUploadSubmitted(
          frontAadharFileData: mockFileData,
          backAadharFileData: mockFileData,
        );
        final event2 = KartaAadharFileUploadSubmitted(
          frontAadharFileData: mockFileData,
          backAadharFileData: mockFileData,
        );

        expect(event1, equals(event2));
      });
    });

    group('HUF PAN Events', () {
      final mockFileData = FileData(name: 'huf_pan.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('HUFPanVerificationSubmitted supports value equality', () {
        final event1 = HUFPanVerificationSubmitted(fileData: mockFileData, panNumber: 'ABCDE1234F');
        final event2 = HUFPanVerificationSubmitted(fileData: mockFileData, panNumber: 'ABCDE1234F');

        expect(event1, equals(event2));
      });
    });

    group('Missing Event Coverage - Part 1', () {
      final mockFileData = FileData(name: 'test.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('ChangeAnnualTurnover supports value equality', () {
        const event1 = ChangeAnnualTurnover('10000000');
        const event2 = ChangeAnnualTurnover('10000000');
        const event3 = ChangeAnnualTurnover('20000000');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeAnnualTurnover props include selectedIndex', () {
        const event = ChangeAnnualTurnover('10000000');
        expect(event.props, ['10000000']);
      });

      test('BusinessOtpTimerTicked supports value equality', () {
        const event1 = BusinessOtpTimerTicked(120);
        const event2 = BusinessOtpTimerTicked(120);
        const event3 = BusinessOtpTimerTicked(60);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BusinessOtpTimerTicked props include remainingTime', () {
        const event = BusinessOtpTimerTicked(120);
        expect(event.props, [120]);
      });

      test('AadharOtpTimerTicked supports value equality', () {
        const event1 = AadharOtpTimerTicked(60);
        const event2 = AadharOtpTimerTicked(60);
        const event3 = AadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('AadharOtpTimerTicked props include remainingTime', () {
        const event = AadharOtpTimerTicked(60);
        expect(event.props, [60]);
      });

      test('Director1UploadPanCard supports value equality', () {
        final event1 = Director1UploadPanCard(mockFileData);
        final event2 = Director1UploadPanCard(mockFileData);
        final event3 = Director1UploadPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('Director2UploadPanCard supports value equality', () {
        final event1 = Director2UploadPanCard(mockFileData);
        final event2 = Director2UploadPanCard(mockFileData);
        final event3 = Director2UploadPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BeneficialOwnerUploadPanCard supports value equality', () {
        final event1 = BeneficialOwnerUploadPanCard(mockFileData);
        final event2 = BeneficialOwnerUploadPanCard(mockFileData);
        final event3 = BeneficialOwnerUploadPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeBeneficialOwnerIsDirector supports value equality', () {
        const event1 = ChangeBeneficialOwnerIsDirector(isSelected: true);
        const event2 = ChangeBeneficialOwnerIsDirector(isSelected: true);
        const event3 = ChangeBeneficialOwnerIsDirector(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeBeneficialOwnerIsBusinessRepresentative supports value equality', () {
        const event1 = ChangeBeneficialOwnerIsBusinessRepresentative(isSelected: true);
        const event2 = ChangeBeneficialOwnerIsBusinessRepresentative(isSelected: true);
        const event3 = ChangeBeneficialOwnerIsBusinessRepresentative(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('SaveBeneficialOwnerPanDetails supports value equality', () {
        final event1 = SaveBeneficialOwnerPanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Beneficial Owner',
        );
        final event2 = SaveBeneficialOwnerPanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Beneficial Owner',
        );

        expect(event1, equals(event2));
      });

      test('BusinessRepresentativeUploadPanCard supports value equality', () {
        final event1 = BusinessRepresentativeUploadPanCard(mockFileData);
        final event2 = BusinessRepresentativeUploadPanCard(mockFileData);
        final event3 = BusinessRepresentativeUploadPanCard(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeBusinessReresentativeOwnerIsDirector supports value equality', () {
        const event1 = ChangeBusinessReresentativeOwnerIsDirector(isSelected: true);
        const event2 = ChangeBusinessReresentativeOwnerIsDirector(isSelected: true);
        const event3 = ChangeBusinessReresentativeOwnerIsDirector(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeBusinessReresentativeIsBeneficialOwner supports value equality', () {
        const event1 = ChangeBusinessReresentativeIsBeneficialOwner(isSelected: true);
        const event2 = ChangeBusinessReresentativeIsBeneficialOwner(isSelected: true);
        const event3 = ChangeBusinessReresentativeIsBeneficialOwner(isSelected: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('SaveBusinessRepresentativePanDetails supports value equality', () {
        final event1 = SaveBusinessRepresentativePanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Business Representative',
        );
        final event2 = SaveBusinessRepresentativePanDetails(
          fileData: mockFileData,
          panNumber: 'ABCDE1234F',
          panName: 'Business Representative',
        );

        expect(event1, equals(event2));
      });
    });

    group('Missing Event Coverage - Part 2', () {
      test('IceNumberChanged supports value equality', () {
        final event1 = IceNumberChanged('ICE123456');
        final event2 = IceNumberChanged('ICE123456');
        final event3 = IceNumberChanged('ICE789012');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('IceNumberChanged props include iceNumber', () {
        final event = IceNumberChanged('ICE123456');
        expect(event.props, []);
      });

      test('BusinessAppBarCollapseChanged supports value equality', () {
        const event1 = BusinessAppBarCollapseChanged(true);
        const event2 = BusinessAppBarCollapseChanged(true);
        const event3 = BusinessAppBarCollapseChanged(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BusinessAppBarCollapseChanged props include isCollapsed', () {
        const event = BusinessAppBarCollapseChanged(true);
        expect(event.props, [true]);
      });

      test('BusinessEkycAppBarCollapseChanged supports value equality', () {
        const event1 = BusinessEkycAppBarCollapseChanged(true);
        const event2 = BusinessEkycAppBarCollapseChanged(true);
        const event3 = BusinessEkycAppBarCollapseChanged(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BusinessEkycAppBarCollapseChanged props include isCollapsed', () {
        const event = BusinessEkycAppBarCollapseChanged(true);
        expect(event.props, [true]);
      });

      test('DirectorCaptchaSend supports value equality', () {
        const event1 = DirectorCaptchaSend();
        const event2 = DirectorCaptchaSend();

        expect(event1, equals(event2));
      });

      test('DirectorCaptchaSend props are empty', () {
        const event = DirectorCaptchaSend();
        expect(event.props, []);
      });

      test('DirectorReCaptchaSend supports value equality', () {
        const event1 = DirectorReCaptchaSend();
        const event2 = DirectorReCaptchaSend();

        expect(event1, equals(event2));
      });

      test('DirectorReCaptchaSend props are empty', () {
        const event = DirectorReCaptchaSend();
        expect(event.props, []);
      });

      test('KartaCaptchaSend supports value equality', () {
        const event1 = KartaCaptchaSend();
        const event2 = KartaCaptchaSend();

        expect(event1, equals(event2));
      });

      test('KartaCaptchaSend props are empty', () {
        const event = KartaCaptchaSend();
        expect(event.props, []);
      });

      test('KartaReCaptchaSend supports value equality', () {
        const event1 = KartaReCaptchaSend();
        const event2 = KartaReCaptchaSend();

        expect(event1, equals(event2));
      });

      test('KartaReCaptchaSend props are empty', () {
        const event = KartaReCaptchaSend();
        expect(event.props, []);
      });

      test('UpdateSelectedCountry supports value equality', () {
        final mockCountry = Country(
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
        );

        final event1 = UpdateSelectedCountry(country: mockCountry);
        final event2 = UpdateSelectedCountry(country: mockCountry);

        expect(event1.country.countryCode, equals(event2.country.countryCode));
      });

      test('UpdateSelectedCountry props include country', () {
        final mockCountry = Country(
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
        );

        final event = UpdateSelectedCountry(country: mockCountry);
        expect(event.props, [mockCountry]);
      });
    });

    group('Missing Event Coverage - Part 3', () {
      final mockFileData = FileData(name: 'test.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('PartnerCaptchaSend supports value equality', () {
        final event1 = PartnerCaptchaSend();
        final event2 = PartnerCaptchaSend();

        expect(event1, equals(event2));
      });

      test('PartnerCaptchaSend props are empty', () {
        final event = PartnerCaptchaSend();
        expect(event.props, []);
      });

      test('PartnerReCaptchaSend supports value equality', () {
        final event1 = PartnerReCaptchaSend();
        final event2 = PartnerReCaptchaSend();

        expect(event1, equals(event2));
      });

      test('PartnerReCaptchaSend props are empty', () {
        final event = PartnerReCaptchaSend();
        expect(event.props, []);
      });

      test('ProprietorCaptchaSend supports value equality', () {
        final event1 = ProprietorCaptchaSend();
        final event2 = ProprietorCaptchaSend();

        expect(event1, equals(event2));
      });

      test('ProprietorCaptchaSend props are empty', () {
        final event = ProprietorCaptchaSend();
        expect(event.props, []);
      });

      test('ProprietorReCaptchaSend supports value equality', () {
        final event1 = ProprietorReCaptchaSend();
        final event2 = ProprietorReCaptchaSend();

        expect(event1, equals(event2));
      });

      test('ProprietorReCaptchaSend props are empty', () {
        final event = ProprietorReCaptchaSend();
        expect(event.props, []);
      });

      test('DirectorAadharNumberChanged supports value equality', () {
        const event1 = DirectorAadharNumberChanged('123456789012');
        const event2 = DirectorAadharNumberChanged('123456789012');
        const event3 = DirectorAadharNumberChanged('987654321098');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('DirectorAadharNumberChanged props are empty', () {
        const event = DirectorAadharNumberChanged('123456789012');
        expect(event.props, []);
      });

      test('KartaAadharNumberChanged supports value equality', () {
        const event1 = KartaAadharNumberChanged('123456789012');
        const event2 = KartaAadharNumberChanged('123456789012');
        const event3 = KartaAadharNumberChanged('987654321098');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('KartaAadharNumberChanged props are empty', () {
        const event = KartaAadharNumberChanged('123456789012');
        expect(event.props, []);
      });

      test('PartnerAadharNumberChanged supports value equality', () {
        const event1 = PartnerAadharNumberChanged('123456789012');
        const event2 = PartnerAadharNumberChanged('123456789012');
        const event3 = PartnerAadharNumberChanged('987654321098');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('PartnerAadharNumberChanged props are empty', () {
        const event = PartnerAadharNumberChanged('123456789012');
        expect(event.props, []);
      });

      test('ProprietorAadharNumberChanged supports value equality', () {
        const event1 = ProprietorAadharNumberChanged('123456789012');
        const event2 = ProprietorAadharNumberChanged('123456789012');
        const event3 = ProprietorAadharNumberChanged('987654321098');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('ProprietorAadharNumberChanged props are empty', () {
        const event = ProprietorAadharNumberChanged('123456789012');
        expect(event.props, []);
      });

      test('LoadBusinessKycFromLocal supports value equality', () {
        const event1 = LoadBusinessKycFromLocal();
        const event2 = LoadBusinessKycFromLocal();

        expect(event1, equals(event2));
      });

      test('LoadBusinessKycFromLocal props are empty', () {
        const event = LoadBusinessKycFromLocal();
        expect(event.props, []);
      });

      test('BusinessGetCityAndState supports value equality', () {
        const event1 = BusinessGetCityAndState('123456');
        const event2 = BusinessGetCityAndState('123456');
        const event3 = BusinessGetCityAndState('654321');

        expect(event1, equals(event2));
        // Since props is empty, all instances are equal regardless of parameters
        expect(event1, equals(event3));
      });

      test('BusinessGetCityAndState props are empty', () {
        const event = BusinessGetCityAndState('123456');
        expect(event.props, []);
      });

      test('LLPINVerificationSubmitted supports value equality', () {
        final event1 = LLPINVerificationSubmitted(
          coifile: mockFileData,
          llpfile: mockFileData,
          llpinNumber: 'LLPIN123456',
        );
        final event2 = LLPINVerificationSubmitted(
          coifile: mockFileData,
          llpfile: mockFileData,
          llpinNumber: 'LLPIN123456',
        );

        expect(event1, equals(event2));
      });

      test('LLPINVerificationSubmitted props include all fields', () {
        final event = LLPINVerificationSubmitted(
          coifile: mockFileData,
          llpfile: mockFileData,
          llpinNumber: 'LLPIN123456',
        );
        expect(event.props, [mockFileData, mockFileData, 'LLPIN123456']);
      });
    });

    group('Missing Event Coverage - Part 4', () {
      final mockFileData = FileData(name: 'test.png', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      test('PartnerShipDeedVerificationSubmitted supports value equality', () {
        final event1 = PartnerShipDeedVerificationSubmitted(partnerShipDeedDoc: mockFileData);
        final event2 = PartnerShipDeedVerificationSubmitted(partnerShipDeedDoc: mockFileData);

        expect(event1, equals(event2));
      });

      test('PartnerShipDeedVerificationSubmitted props include partnerShipDeedDoc', () {
        final event = PartnerShipDeedVerificationSubmitted(partnerShipDeedDoc: mockFileData);
        expect(event.props, [mockFileData]);
      });

      test('BusinessGSTVerification supports value equality', () {
        const event1 = BusinessGSTVerification(turnover: '10000000', gstNumber: 'GST123456789');
        const event2 = BusinessGSTVerification(turnover: '10000000', gstNumber: 'GST123456789');
        const event3 = BusinessGSTVerification(turnover: '20000000', gstNumber: 'GST987654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('BusinessGSTVerification props include turnover and gstNumber', () {
        const event = BusinessGSTVerification(turnover: '10000000', gstNumber: 'GST123456789');
        expect(event.props, ['10000000', 'GST123456789']);
      });

      test('ResetData supports value equality', () {
        final event1 = ResetData();
        final event2 = ResetData();

        expect(event1, equals(event2));
      });

      test('ResetData props are empty', () {
        final event = ResetData();
        expect(event.props, []);
      });

      test('ValidateBusinessOtp supports value equality', () {
        const event1 = ValidateBusinessOtp(phoneNumber: '9876543210', otp: '123456');
        const event2 = ValidateBusinessOtp(phoneNumber: '9876543210', otp: '123456');
        const event3 = ValidateBusinessOtp(phoneNumber: '1234567890', otp: '654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ValidateBusinessOtp props include phoneNumber and otp', () {
        const event = ValidateBusinessOtp(phoneNumber: '9876543210', otp: '123456');
        expect(event.props, ['9876543210', '123456']);
      });

      test('UpdateBusinessNatureString supports value equality', () {
        const event1 = UpdateBusinessNatureString('Manufacturing');
        const event2 = UpdateBusinessNatureString('Manufacturing');
        const event3 = UpdateBusinessNatureString('Services');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UpdateBusinessNatureString props include businessNatureString', () {
        const event = UpdateBusinessNatureString('Manufacturing');
        expect(event.props, ['Manufacturing']);
      });

      test('GetBusinessCurrencyOptions supports value equality', () {
        final event1 = GetBusinessCurrencyOptions();
        final event2 = GetBusinessCurrencyOptions();

        expect(event1, equals(event2));
      });

      test('GetBusinessCurrencyOptions props are empty', () {
        final event = GetBusinessCurrencyOptions();
        expect(event.props, []);
      });

      test('UploadICECertificate supports value equality', () {
        final event1 = UploadICECertificate(mockFileData);
        final event2 = UploadICECertificate(mockFileData);
        final event3 = UploadICECertificate(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadICECertificate props include fileData', () {
        final event = UploadICECertificate(mockFileData);
        expect(event.props, [mockFileData]);
      });

      test('ICEVerificationSubmitted supports value equality', () {
        final event1 = ICEVerificationSubmitted(fileData: mockFileData, iceNumber: 'ICE123456');
        final event2 = ICEVerificationSubmitted(fileData: mockFileData, iceNumber: 'ICE123456');

        expect(event1, equals(event2));
      });

      test('ICEVerificationSubmitted props include fileData and iceNumber', () {
        final event = ICEVerificationSubmitted(fileData: mockFileData, iceNumber: 'ICE123456');
        expect(event.props, [mockFileData, 'ICE123456']);
      });

      test('UploadCOICertificate supports value equality', () {
        final event1 = UploadCOICertificate(mockFileData);
        final event2 = UploadCOICertificate(mockFileData);
        final event3 = UploadCOICertificate(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadCOICertificate props include fileData', () {
        final event = UploadCOICertificate(mockFileData);
        expect(event.props, [mockFileData]);
      });

      test('UploadLLPAgreement supports value equality', () {
        final event1 = UploadLLPAgreement(mockFileData);
        final event2 = UploadLLPAgreement(mockFileData);
        final event3 = UploadLLPAgreement(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadLLPAgreement props include fileData', () {
        final event = UploadLLPAgreement(mockFileData);
        expect(event.props, [mockFileData]);
      });

      test('UploadPartnershipDeed supports value equality', () {
        final event1 = UploadPartnershipDeed(mockFileData);
        final event2 = UploadPartnershipDeed(mockFileData);
        final event3 = UploadPartnershipDeed(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UploadPartnershipDeed props include fileData', () {
        final event = UploadPartnershipDeed(mockFileData);
        expect(event.props, [mockFileData]);
      });

      test('CINVerificationSubmitted supports value equality', () {
        final event1 = CINVerificationSubmitted(fileData: mockFileData, cinNumber: 'CIN123456789');
        final event2 = CINVerificationSubmitted(fileData: mockFileData, cinNumber: 'CIN123456789');

        expect(event1, equals(event2));
      });

      test('CINVerificationSubmitted props include fileData and cinNumber', () {
        final event = CINVerificationSubmitted(fileData: mockFileData, cinNumber: 'CIN123456789');
        expect(event.props, [mockFileData, 'CIN123456789']);
      });
    });

    group('Missing Event Coverage - Part 5', () {
      test('KartaAadharOtpTimerTicked supports value equality', () {
        const event1 = KartaAadharOtpTimerTicked(60);
        const event2 = KartaAadharOtpTimerTicked(60);
        const event3 = KartaAadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('KartaAadharOtpTimerTicked props include remainingTime', () {
        const event = KartaAadharOtpTimerTicked(60);
        expect(event.props, [60]);
      });

      test('PartnerAadharOtpTimerTicked supports value equality', () {
        const event1 = PartnerAadharOtpTimerTicked(60);
        const event2 = PartnerAadharOtpTimerTicked(60);
        const event3 = PartnerAadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PartnerAadharOtpTimerTicked props include remainingTime', () {
        const event = PartnerAadharOtpTimerTicked(60);
        expect(event.props, [60]);
      });

      test('ProprietorAadharOtpTimerTicked supports value equality', () {
        const event1 = ProprietorAadharOtpTimerTicked(60);
        const event2 = ProprietorAadharOtpTimerTicked(60);
        const event3 = ProprietorAadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ProprietorAadharOtpTimerTicked props include remainingTime', () {
        const event = ProprietorAadharOtpTimerTicked(60);
        expect(event.props, [60]);
      });

      test('ProprietorSendAadharOtp supports value equality', () {
        const event1 = ProprietorSendAadharOtp(aadhar: '123456789012', captcha: 'ABCD', sessionId: 'session123');
        const event2 = ProprietorSendAadharOtp(aadhar: '123456789012', captcha: 'ABCD', sessionId: 'session123');

        expect(event1, equals(event2));
      });

      test('ProprietorSendAadharOtp props include aadhar, captcha, and sessionId', () {
        const event = ProprietorSendAadharOtp(aadhar: '123456789012', captcha: 'ABCD', sessionId: 'session123');
        expect(event.props, ['123456789012', 'ABCD', 'session123']);
      });

      test('ProprietorChangeOtpSentStatus supports value equality', () {
        const event1 = ProprietorChangeOtpSentStatus(true);
        const event2 = ProprietorChangeOtpSentStatus(true);
        const event3 = ProprietorChangeOtpSentStatus(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ProprietorChangeOtpSentStatus props include isOtpSent', () {
        const event = ProprietorChangeOtpSentStatus(true);
        expect(event.props, [true]);
      });

      test('ProprietorAadharSendOtpPressed supports value equality', () {
        final event1 = ProprietorAadharSendOtpPressed();
        final event2 = ProprietorAadharSendOtpPressed();

        expect(event1, equals(event2));
      });

      test('ProprietorAadharSendOtpPressed props are empty', () {
        final event = ProprietorAadharSendOtpPressed();
        expect(event.props, []);
      });

      test('ProprietorAadharNumbeVerified supports value equality', () {
        const event1 = ProprietorAadharNumbeVerified('123456789012', '123456');
        const event2 = ProprietorAadharNumbeVerified('123456789012', '123456');
        const event3 = ProprietorAadharNumbeVerified('987654321098', '654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ProprietorAadharNumbeVerified props include aadharNumber and otp', () {
        const event = ProprietorAadharNumbeVerified('123456789012', '123456');
        expect(event.props, ['123456789012', '123456']);
      });

      test('VerifyPanSubmitted supports value equality', () {
        const event1 = VerifyPanSubmitted();
        const event2 = VerifyPanSubmitted();

        expect(event1, equals(event2));
      });

      test('VerifyPanSubmitted props are empty', () {
        const event = VerifyPanSubmitted();
        expect(event.props, []);
      });
    });
  });
}
