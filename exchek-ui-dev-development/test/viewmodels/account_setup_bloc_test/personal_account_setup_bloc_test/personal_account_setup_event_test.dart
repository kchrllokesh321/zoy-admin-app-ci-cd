import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:typed_data';

void main() {
  group('PersonalAccountSetupEvent', () {
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

    group('PersonalInfoStepChanged', () {
      test('supports value equality', () {
        const event1 = PersonalInfoStepChanged(PersonalAccountSetupSteps.personalInformation);
        const event2 = PersonalInfoStepChanged(PersonalAccountSetupSteps.personalInformation);
        const event3 = PersonalInfoStepChanged(PersonalAccountSetupSteps.personalEntity);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include step', () {
        const event = PersonalInfoStepChanged(PersonalAccountSetupSteps.personalInformation);
        expect(event.props, [PersonalAccountSetupSteps.personalInformation]);
      });
    });

    group('NextStep', () {
      test('supports value equality', () {
        const event1 = NextStep();
        const event2 = NextStep();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = NextStep();
        expect(event.props, []);
      });
    });

    group('PreviousStepEvent', () {
      test('supports value equality', () {
        const event1 = PreviousStepEvent();
        const event2 = PreviousStepEvent();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = PreviousStepEvent();
        expect(event.props, []);
      });
    });

    group('ChangePurpose', () {
      test('supports value equality', () {
        const event1 = ChangePurpose('Business');
        const event2 = ChangePurpose('Business');
        const event3 = ChangePurpose('Personal');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include purpose', () {
        const event = ChangePurpose('Business');
        expect(event.props, ['Business']);
      });
    });

    group('ChangeProfession', () {
      test('supports value equality', () {
        const event1 = ChangeProfession('Software Engineer');
        const event2 = ChangeProfession('Software Engineer');
        const event3 = ChangeProfession('Doctor');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include profession', () {
        const event = ChangeProfession('Software Engineer');
        expect(event.props, ['Software Engineer']);
      });
    });

    group('UpdatePersonalDetails', () {
      test('supports value equality', () {
        const event1 = UpdatePersonalDetails(
          fullName: 'John Doe',
          website: 'https://johndoe.com',
          phoneNumber: '9876543210',
        );
        const event2 = UpdatePersonalDetails(
          fullName: 'John Doe',
          website: 'https://johndoe.com',
          phoneNumber: '9876543210',
        );
        const event3 = UpdatePersonalDetails(
          fullName: 'Jane Smith',
          website: 'https://janesmith.com',
          phoneNumber: '9876543211',
        );

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include all personal details', () {
        const event = UpdatePersonalDetails(
          fullName: 'John Doe',
          website: 'https://johndoe.com',
          phoneNumber: '9876543210',
        );
        expect(event.props, ['John Doe', 'https://johndoe.com', '9876543210']);
      });
    });

    group('PersonalPasswordSubmitted', () {
      test('supports value equality', () {
        final event1 = PersonalPasswordSubmitted();
        final event2 = PersonalPasswordSubmitted();

        expect(event1, equals(event2));
      });

      test('props include password', () {
        final event = PersonalPasswordSubmitted();
        expect(event.props, []);
      });
    });

    group('Currency and Transaction Events', () {
      final mockCurrency = CurrencyModel(
        currencyName: 'US Dollar',
        currencySymbol: 'USD',
        currencyImagePath: '/path/usd.png',
      );

      test('PersonalChangeEstimatedMonthlyTransaction supports value equality', () {
        const event1 = PersonalChangeEstimatedMonthlyTransaction('1000-5000');
        const event2 = PersonalChangeEstimatedMonthlyTransaction('1000-5000');
        const event3 = PersonalChangeEstimatedMonthlyTransaction('5000-10000');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalToggleCurrencySelection supports value equality', () {
        final event1 = PersonalToggleCurrencySelection(mockCurrency);
        final event2 = PersonalToggleCurrencySelection(mockCurrency);

        expect(event1.currency.currencySymbol, equals(event2.currency.currencySymbol));
      });

      test('PersonalTransactionDetailSubmitted supports value equality', () {
        final event1 = PersonalTransactionDetailSubmitted(
          currencyList: [mockCurrency],
          monthlyTransaction: '1000-5000',
        );
        final event2 = PersonalTransactionDetailSubmitted(
          currencyList: [mockCurrency],
          monthlyTransaction: '1000-5000',
        );

        expect(event1, equals(event2));
      });
    });

    group('KYC Verification Events', () {
      test('PersonalKycStepChange supports value equality', () {
        const event1 = PersonalKycStepChange(PersonalEKycVerificationSteps.identityVerification);
        const event2 = PersonalKycStepChange(PersonalEKycVerificationSteps.identityVerification);
        const event3 = PersonalKycStepChange(PersonalEKycVerificationSteps.panDetails);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalUpdateIdVerificationDocType supports value equality', () {
        const event1 = PersonalUpdateIdVerificationDocType(IDVerificationDocType.aadharCard);
        const event2 = PersonalUpdateIdVerificationDocType(IDVerificationDocType.aadharCard);
        const event3 = PersonalUpdateIdVerificationDocType(IDVerificationDocType.drivingLicense);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalSendAadharOtp supports value equality', () {
        const event1 = PersonalSendAadharOtp(aadhar: '123456789012', captcha: '123456', sessionId: '123456');
        const event2 = PersonalSendAadharOtp(aadhar: '123456789012', captcha: '123456', sessionId: '123456');
        const event3 = PersonalSendAadharOtp(aadhar: '999999999999', captcha: '654321', sessionId: '654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ChangeOtpSentStatus supports value equality', () {
        const event1 = ChangeOtpSentStatus(true);
        const event2 = ChangeOtpSentStatus(true);
        const event3 = ChangeOtpSentStatus(false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('AadharSendOtpPressed supports value equality', () {
        final event1 = AadharSendOtpPressed();
        final event2 = AadharSendOtpPressed();

        expect(event1, equals(event2));
      });

      test('AadharOtpTimerTicked supports value equality', () {
        const event1 = AadharOtpTimerTicked(60);
        const event2 = AadharOtpTimerTicked(60);
        const event3 = AadharOtpTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('Identity Verification Events', () {
      test('PersonalAadharNumbeVerified supports value equality', () {
        const event1 = PersonalAadharNumbeVerified(aadharNumber: '123456789013', otp: '123456');
        const event2 = PersonalAadharNumbeVerified(aadharNumber: '123456789013', otp: '123456');
        const event3 = PersonalAadharNumbeVerified(aadharNumber: '999999999999', otp: '654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalDrivingLicenceVerified supports value equality', () {
        const event1 = PersonalDrivingLicenceVerified('DL1234567890');
        const event2 = PersonalDrivingLicenceVerified('DL1234567890');
        const event3 = PersonalDrivingLicenceVerified('DL0987654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalVoterIdVerified supports value equality', () {
        const event1 = PersonalVoterIdVerified('VOTER123456');
        const event2 = PersonalVoterIdVerified('VOTER123456');
        const event3 = PersonalVoterIdVerified('VOTER654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalPassportVerified supports value equality', () {
        const event1 = PersonalPassportVerified('PASSPORT123456');
        const event2 = PersonalPassportVerified('PASSPORT123456');
        const event3 = PersonalPassportVerified('PASSPORT654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('File Upload Events', () {
      final mockFileData = FileData(name: 'test.png', path: '/path/test.png', bytes: Uint8List(0), sizeInMB: 0);

      test('PersonalFrontSlideAadharCardUpload supports value equality', () {
        final event1 = PersonalFrontSlideAadharCardUpload(mockFileData);
        final event2 = PersonalFrontSlideAadharCardUpload(mockFileData);
        final differentFileData = FileData(
          name: 'different.png',
          path: '/path/different.png',
          bytes: Uint8List(0),
          sizeInMB: 0,
        );
        final event3 = PersonalFrontSlideAadharCardUpload(differentFileData);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalBackSlideAadharCardUpload supports value equality', () {
        final event1 = PersonalBackSlideAadharCardUpload(mockFileData);
        final event2 = PersonalBackSlideAadharCardUpload(mockFileData);
        final differentFileData = FileData(
          name: 'different.png',
          path: '/path/different.png',
          bytes: Uint8List(0),
          sizeInMB: 0,
        );
        final event3 = PersonalBackSlideAadharCardUpload(differentFileData);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalAadharFileUploadSubmitted supports value equality', () {
        final event1 = PersonalAadharFileUploadSubmitted(
          frontAadharFileData: mockFileData,
          backAadharFileData: mockFileData,
        );
        final event2 = PersonalAadharFileUploadSubmitted(
          frontAadharFileData: mockFileData,
          backAadharFileData: mockFileData,
        );

        expect(event1, equals(event2));
      });

      test('PersonalFrontSlideDrivingLicenceUpload supports value equality', () {
        final event1 = PersonalFrontSlideDrivingLicenceUpload(mockFileData);
        final event2 = PersonalFrontSlideDrivingLicenceUpload(mockFileData);
        final event3 = PersonalFrontSlideDrivingLicenceUpload(null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalDrivingFileUploadSubmitted supports value equality', () {
        final event1 = PersonalDrivingFileUploadSubmitted(frontDrivingLicenceFileData: mockFileData);
        final event2 = PersonalDrivingFileUploadSubmitted(frontDrivingLicenceFileData: mockFileData);

        expect(event1, equals(event2));
      });

      test('PersonalVoterIdFileUpload supports value equality', () {
        final event1 = PersonalVoterIdFrontFileUpload(mockFileData);
        final event2 = PersonalVoterIdFrontFileUpload(mockFileData);
        final differentFileData = FileData(
          name: 'different.png',
          path: '/path/different.png',
          bytes: Uint8List(0),
          sizeInMB: 0,
        );
        final event3 = PersonalVoterIdFrontFileUpload(differentFileData);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalVoterIdFileUploadSubmitted supports value equality', () {
        final event1 = PersonalVoterIdFileUploadSubmitted(voterIdFrontFileData: mockFileData);
        final event2 = PersonalVoterIdFileUploadSubmitted(voterIdFrontFileData: mockFileData);

        expect(event1, equals(event2));
      });

      test('PersonalPassportFileUpload supports value equality', () {
        final event1 = PersonalPassportFrontFileUpload(mockFileData);
        final event2 = PersonalPassportFrontFileUpload(mockFileData);
        final differentFileData = FileData(
          name: 'different.png',
          path: '/path/different.png',
          bytes: Uint8List(0),
          sizeInMB: 0,
        );
        final event3 = PersonalPassportFrontFileUpload(differentFileData);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalPassportFileUploadSubmitted supports value equality', () {
        final event1 = PersonalPassportFileUploadSubmitted(passportFrontFileData: mockFileData);
        final event2 = PersonalPassportFileUploadSubmitted(passportFrontFileData: mockFileData);

        expect(event1, equals(event2));
      });

      test('PersonalUploadPanCard supports value equality', () {
        final event1 = PersonalUploadPanCard(mockFileData);
        final event2 = PersonalUploadPanCard(mockFileData);
        final differentFileData = FileData(
          name: 'different.png',
          path: '/path/different.png',
          bytes: Uint8List(0),
          sizeInMB: 0,
        );
        final event3 = PersonalUploadPanCard(differentFileData);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('PAN Verification Events', () {
      final mockFileData = FileData(name: 'pan.png', path: '/path/pan.png', bytes: Uint8List(0), sizeInMB: 0);

      test('PersonalPanVerificationSubmitted supports value equality', () {
        final event1 = PersonalPanVerificationSubmitted(
          fileData: mockFileData,
          panName: 'John Doe',
          panNumber: 'ABCDE1234F',
        );
        final event2 = PersonalPanVerificationSubmitted(
          fileData: mockFileData,
          panName: 'John Doe',
          panNumber: 'ABCDE1234F',
        );

        expect(event1, equals(event2));
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

      final mockFileData = FileData(
        name: 'address_proof.png',
        path: '/path/address_proof.png',
        bytes: Uint8List(0),
        sizeInMB: 0,
      );

      test('PersonalUpdateSelectedCountry supports value equality', () {
        final event1 = PersonalUpdateSelectedCountry(country: mockCountry);
        final event2 = PersonalUpdateSelectedCountry(country: mockCountry);

        expect(event1.country.countryCode, equals(event2.country.countryCode));
      });

      test('PersonalUpdateAddressVerificationDocType supports value equality', () {
        const event1 = PersonalUpdateAddressVerificationDocType('Utility Bill');
        const event2 = PersonalUpdateAddressVerificationDocType('Utility Bill');
        const event3 = PersonalUpdateAddressVerificationDocType('Bank Statement');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalUploadAddressVerificationFile supports value equality', () {
        final event1 = PersonalUploadAddressVerificationFile(fileData: mockFileData);
        final event2 = PersonalUploadAddressVerificationFile(fileData: mockFileData);
        final event3 = PersonalUploadAddressVerificationFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalRegisterAddressSubmitted supports value equality', () {
        final event1 = PersonalRegisterAddressSubmitted(
          addressValidateFileData: mockFileData,
          isAddharCard: false,
          docType: 'BankStatement',
        );
        final event2 = PersonalRegisterAddressSubmitted(
          addressValidateFileData: mockFileData,
          isAddharCard: false,
          docType: 'BankStatement',
        );

        expect(event1, equals(event2));
      });
    });

    group('GST and Turnover Events', () {
      final mockFileData = FileData(
        name: 'gst_certificate.pdf',
        path: '/path/gst_certificate.pdf',
        bytes: Uint8List(0),
        sizeInMB: 0,
      );

      test('PersonalUploadGstCertificateFile supports value equality', () {
        final event1 = PersonalUploadGstCertificateFile(fileData: mockFileData);
        final event2 = PersonalUploadGstCertificateFile(fileData: mockFileData);
        final event3 = PersonalUploadGstCertificateFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalAnnualTurnOverVerificationSubmitted supports value equality', () {
        final event1 = PersonalAnnualTurnOverVerificationSubmitted(
          gstNumber: 'GST123456789',
          gstCertificate: mockFileData,
        );
        final event2 = PersonalAnnualTurnOverVerificationSubmitted(
          gstNumber: 'GST123456789',
          gstCertificate: mockFileData,
        );

        expect(event1, equals(event2));
      });
    });

    group('Bank Account Events', () {
      final mockFileData = FileData(
        name: 'bank_statement.pdf',
        path: '/path/bank_statement.pdf',
        bytes: Uint8List(0),
        sizeInMB: 0,
      );

      test('PersonalBankAccountNumberVerify supports value equality', () {
        const event1 = PersonalBankAccountNumberVerify(accountNumber: '1234567890', ifscCode: 'SBIN0001234');
        const event2 = PersonalBankAccountNumberVerify(accountNumber: '1234567890', ifscCode: 'SBIN0001234');
        const event3 = PersonalBankAccountNumberVerify(accountNumber: '0987654321', ifscCode: 'SBIN0001234');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalUpdateBankAccountVerificationDocType supports value equality', () {
        const event1 = PersonalUpdateBankAccountVerificationDocType('Bank Statement');
        const event2 = PersonalUpdateBankAccountVerificationDocType('Bank Statement');
        const event3 = PersonalUpdateBankAccountVerificationDocType('Passbook');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('PersonalUploadBankAccountVerificationFile supports value equality', () {
        final event1 = PersonalUploadBankAccountVerificationFile(fileData: mockFileData);
        final event2 = PersonalUploadBankAccountVerificationFile(fileData: mockFileData);
        final event3 = PersonalUploadBankAccountVerificationFile(fileData: null);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      testWidgets('PersonalBankAccountDetailSubmitted supports value equality', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final event1 = PersonalBankAccountDetailSubmitted(
                  bankAccountVerifyFile: mockFileData,
                  documentType: 'bank_statement',
                  context: context,
                );
                final event2 = PersonalBankAccountDetailSubmitted(
                  bankAccountVerifyFile: mockFileData,
                  documentType: 'bank_statement',
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

    group('Scroll Events', () {
      test('PersonalScrollToPosition supports value equality', () {
        final key1 = GlobalKey();
        final key2 = GlobalKey();

        final event1 = PersonalScrollToPosition(key1);
        final event2 = PersonalScrollToPosition(key1);
        final event3 = PersonalScrollToPosition(key2);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('OTP Events', () {
      test('SendOTP supports value equality', () {
        final event1 = SendOTP();
        final event2 = SendOTP();

        expect(event1, equals(event2));
      });

      test('UpdateOTPError supports value equality', () {
        const event1 = UpdateOTPError('Invalid OTP');
        const event2 = UpdateOTPError('Invalid OTP');
        const event3 = UpdateOTPError('OTP expired');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ConfirmAndContinue supports value equality', () {
        final event1 = ConfirmAndContinue();
        final event2 = ConfirmAndContinue();

        expect(event1, equals(event2));
      });

      test('UpdateResendTimerState supports value equality', () {
        const event1 = UpdateResendTimerState(timeLeft: 30, canResend: false);
        const event2 = UpdateResendTimerState(timeLeft: 30, canResend: false);
        const event3 = UpdateResendTimerState(timeLeft: 0, canResend: true);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('UpdateResendTimerState props include timeLeft and canResend', () {
        const event = UpdateResendTimerState(timeLeft: 30, canResend: false);
        expect(event.props, [30, false]);
      });
    });

    group('Password Events', () {
      test('TogglePasswordVisibility supports value equality', () {
        const event1 = TogglePasswordVisibility();
        const event2 = TogglePasswordVisibility();

        expect(event1, equals(event2));
      });

      test('ToggleConfirmPasswordVisibility supports value equality', () {
        const event1 = ToggleConfirmPasswordVisibility();
        const event2 = ToggleConfirmPasswordVisibility();

        expect(event1, equals(event2));
      });

      test('PasswordChanged supports value equality', () {
        const event1 = PasswordChanged(password: 'password123');
        const event2 = PasswordChanged(password: 'password123');
        const event3 = PasswordChanged(password: 'password456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include password', () {
        const event = PasswordChanged(password: 'password123');
        expect(event.props, ['password123']);
      });

      test('ConfirmPasswordChanged supports value equality', () {
        const event1 = ConfirmPasswordChanged(password: 'password123');
        const event2 = ConfirmPasswordChanged(password: 'password123');
        const event3 = ConfirmPasswordChanged(password: 'password456');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include password', () {
        const event = ConfirmPasswordChanged(password: 'password123');
        expect(event.props, ['password123']);
      });
    });

    group('Reset and Data Events', () {
      test('PersonalResetData supports value equality', () {
        const event1 = PersonalResetData();
        const event2 = PersonalResetData();

        expect(event1, equals(event2));
      });

      test('PersonalResetSignupSuccess supports value equality', () {
        const event1 = PersonalResetSignupSuccess();
        const event2 = PersonalResetSignupSuccess();

        expect(event1, equals(event2));
      });

      test('GetPersonalCurrencyOptions supports value equality', () {
        const event1 = GetPersonalCurrencyOptions();
        const event2 = GetPersonalCurrencyOptions();

        expect(event1, equals(event2));
      });
    });

    group('Event Props Validation', () {
      test('all events extend PersonalAccountSetupEvent', () {
        final events = [
          LoadInitialState(),
          const PersonalInfoStepChanged(PersonalAccountSetupSteps.personalInformation),
          const NextStep(),
          const PreviousStepEvent(),
          const ChangePurpose('Business'),
          const ChangeProfession('Engineer'),
          PersonalPasswordSubmitted(),
          const PersonalChangeEstimatedMonthlyTransaction('1000'),
          const PersonalKycStepChange(PersonalEKycVerificationSteps.identityVerification),
          const PersonalUpdateIdVerificationDocType(IDVerificationDocType.aadharCard),
          const PersonalSendAadharOtp(aadhar: '123456789012', captcha: '123456', sessionId: '123456'),
          const ChangeOtpSentStatus(true),
          AadharSendOtpPressed(),
          const AadharOtpTimerTicked(60),
          const PersonalAadharNumbeVerified(aadharNumber: '123456789012', otp: '123456'),
          const PersonalDrivingLicenceVerified('DL123456'),
          const PersonalVoterIdVerified('VOTER123'),
          const PersonalPassportVerified('PASSPORT123'),
          SendOTP(),
          const UpdateOTPError('Error'),
          ConfirmAndContinue(),
          const UpdateResendTimerState(timeLeft: 30),
          const TogglePasswordVisibility(),
          const ToggleConfirmPasswordVisibility(),
          const PasswordChanged(password: 'test'),
          const ConfirmPasswordChanged(password: 'test'),
          const PersonalResetData(),
          const PersonalResetSignupSuccess(),
          const GetPersonalCurrencyOptions(),
        ];

        for (final event in events) {
          expect(event, isA<PersonalAccountSetupEvent>());
          expect(event.props, isA<List<Object?>>());
        }
      });
    });

    group('Complex Event Scenarios', () {
      test('events with file data handle null values correctly', () {
        final mockFileData = FileData(name: 'test.png', path: '/path/test.png', bytes: Uint8List(0), sizeInMB: 0);

        final eventsWithFileData = [
          PersonalFrontSlideAadharCardUpload(mockFileData),
          PersonalFrontSlideAadharCardUpload(null),
          PersonalBackSlideAadharCardUpload(mockFileData),
          PersonalBackSlideAadharCardUpload(null),
          PersonalUploadPanCard(mockFileData),
          PersonalUploadPanCard(null),
          PersonalVoterIdFrontFileUpload(mockFileData),
          PersonalVoterIdFrontFileUpload(null),
          PersonalPassportFrontFileUpload(mockFileData),
          PersonalPassportFrontFileUpload(null),
        ];

        for (final event in eventsWithFileData) {
          expect(event, isA<PersonalAccountSetupEvent>());
          expect(event.props, isA<List<Object?>>());
        }
      });

      test('events with optional parameters work correctly', () {
        const event1 = UpdatePersonalDetails(fullName: 'John Doe', phoneNumber: '9876543210');

        const event2 = UpdatePersonalDetails(
          fullName: 'John Doe',
          website: 'https://example.com',
          phoneNumber: '9876543210',
        );

        expect(event1, isNot(equals(event2)));
        expect(event2.website, 'https://example.com');
      });

      test('timer events handle edge cases', () {
        const zeroTimeEvent = UpdateResendTimerState(timeLeft: 0, canResend: true);
        const negativeTimeEvent = UpdateResendTimerState(timeLeft: -1, canResend: true);
        const largeTimeEvent = UpdateResendTimerState(timeLeft: 999999, canResend: false);

        expect(zeroTimeEvent.timeLeft, 0);
        expect(negativeTimeEvent.timeLeft, -1);
        expect(largeTimeEvent.timeLeft, 999999);
      });
    });
  });
}
