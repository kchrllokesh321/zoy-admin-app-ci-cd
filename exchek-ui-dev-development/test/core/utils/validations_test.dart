import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/utils/validations.dart';

void main() {
  group('ExchekValidations', () {
    // =============================================================================
    // BASIC VALIDATIONS TESTS
    // =============================================================================

    group('validateRequired', () {
      test('returns error message when value is null', () {
        final result = ExchekValidations.validateRequired(null);
        expect(result, equals('This field is required.'));
      });

      test('returns error message when value is empty', () {
        final result = ExchekValidations.validateRequired('');
        expect(result, equals('This field is required.'));
      });

      test('returns error message when value is only whitespace', () {
        final result = ExchekValidations.validateRequired('   ');
        expect(result, equals('This field is required.'));
      });

      test('returns null when value is valid', () {
        final result = ExchekValidations.validateRequired('Valid input');
        expect(result, isNull);
      });

      test('returns custom field name in error message', () {
        final result = ExchekValidations.validateRequired(
          null,
          fieldName: 'Email',
        );
        expect(result, equals('Email is required.'));
      });
    });

    group('validateEmail', () {
      test('returns error when email is null', () {
        final result = ExchekValidations.validateEmail(null);
        expect(result, equals('Email is required'));
      });

      test('returns error when email is empty', () {
        final result = ExchekValidations.validateEmail('');
        expect(result, equals('Email is required'));
      });

      test('returns error for invalid email format', () {
        final result = ExchekValidations.validateEmail('invalid-email');
        expect(result, equals('Please enter a valid email address'));
      });

      test('returns error for email without domain', () {
        final result = ExchekValidations.validateEmail('test@');
        expect(result, equals('Please enter a valid email address'));
      });

      test('returns error for email without @ symbol', () {
        final result = ExchekValidations.validateEmail('testexample.com');
        expect(result, equals('Please enter a valid email address'));
      });

      test('returns null for valid email', () {
        final result = ExchekValidations.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('returns null for valid email with subdomain', () {
        final result = ExchekValidations.validateEmail('user@mail.example.com');
        expect(result, isNull);
      });

      test('handles email with whitespace', () {
        final result = ExchekValidations.validateEmail('  test@example.com  ');
        expect(result, isNull);
      });
    });

    group('validateBusinessEmail', () {
      test('returns error for invalid email format', () {
        final result = ExchekValidations.validateBusinessEmail('invalid-email');
        expect(result, equals('Please enter a valid email address'));
      });

      test('returns null for valid business email', () {
        final result = ExchekValidations.validateBusinessEmail(
          'business@company.com',
        );
        expect(result, isNull);
      });
    });

    group('validateEmailOrUserId', () {
      test('returns error when value is null', () {
        final result = ExchekValidations.validateEmailOrUserId(null);
        expect(result, equals('Email Address / User ID is required'));
      });

      test('returns error when value is too short', () {
        final result = ExchekValidations.validateEmailOrUserId('ab');
        expect(
          result,
          equals('Email Address / User ID must be at least 3 characters'),
        );
      });

      test('returns error when value is too long', () {
        final result = ExchekValidations.validateEmailOrUserId('a' * 101);
        expect(
          result,
          equals('Email Address / User ID must not exceed 100 characters'),
        );
      });

      test('validates email when @ symbol is present', () {
        final result = ExchekValidations.validateEmailOrUserId(
          'test@example.com',
        );
        expect(result, isNull);
      });

      test('validates user ID when no @ symbol', () {
        final result = ExchekValidations.validateEmailOrUserId('user123');
        expect(result, isNull);
      });

      test('returns error for invalid user ID format', () {
        final result = ExchekValidations.validateEmailOrUserId('user@123');
        expect(result, equals('Please enter a valid email address'));
      });
    });

    group('validateEmailOrMobileNumber', () {
      test('returns error when value is null', () {
        final result = ExchekValidations.validateEmailOrMobileNumber(null);
        expect(result, equals('Email or Mobile number is required'));
      });

      test('validates email when @ symbol is present', () {
        final result = ExchekValidations.validateEmailOrMobileNumber(
          'test@example.com',
        );
        expect(result, isNull);
      });

      test('validates mobile number when no @ symbol', () {
        final result = ExchekValidations.validateEmailOrMobileNumber(
          '9876543210',
        );
        expect(result, isNull);
      });

      test('returns error for invalid mobile number', () {
        final result = ExchekValidations.validateEmailOrMobileNumber(
          '1234567890',
        );
        expect(result, equals('Please enter a valid 10-digit mobile number'));
      });
    });

    // =============================================================================
    // MOBILE NUMBER VALIDATIONS TESTS
    // =============================================================================

    group('validateMobileNumber', () {
      test('returns error when mobile number is null', () {
        final result = ExchekValidations.validateMobileNumber(null);
        expect(result, equals('Mobile number is required'));
      });

      test('returns error when mobile number is empty', () {
        final result = ExchekValidations.validateMobileNumber('');
        expect(result, equals('Mobile number is required'));
      });

      test(
        'returns error for invalid Indian mobile number starting with 5',
        () {
          final result = ExchekValidations.validateMobileNumber('5876543210');
          expect(result, equals('Please enter a valid 10-digit mobile number'));
        },
      );

      test('returns error for mobile number with less than 10 digits', () {
        final result = ExchekValidations.validateMobileNumber('987654321');
        expect(result, equals('Please enter a valid 10-digit mobile number'));
      });

      test('returns error for mobile number with more than 10 digits', () {
        final result = ExchekValidations.validateMobileNumber('98765432101');
        expect(result, equals('Please enter a valid 10-digit mobile number'));
      });

      test('returns null for valid Indian mobile number starting with 6', () {
        final result = ExchekValidations.validateMobileNumber('6876543210');
        expect(result, isNull);
      });

      test('returns null for valid Indian mobile number starting with 7', () {
        final result = ExchekValidations.validateMobileNumber('7876543210');
        expect(result, isNull);
      });

      test('returns null for valid Indian mobile number starting with 8', () {
        final result = ExchekValidations.validateMobileNumber('8876543210');
        expect(result, isNull);
      });

      test('returns null for valid Indian mobile number starting with 9', () {
        final result = ExchekValidations.validateMobileNumber('9876543210');
        expect(result, isNull);
      });

      test('handles mobile number with spaces and special characters', () {
        final result = ExchekValidations.validateMobileNumber(
          '+91 9876 543 210',
        );
        expect(result, isNull);
      });
    });

    // =============================================================================
    // OTP VALIDATIONS TESTS
    // =============================================================================

    group('validateOTP', () {
      test('returns error when OTP is null', () {
        final result = ExchekValidations.validateOTP(null);
        expect(result, equals('Please enter OTP'));
      });

      test('returns error when OTP is empty', () {
        final result = ExchekValidations.validateOTP('');
        expect(result, equals('Please enter OTP'));
      });

      test('returns error when OTP is less than 6 digits', () {
        final result = ExchekValidations.validateOTP('12345');
        expect(result, equals('OTP must be exactly 6 digits'));
      });

      test('returns error when OTP is more than 6 digits', () {
        final result = ExchekValidations.validateOTP('1234567');
        expect(result, equals('OTP must be exactly 6 digits'));
      });

      test('returns error when OTP contains non-numeric characters', () {
        final result = ExchekValidations.validateOTP('12345a');
        expect(result, equals('OTP should contain only digits'));
      });

      test('returns null for valid 6-digit OTP', () {
        final result = ExchekValidations.validateOTP('123456');
        expect(result, isNull);
      });
    });

    // =============================================================================
    // PASSWORD VALIDATIONS TESTS
    // =============================================================================

    group('validatePassword', () {
      test('returns error when password is null', () {
        final result = ExchekValidations.validatePassword(null);
        expect(result, equals('Password is required'));
      });

      test('returns error when password is empty', () {
        final result = ExchekValidations.validatePassword('');
        expect(result, equals('Password is required'));
      });

      test('returns error when password is less than 8 characters', () {
        final result = ExchekValidations.validatePassword('Pass1@');
        expect(result, equals('Password must be at least 8 characters long'));
      });

      test('returns error when password lacks uppercase letter', () {
        final result = ExchekValidations.validatePassword('password1@');
        expect(
          result,
          equals(
            'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
          ),
        );
      });

      test('returns error when password lacks lowercase letter', () {
        final result = ExchekValidations.validatePassword('PASSWORD1@');
        expect(
          result,
          equals(
            'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
          ),
        );
      });

      test('returns error when password lacks number', () {
        final result = ExchekValidations.validatePassword('Password@');
        expect(
          result,
          equals(
            'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
          ),
        );
      });

      test('returns error when password lacks special character', () {
        final result = ExchekValidations.validatePassword('Password1');
        expect(
          result,
          equals(
            'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
          ),
        );
      });

      test('returns null for valid password', () {
        final result = ExchekValidations.validatePassword('Password1@');
        expect(result, isNull);
      });
    });

    group('validateConfirmPassword', () {
      test('returns error when confirm password is null', () {
        final result = ExchekValidations.validateConfirmPassword(
          'Password1@',
          null,
        );
        expect(result, equals('Please confirm your password'));
      });

      test('returns error when confirm password is empty', () {
        final result = ExchekValidations.validateConfirmPassword(
          'Password1@',
          '',
        );
        expect(result, equals('Please confirm your password'));
      });

      test('returns error when passwords do not match', () {
        final result = ExchekValidations.validateConfirmPassword(
          'Password1@',
          'Password2@',
        );
        expect(result, equals('Passwords do not match'));
      });

      test('returns null when passwords match', () {
        final result = ExchekValidations.validateConfirmPassword(
          'Password1@',
          'Password1@',
        );
        expect(result, isNull);
      });
    });

    // =============================================================================
    // ADDRESS VALIDATIONS TESTS
    // =============================================================================

    group('validatePostalCode', () {
      test('returns error when postal code is null', () {
        final result = ExchekValidations.validatePostalCode(null);
        expect(result, equals('Postal code is required'));
      });

      test('returns error when postal code is empty', () {
        final result = ExchekValidations.validatePostalCode('');
        expect(result, equals('Postal code is required'));
      });

      test('returns error for invalid Indian postal code format', () {
        final result = ExchekValidations.validatePostalCode('12345');
        expect(result, equals('Please enter a valid 6-digit postal code'));
      });

      test('returns error for postal code with letters', () {
        final result = ExchekValidations.validatePostalCode('12345a');
        expect(result, equals('Please enter a valid 6-digit postal code'));
      });

      test('returns null for valid Indian postal code', () {
        final result = ExchekValidations.validatePostalCode('123456');
        expect(result, isNull);
      });

      test('handles postal code with whitespace', () {
        final result = ExchekValidations.validatePostalCode('  123456  ');
        expect(result, isNull);
      });
    });

    group('validateFullName', () {
      test('returns error when name is null', () {
        final result = ExchekValidations.validateFullName(null);
        expect(result, equals('Full name is required'));
      });

      test('returns error when name is empty', () {
        final result = ExchekValidations.validateFullName('');
        expect(result, equals('Full name is required'));
      });

      test('returns error when name is too short', () {
        final result = ExchekValidations.validateFullName('A');
        expect(result, equals('Please enter your full name'));
      });

      test('returns error when name contains numbers', () {
        final result = ExchekValidations.validateFullName('John123');
        expect(result, equals('Name should contain only letters and spaces'));
      });

      test('returns error when name contains special characters', () {
        final result = ExchekValidations.validateFullName('John@Doe');
        expect(result, equals('Name should contain only letters and spaces'));
      });

      test('returns null for valid name with spaces', () {
        final result = ExchekValidations.validateFullName('John Doe');
        expect(result, isNull);
      });

      test('returns null for valid single name', () {
        final result = ExchekValidations.validateFullName('John');
        expect(result, isNull);
      });
    });

    // =============================================================================
    // DOCUMENT VALIDATIONS TESTS
    // =============================================================================

    group('validateAadhaar', () {
      test('returns error when Aadhaar is null', () {
        final result = ExchekValidations.validateAadhaar(null);
        expect(result, equals('Aadhaar number is required'));
      });

      test('returns error when Aadhaar is empty', () {
        final result = ExchekValidations.validateAadhaar('');
        expect(result, equals('Aadhaar number is required'));
      });

      test('returns error for Aadhaar with less than 12 digits', () {
        final result = ExchekValidations.validateAadhaar('12345678901');
        expect(
          result,
          equals('Enter Valid Aadhaar Number. Please check and try again'),
        );
      });

      test('returns error for Aadhaar with more than 12 digits', () {
        final result = ExchekValidations.validateAadhaar('1234567890123');
        expect(
          result,
          equals('Enter Valid Aadhaar Number. Please check and try again'),
        );
      });

      test('returns error for Aadhaar with letters', () {
        final result = ExchekValidations.validateAadhaar('12345678901a');
        expect(
          result,
          equals('Enter Valid Aadhaar Number. Please check and try again'),
        );
      });

      test('returns null for valid Aadhaar number', () {
        final result = ExchekValidations.validateAadhaar('123456789012');
        expect(result, isNull);
      });

      test('handles Aadhaar with spaces and special characters', () {
        final result = ExchekValidations.validateAadhaar('1234 5678 9012');
        expect(result, isNull);
      });
    });

    group('validatePAN', () {
      test('returns error when PAN is null', () {
        final result = ExchekValidations.validatePAN(null);
        expect(result, equals('PAN number is required'));
      });

      test('returns error when PAN is empty', () {
        final result = ExchekValidations.validatePAN('');
        expect(result, equals('PAN number is required'));
      });

      test('returns error for invalid PAN format', () {
        final result = ExchekValidations.validatePAN('INVALID123');
        expect(
          result,
          equals('Invalid PAN number. Please check and try again'),
        );
      });

      test('returns error for PAN with invalid 4th character', () {
        final result = ExchekValidations.validatePAN('ABCX1234Z');
        expect(
          result,
          equals('Invalid PAN number. Please check and try again'),
        );
      });

      test('returns null for valid individual PAN', () {
        final result = ExchekValidations.validatePAN('ABCPP1234F');
        expect(result, isNull);
      });

      test('returns null for valid company PAN', () {
        final result = ExchekValidations.validatePAN('ABCPC1234F');
        expect(result, isNull);
      });

      test('handles lowercase PAN input', () {
        final result = ExchekValidations.validatePAN('abcpp1234f');
        expect(result, isNull);
      });
    });

    group('validateGST', () {
      test('returns null when GST is null and optional', () {
        final result = ExchekValidations.validateGST(null, isOptional: true);
        expect(result, isNull);
      });

      test('returns error when GST is null and required', () {
        final result = ExchekValidations.validateGST(null, isOptional: false);
        expect(result, equals('GST number is required'));
      });

      test('returns error for invalid GST length', () {
        final result = ExchekValidations.validateGST('12ABCDE1234F1Z');
        expect(result, equals('GST number must be exactly 15 characters long'));
      });

      test('returns error for invalid GST format', () {
        final result = ExchekValidations.validateGST('INVALID12345678');
        expect(result, equals('Invalid GST number format'));
      });

      test('returns error for invalid state code', () {
        final result = ExchekValidations.validateGST('99ABCDE1234F1Z5');
        expect(result, equals('Invalid state code in GST number'));
      });

      test('returns error when 14th character is not Z', () {
        final result = ExchekValidations.validateGST('12ABCDE1234F1X5');
        expect(result, equals('Invalid GST number format'));
      });

      test('returns null for valid GST number', () {
        final result = ExchekValidations.validateGST('12ABCDE1234F1Z5');
        expect(result, isNull);
      });
    });

    group('validatePassport', () {
      test('returns null when passport is null and optional', () {
        final result = ExchekValidations.validatePassport(
          null,
          isOptional: true,
        );
        expect(result, isNull);
      });

      test('returns error when passport is null and required', () {
        final result = ExchekValidations.validatePassport(
          null,
          isOptional: false,
        );
        expect(result, equals('Passport number is required'));
      });

      test('returns error for invalid passport format', () {
        final result = ExchekValidations.validatePassport('INVALID');
        expect(result, equals('Enter valid passport number'));
      });

      test('returns null for valid passport number', () {
        final result = ExchekValidations.validatePassport('A1234567');
        expect(result, isNull);
      });
    });

    // =============================================================================
    // BANK VALIDATIONS TESTS
    // =============================================================================

    group('validateBankAccount', () {
      test('returns error when account number is null', () {
        final result = ExchekValidations.validateBankAccount(null);
        expect(result, equals('Bank account number is required'));
      });

      test('returns error when account number is empty', () {
        final result = ExchekValidations.validateBankAccount('');
        expect(result, equals('Bank account number is required'));
      });

      test('returns error for account number too short', () {
        final result = ExchekValidations.validateBankAccount('12345678');
        expect(result, equals('Please enter a valid account number.'));
      });

      test(
        'returns null for account number with 19 digits (no max length limit)',
        () {
          final result = ExchekValidations.validateBankAccount(
            '1234567890123456789',
          );
          expect(result, isNull);
        },
      );

      test('returns error for account number with letters', () {
        final result = ExchekValidations.validateBankAccount('123456789a');
        expect(
          result,
          equals('Please enter a valid account number.'),
        ); // Letters make it invalid
      });

      test('returns null for valid account number', () {
        final result = ExchekValidations.validateBankAccount('123456789012');
        expect(result, isNull);
      });

      test('handles account number with spaces', () {
        final result = ExchekValidations.validateBankAccount('1234 5678 9012');
        expect(result, isNull);
      });
    });

    group('validateIFSC', () {
      test('returns error when IFSC is null', () {
        final result = ExchekValidations.validateIFSC(null);
        expect(result, equals('IFSC code is required'));
      });

      test('returns error when IFSC is empty', () {
        final result = ExchekValidations.validateIFSC('');
        expect(result, equals('IFSC code is required'));
      });

      test('returns error for invalid IFSC length', () {
        final result = ExchekValidations.validateIFSC(
          'SBIN000123',
        ); // 10 characters
        expect(
          result,
          equals('Invalid IFSC code. Please check and try again.'),
        );
      });

      test('returns error for invalid IFSC format', () {
        final result = ExchekValidations.validateIFSC('INVALID1234');
        expect(
          result,
          equals('Invalid IFSC code. Please check and try again.'),
        );
      });

      test('returns null for valid IFSC code', () {
        final result = ExchekValidations.validateIFSC('SBIN0001234');
        expect(result, isNull);
      });

      test('handles lowercase IFSC input', () {
        final result = ExchekValidations.validateIFSC('sbin0001234');
        expect(result, isNull);
      });
    });

    group('validateAccountConfirmation', () {
      test('returns error when confirmation is null', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '123456789012',
          null,
        );
        expect(result, equals('Please re-enter your account number'));
      });

      test('returns error when confirmation is empty', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '123456789012',
          '',
        );
        expect(result, equals('Please re-enter your account number'));
      });

      test('returns error when account numbers do not match', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '123456789012',
          '123456789013',
        );
        expect(result, equals('Account numbers do not match'));
      });

      test('returns null when account numbers match', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '123456789012',
          '123456789012',
        );
        expect(result, isNull);
      });

      test('handles whitespace in account numbers', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '  123456789012  ',
          '123456789012',
        );
        expect(result, isNull);
      });
    });

    // =============================================================================
    // BUSINESS VALIDATIONS TESTS
    // =============================================================================

    group('validateBusinessName', () {
      test('returns error when business name is null', () {
        final result = ExchekValidations.validateBusinessName(null);
        expect(result, equals('Business name is required'));
      });

      test('returns error when business name is empty', () {
        final result = ExchekValidations.validateBusinessName('');
        expect(result, equals('Business name is required'));
      });

      test('returns error when business name is too short', () {
        final result = ExchekValidations.validateBusinessName('A');
        expect(result, equals('Business name must be at least 2 characters'));
      });

      test('returns null for valid business name', () {
        final result = ExchekValidations.validateBusinessName('ABC Company');
        expect(result, isNull);
      });
    });

    group('validateCIN', () {
      test('returns null when CIN is null and optional', () {
        final result = ExchekValidations.validateCIN(null, isOptional: true);
        expect(result, isNull);
      });

      test('returns error when CIN is null and required', () {
        final result = ExchekValidations.validateCIN(null, isOptional: false);
        expect(result, equals('Please enter a valid registration number'));
      });

      test('returns error for invalid CIN length', () {
        final result = ExchekValidations.validateCIN(
          'L12345MH2020PLC12345',
        ); // 20 characters
        expect(result, equals('CIN must be exactly 21 characters long'));
      });

      test('returns error for invalid CIN format', () {
        final result = ExchekValidations.validateCIN(
          'Z12345MH2020PLC123456',
        ); // 21 chars, starts with Z (invalid)
        expect(result, equals('Invalid CIN format'));
      });

      test('returns error for invalid listing status', () {
        final result = ExchekValidations.validateCIN(
          'X12345MH2020PLC123456',
        ); // 21 chars, valid format but invalid first char
        expect(
          result,
          equals('Invalid CIN format'),
        ); // Format check comes before listing status check
      });

      test('returns error for invalid year', () {
        final result = ExchekValidations.validateCIN('L12345MH1800PLC123456');
        expect(result, equals('Please enter a valid registration number'));
      });

      test('returns null for valid CIN', () {
        final result = ExchekValidations.validateCIN('L12345MH2020PLC123456');
        expect(result, isNull);
      });
    });

    group('validateLLPIN', () {
      test('returns null when LLPIN is null and optional', () {
        final result = ExchekValidations.validateLLPIN(null, isOptional: true);
        expect(result, isNull);
      });

      test('returns error when LLPIN is null and required', () {
        final result = ExchekValidations.validateLLPIN(null, isOptional: false);
        expect(result, equals('Please enter a valid registration number'));
      });

      test('returns error for invalid LLPIN format', () {
        final result = ExchekValidations.validateLLPIN('INVALID');
        expect(result, equals('Please enter a valid registration number'));
      });

      test('returns null for valid LLPIN', () {
        final result = ExchekValidations.validateLLPIN('AAB1234');
        expect(result, isNull);
      });
    });

    group('validateWebsite', () {
      test('returns null when website is null and optional', () {
        final result = ExchekValidations.validateWebsite(
          null,
          isOptional: true,
        );
        expect(result, isNull);
      });

      test('returns error when website is null and required', () {
        final result = ExchekValidations.validateWebsite(
          null,
          isOptional: false,
        );
        expect(result, equals('Website URL is required'));
      });

      test('returns error for invalid website format', () {
        final result = ExchekValidations.validateWebsite('invalid-url');
        expect(result, equals('Please enter a valid website URL'));
      });

      test('returns null for valid website with https', () {
        final result = ExchekValidations.validateWebsite(
          'https://www.example.com',
        );
        expect(result, isNull);
      });

      test('returns null for valid website without protocol', () {
        final result = ExchekValidations.validateWebsite('www.example.com');
        expect(result, isNull);
      });
    });

    // =============================================================================
    // FILE VALIDATIONS TESTS
    // =============================================================================

    group('validateFileSize', () {
      test('returns error when file size is null', () {
        final result = ExchekValidations.validateFileSize(null);
        expect(result, equals('File size information not available'));
      });

      test('returns error when file size exceeds limit', () {
        final result = ExchekValidations.validateFileSize(
          3 * 1024 * 1024,
          maxSizeInMB: 2,
        ); // 3MB
        expect(result, equals('File size exceeds 2MB limit'));
      });

      test('returns null for valid file size', () {
        final result = ExchekValidations.validateFileSize(
          1 * 1024 * 1024,
          maxSizeInMB: 2,
        ); // 1MB
        expect(result, isNull);
      });
    });

    group('validateFileFormat', () {
      test('returns error when file name is null', () {
        final result = ExchekValidations.validateFileFormat(null, [
          'pdf',
          'png',
        ]);
        expect(result, equals('File name is required'));
      });

      test('returns error when file name is empty', () {
        final result = ExchekValidations.validateFileFormat('', ['pdf', 'png']);
        expect(result, equals('File name is required'));
      });

      test('returns error for invalid file format', () {
        final result = ExchekValidations.validateFileFormat('document.txt', [
          'pdf',
          'png',
        ]);
        expect(result, equals('Invalid file format. Allowed: pdf, png'));
      });

      test('returns null for valid file format', () {
        final result = ExchekValidations.validateFileFormat('document.pdf', [
          'pdf',
          'png',
        ]);
        expect(result, isNull);
      });

      test('handles case insensitive file extensions', () {
        final result = ExchekValidations.validateFileFormat('document.PDF', [
          'pdf',
          'png',
        ]);
        expect(result, isNull);
      });
    });

    // =============================================================================
    // ADDITIONAL VALIDATIONS TESTS (for 100% coverage)
    // =============================================================================

    group('validateEmailStrict', () {
      test('returns error when email is null', () {
        final result = ExchekValidations.validateEmailStrict(null);
        expect(result, equals('Email address is required'));
      });

      test('returns error when email is empty', () {
        final result = ExchekValidations.validateEmailStrict('');
        expect(result, equals('Email address is required'));
      });

      test('returns error for invalid email format', () {
        final result = ExchekValidations.validateEmailStrict('invalid-email');
        expect(result, equals('Please enter a valid email address'));
      });

      test('returns null for valid email', () {
        final result = ExchekValidations.validateEmailStrict(
          'test@example.com',
        );
        expect(result, isNull);
      });
    });

    group('validateUserIdStrict', () {
      test('returns error when user ID is null', () {
        final result = ExchekValidations.validateUserIdStrict(null);
        expect(result, equals('User ID is required'));
      });

      test('returns error when user ID is empty', () {
        final result = ExchekValidations.validateUserIdStrict('');
        expect(result, equals('User ID is required'));
      });

      test('returns error when user ID contains @ symbol', () {
        final result = ExchekValidations.validateUserIdStrict('user@123');
        expect(result, equals('User ID cannot contain @ symbol'));
      });

      test('returns null for valid user ID', () {
        final result = ExchekValidations.validateUserIdStrict('user123');
        expect(result, isNull);
      });
    });

    group('validateDocumentUpload', () {
      test('returns error when file name is null', () {
        final result = ExchekValidations.validateDocumentUpload(null, 1024);
        expect(result, equals('Please upload a document'));
      });

      test('returns error when file name is empty', () {
        final result = ExchekValidations.validateDocumentUpload('', 1024);
        expect(result, equals('Please upload a document'));
      });

      test('returns error when file size is null', () {
        final result = ExchekValidations.validateDocumentUpload(
          'document.pdf',
          null,
        );
        expect(result, equals('File size information not available'));
      });

      test('returns error when file size exceeds limit', () {
        final result = ExchekValidations.validateDocumentUpload(
          'document.pdf',
          3 * 1024 * 1024,
        ); // 3MB (limit is 2MB)
        expect(result, equals('File size exceeds 2MB limit'));
      });

      test('returns error for invalid file format', () {
        final result = ExchekValidations.validateDocumentUpload(
          'document.txt',
          1024,
        );
        expect(
          result,
          equals('Invalid file format. Allowed: pdf, jpeg, png'),
        );
      });

      test('returns null for valid document upload', () {
        final result = ExchekValidations.validateDocumentUpload(
          'document.pdf',
          1024,
        );
        expect(result, isNull);
      });
    });

    group('validateDropdownSelection', () {
      test('returns error when value is null', () {
        final result = ExchekValidations.validateDropdownSelection(null);
        expect(result, equals('Please select This field'));
      });

      test('returns error when value is empty', () {
        final result = ExchekValidations.validateDropdownSelection('');
        expect(result, equals('Please select This field'));
      });

      test('returns error when value is "Select"', () {
        final result = ExchekValidations.validateDropdownSelection('Select');
        expect(result, equals('Please select This field'));
      });

      test('returns null for valid selection', () {
        final result = ExchekValidations.validateDropdownSelection('Option 1');
        expect(result, isNull);
      });

      test('returns custom field name in error message', () {
        final result = ExchekValidations.validateDropdownSelection(
          null,
          fieldName: 'Country',
        );
        expect(result, equals('Please select Country'));
      });
    });

    group('validateCheckboxAgreement', () {
      test('returns error when checkbox is not checked', () {
        final result = ExchekValidations.validateCheckboxAgreement(false);
        expect(result, equals('Please agree to terms and conditions'));
      });

      test('returns error when checkbox is null', () {
        final result = ExchekValidations.validateCheckboxAgreement(null);
        expect(result, equals('Please agree to terms and conditions'));
      });

      test('returns null when checkbox is checked', () {
        final result = ExchekValidations.validateCheckboxAgreement(true);
        expect(result, isNull);
      });

      test('returns custom field name in error message', () {
        final result = ExchekValidations.validateCheckboxAgreement(
          false,
          fieldName: 'privacy policy',
        );
        expect(result, equals('Please agree to privacy policy'));
      });
    });

    group('validateAge', () {
      test('returns error when date of birth is null', () {
        final result = ExchekValidations.validateAge(null);
        expect(result, equals('Date of birth is required'));
      });

      test('returns error when age is less than 18', () {
        final dateOfBirth = DateTime.now().subtract(
          const Duration(days: 365 * 17),
        ); // 17 years old
        final result = ExchekValidations.validateAge(dateOfBirth);
        expect(result, equals('You must be at least 18 years old'));
      });

      test('returns null when age is 18 or older', () {
        final dateOfBirth = DateTime.now().subtract(
          const Duration(days: 365 * 20),
        ); // 20 years old
        final result = ExchekValidations.validateAge(dateOfBirth);
        expect(result, isNull);
      });
    });

    group('validateDate', () {
      test('returns error when date is null and required', () {
        final result = ExchekValidations.validateDate(null, isOptional: false);
        expect(result, equals('Date is required'));
      });

      test('returns null when date is null and optional', () {
        final result = ExchekValidations.validateDate(null, isOptional: true);
        expect(result, isNull);
      });

      test('returns error when date is empty', () {
        final result = ExchekValidations.validateDate('', isOptional: false);
        expect(result, equals('Date is required'));
      });

      test('returns error for invalid date format', () {
        final result = ExchekValidations.validateDate('invalid-date');
        expect(result, equals('Please use DD/MM/YYYY format'));
      });

      test('returns error for invalid date values', () {
        final result = ExchekValidations.validateDate('32/13/2023');
        expect(result, equals('Please enter a valid date'));
      });

      test('returns null for valid date format', () {
        final result = ExchekValidations.validateDate('15/06/1990');
        expect(result, isNull);
      });

      test('returns null for valid date with leading zeros', () {
        final result = ExchekValidations.validateDate('01/01/2000');
        expect(result, isNull);
      });
    });

    group('validateDrivingLicence', () {
      test('returns null when driving licence is null and optional', () {
        final result = ExchekValidations.validateDrivingLicence(
          null,
          isOptional: true,
        );
        expect(result, isNull);
      });

      test('returns error when driving licence is null and required', () {
        final result = ExchekValidations.validateDrivingLicence(
          null,
          isOptional: false,
        );
        expect(result, equals('Driving license number is required'));
      });

      test('returns error for invalid driving licence format', () {
        final result = ExchekValidations.validateDrivingLicence('INVALID123');
        expect(result, equals('Enter valid driving license number'));
      });

      test('returns null for valid driving licence format', () {
        final result = ExchekValidations.validateDrivingLicence(
          'MH1420110012345',
        );
        expect(result, isNull);
      });

      test('handles lowercase driving licence input', () {
        final result = ExchekValidations.validateDrivingLicence(
          'mh1420110012345',
        );
        expect(result, isNull);
      });
    });

    group('validateVoterId', () {
      test('returns error when voter ID is null', () {
        final result = ExchekValidations.validateVoterId(null);
        expect(result, equals('Voter id number is required'));
      });

      test('returns error when voter ID is empty', () {
        final result = ExchekValidations.validateVoterId('');
        expect(result, equals('Voter id number is required'));
      });

      test('returns error for invalid voter ID format', () {
        final result = ExchekValidations.validateVoterId('INVALID123');
        expect(result, equals('Invalid voter id number'));
      });

      test('returns null for valid voter ID format', () {
        final result = ExchekValidations.validateVoterId('ABC1234567');
        expect(result, isNull);
      });

      test('handles lowercase voter ID input', () {
        final result = ExchekValidations.validateVoterId('abc1234567');
        expect(result, isNull);
      });
    });

    group('validateIceCertificateNumber', () {
      test('returns error when ICE certificate number is null', () {
        final result = ExchekValidations.validateIceCertificateNumber(null);
        expect(result, equals('Please enter your IEC number.'));
      });

      test('returns error when ICE certificate number is empty', () {
        final result = ExchekValidations.validateIceCertificateNumber('');
        expect(result, equals('Please enter your IEC number.'));
      });

      test('returns error for invalid ICE certificate format', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          'INVALID',
        );
        expect(
          result,
          equals('Enter a valid IEC number (PAN format or numeric only)'),
        );
      });

      test('returns null for valid numeric IEC number (10 digits)', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          '1234567890',
        );
        expect(result, isNull);
      });

      test('returns null for valid PAN format IEC number', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          'ABCDE1234F',
        );
        expect(result, isNull);
      });
      test('returns null for another valid PAN with F as 4th character', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          'ABCFX5678K',
        );
        expect(result, isNull);
      });
      test('returns error for numeric but wrong length', () {
        final result = ExchekValidations.validateIceCertificateNumber('12345');
        expect(
          result,
          equals('Enter a valid IEC number (PAN format or numeric only)'),
        );
      });

      test('returns error for PAN with wrong structure', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          'ABC1234567',
        );
        // only 3 letters at start instead of 5
        expect(
          result,
          equals('Enter a valid IEC number (PAN format or numeric only)'),
        );
      });

      test('returns error for special characters', () {
        final result = ExchekValidations.validateIceCertificateNumber(
          'ABC!E1234F',
        );
        expect(
          result,
          equals('Enter a valid IEC number (PAN format or numeric only)'),
        );
      });
    });

    // =============================================================================
    // EDGE CASES AND ADDITIONAL COVERAGE TESTS
    // =============================================================================

    group('Edge Cases and Additional Coverage', () {
      test('validateMobileNumber with different country codes', () {
        final result = ExchekValidations.validateMobileNumber(
          '9876543210',
          countryCode: '+1',
        );
        expect(result, isNull);
      });

      test('validatePostalCode with different country', () {
        final result = ExchekValidations.validatePostalCode(
          '12345',
          country: 'USA',
        );
        expect(result, isNull);
      });

      test('validateFullName with single character after trimming', () {
        final result = ExchekValidations.validateFullName('  A  ');
        expect(result, equals('Please enter your full name'));
      });

      test('validateAadhaar with exactly 12 digits after cleaning', () {
        final result = ExchekValidations.validateAadhaar('1234-5678-9012');
        expect(result, isNull);
      });

      test('validatePAN with valid fourth character variations', () {
        // Test all valid fourth characters
        final validFourthChars = [
          'P',
          'C',
          'F',
          'H',
          'A',
          'B',
          'G',
          'J',
          'L',
          'T',
        ];
        for (final char in validFourthChars) {
          final result = ExchekValidations.validatePAN('ABC${char}E1234F');
          expect(result, isNull, reason: 'Failed for fourth character: $char');
        }
      });

      test('validateGST with valid state codes', () {
        // Test valid state codes (1-37)
        final result1 = ExchekValidations.validateGST('01ABCDE1234F1Z5');
        expect(result1, isNull);

        final result37 = ExchekValidations.validateGST('37ABCDE1234F1Z5');
        expect(result37, isNull);
      });

      test('validateGST with invalid state codes', () {
        final result0 = ExchekValidations.validateGST('00ABCDE1234F1Z5');
        expect(result0, equals('Invalid state code in GST number'));

        final result38 = ExchekValidations.validateGST('38ABCDE1234F1Z5');
        expect(result38, equals('Invalid state code in GST number'));
      });

      test('validateCIN with valid year range', () {
        final currentYear = DateTime.now().year;
        final result = ExchekValidations.validateCIN(
          'L12345MH${currentYear}PLC123456',
        );
        expect(result, isNull);
      });

      test('validateCIN with year boundary conditions', () {
        final result1850 = ExchekValidations.validateCIN(
          'L12345MH1850PLC123456',
        );
        expect(result1850, isNull);

        final result1849 = ExchekValidations.validateCIN(
          'L12345MH1849PLC123456',
        );
        expect(result1849, equals('Please enter a valid registration number'));
      });

      test('validateLLPIN with valid format', () {
        final result = ExchekValidations.validateLLPIN('AAB1234');
        expect(result, isNull);
      });

      test('validateWebsite with various valid formats', () {
        final validUrls = [
          'https://www.example.com',
          'http://example.com',
          'www.example.com',
          'example.com',
          'subdomain.example.com',
        ];

        for (final url in validUrls) {
          final result = ExchekValidations.validateWebsite(
            url,
            isOptional: false,
          );
          expect(result, isNull, reason: 'Failed for URL: $url');
        }
      });

      test('validateFileSize with exact boundary conditions', () {
        final result2MB = ExchekValidations.validateFileSize(
          2 * 1024 * 1024,
          maxSizeInMB: 2,
        );
        expect(result2MB, isNull);

        final resultOver2MB = ExchekValidations.validateFileSize(
          2 * 1024 * 1024 + 1,
          maxSizeInMB: 2,
        );
        expect(resultOver2MB, equals('File size exceeds 2MB limit'));
      });

       test('validateBankAccount with boundary lengths', () {
        final result9Digits = ExchekValidations.validateBankAccount(
          '123456789',
        );
        expect(result9Digits, isNull);

        final result18Digits = ExchekValidations.validateBankAccount(
          '123456789012345678',
        );
        expect(result18Digits, isNull);

        final result8Digits = ExchekValidations.validateBankAccount('12345678');
        expect(result8Digits, equals('Please enter a valid account number.'));

        final result19Digits = ExchekValidations.validateBankAccount(
          '1234567890123456789',
        );
        expect(result19Digits, isNull); // No maximum length limit
      });

      test('validateIFSC with valid format variations', () {
        final result = ExchekValidations.validateIFSC('HDFC0001234');
        expect(result, isNull);
      });

      test('validateAccountConfirmation with whitespace handling', () {
        final result = ExchekValidations.validateAccountConfirmation(
          '  123456789012  ',
          '  123456789012  ',
        );
        expect(result, isNull);
      });
    });

    group('validatePANByType', () {
      test('returns error when PAN is null', () {
        final result = ExchekValidations.validatePANByType(null, 'INDIVIDUAL');
        expect(result, equals('PAN number is required'));
      });

      test('returns error when PAN is empty', () {
        final result = ExchekValidations.validatePANByType('', 'INDIVIDUAL');
        expect(result, equals('PAN number is required'));
      });

      test('returns error for invalid PAN format', () {
        final result = ExchekValidations.validatePANByType(
          'INVALID123',
          'INDIVIDUAL',
        );
        expect(result, equals('Invalid PAN number'));
      });

      test('returns null for valid individual PAN', () {
        final result = ExchekValidations.validatePANByType(
          'ABCPP1234F',
          'INDIVIDUAL',
        );
        expect(result, isNull);
      });

      test('returns null for valid company PAN', () {
        final result = ExchekValidations.validatePANByType(
          'ABCPC1234F',
          'COMPANY',
        );
        expect(result, isNull);
      });

      test('handles lowercase PAN input', () {
        final result = ExchekValidations.validatePANByType(
          'abcpp1234f',
          'INDIVIDUAL',
        );
        expect(result, isNull);
      });
    });

    group('validateDirectorPANsAreDifferent', () {
      test('returns null when authorized director PAN is empty', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          '',
          'ABCPP1234F',
        );
        expect(result, isNull);
      });

      test('returns null when other director PAN is empty', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          'ABCPP1234F',
          '',
        );
        expect(result, isNull);
      });

      test('returns null when both PANs are empty', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          '',
          '',
        );
        expect(result, isNull);
      });

      test('returns null when PANs are different', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          'ABCPP1234F',
          'DEFPP5678G',
        );
        expect(result, isNull);
      });

      test('returns error when PANs are the same', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          'ABCPP1234F',
          'ABCPP1234F',
        );
        expect(
          result,
          equals(
            'PAN for Authorized Director and Other Director must be different',
          ),
        );
      });

      test('handles case insensitive comparison', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          'ABCPP1234F',
          'abcpp1234f',
        );
        expect(
          result,
          equals(
            'PAN for Authorized Director and Other Director must be different',
          ),
        );
      });

      test('handles whitespace', () {
        final result = ExchekValidations.validateDirectorPANsAreDifferent(
          'ABCPP1234F',
          ' ABCPP1234F ',
        );
        expect(
          result,
          equals(
            'PAN for Authorized Director and Other Director must be different',
          ),
        );
      });
    });

    group('validateDirectorAadhaarsAreDifferent', () {
      test('returns null when authorized director Aadhaar is empty', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '',
          '123456789012',
        );
        expect(result, isNull);
      });

      test('returns null when other director Aadhaar is empty', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '123456789012',
          '',
        );
        expect(result, isNull);
      });

      test('returns null when both Aadhaars are empty', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '',
          '',
        );
        expect(result, isNull);
      });

      test('returns null when Aadhaars are different', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '123456789012',
          '987654321098',
        );
        expect(result, isNull);
      });

      test('returns error when Aadhaars are the same', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '123456789012',
          '123456789012',
        );
        expect(
          result,
          equals(
            'Aadhaar for Authorized Director and Other Director must be different',
          ),
        );
      });

      test('handles formatted Aadhaar numbers', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '1234-5678-9012',
          '123456789012',
        );
        expect(
          result,
          equals(
            'Aadhaar for Authorized Director and Other Director must be different',
          ),
        );
      });

      test('handles whitespace in Aadhaar numbers', () {
        final result = ExchekValidations.validateDirectorAadhaarsAreDifferent(
          '123456789012',
          ' 123456789012 ',
        );
        expect(
          result,
          equals(
            'Aadhaar for Authorized Director and Other Director must be different',
          ),
        );
      });
    });
  });
}
