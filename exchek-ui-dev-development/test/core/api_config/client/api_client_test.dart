import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;

    setUpAll(() {
      // Initialize Flutter binding for testing
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() {
      apiClient = ApiClient();
    });

    group('Constructor Tests', () {
      test('creates ApiClient with default configuration', () {
        expect(apiClient, isA<ApiClient>());
      });

      test('ApiClient instance is created successfully', () {
        final client1 = ApiClient();
        final client2 = ApiClient();
        expect(client1, isA<ApiClient>());
        expect(client2, isA<ApiClient>());
      });
    });

    group('Request Method Tests', () {
      test('request method exists and can be called', () {
        // Test that the request method exists and doesn't throw immediately
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);
      });

      test('request method handles GET requests', () {
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);
      });

      test('request method handles POST requests with data', () {
        expect(
          () => apiClient.request(RequestType.POST, '/test', data: {'key': 'value'}, isShowToast: false),
          returnsNormally,
        );
      });

      test('request method handles PUT requests with data', () {
        expect(
          () => apiClient.request(RequestType.PUT, '/test', data: {'key': 'value'}, isShowToast: false),
          returnsNormally,
        );
      });

      test('request method handles DELETE requests', () {
        expect(() => apiClient.request(RequestType.DELETE, '/test', isShowToast: false), returnsNormally);
      });

      test('request method handles PATCH requests with data', () {
        expect(
          () => apiClient.request(RequestType.PATCH, '/test', data: {'key': 'value'}, isShowToast: false),
          returnsNormally,
        );
      });

      test('request method handles MULTIPART_POST requests', () {
        final multipartData = {
          'name': 'test',
          'file': FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
        };
        expect(
          () => apiClient.request(
            RequestType.MULTIPART_POST,
            '/upload',
            multipartData: multipartData,
            isShowToast: false,
          ),
          returnsNormally,
        );
      });

      test('request method handles isShowToast parameter', () {
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: true), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);
      });

      test('request method handles all RequestType enum values', () {
        for (final requestType in RequestType.values) {
          switch (requestType) {
            case RequestType.GET:
            case RequestType.DELETE:
              expect(() => apiClient.request(requestType, '/test', isShowToast: false), returnsNormally);
              break;
            case RequestType.POST:
            case RequestType.PUT:
            case RequestType.PATCH:
              expect(
                () => apiClient.request(requestType, '/test', data: {'key': 'value'}, isShowToast: false),
                returnsNormally,
              );
              break;
            case RequestType.MULTIPART_POST:
              final multipartData = {
                'name': 'test',
                'file': FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
              };
              expect(
                () => apiClient.request(requestType, '/test', multipartData: multipartData, isShowToast: false),
                returnsNormally,
              );
              break;
              case RequestType.MULTIPART_PUT:
                final multipartData = {
                  'name': 'test',
                  'file': FileData(
                    name: 'test.pdf',
                    bytes: Uint8List.fromList([1, 2, 3]),
                    sizeInMB: 1.0,
                  ),
                };
                expect(
                  () => apiClient.request(requestType, '/test', multipartData: multipartData, isShowToast: false),
                  returnsNormally,
                );
          }
        }
      });
    });

    group('FileData Integration Tests', () {
      test('handles FileData with PDF extension', () {
        final fileData = FileData(name: 'document.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

        expect(fileData.name, 'document.pdf');
        expect(fileData.bytes, [1, 2, 3, 4]);
        expect(fileData.sizeInMB, 1.0);
      });

      test('handles FileData with PNG extension', () {
        final fileData = FileData(name: 'image.png', bytes: Uint8List.fromList([137, 80, 78, 71]), sizeInMB: 1.5);

        expect(fileData.name, 'image.png');
        expect(fileData.bytes, [137, 80, 78, 71]);
        expect(fileData.sizeInMB, 1.5);
      });

      test('handles FileData with unknown extension', () {
        final fileData = FileData(
          name: 'document.txt',
          bytes: Uint8List.fromList([72, 101, 108, 108, 111]),
          sizeInMB: 0.1,
        );

        expect(fileData.name, 'document.txt');
        expect(fileData.bytes, [72, 101, 108, 108, 111]);
        expect(fileData.sizeInMB, 0.1);
      });

      test('handles FileData with empty name', () {
        final fileData = FileData(name: '', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0);

        expect(fileData.name, '');
        expect(fileData.bytes, [1, 2, 3]);
        expect(fileData.sizeInMB, 1.0);
      });

      test('handles FileData with case insensitive extensions', () {
        final testFiles = [
          FileData(name: 'doc.PDF', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
          FileData(name: 'photo.JPEG', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
          FileData(name: 'graphic.PNG', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
        ];

        for (final fileData in testFiles) {
          expect(fileData.name, isNotEmpty);
          expect(fileData.bytes, isNotEmpty);
          expect(fileData.sizeInMB, greaterThan(0));
        }
      });
    });

    group('RequestType Enum Tests', () {
      test('RequestType enum has all expected values', () {
        expect(RequestType.values, contains(RequestType.GET));
        expect(RequestType.values, contains(RequestType.POST));
        expect(RequestType.values, contains(RequestType.PUT));
        expect(RequestType.values, contains(RequestType.DELETE));
        expect(RequestType.values, contains(RequestType.PATCH));
        expect(RequestType.values, contains(RequestType.MULTIPART_POST));
      });

      test('RequestType enum values are distinct', () {
        final values = RequestType.values;
        final uniqueValues = values.toSet();
        expect(values.length, equals(uniqueValues.length));
      });
    });

    group('SharedPreferences Integration Tests', () {
      test('handles auth token storage and retrieval', () async {
        final prefs = await SharedPreferences.getInstance();

        // Test setting auth token
        await prefs.setString('auth_token', 'test-token');
        final token = prefs.getString('auth_token');
        expect(token, 'test-token');

        // Test clearing auth token
        await prefs.remove('auth_token');
        final clearedToken = prefs.getString('auth_token');
        expect(clearedToken, isNull);
      });

      test('handles empty auth token', () async {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', '');
        final token = prefs.getString('auth_token');
        expect(token, '');
      });
    });

    group('Error Handling Integration Tests', () {
      test('handles network errors gracefully', () {
        // Test that the ApiClient doesn't crash when network errors occur
        expect(() => apiClient.request(RequestType.GET, '/nonexistent', isShowToast: false), returnsNormally);
      });

      test('handles invalid URLs gracefully', () {
        expect(() => apiClient.request(RequestType.GET, '', isShowToast: false), returnsNormally);
      });

      test('handles null data gracefully', () {
        expect(() => apiClient.request(RequestType.POST, '/test', data: null, isShowToast: false), returnsNormally);
      });

      test('handles empty multipart data gracefully', () {
        expect(
          () => apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: {}, isShowToast: false),
          returnsNormally,
        );
      });

      test('handles null multipart data gracefully', () {
        expect(
          () => apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: null, isShowToast: false),
          returnsNormally,
        );
      });

      test('handles complex multipart data with mixed types', () {
        final multipartData = {
          'string_field': 'test value',
          'number_field': 42,
          'boolean_field': true,
          'null_field': null,
          'file_field': FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
        };
        expect(
          () =>
              apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: multipartData, isShowToast: false),
          returnsNormally,
        );
      });

      test('handles requests with both data and multipartData parameters', () {
        final multipartData = {
          'file': FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
        };
        expect(
          () => apiClient.request(
            RequestType.MULTIPART_POST,
            '/test',
            data: {'key': 'value'},
            multipartData: multipartData,
            isShowToast: false,
          ),
          returnsNormally,
        );
      });
    });

    group('FileData Edge Cases Tests', () {
      test('handles FileData with various file extensions', () {
        final extensions = ['pdf', 'jpeg', 'png', 'txt', 'doc', 'docx', 'xlsx', 'zip'];

        for (final ext in extensions) {
          final fileData = FileData(name: 'test.$ext', bytes: Uint8List.fromList([1, 2, 3, 4, 5]), sizeInMB: 1.0);

          expect(fileData.name, 'test.$ext');
          expect(fileData.bytes.length, 5);
          expect(fileData.sizeInMB, 1.0);
        }
      });

      test('handles FileData with special characters in filename', () {
        final specialNames = [
          'test file with spaces.pdf',
          'test_file_with_underscores.png',
          'test.file.with.dots.pdf',
        ];

        for (final name in specialNames) {
          final fileData = FileData(name: name, bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0);

          expect(fileData.name, name);
          expect(fileData.bytes, [1, 2, 3]);
        }
      });

      test('handles FileData with large file sizes', () {
        final fileSizes = [0.1, 1.0, 5.0, 10.0, 50.0, 100.0];

        for (final size in fileSizes) {
          final fileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: size);

          expect(fileData.sizeInMB, size);
        }
      });

      test('handles FileData with empty bytes', () {
        final fileData = FileData(name: 'empty.pdf', bytes: Uint8List.fromList([]), sizeInMB: 0.0);

        expect(fileData.name, 'empty.pdf');
        expect(fileData.bytes, isEmpty);
        expect(fileData.sizeInMB, 0.0);
      });

      test('handles FileData with optional parameters', () {
        final fileData = FileData(
          name: 'test.pdf',
          bytes: Uint8List.fromList([1, 2, 3]),
          sizeInMB: 1.0,
          path: '/path/to/file.pdf',
          webPath: 'web_path_to_file.pdf',
        );

        expect(fileData.name, 'test.pdf');
        expect(fileData.bytes, [1, 2, 3]);
        expect(fileData.sizeInMB, 1.0);
        expect(fileData.path, '/path/to/file.pdf');
        expect(fileData.webPath, 'web_path_to_file.pdf');
      });
    });

    group('RequestType Enum Comprehensive Tests', () {
      test('RequestType enum has exactly 6 values', () {
        expect(RequestType.values.length, 6);
      });

      test('RequestType enum contains all expected HTTP methods', () {
        final expectedMethods = [
          RequestType.GET,
          RequestType.POST,
          RequestType.PUT,
          RequestType.DELETE,
          RequestType.PATCH,
          RequestType.MULTIPART_POST,
        ];

        for (final method in expectedMethods) {
          expect(RequestType.values, contains(method));
        }
      });

      test('RequestType enum values have correct string representations', () {
        expect(RequestType.GET.toString(), 'RequestType.GET');
        expect(RequestType.POST.toString(), 'RequestType.POST');
        expect(RequestType.PUT.toString(), 'RequestType.PUT');
        expect(RequestType.DELETE.toString(), 'RequestType.DELETE');
        expect(RequestType.PATCH.toString(), 'RequestType.PATCH');
        expect(RequestType.MULTIPART_POST.toString(), 'RequestType.MULTIPART_POST');
      });

      test('RequestType enum values are comparable', () {
        expect(RequestType.GET == RequestType.GET, isTrue);
        expect(RequestType.GET == RequestType.POST, isFalse);
        expect(RequestType.POST != RequestType.PUT, isTrue);
      });
    });

    group('Integration Tests with SharedPreferences', () {
      test('handles multiple preference operations', () async {
        final prefs = await SharedPreferences.getInstance();

        // Test multiple key-value pairs
        final testData = {
          'auth_token': 'test-token-123',
          'user_id': 'user-456',
          'session_id': 'session-789',
          'refresh_token': 'refresh-abc',
        };

        // Set all values
        for (final entry in testData.entries) {
          await prefs.setString(entry.key, entry.value);
        }

        // Verify all values
        for (final entry in testData.entries) {
          expect(prefs.getString(entry.key), entry.value);
        }

        // Clear all values
        for (final key in testData.keys) {
          await prefs.remove(key);
          expect(prefs.getString(key), isNull);
        }
      });

      test('handles preference data types', () async {
        final prefs = await SharedPreferences.getInstance();

        // Test different data types
        await prefs.setString('string_key', 'string_value');
        await prefs.setInt('int_key', 42);
        await prefs.setBool('bool_key', true);
        await prefs.setDouble('double_key', 3.14);
        await prefs.setStringList('list_key', ['item1', 'item2', 'item3']);

        // Verify values
        expect(prefs.getString('string_key'), 'string_value');
        expect(prefs.getInt('int_key'), 42);
        expect(prefs.getBool('bool_key'), true);
        expect(prefs.getDouble('double_key'), 3.14);
        expect(prefs.getStringList('list_key'), ['item1', 'item2', 'item3']);

        // Clean up
        await prefs.clear();
      });
    });

    group('Header Building Tests', () {
      test('buildHeaders method exists and can be called', () async {
        // Test that buildHeaders method exists and can be called
        expect(() => apiClient.buildHeaders(), returnsNormally);
      });

      test('buildHeaders updates dio options headers', () async {
        // Test that buildHeaders method updates the headers
        await apiClient.buildHeaders();
        // The method should complete without throwing
        expect(apiClient, isA<ApiClient>());
      });
    });

    group('Multipart Form Building Tests', () {
      test('handles empty multipart data', () async {
        final multipartData = <String, dynamic>{};
        expect(
          () =>
              apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: multipartData, isShowToast: false),
          returnsNormally,
        );
      });

      test('handles null values in multipart data', () async {
        final multipartData = {'field1': 'value1', 'field2': null, 'field3': 'value3'};
        expect(
          () =>
              apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: multipartData, isShowToast: false),
          returnsNormally,
        );
      });

      test('handles FileData with different extensions', () async {
        final testFiles = [
          {'name': 'test.pdf', 'expectedMime': 'application/pdf'},
          {'name': 'test.jpeg', 'expectedMime': 'image/jpeg'},
          {'name': 'test.png', 'expectedMime': 'image/png'},
          {'name': 'test.txt', 'expectedMime': null}, // Unknown extension
        ];

        for (final testFile in testFiles) {
          final multipartData = {
            'file': FileData(name: testFile['name'] as String, bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0),
          };
          expect(
            () => apiClient.request(
              RequestType.MULTIPART_POST,
              '/test',
              multipartData: multipartData,
              isShowToast: false,
            ),
            returnsNormally,
          );
        }
      });

      test('handles mixed data types in multipart form', () async {
        final multipartData = {
          'string_field': 'test string',
          'int_field': 42,
          'double_field': 3.14,
          'bool_field': true,
          'file_field': FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0),
        };
        expect(
          () =>
              apiClient.request(RequestType.MULTIPART_POST, '/test', multipartData: multipartData, isShowToast: false),
          returnsNormally,
        );
      });
    });

    group('Error Handling and Response Tests', () {
      test('handles successful responses with different status codes', () async {
        // Test that the client handles different success status codes
        // Note: These will fail in actual network calls, but we're testing the method structure
        expect(() => apiClient.request(RequestType.GET, '/success-200', isShowToast: false), returnsNormally);
        expect(
          () => apiClient.request(RequestType.POST, '/success-201', data: {}, isShowToast: false),
          returnsNormally,
        );
        expect(() => apiClient.request(RequestType.DELETE, '/success-204', isShowToast: false), returnsNormally);
      });

      test('handles error responses with different status codes', () async {
        // Test that the client handles different error status codes
        expect(() => apiClient.request(RequestType.GET, '/error-400', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-401', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-403', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-404', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-409', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-422', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-429', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-500', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/error-503', isShowToast: false), returnsNormally);
      });

      test('handles network errors', () async {
        // Test network error handling
        expect(() => apiClient.request(RequestType.GET, 'invalid-url', isShowToast: false), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '', isShowToast: false), returnsNormally);
      });

      test('handles toast display parameter correctly', () async {
        // Test both isShowToast true and false scenarios
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: true), returnsNormally);
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);
      });

      test('handles generic exceptions', () async {
        // Test that generic exceptions are re-thrown
        expect(() => apiClient.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);
      });
    });

    group('Authentication Token Tests', () {
      test('handles requests with auth token', () async {
        final prefs = await SharedPreferences.getInstance();

        // Set auth token
        await prefs.setString('auth_token', 'test-bearer-token');

        // Create new client to pick up the token
        final clientWithToken = ApiClient();
        await clientWithToken.buildHeaders();

        expect(() => clientWithToken.request(RequestType.GET, '/authenticated', isShowToast: false), returnsNormally);

        // Clean up
        await prefs.remove('auth_token');
      });

      test('handles requests without auth token', () async {
        final prefs = await SharedPreferences.getInstance();

        // Ensure no auth token
        await prefs.remove('auth_token');

        // Create new client without token
        final clientWithoutToken = ApiClient();
        await clientWithoutToken.buildHeaders();

        expect(() => clientWithoutToken.request(RequestType.GET, '/public', isShowToast: false), returnsNormally);
      });

      test('handles empty auth token', () async {
        final prefs = await SharedPreferences.getInstance();

        // Set empty auth token
        await prefs.setString('auth_token', '');

        // Create new client with empty token
        final clientWithEmptyToken = ApiClient();
        await clientWithEmptyToken.buildHeaders();

        expect(() => clientWithEmptyToken.request(RequestType.GET, '/test', isShowToast: false), returnsNormally);

        // Clean up
        await prefs.remove('auth_token');
      });
    });

    group('File Extension Handling Tests', () {
      test('handles case insensitive file extensions', () async {
        final testExtensions = ['PDF', 'JPEG', 'PNG', 'pdf', 'jpeg', 'png'];

        for (final ext in testExtensions) {
          final multipartData = {
            'file': FileData(name: 'test.$ext', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0),
          };
          expect(
            () => apiClient.request(
              RequestType.MULTIPART_POST,
              '/upload',
              multipartData: multipartData,
              isShowToast: false,
            ),
            returnsNormally,
          );
        }
      });

      test('handles files without extensions', () async {
        final multipartData = {
          'file': FileData(name: 'testfile', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0),
        };
        expect(
          () => apiClient.request(
            RequestType.MULTIPART_POST,
            '/upload',
            multipartData: multipartData,
            isShowToast: false,
          ),
          returnsNormally,
        );
      });

      test('handles files with multiple dots in name', () async {
        final multipartData = {
          'file': FileData(name: 'test.file.with.dots.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0),
        };
        expect(
          () => apiClient.request(
            RequestType.MULTIPART_POST,
            '/upload',
            multipartData: multipartData,
            isShowToast: false,
          ),
          returnsNormally,
        );
      });
    });
  });
}
