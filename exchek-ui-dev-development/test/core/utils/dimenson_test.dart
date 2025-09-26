import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/utils/dimenson.dart';

void main() {
  group('Dimension Utilities', () {
    // =============================================================================
    // buildSizedBoxH TESTS
    // =============================================================================

    group('buildSizedBoxH', () {
      test('returns SizedBox with correct height when given positive value', () {
        const double testHeight = 20.0;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with zero height', () {
        const double testHeight = 0.0;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with small decimal height', () {
        const double testHeight = 0.5;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with large height value', () {
        const double testHeight = 1000.0;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with negative height value', () {
        const double testHeight = -10.0;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with very small positive height', () {
        const double testHeight = 0.001;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with double.infinity height', () {
        const double testHeight = double.infinity;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with double.maxFinite height', () {
        const double testHeight = double.maxFinite;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns SizedBox with double.minPositive height', () {
        const double testHeight = double.minPositive;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('returns different SizedBox instances for multiple calls', () {
        const double testHeight = 15.0;
        final result1 = buildSizedBoxH(testHeight) as SizedBox;
        final result2 = buildSizedBoxH(testHeight) as SizedBox;

        expect(result1, isA<SizedBox>());
        expect(result2, isA<SizedBox>());
        expect(result1.height, equals(result2.height));
        expect(identical(result1, result2), isFalse); // Different instances
      });
    });

    // =============================================================================
    // buildSizedboxW TESTS
    // =============================================================================

    group('buildSizedboxW', () {
      test('returns SizedBox with correct width when given positive value', () {
        const double testWidth = 30.0;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with zero width', () {
        const double testWidth = 0.0;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with small decimal width', () {
        const double testWidth = 0.75;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with large width value', () {
        const double testWidth = 2000.0;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with negative width value', () {
        const double testWidth = -25.0;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with very small positive width', () {
        const double testWidth = 0.0001;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with double.infinity width', () {
        const double testWidth = double.infinity;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with double.maxFinite width', () {
        const double testWidth = double.maxFinite;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns SizedBox with double.minPositive width', () {
        const double testWidth = double.minPositive;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('returns different SizedBox instances for multiple calls', () {
        const double testWidth = 40.0;
        final result1 = buildSizedboxW(testWidth) as SizedBox;
        final result2 = buildSizedboxW(testWidth) as SizedBox;

        expect(result1, isA<SizedBox>());
        expect(result2, isA<SizedBox>());
        expect(result1.width, equals(result2.width));
        expect(identical(result1, result2), isFalse); // Different instances
      });
    });

    // =============================================================================
    // EDGE CASES AND BOUNDARY TESTING
    // =============================================================================

    group('Edge Cases and Boundary Testing', () {
      test('buildSizedBoxH with NaN value', () {
        const double testHeight = double.nan;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height!.isNaN, isTrue);
        expect(result.width, isNull);
      });

      test('buildSizedboxW with NaN value', () {
        const double testWidth = double.nan;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width!.isNaN, isTrue);
        expect(result.height, isNull);
      });

      test('buildSizedBoxH with negative infinity', () {
        const double testHeight = double.negativeInfinity;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('buildSizedboxW with negative infinity', () {
        const double testWidth = double.negativeInfinity;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });

      test('buildSizedBoxH preserves exact decimal precision', () {
        const double testHeight = 123.456789;
        final result = buildSizedBoxH(testHeight) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.height, equals(testHeight));
        expect(result.width, isNull);
      });

      test('buildSizedboxW preserves exact decimal precision', () {
        const double testWidth = 987.654321;
        final result = buildSizedboxW(testWidth) as SizedBox;

        expect(result, isA<SizedBox>());
        expect(result.width, equals(testWidth));
        expect(result.height, isNull);
      });
    });

    // =============================================================================
    // FUNCTIONAL BEHAVIOR TESTING
    // =============================================================================

    group('Functional Behavior', () {
      test('buildSizedBoxH creates widget that can be used in widget tree', () {
        const double testHeight = 50.0;
        final sizedBox = buildSizedBoxH(testHeight);

        // Test that it can be used as a child widget
        final container = Container(child: sizedBox);
        expect(container.child, equals(sizedBox));
      });

      test('buildSizedboxW creates widget that can be used in widget tree', () {
        const double testWidth = 60.0;
        final sizedBox = buildSizedboxW(testWidth);

        // Test that it can be used as a child widget
        final container = Container(child: sizedBox);
        expect(container.child, equals(sizedBox));
      });

      test('buildSizedBoxH and buildSizedboxW can be used together', () {
        const double testHeight = 100.0;
        const double testWidth = 200.0;

        final heightBox = buildSizedBoxH(testHeight) as SizedBox;
        final widthBox = buildSizedboxW(testWidth) as SizedBox;

        expect(heightBox.height, equals(testHeight));
        expect(heightBox.width, isNull);
        expect(widthBox.width, equals(testWidth));
        expect(widthBox.height, isNull);
      });

      test('functions return consistent results for same input', () {
        const double testHeight = 75.0;
        const double testWidth = 85.0;

        // Test multiple calls with same input
        for (int i = 0; i < 5; i++) {
          final heightResult = buildSizedBoxH(testHeight) as SizedBox;
          final widthResult = buildSizedboxW(testWidth) as SizedBox;

          expect(heightResult.height, equals(testHeight));
          expect(widthResult.width, equals(testWidth));
        }
      });
    });

    // =============================================================================
    // PERFORMANCE AND MEMORY TESTING
    // =============================================================================

    group('Performance and Memory', () {
      test('functions execute quickly for normal values', () {
        const double testHeight = 25.0;
        const double testWidth = 35.0;

        final stopwatch = Stopwatch()..start();

        // Execute functions multiple times
        for (int i = 0; i < 1000; i++) {
          buildSizedBoxH(testHeight);
          buildSizedboxW(testWidth);
        }

        stopwatch.stop();

        // Should complete quickly (less than 1 second for 1000 iterations)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('functions handle rapid successive calls', () {
        final results = <Widget>[];

        // Rapid successive calls
        for (int i = 0; i < 100; i++) {
          results.add(buildSizedBoxH(i.toDouble()));
          results.add(buildSizedboxW(i.toDouble()));
        }

        expect(results.length, equals(200));

        // Verify all results are valid SizedBox widgets
        for (final result in results) {
          expect(result, isA<SizedBox>());
        }
      });
    });
  });
}
