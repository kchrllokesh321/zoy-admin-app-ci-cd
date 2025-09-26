import 'package:exchek/models/personal_user_models/presigned_url_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PresignedUrlModel', () {
    test('constructor creates instance with url parameter', () {
      const testUrl = 'https://example.com/presigned-url';
      final model = PresignedUrlModel(url: testUrl);

      expect(model.url, equals(testUrl));
    });

    test('constructor creates instance with null url parameter', () {
      final model = PresignedUrlModel(url: null);

      expect(model.url, isNull);
    });

    test('constructor creates instance without parameters', () {
      final model = PresignedUrlModel();

      expect(model.url, isNull);
    });

    test('fromJson creates instance from JSON with url', () {
      final json = {'url': 'https://s3.amazonaws.com/bucket/file.jpg?signature=abc123'};

      final model = PresignedUrlModel.fromJson(json);

      expect(model.url, equals('https://s3.amazonaws.com/bucket/file.jpg?signature=abc123'));
    });

    test('fromJson creates instance from JSON with null url', () {
      final json = {'url': null};

      final model = PresignedUrlModel.fromJson(json);

      expect(model.url, isNull);
    });

    test('fromJson creates instance from JSON without url field', () {
      final json = <String, dynamic>{};

      final model = PresignedUrlModel.fromJson(json);

      expect(model.url, isNull);
    });

    test('fromJson creates instance from empty JSON', () {
      final json = <String, dynamic>{};

      final model = PresignedUrlModel.fromJson(json);

      expect(model.url, isNull);
    });

    test('toJson converts instance to JSON with url', () {
      const testUrl = 'https://storage.googleapis.com/bucket/document.pdf?token=xyz789';
      final model = PresignedUrlModel(url: testUrl);

      final json = model.toJson();

      expect(json['url'], equals(testUrl));
      expect(json.keys.length, equals(1));
    });

    test('toJson converts instance to JSON with null url', () {
      final model = PresignedUrlModel(url: null);

      final json = model.toJson();

      expect(json['url'], isNull);
      expect(json.keys.length, equals(1));
    });

    test('toJson converts instance to JSON with empty string url', () {
      final model = PresignedUrlModel(url: '');

      final json = model.toJson();

      expect(json['url'], equals(''));
      expect(json.keys.length, equals(1));
    });

    test('handles various URL formats correctly', () {
      final urlFormats = [
        'https://example.com/file.jpg',
        'http://localhost:3000/upload',
        'https://s3.amazonaws.com/bucket/path/to/file.png?AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Expires=1234567890&Signature=signature',
        'https://storage.googleapis.com/bucket/file.pdf?GoogleAccessId=service@project.iam.gserviceaccount.com&Expires=1234567890&Signature=signature',
        'https://azure.blob.core.windows.net/container/file.docx?sv=2020-08-04&ss=b&srt=sco&sp=rwdlacx&se=2023-12-31T23:59:59Z&st=2023-01-01T00:00:00Z&spr=https&sig=signature',
        'ftp://ftp.example.com/file.txt',
        'file:///local/path/to/file.jpg',
        '',
      ];

      for (final url in urlFormats) {
        final json = {'url': url};
        final model = PresignedUrlModel.fromJson(json);

        expect(model.url, equals(url));

        final convertedJson = model.toJson();
        expect(convertedJson['url'], equals(url));
      }
    });

    test('handles special characters in URLs', () {
      final specialUrls = [
        'https://example.com/file with spaces.jpg',
        'https://example.com/файл.jpg',
        'https://example.com/文件.png',
        'https://example.com/file%20encoded.pdf',
        'https://example.com/file?param=value&other=123',
        'https://example.com/file#fragment',
        'https://user:pass@example.com/file.jpg',
        'https://example.com:8080/file.jpg',
      ];

      for (final url in specialUrls) {
        final model = PresignedUrlModel(url: url);
        final json = model.toJson();
        final reconstructedModel = PresignedUrlModel.fromJson(json);

        expect(reconstructedModel.url, equals(url));
      }
    });

    test('round-trip conversion maintains data integrity', () {
      const originalUrl = 'https://example.com/presigned-url?signature=abc123&expires=1234567890';
      final originalModel = PresignedUrlModel(url: originalUrl);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = PresignedUrlModel.fromJson(json);

      // Verify data is preserved
      expect(reconstructedModel.url, equals(originalModel.url));
    });

    test('round-trip conversion with null url', () {
      final originalModel = PresignedUrlModel(url: null);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = PresignedUrlModel.fromJson(json);

      // Verify null value is preserved
      expect(reconstructedModel.url, isNull);
    });

    test('round-trip conversion with empty string url', () {
      final originalModel = PresignedUrlModel(url: '');

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = PresignedUrlModel.fromJson(json);

      // Verify empty string is preserved
      expect(reconstructedModel.url, equals(''));
    });

    test('handles very long URLs', () {
      final longUrl = 'https://example.com/${'a' * 2000}.jpg?signature=${'b' * 1000}';
      final model = PresignedUrlModel(url: longUrl);

      final json = model.toJson();
      final reconstructedModel = PresignedUrlModel.fromJson(json);

      expect(reconstructedModel.url, equals(longUrl));
      expect(reconstructedModel.url!.length, equals(longUrl.length));
    });
  });

  group('Integration Tests', () {
    test('simulates AWS S3 presigned URL workflow', () {
      // Simulate AWS S3 presigned URL response
      final awsResponse = {
        'url':
            'https://my-bucket.s3.amazonaws.com/uploads/document.pdf?AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Expires=1609459200&Signature=signature123',
      };

      final model = PresignedUrlModel.fromJson(awsResponse);

      expect(model.url, isNotNull);
      expect(model.url, contains('s3.amazonaws.com'));
      expect(model.url, contains('AWSAccessKeyId'));
      expect(model.url, contains('Expires'));
      expect(model.url, contains('Signature'));

      // Convert back for API usage
      final requestJson = model.toJson();
      expect(requestJson['url'], equals(model.url));
    });

    test('simulates Google Cloud Storage presigned URL workflow', () {
      // Simulate GCS presigned URL response
      final gcsResponse = {
        'url':
            'https://storage.googleapis.com/my-bucket/uploads/image.png?GoogleAccessId=service@project.iam.gserviceaccount.com&Expires=1609459200&Signature=signature456',
      };

      final model = PresignedUrlModel.fromJson(gcsResponse);

      expect(model.url, isNotNull);
      expect(model.url, contains('storage.googleapis.com'));
      expect(model.url, contains('GoogleAccessId'));
      expect(model.url, contains('Expires'));
      expect(model.url, contains('Signature'));
    });

    test('simulates Azure Blob Storage presigned URL workflow', () {
      // Simulate Azure Blob Storage SAS URL response
      final azureResponse = {
        'url':
            'https://mystorageaccount.blob.core.windows.net/container/file.docx?sv=2020-08-04&ss=b&srt=sco&sp=rwdlacx&se=2023-12-31T23:59:59Z&st=2023-01-01T00:00:00Z&spr=https&sig=signature789',
      };

      final model = PresignedUrlModel.fromJson(azureResponse);

      expect(model.url, isNotNull);
      expect(model.url, contains('blob.core.windows.net'));
      expect(model.url, contains('sv='));
      expect(model.url, contains('sig='));
    });

    test('simulates error response with no URL', () {
      // Simulate error response
      final errorResponse = {'url': null};

      final model = PresignedUrlModel.fromJson(errorResponse);

      expect(model.url, isNull);

      // Convert back
      final requestJson = model.toJson();
      expect(requestJson['url'], isNull);
    });
  });

  group('Edge Cases and Error Handling', () {
    test('handles JSON with additional unexpected fields', () {
      final json = {
        'url': 'https://example.com/file.jpg',
        'unexpected_field': 'should_be_ignored',
        'another_field': 123,
      };

      final model = PresignedUrlModel.fromJson(json);

      expect(model.url, equals('https://example.com/file.jpg'));

      // toJson should only include the url field
      final convertedJson = model.toJson();
      expect(convertedJson.keys.length, equals(1));
      expect(convertedJson.containsKey('url'), isTrue);
      expect(convertedJson.containsKey('unexpected_field'), isFalse);
    });

    test('handles non-string URL values by throwing type error', () {
      // The model expects String? type, so non-string values should throw TypeError
      final jsonWithNumber = {'url': 123};
      expect(() => PresignedUrlModel.fromJson(jsonWithNumber), throwsA(isA<TypeError>()));

      final jsonWithBool = {'url': true};
      expect(() => PresignedUrlModel.fromJson(jsonWithBool), throwsA(isA<TypeError>()));

      final jsonWithList = {
        'url': ['not', 'a', 'url'],
      };
      expect(() => PresignedUrlModel.fromJson(jsonWithList), throwsA(isA<TypeError>()));

      final jsonWithObject = {
        'url': {'nested': 'object'},
      };
      expect(() => PresignedUrlModel.fromJson(jsonWithObject), throwsA(isA<TypeError>()));
    });

    test('maintains consistency across multiple operations', () {
      const testUrl = 'https://example.com/test.png';

      // Create model
      final model1 = PresignedUrlModel(url: testUrl);

      // Convert to JSON
      final json1 = model1.toJson();

      // Create from JSON
      final model2 = PresignedUrlModel.fromJson(json1);

      // Convert to JSON again
      final json2 = model2.toJson();

      // Create from JSON again
      final model3 = PresignedUrlModel.fromJson(json2);

      // All should be equal
      expect(model1.url, equals(model2.url));
      expect(model2.url, equals(model3.url));
      expect(json1, equals(json2));
    });
  });
}
