import 'package:exchek/models/auth_models/get_user_kyc_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetUserKycDetailsModel and nested models', () {
    test('fromJson parses full payload and toJson serializes all non-null fields', () {
      final json = {
        'success': true,
        'data': {
          'user_id': 'u1',
          'user_email': 'user@example.com',
          'user_type': 'business',
          'mobile_number': '1234567890',
          'multicurrency': [1, 'USD', null],
          'estimated_monthly_volume': '10000',
          'business_details': {
            'business_type': 'company',
            'business_nature': 'software',
            'exports_type': ['goods', 2, null],
            'business_legal_name': 'Exchek Inc',
          },
          'personal_details': {
            'payment_purpose': 'services',
            'profession': ['engineer', 3, null],
            'product_desc': 'desc',
            'legal_full_name': 'John Doe',
          },
          'user_identity_documents': {
            'document_type': 'Aadhaar',
            'document_number': '1234',
            'front_doc_url': 'front.png',
            'identity_verify_status': 'SUBMITTED',
          },
          'pan_details': {
            'document_type': 'Pan',
            'document_number': 'ABCDE1234F',
            'front_doc_url': 'pan.png',
            'name_on_pan': 'JOHN DOE',
            'pan_verify_status': 'SUBMITTED',
          },
          'karta_pan_details': {
            'document_type': 'Pan',
            'document_number': 'KARTA1234F',
            'front_doc_url': 'karta.png',
            'name_on_pan': 'KARTA DOE',
            'pan_verify_status': 'SUBMITTED',
          },
          'user_gst_details': {
            'gst_number': '27AAAAP0267H2ZN',
            'legal_name': 'Exchek Legal',
            'gst_certificate_url': 'gst.pdf',
            'estimated_annual_income': 'Less than ₹20 lakhs',
            'gst_verify_status': 'SUBMITTED',
          },
          'iec_details': {
            'document_type': 'IEC',
            'document_number': 'IEC123',
            'doc_url': 'iec.pdf',
            'iec_verify_status': 'SUBMITTED',
          },
          'user_address_documents': {
            'document_type': 'Address',
            'country': 'IN',
            'pincode': '400001',
            'state': 'MH',
            'city': 'Mumbai',
            'address_line1': 'Street 1',
            'front_doc_url': 'addr.png',
            'resident_verify_status': 'SUBMITTED',
          },
          'user_bank_details': {
            'document_type': 'Bank',
            'account_number': '123456',
            'ifsc_code': 'IFSC0001',
            'document_url': 'bank.pdf',
            'bank_verify_status': 'SUBMITTED',
            'account_holder_name': 'John Doe',
          },
          'business_identity': {
            'document_type': 'CIN',
            'document_number': 'CIN001',
            'front_doc_url': 'cin_front.pdf',
            'back_doc_url': 'cin_back.pdf',
          },
          'business_director_list': [
            {
              'director_type': 'AUTH_DIRECTOR',
              'document_type': 'Pan',
              'document_number': 'ABCDE1234F',
              'name_on_pan': 'John Director',
              'front_doc_url': 'front.png',
              'back_doc_url': 'back.png',
              'is_business_owner': true,
              'is_business_represtive': false,
              'verify_status': 'SUBMITTED',
            },
          ],
          'kyc_status_details': {
            'final_status': 'APPROVED',
            'final_status_comment': 'ok',
            'kyc_submitted_date': '2024-01-01',
            'kyc_updated_date': '2024-01-02',
            'kyc_status': 'COMPLETED',
          },
        },
      };

      final model = GetUserKycDetailsModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.data, isA<KycData>());
      final data = model.data!;

      // Mixed-type lists converted to strings with nulls as ''
      expect(data.multicurrency, ['1', 'USD', '']);
      expect(data.businessDetails!.exportsType, ['goods', '2', '']);
      expect(data.personalDetails!.profession, ['engineer', '3', '']);

      // Director list mapping including misspelled key
      expect(data.businessDirectorList, isNotNull);
      expect(data.businessDirectorList!.first.isBusinessRepresentative, isFalse);
      expect(data.businessDirectorList!.first.isBusinessOwner, isTrue);

      // Serialize back to JSON and verify presence of nested maps
      final out = model.toJson();
      expect(out['success'], isTrue);
      final outData = out['data'] as Map<String, dynamic>;
      expect(outData['user_id'], 'u1');
      expect(outData['business_details'], isA<Map<String, dynamic>>());
      expect(outData['personal_details'], isA<Map<String, dynamic>>());
      expect(outData['user_identity_documents'], isA<Map<String, dynamic>>());
      expect(outData['pan_details'], isA<Map<String, dynamic>>());
      expect(outData['karta_pan_details'], isA<Map<String, dynamic>>());
      expect(outData['user_gst_details'], isA<Map<String, dynamic>>());
      expect(outData['iec_details'], isA<Map<String, dynamic>>());
      expect(outData['user_address_documents'], isA<Map<String, dynamic>>());
      expect(outData['user_bank_details'], isA<Map<String, dynamic>>());
      expect(outData['business_identity'], isA<Map<String, dynamic>>());
      expect(outData['business_director_list'], isA<List>());
      expect(outData['kyc_status_details'], isA<Map<String, dynamic>>());
    });

    test('fromJson handles missing or non-list fields and toJson omits nulls', () {
      final json = {
        'success': false,
        'data': {
          'user_id': 'u2',
          // missing 'multicurrency' and 'business_director_list'
          'business_details': {
            'business_type': 'sole_proprietor',
            // non-list exports_type should become null
            'exports_type': 'not-a-list',
          },
          'personal_details': {
            'payment_purpose': 'goods',
            // non-list profession should become null
            'profession': 'dev',
          },
          // many nested fields omitted
        },
      };

      final model = GetUserKycDetailsModel.fromJson(json);
      expect(model.success, isFalse);
      final data = model.data!;
      expect(data.multicurrency, isNull);
      expect(data.businessDirectorList, isNull);
      expect(data.businessDetails!.exportsType, isNull);
      expect(data.personalDetails!.profession, isNull);

      final out = model.toJson();
      final outData = out['data'] as Map<String, dynamic>;
      // Only non-null nested objects are emitted
      expect(outData.containsKey('user_identity_documents'), isFalse);
      expect(outData.containsKey('pan_details'), isFalse);
      expect(outData.containsKey('karta_pan_details'), isFalse);
      expect(outData.containsKey('user_gst_details'), isFalse);
      expect(outData.containsKey('iec_details'), isFalse);
      expect(outData.containsKey('user_address_documents'), isFalse);
      expect(outData.containsKey('user_bank_details'), isFalse);
      expect(outData.containsKey('business_identity'), isFalse);
      expect(outData.containsKey('business_director_list'), isFalse);
      expect(outData.containsKey('kyc_status_details'), isFalse);
    });

    test('round-trip toJson/fromJson preserves values', () {
      final original = GetUserKycDetailsModel(
        success: true,
        data: KycData(
          userId: 'x',
          multicurrency: ['EUR', 'INR'],
          businessDetails: BusinessDetails(
            businessType: 'company',
            businessNature: 'it',
            exportsType: ['services'],
            businessLegalName: 'Exchek',
          ),
          panDetails: PanDetails(documentType: 'Pan', documentNumber: 'ABCDE1234F'),
          businessDirectorList: [
            BusinessDirectorList(directorType: 'AUTH_DIRECTOR', documentType: 'Pan', documentNumber: 'ABCDE1234F'),
          ],
        ),
      );

      final map = original.toJson();
      final copy = GetUserKycDetailsModel.fromJson(map);
      expect(copy.success, original.success);
      expect(copy.data!.userId, original.data!.userId);
      expect(copy.data!.multicurrency, original.data!.multicurrency);
      expect(copy.data!.businessDetails!.businessType, 'company');
      expect(copy.data!.panDetails!.documentNumber, 'ABCDE1234F');
      expect(copy.data!.businessDirectorList!.length, 1);
    });
  });
}

// import 'package:exchek/models/auth_models/get_user_kyc_detail_model.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('GetUserDetailModel', () {
//     test('constructor creates instance with required parameters', () {
//       final data = Data(
//         userId: 'user123',
//         userEmail: 'test@example.com',
//         userType: 'personal',
//         mobileNumber: '1234567890',
//         multicurrency: ['USD', 'EUR'],
//         estimatedMonthlyVolume: '10000',
//       );

//       final model = GetUserDetailModel(success: true, data: data);

//       expect(model.success, isTrue);
//       expect(model.data, equals(data));
//     });

//     test('fromJson creates instance from JSON with business details', () {
//       final json = {
//         'success': true,
//         'data': {
//           'business_details': {
//             'business_legal_name': 'Test Company Ltd',
//             'business_nature': 'Technology',
//             'business_type': 'Private Limited',
//             'exports_type': ['Services'],
//           },
//           'user_id': 'user123',
//           'user_email': 'business@example.com',
//           'user_type': 'business',
//           'mobile_number': '9876543210',
//           'multicurrency': ['USD', 'EUR', 'GBP'],
//           'estimated_monthly_volume': '50000',
//           'personal_details': null,
//         },
//       };

//       final model = GetUserDetailModel.fromJson(json);

//       expect(model.success, isTrue);
//       expect(model.data?.userId, equals('user123'));
//       expect(model.data?.userEmail, equals('business@example.com'));
//       expect(model.data?.userType, equals('business'));
//       expect(model.data?.mobileNumber, equals('9876543210'));
//       // expect(model.data.createdAt, equals(DateTime.parse('2023-01-01T00:00:00.000Z')));
//       // expect(model.data.updatedAt, equals(DateTime.parse('2023-01-02T00:00:00.000Z')));
//       expect(model.data?.multicurrency, equals(['USD', 'EUR', 'GBP']));
//       expect(model.data?.estimatedMonthlyVolume, equals('50000'));
//       expect(model.data?.businessDetails, isNotNull);
//       expect(model.data?.businessDetails!.businessLegalName, equals('Test Company Ltd'));
//       expect(model.data?.personalDetails, isNull);
//     });

//     test('fromJson creates instance from JSON with personal details', () {
//       final json = {
//         'success': false,
//         'data': {
//           'business_details': null,
//           'user_id': 'user456',
//           'user_email': 'personal@example.com',
//           'user_type': 'personal',
//           'mobile_number': '5555555555',
//           'multicurrency': ['INR'],
//           'estimated_monthly_volume': '5000',
//           'personal_details': {
//             'payment_purpose': 'Investment',
//             'profession': ['Software Engineer'],
//             'product_desc': 'Freelance Services',
//             'legal_full_name': 'John Doe',
//           },
//         },
//       };

//       final model = GetUserDetailModel.fromJson(json);

//       expect(model.success, isFalse);
//       expect(model.data?.userId, equals('user456'));
//       expect(model.data?.userEmail, equals('personal@example.com'));
//       expect(model.data?.userType, equals('personal'));
//       expect(model.data?.mobileNumber, equals('5555555555'));
//       expect(model.data?.multicurrency, equals(['INR']));
//       expect(model.data?.estimatedMonthlyVolume, equals('5000'));
//       expect(model.data?.businessDetails, isNull);
//       expect(model.data?.personalDetails, isNotNull);
//       expect(model.data?.personalDetails!.paymentPurpose, equals('Investment'));
//       expect(model.data?.personalDetails!.profession, equals(['Software Engineer']));
//     });

//     test('toJson converts instance to JSON with business details', () {
//       final businessDetails = BusinessDetails(
//         businessLegalName: 'ABC Corp',
//         businessNature: 'Manufacturing',
//         businessType: 'Corporation',
//         exportsType: ['Goods'],
//       );

//       final data = Data(
//         businessDetails: businessDetails,
//         userId: 'biz123',
//         userEmail: 'biz@example.com',
//         userType: 'business',
//         mobileNumber: '1111111111',
//         multicurrency: ['USD', 'CAD'],
//         estimatedMonthlyVolume: '75000',
//       );

//       final model = GetUserDetailModel(success: true, data: data);
//       final json = model.toJson();

//       expect(json['success'], isTrue);
//       expect(json['data']['user_id'], equals('biz123'));
//       expect(json['data']['user_email'], equals('biz@example.com'));
//       expect(json['data']['user_type'], equals('business'));
//       expect(json['data']['mobile_number'], equals('1111111111'));
//       expect(json['data']['multicurrency'], equals(['USD', 'CAD']));
//       expect(json['data']['estimated_monthly_volume'], equals('75000'));
//       expect(json['data']['business_details'], isNotNull);
//       expect(json['data']['business_details']['business_legal_name'], equals('ABC Corp'));
//       expect(json['data']['business_details']['exports_type'], equals(['Goods']));
//       expect(json['data'].containsKey('personal_details'), isFalse);
//     });

//     test('toJson converts instance to JSON with personal details', () {
//       final personalDetails = PersonalDetails(
//         paymentPurpose: 'Education',
//         profession: ['Teacher'],
//         productDesc: 'Online Courses',
//         legalFullName: 'Jane Smith',
//       );

//       final data = Data(
//         personalDetails: personalDetails,
//         userId: 'per789',
//         userEmail: 'jane@example.com',
//         userType: 'personal',
//         mobileNumber: '2222222222',
//         multicurrency: ['EUR', 'GBP'],
//         estimatedMonthlyVolume: '3000',
//       );

//       final model = GetUserDetailModel(success: false, data: data);
//       final json = model.toJson();

//       expect(json['success'], isFalse);
//       expect(json['data']['user_id'], equals('per789'));
//       expect(json['data']['user_email'], equals('jane@example.com'));
//       expect(json['data']['user_type'], equals('personal'));
//       expect(json['data']['mobile_number'], equals('2222222222'));
//       expect(json['data']['multicurrency'], equals(['EUR', 'GBP']));
//       expect(json['data']['estimated_monthly_volume'], equals('3000'));
//       expect(json['data']['personal_details'], isNotNull);
//       expect(json['data']['personal_details']['payment_purpose'], equals('Education'));
//       expect(json['data']['personal_details']['profession'], equals(['Teacher']));
//       expect(json['data']['personal_details']['legal_full_name'], equals('Jane Smith'));
//       expect(json['data'].containsKey('business_details'), isFalse);
//     });

//     test('toJson converts instance to JSON without optional details', () {
//       final data = Data(
//         userId: 'min123',
//         userEmail: 'minimal@example.com',
//         userType: 'basic',
//         mobileNumber: '3333333333',
//         multicurrency: ['USD'],
//         estimatedMonthlyVolume: '1000',
//       );

//       final model = GetUserDetailModel(success: true, data: data);
//       final json = model.toJson();

//       expect(json['success'], isTrue);
//       expect(json['data']['user_id'], equals('min123'));
//       expect(json['data'].containsKey('business_details'), isFalse);
//       expect(json['data'].containsKey('personal_details'), isFalse);
//     });
//   });

//   group('Data', () {
//     test('constructor creates instance with all parameters', () {
//       final businessDetails = BusinessDetails(
//         businessLegalName: 'Test Business',
//         businessNature: 'Service',
//         businessType: 'LLC',
//         exportsType: ['Digital'],
//       );

//       final personalDetails = PersonalDetails(
//         paymentPurpose: 'Business',
//         profession: ['Consultant'],
//         productDesc: 'Consulting Services',
//         legalFullName: 'Test User',
//       );

//       final data = Data(
//         businessDetails: businessDetails,
//         userId: 'test123',
//         userEmail: 'test@test.com',
//         userType: 'hybrid',
//         mobileNumber: '4444444444',
//         multicurrency: ['USD', 'EUR', 'GBP', 'INR'],
//         estimatedMonthlyVolume: '100000',
//         personalDetails: personalDetails,
//       );

//       expect(data.businessDetails, equals(businessDetails));
//       expect(data.userId, equals('test123'));
//       expect(data.userEmail, equals('test@test.com'));
//       expect(data.userType, equals('hybrid'));
//       expect(data.mobileNumber, equals('4444444444'));
//       expect(data.multicurrency, equals(['USD', 'EUR', 'GBP', 'INR']));
//       expect(data.estimatedMonthlyVolume, equals('100000'));
//       expect(data.personalDetails, equals(personalDetails));
//     });
//   });

//   group('BusinessDetails', () {
//     test('constructor creates instance with required parameters', () {
//       final businessDetails = BusinessDetails(
//         businessLegalName: 'XYZ Corporation',
//         businessNature: 'Technology Services',
//         businessType: 'Public Limited Company',
//         exportsType: ['Software Products'],
//       );

//       expect(businessDetails.businessLegalName, equals('XYZ Corporation'));
//       expect(businessDetails.businessNature, equals('Technology Services'));
//       expect(businessDetails.businessType, equals('Public Limited Company'));
//       expect(businessDetails.exportsType, equals(['Software Products']));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'business_legal_name': 'Tech Innovations Ltd',
//         'business_nature': 'Software Development',
//         'business_type': 'Private Limited',
//         'exports_type': ['IT Services'],
//       };

//       final businessDetails = BusinessDetails.fromJson(json);

//       expect(businessDetails.businessLegalName, equals('Tech Innovations Ltd'));
//       expect(businessDetails.businessNature, equals('Software Development'));
//       expect(businessDetails.businessType, equals('Private Limited'));
//       expect(businessDetails.exportsType, equals(['IT Services']));
//     });

//     test('toJson converts instance to JSON', () {
//       final businessDetails = BusinessDetails(
//         businessLegalName: 'Global Trade Co',
//         businessNature: 'Import Export',
//         businessType: 'Partnership',
//         exportsType: ['Physical Goods'],
//       );

//       final json = businessDetails.toJson();

//       expect(json['business_legal_name'], equals('Global Trade Co'));
//       expect(json['business_nature'], equals('Import Export'));
//       expect(json['business_type'], equals('Partnership'));
//       expect(json['exports_type'], equals(['Physical Goods']));
//     });
//   });

//   group('PersonalDetails', () {
//     test('constructor creates instance with required parameters', () {
//       final personalDetails = PersonalDetails(
//         paymentPurpose: 'Personal Investment',
//         profession: ['Doctor'],
//         productDesc: 'Medical Services',
//         legalFullName: 'Dr. Alice Johnson',
//       );

//       expect(personalDetails.paymentPurpose, equals('Personal Investment'));
//       expect(personalDetails.profession, equals(['Doctor']));
//       expect(personalDetails.productDesc, equals('Medical Services'));
//       expect(personalDetails.legalFullName, equals('Dr. Alice Johnson'));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'payment_purpose': 'Freelance Work',
//         'profession': ['Graphic Designer'],
//         'product_desc': 'Design Services',
//         'legal_full_name': 'Bob Wilson',
//       };

//       final personalDetails = PersonalDetails.fromJson(json);

//       expect(personalDetails.paymentPurpose, equals('Freelance Work'));
//       expect(personalDetails.profession, equals(['Graphic Designer']));
//       expect(personalDetails.productDesc, equals('Design Services'));
//       expect(personalDetails.legalFullName, equals('Bob Wilson'));
//     });

//     test('toJson converts instance to JSON', () {
//       final personalDetails = PersonalDetails(
//         paymentPurpose: 'Online Business',
//         profession: ['Content Creator'],
//         productDesc: 'Digital Content',
//         legalFullName: 'Charlie Brown',
//       );

//       final json = personalDetails.toJson();

//       expect(json['payment_purpose'], equals('Online Business'));
//       expect(json['profession'], equals(['Content Creator']));
//       expect(json['product_desc'], equals('Digital Content'));
//       expect(json['legal_full_name'], equals('Charlie Brown'));
//     });
//   });

//   group('UserIdentityDocuments', () {
//     test('constructor creates instance with all parameters', () {
//       final userIdentityDoc = UserIdentityDocuments(
//         documentType: 'PAN',
//         documentNumber: 'ABCDE1234F',
//         frontDocUrl: 'https://example.com/front.jpg',
//         backDocUrl: 'https://example.com/back.jpg',
//         kycRole: 'primary',
//         nameOnPan: 'John Doe',
//       );

//       expect(userIdentityDoc.documentType, equals('PAN'));
//       expect(userIdentityDoc.documentNumber, equals('ABCDE1234F'));
//       expect(userIdentityDoc.frontDocUrl, equals('https://example.com/front.jpg'));
//       expect(userIdentityDoc.backDocUrl, equals('https://example.com/back.jpg'));
//       expect(userIdentityDoc.kycRole, equals('primary'));
//       expect(userIdentityDoc.nameOnPan, equals('John Doe'));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'document_type': 'Aadhaar',
//         'document_number': '1234-5678-9012',
//         'front_doc_url': 'https://example.com/aadhaar_front.jpg',
//         'back_doc_url': 'https://example.com/aadhaar_back.jpg',
//         'kyc_role': 'secondary',
//         'name_on_pan': 'Jane Smith',
//       };

//       final userIdentityDoc = UserIdentityDocuments.fromJson(json);

//       expect(userIdentityDoc.documentType, equals('Aadhaar'));
//       expect(userIdentityDoc.documentNumber, equals('1234-5678-9012'));
//       expect(userIdentityDoc.frontDocUrl, equals('https://example.com/aadhaar_front.jpg'));
//       expect(userIdentityDoc.backDocUrl, equals('https://example.com/aadhaar_back.jpg'));
//       expect(userIdentityDoc.kycRole, equals('secondary'));
//       expect(userIdentityDoc.nameOnPan, equals('Jane Smith'));
//     });

//     test('toJson converts instance to JSON', () {
//       final userIdentityDoc = UserIdentityDocuments(
//         documentType: 'Passport',
//         documentNumber: 'A1234567',
//         frontDocUrl: 'https://example.com/passport.jpg',
//         backDocUrl: null,
//         kycRole: 'primary',
//         nameOnPan: 'Alice Johnson',
//       );

//       final json = userIdentityDoc.toJson();

//       expect(json['document_type'], equals('Passport'));
//       expect(json['document_number'], equals('A1234567'));
//       expect(json['front_doc_url'], equals('https://example.com/passport.jpg'));
//       expect(json['back_doc_url'], isNull);
//       expect(json['kyc_role'], equals('primary'));
//       expect(json['name_on_pan'], equals('Alice Johnson'));
//     });

//     test('fromJson handles null values', () {
//       final json = <String, dynamic>{
//         'document_type': null,
//         'document_number': null,
//         'front_doc_url': null,
//         'back_doc_url': null,
//         'kyc_role': null,
//         'name_on_pan': null,
//       };

//       final userIdentityDoc = UserIdentityDocuments.fromJson(json);

//       expect(userIdentityDoc.documentType, isNull);
//       expect(userIdentityDoc.documentNumber, isNull);
//       expect(userIdentityDoc.frontDocUrl, isNull);
//       expect(userIdentityDoc.backDocUrl, isNull);
//       expect(userIdentityDoc.kycRole, isNull);
//       expect(userIdentityDoc.nameOnPan, isNull);
//     });
//   });

//   group('UserAddressDocuments', () {
//     test('constructor creates instance with all parameters', () {
//       final userAddressDoc = UserAddressDocuments(
//         documentType: 'Utility Bill',
//         country: 'India',
//         pincode: '110001',
//         state: 'Delhi',
//         city: 'New Delhi',
//         addressLine1: '123 Main Street',
//         frontDocUrl: 'https://example.com/utility_bill.jpg',
//       );

//       expect(userAddressDoc.documentType, equals('Utility Bill'));
//       expect(userAddressDoc.country, equals('India'));
//       expect(userAddressDoc.pincode, equals('110001'));
//       expect(userAddressDoc.state, equals('Delhi'));
//       expect(userAddressDoc.city, equals('New Delhi'));
//       expect(userAddressDoc.addressLine1, equals('123 Main Street'));
//       expect(userAddressDoc.frontDocUrl, equals('https://example.com/utility_bill.jpg'));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'document_type': 'Bank Statement',
//         'country': 'USA',
//         'pincode': '10001',
//         'state': 'New York',
//         'city': 'New York City',
//         'address_line1': '456 Broadway',
//         'front_doc_url': 'https://example.com/bank_statement.pdf',
//       };

//       final userAddressDoc = UserAddressDocuments.fromJson(json);

//       expect(userAddressDoc.documentType, equals('Bank Statement'));
//       expect(userAddressDoc.country, equals('USA'));
//       expect(userAddressDoc.pincode, equals('10001'));
//       expect(userAddressDoc.state, equals('New York'));
//       expect(userAddressDoc.city, equals('New York City'));
//       expect(userAddressDoc.addressLine1, equals('456 Broadway'));
//       expect(userAddressDoc.frontDocUrl, equals('https://example.com/bank_statement.pdf'));
//     });

//     test('toJson converts instance to JSON', () {
//       final userAddressDoc = UserAddressDocuments(
//         documentType: 'Lease Agreement',
//         country: 'Canada',
//         pincode: 'M5V 3A8',
//         state: 'Ontario',
//         city: 'Toronto',
//         addressLine1: '789 Queen Street',
//         frontDocUrl: 'https://example.com/lease.pdf',
//       );

//       final json = userAddressDoc.toJson();

//       expect(json['document_type'], equals('Lease Agreement'));
//       expect(json['country'], equals('Canada'));
//       expect(json['pincode'], equals('M5V 3A8'));
//       expect(json['state'], equals('Ontario'));
//       expect(json['city'], equals('Toronto'));
//       expect(json['address_line1'], equals('789 Queen Street'));
//       expect(json['front_doc_url'], equals('https://example.com/lease.pdf'));
//     });

//     test('fromJson handles null values', () {
//       final json = <String, dynamic>{
//         'document_type': null,
//         'country': null,
//         'pincode': null,
//         'state': null,
//         'city': null,
//         'address_line1': null,
//         'front_doc_url': null,
//       };

//       final userAddressDoc = UserAddressDocuments.fromJson(json);

//       expect(userAddressDoc.documentType, isNull);
//       expect(userAddressDoc.country, isNull);
//       expect(userAddressDoc.pincode, isNull);
//       expect(userAddressDoc.state, isNull);
//       expect(userAddressDoc.city, isNull);
//       expect(userAddressDoc.addressLine1, isNull);
//       expect(userAddressDoc.frontDocUrl, isNull);
//     });
//   });

//   group('UserGstDetails', () {
//     test('constructor creates instance with all parameters', () {
//       final userGstDetails = UserGstDetails(
//         gstNumber: '27AAAAA0000A1Z5',
//         legalName: 'ABC Private Limited',
//         gstCertificateUrl: 'https://example.com/gst_certificate.pdf',
//         estimatedAnnualIncome: '5000000',
//       );

//       expect(userGstDetails.gstNumber, equals('27AAAAA0000A1Z5'));
//       expect(userGstDetails.legalName, equals('ABC Private Limited'));
//       expect(userGstDetails.gstCertificateUrl, equals('https://example.com/gst_certificate.pdf'));
//       expect(userGstDetails.estimatedAnnualIncome, equals('5000000'));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'gst_number': '29BBBBB1111B2Z6',
//         'legal_name': 'XYZ Corporation',
//         'gst_certificate_url': 'https://example.com/gst_cert.pdf',
//         'estimated_annual_income': '10000000',
//       };

//       final userGstDetails = UserGstDetails.fromJson(json);

//       expect(userGstDetails.gstNumber, equals('29BBBBB1111B2Z6'));
//       expect(userGstDetails.legalName, equals('XYZ Corporation'));
//       expect(userGstDetails.gstCertificateUrl, equals('https://example.com/gst_cert.pdf'));
//       expect(userGstDetails.estimatedAnnualIncome, equals('10000000'));
//     });

//     test('toJson converts instance to JSON', () {
//       final userGstDetails = UserGstDetails(
//         gstNumber: '07CCCCC2222C3Z7',
//         legalName: 'Tech Solutions Ltd',
//         gstCertificateUrl: 'https://example.com/tech_gst.pdf',
//         estimatedAnnualIncome: '7500000',
//       );

//       final json = userGstDetails.toJson();

//       expect(json['gst_number'], equals('07CCCCC2222C3Z7'));
//       expect(json['legal_name'], equals('Tech Solutions Ltd'));
//       expect(json['gst_certificate_url'], equals('https://example.com/tech_gst.pdf'));
//       expect(json['estimated_annual_income'], equals('7500000'));
//     });

//     test('fromJson handles null values', () {
//       final json = <String, dynamic>{
//         'gst_number': null,
//         'legal_name': null,
//         'gst_certificate_url': null,
//         'estimated_annual_income': null,
//       };

//       final userGstDetails = UserGstDetails.fromJson(json);

//       expect(userGstDetails.gstNumber, isNull);
//       expect(userGstDetails.legalName, isNull);
//       expect(userGstDetails.gstCertificateUrl, isNull);
//       expect(userGstDetails.estimatedAnnualIncome, isNull);
//     });
//   });

//   group('UserBusinessLegalDocuments', () {
//     test('constructor creates instance with all parameters', () {
//       final userBusinessLegalDoc = UserBusinessLegalDocuments(
//         documentType: 'Certificate of Incorporation',
//         documentNumber: 'COI123456',
//         docUrl: 'https://example.com/incorporation_cert.pdf',
//       );

//       expect(userBusinessLegalDoc.documentType, equals('Certificate of Incorporation'));
//       expect(userBusinessLegalDoc.documentNumber, equals('COI123456'));
//       expect(userBusinessLegalDoc.docUrl, equals('https://example.com/incorporation_cert.pdf'));
//     });

//     test('fromJson creates instance from JSON', () {
//       final json = {
//         'document_type': 'Partnership Deed',
//         'document_number': 'PD789012',
//         'doc_url': 'https://example.com/partnership_deed.pdf',
//       };

//       final userBusinessLegalDoc = UserBusinessLegalDocuments.fromJson(json);

//       expect(userBusinessLegalDoc.documentType, equals('Partnership Deed'));
//       expect(userBusinessLegalDoc.documentNumber, equals('PD789012'));
//       expect(userBusinessLegalDoc.docUrl, equals('https://example.com/partnership_deed.pdf'));
//     });

//     test('toJson converts instance to JSON', () {
//       final userBusinessLegalDoc = UserBusinessLegalDocuments(
//         documentType: 'MOA',
//         documentNumber: 'MOA345678',
//         docUrl: 'https://example.com/moa.pdf',
//       );

//       final json = userBusinessLegalDoc.toJson();

//       expect(json['document_type'], equals('MOA'));
//       expect(json['document_number'], equals('MOA345678'));
//       expect(json['doc_url'], equals('https://example.com/moa.pdf'));
//     });

//     test('fromJson handles null values', () {
//       final json = <String, dynamic>{'document_type': null, 'document_number': null, 'doc_url': null};

//       final userBusinessLegalDoc = UserBusinessLegalDocuments.fromJson(json);

//       expect(userBusinessLegalDoc.documentType, isNull);
//       expect(userBusinessLegalDoc.documentNumber, isNull);
//       expect(userBusinessLegalDoc.docUrl, isNull);
//     });
//   });

//   group('Complex Integration Tests', () {
//     test('Data.fromJson handles complete JSON with all nested objects and lists', () {
//       final json = {
//         'user_id': 'complex123',
//         'user_email': 'complex@example.com',
//         'user_type': 'business',
//         'mobile_number': '9999999999',
//         'multicurrency': ['USD', 'EUR', 'GBP', 'INR'],
//         'estimated_monthly_volume': '1000000',
//         'business_details': {
//           'business_type': 'Corporation',
//           'business_nature': 'Technology',
//           'exports_type': ['Software', 'Services'],
//           'business_legal_name': 'Tech Corp Ltd',
//         },
//         'personal_details': {
//           'legal_full_name': 'John Tech',
//           'payment_purpose': 'Business Operations',
//           'product_desc': 'Software Solutions',
//           'profession': ['CEO', 'Developer'],
//         },
//         'user_identity_documents': [
//           {
//             'document_type': 'PAN',
//             'document_number': 'ABCDE1234F',
//             'front_doc_url': 'https://example.com/pan_front.jpg',
//             'back_doc_url': 'https://example.com/pan_back.jpg',
//             'kyc_role': 'primary',
//             'name_on_pan': 'John Tech',
//           },
//           {
//             'document_type': 'Aadhaar',
//             'document_number': '1234-5678-9012',
//             'front_doc_url': 'https://example.com/aadhaar_front.jpg',
//             'back_doc_url': 'https://example.com/aadhaar_back.jpg',
//             'kyc_role': 'secondary',
//             'name_on_pan': 'John Tech',
//           },
//         ],
//         'user_address_documents': {
//           'document_type': 'Utility Bill',
//           'country': 'India',
//           'pincode': '110001',
//           'state': 'Delhi',
//           'city': 'New Delhi',
//           'address_line1': '123 Tech Street',
//           'front_doc_url': 'https://example.com/utility.jpg',
//         },
//         'user_gst_details': {
//           'gst_number': '07ABCDE1234F1Z5',
//           'legal_name': 'Tech Corp Ltd',
//           'gst_certificate_url': 'https://example.com/gst.pdf',
//           'estimated_annual_income': '12000000',
//         },
//         'user_business_legal_documents': [
//           {
//             'document_type': 'Certificate of Incorporation',
//             'document_number': 'COI123456',
//             'doc_url': 'https://example.com/coi.pdf',
//           },
//           {'document_type': 'MOA', 'document_number': 'MOA789012', 'doc_url': 'https://example.com/moa.pdf'},
//         ],
//       };

//       final data = Data.fromJson(json);

//       // Basic fields
//       expect(data.userId, equals('complex123'));
//       expect(data.userEmail, equals('complex@example.com'));
//       expect(data.userType, equals('business'));
//       expect(data.mobileNumber, equals('9999999999'));
//       expect(data.multicurrency, equals(['USD', 'EUR', 'GBP', 'INR']));
//       expect(data.estimatedMonthlyVolume, equals('1000000'));

//       // Business details
//       expect(data.businessDetails, isNotNull);
//       expect(data.businessDetails!.businessType, equals('Corporation'));
//       expect(data.businessDetails!.exportsType, equals(['Software', 'Services']));

//       // Personal details
//       expect(data.personalDetails, isNotNull);
//       expect(data.personalDetails!.legalFullName, equals('John Tech'));
//       expect(data.personalDetails!.profession, equals(['CEO', 'Developer']));

//       // Identity documents list
//       expect(data.userIdentityDocuments, isNotNull);
//       expect(data.userIdentityDocuments!.length, equals(2));
//       expect(data.userIdentityDocuments![0].documentType, equals('PAN'));
//       expect(data.userIdentityDocuments![1].documentType, equals('Aadhaar'));

//       // Address documents
//       expect(data.userAddressDocuments, isNotNull);
//       expect(data.userAddressDocuments!.country, equals('India'));

//       // GST details
//       expect(data.userGstDetails, isNotNull);
//       expect(data.userGstDetails!.gstNumber, equals('07ABCDE1234F1Z5'));

//       // Business legal documents list
//       expect(data.userBusinessLegalDocuments, isNotNull);
//       expect(data.userBusinessLegalDocuments!.length, equals(2));
//       expect(data.userBusinessLegalDocuments![0].documentType, equals('Certificate of Incorporation'));
//       expect(data.userBusinessLegalDocuments![1].documentType, equals('MOA'));
//     });

//     test('Data.toJson converts complete instance with all nested objects to JSON', () {
//       final businessDetails = BusinessDetails(
//         businessType: 'LLC',
//         businessNature: 'Consulting',
//         exportsType: ['Services', 'Digital Products'],
//         businessLegalName: 'Consulting LLC',
//       );

//       final personalDetails = PersonalDetails(
//         legalFullName: 'Jane Consultant',
//         paymentPurpose: 'Consulting Services',
//         productDesc: 'Business Consulting',
//         profession: ['Consultant', 'Advisor'],
//       );

//       final identityDoc1 = UserIdentityDocuments(
//         documentType: 'Passport',
//         documentNumber: 'P1234567',
//         frontDocUrl: 'https://example.com/passport.jpg',
//         kycRole: 'primary',
//         nameOnPan: 'Jane Consultant',
//       );

//       final identityDoc2 = UserIdentityDocuments(
//         documentType: 'Driver License',
//         documentNumber: 'DL987654',
//         frontDocUrl: 'https://example.com/dl_front.jpg',
//         backDocUrl: 'https://example.com/dl_back.jpg',
//         kycRole: 'secondary',
//         nameOnPan: 'Jane Consultant',
//       );

//       final addressDoc = UserAddressDocuments(
//         documentType: 'Bank Statement',
//         country: 'USA',
//         pincode: '10001',
//         state: 'New York',
//         city: 'NYC',
//         addressLine1: '456 Consulting Ave',
//         frontDocUrl: 'https://example.com/bank_stmt.pdf',
//       );

//       final gstDetails = UserGstDetails(
//         gstNumber: '36ABCDE5678G1Z9',
//         legalName: 'Consulting LLC',
//         gstCertificateUrl: 'https://example.com/gst_cert.pdf',
//         estimatedAnnualIncome: '8000000',
//       );

//       final legalDoc1 = UserBusinessLegalDocuments(
//         documentType: 'LLC Agreement',
//         documentNumber: 'LLC123',
//         docUrl: 'https://example.com/llc_agreement.pdf',
//       );

//       final legalDoc2 = UserBusinessLegalDocuments(
//         documentType: 'Operating Agreement',
//         documentNumber: 'OA456',
//         docUrl: 'https://example.com/operating_agreement.pdf',
//       );

//       final data = Data(
//         userId: 'complete456',
//         userEmail: 'complete@example.com',
//         userType: 'business',
//         mobileNumber: '8888888888',
//         multicurrency: ['USD', 'CAD'],
//         estimatedMonthlyVolume: '500000',
//         businessDetails: businessDetails,
//         personalDetails: personalDetails,
//         userIdentityDocuments: [identityDoc1, identityDoc2],
//         userAddressDocuments: addressDoc,
//         userGstDetails: gstDetails,
//         userBusinessLegalDocuments: [legalDoc1, legalDoc2],
//       );

//       final json = data.toJson();

//       // Verify all fields are present and correct
//       expect(json['user_id'], equals('complete456'));
//       expect(json['user_email'], equals('complete@example.com'));
//       expect(json['multicurrency'], equals(['USD', 'CAD']));
//       expect(json['business_details']['business_type'], equals('LLC'));
//       expect(json['personal_details']['legal_full_name'], equals('Jane Consultant'));
//       expect(json['user_identity_documents'].length, equals(2));
//       expect(json['user_identity_documents'][0]['document_type'], equals('Passport'));
//       expect(json['user_address_documents']['country'], equals('USA'));
//       expect(json['user_gst_details']['gst_number'], equals('36ABCDE5678G1Z9'));
//       expect(json['user_business_legal_documents'].length, equals(2));
//       expect(json['user_business_legal_documents'][0]['document_type'], equals('LLC Agreement'));
//     });
//   });

//   group('Edge Cases and Error Handling', () {
//     test('GetUserDetailModel.fromJson handles null data', () {
//       final json = {'success': true, 'data': null};

//       final model = GetUserDetailModel.fromJson(json);

//       expect(model.success, isTrue);
//       expect(model.data, isNull);
//     });

//     test('GetUserDetailModel.toJson handles null data', () {
//       final model = GetUserDetailModel(success: false, data: null);
//       final json = model.toJson();

//       expect(json['success'], isFalse);
//       expect(json.containsKey('data'), isFalse);
//     });

//     test('Data.fromJson handles null and empty lists correctly', () {
//       final json = {
//         'user_id': 'edge123',
//         'user_email': 'edge@example.com',
//         'user_type': 'test',
//         'mobile_number': '1111111111',
//         'multicurrency': null,
//         'estimated_monthly_volume': '1000',
//         'user_identity_documents': null,
//         'user_business_legal_documents': null,
//       };

//       final data = Data.fromJson(json);

//       expect(data.multicurrency, isNull);
//       expect(data.userIdentityDocuments, isNull);
//       expect(data.userBusinessLegalDocuments, isNull);
//     });

//     test('Data.fromJson handles empty lists correctly', () {
//       final json = {
//         'user_id': 'empty123',
//         'user_email': 'empty@example.com',
//         'user_type': 'test',
//         'mobile_number': '2222222222',
//         'multicurrency': [],
//         'estimated_monthly_volume': '2000',
//         'user_identity_documents': [],
//         'user_business_legal_documents': [],
//       };

//       final data = Data.fromJson(json);

//       expect(data.multicurrency, equals([]));
//       expect(data.userIdentityDocuments, equals([]));
//       expect(data.userBusinessLegalDocuments, equals([]));
//     });

//     test('Data.fromJson handles non-list values for list fields', () {
//       final json = {
//         'user_id': 'nonlist123',
//         'user_email': 'nonlist@example.com',
//         'user_type': 'test',
//         'mobile_number': '3333333333',
//         'multicurrency': 'not_a_list',
//         'estimated_monthly_volume': '3000',
//       };

//       final data = Data.fromJson(json);

//       expect(data.multicurrency, isNull);
//     });

//     test('BusinessDetails.fromJson handles non-list exports_type', () {
//       final json = {
//         'business_type': 'Test',
//         'business_nature': 'Testing',
//         'exports_type': 'not_a_list',
//         'business_legal_name': 'Test Corp',
//       };

//       final businessDetails = BusinessDetails.fromJson(json);

//       expect(businessDetails.exportsType, isNull);
//     });

//     test('PersonalDetails.fromJson handles non-list profession', () {
//       final json = {
//         'legal_full_name': 'Test User',
//         'payment_purpose': 'Testing',
//         'product_desc': 'Test Product',
//         'profession': 'not_a_list',
//       };

//       final personalDetails = PersonalDetails.fromJson(json);

//       expect(personalDetails.profession, isNull);
//     });

//     test('Data.fromJson handles list with null elements correctly', () {
//       final json = {
//         'user_id': 'nullelem123',
//         'user_email': 'nullelem@example.com',
//         'user_type': 'test',
//         'mobile_number': '4444444444',
//         'multicurrency': ['USD', null, 'EUR', null],
//         'estimated_monthly_volume': '4000',
//       };

//       final data = Data.fromJson(json);

//       expect(data.multicurrency, equals(['USD', '', 'EUR', '']));
//     });

//     test('BusinessDetails.fromJson handles list with null elements', () {
//       final json = {
//         'business_type': 'Test',
//         'business_nature': 'Testing',
//         'exports_type': ['Service', null, 'Product'],
//         'business_legal_name': 'Test Corp',
//       };

//       final businessDetails = BusinessDetails.fromJson(json);

//       expect(businessDetails.exportsType, equals(['Service', '', 'Product']));
//     });

//     test('PersonalDetails.fromJson handles list with null elements', () {
//       final json = {
//         'legal_full_name': 'Test User',
//         'payment_purpose': 'Testing',
//         'product_desc': 'Test Product',
//         'profession': ['Engineer', null, 'Developer'],
//       };

//       final personalDetails = PersonalDetails.fromJson(json);

//       expect(personalDetails.profession, equals(['Engineer', '', 'Developer']));
//     });

//     test('Data.toJson handles null lists correctly', () {
//       final data = Data(
//         userId: 'nulllists123',
//         userEmail: 'nulllists@example.com',
//         userType: 'test',
//         mobileNumber: '5555555555',
//         multicurrency: null,
//         estimatedMonthlyVolume: '5000',
//         userIdentityDocuments: null,
//         userBusinessLegalDocuments: null,
//       );

//       final json = data.toJson();

//       expect(json['multicurrency'], isNull);
//       expect(json.containsKey('user_identity_documents'), isFalse);
//       expect(json.containsKey('user_business_legal_documents'), isFalse);
//     });

//     test('Data.toJson handles empty lists correctly', () {
//       final data = Data(
//         userId: 'emptylists123',
//         userEmail: 'emptylists@example.com',
//         userType: 'test',
//         mobileNumber: '6666666666',
//         multicurrency: [],
//         estimatedMonthlyVolume: '6000',
//         userIdentityDocuments: [],
//         userBusinessLegalDocuments: [],
//       );

//       final json = data.toJson();

//       expect(json['multicurrency'], equals([]));
//       expect(json['user_identity_documents'], equals([]));
//       expect(json['user_business_legal_documents'], equals([]));
//     });
//   });
// }
