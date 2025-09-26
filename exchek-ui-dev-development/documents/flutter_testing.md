# Flutter Testing Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Types of Tests](#types-of-tests)
3. [Unit Testing](#unit-testing)
4. [Widget Testing](#widget-testing)
5. [Integration Testing](#integration-testing)
6. [Best Practices](#best-practices)
7. [Test Coverage](#test-coverage)

## Introduction

Testing is a crucial part of Flutter development that helps ensure your app works as expected and maintains quality over time. Flutter provides a comprehensive testing framework that supports different types of tests.

## Types of Tests

Flutter supports three main types of tests:

1. **Unit Tests**: Test a single function, method, or class
2. **Widget Tests**: Test a single widget
3. **Integration Tests**: Test a complete app or a large part of an app

## Unit Testing

Unit tests verify that a piece of code works as expected in isolation. Here's an example:

```dart
// counter.dart
class Counter {
  int value = 0;
  void increment() => value++;
  void decrement() => value--;
}

// counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/counter.dart';

void main() {
  group('Counter', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();
      counter.decrement();
      expect(counter.value, -1);
    });
  });
}
```

## Widget Testing

Widget tests verify that a widget's UI looks and interacts as expected. Here's an example:

```dart
// my_widget.dart
class MyWidget extends StatelessWidget {
  final String title;
  
  const MyWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}

// my_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/my_widget.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T'));

    expect(find.text('T'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
  });
}
```

## Integration Testing

Integration tests verify that different parts of your app work together correctly. Here's an example:

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on button, verify counter', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
```

## Best Practices

1. **Test Organization**
   - Group related tests using `group()`
   - Use descriptive test names
   - Follow the Arrange-Act-Assert pattern

2. **Test Independence**
   - Each test should be independent
   - Don't rely on the state from other tests
   - Reset state between tests

3. **Mocking**
   - Use mocks for external dependencies
   - Use `Mockito` or `mocktail` for creating mocks
   - Mock network calls and database operations

4. **Test Coverage**
   - Aim for high test coverage
   - Focus on critical business logic
   - Don't test implementation details

## Test Coverage

To check test coverage:

1. Run tests with coverage:
```bash
flutter test --coverage
```

2. Generate coverage report:
```bash
genhtml coverage/lcov.info -o coverage/html
```

3. View the report in your browser:
```bash
open coverage/html/index.html
```

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Flutter Testing Cookbook](https://docs.flutter.dev/cookbook/testing)
- [Flutter Testing GitHub Repository](https://github.com/flutter/flutter/tree/master/packages/flutter_test)

## Common Testing Patterns

1. **Testing State Management**
```dart
test('state changes correctly', () {
  final bloc = MyBloc();
  expect(bloc.state, equals(InitialState()));
  
  bloc.add(MyEvent());
  expect(bloc.state, equals(NewState()));
});
```

2. **Testing Navigation**
```dart
testWidgets('navigates to new screen', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.byType(NewScreen), findsOneWidget);
});
```

3. **Testing API Calls**
```dart
test('fetches data successfully', () async {
  final repository = MockRepository();
  when(repository.getData()).thenAnswer((_) async => [1, 2, 3]);
  
  final result = await repository.getData();
  expect(result, equals([1, 2, 3]));
});
```

Remember to:
- Write tests before or alongside your code
- Keep tests simple and focused
- Use meaningful assertions
- Test edge cases and error conditions
- Maintain test code quality 