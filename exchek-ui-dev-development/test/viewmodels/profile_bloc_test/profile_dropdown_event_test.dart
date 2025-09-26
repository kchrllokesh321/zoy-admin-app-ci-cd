import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_event.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileDropdownEvent', () {
    group('ToggleDropdownEvent', () {
      test('supports value equality', () {
        final event1 = ToggleDropdownEvent();
        final event2 = ToggleDropdownEvent();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = ToggleDropdownEvent();
        expect(event.props, []);
      });

      test('extends ProfileDropdownEvent', () {
        final event = ToggleDropdownEvent();
        expect(event, isA<ProfileDropdownEvent>());
      });
    });

    group('CloseDropdownEvent', () {
      test('supports value equality', () {
        final event1 = CloseDropdownEvent();
        final event2 = CloseDropdownEvent();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = CloseDropdownEvent();
        expect(event.props, []);
      });

      test('extends ProfileDropdownEvent', () {
        final event = CloseDropdownEvent();
        expect(event, isA<ProfileDropdownEvent>());
      });
    });

    group('LogoutRequestedEvent', () {
      test('supports value equality', () {
        final event1 = LogoutRequestedEvent();
        final event2 = LogoutRequestedEvent();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = LogoutRequestedEvent();
        expect(event.props, []);
      });

      test('extends ProfileDropdownEvent', () {
        final event = LogoutRequestedEvent();
        expect(event, isA<ProfileDropdownEvent>());
      });
    });

    group('LogoutConfirmedEvent', () {
      test('supports value equality', () {
        final event1 = LogoutConfirmedEvent();
        final event2 = LogoutConfirmedEvent();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        final event = LogoutConfirmedEvent();
        expect(event.props, []);
      });

      test('extends ProfileDropdownEvent', () {
        final event = LogoutConfirmedEvent();
        expect(event, isA<ProfileDropdownEvent>());
      });
    });

    group('LogoutWithEmailRequested', () {
      testWidgets('supports value equality', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final event1 = LogoutWithEmailRequested('test@example.com', context);
        final event2 = LogoutWithEmailRequested('test@example.com', context);
        final event3 = LogoutWithEmailRequested('other@example.com', context);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      testWidgets('props include email and context', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final event = LogoutWithEmailRequested('test@example.com', context);
        expect(event.props, ['test@example.com', context]);
      });

      testWidgets('extends ProfileDropdownEvent', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final event = LogoutWithEmailRequested('test@example.com', context);
        expect(event, isA<ProfileDropdownEvent>());
      });

      testWidgets('email property is accessible', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        const email = 'user@example.com';
        final event = LogoutWithEmailRequested(email, context);
        expect(event.email, equals(email));
      });

      testWidgets('different emails create different events', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final event1 = LogoutWithEmailRequested('user1@example.com', context);
        final event2 = LogoutWithEmailRequested('user2@example.com', context);

        expect(event1, isNot(equals(event2)));
        expect(event1.props, isNot(equals(event2.props)));
      });

      testWidgets('empty email is handled correctly', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final event1 = LogoutWithEmailRequested('', context);
        final event2 = LogoutWithEmailRequested('', context);

        expect(event1, equals(event2));
        expect(event1.props, ['', context]);
      });
    });

    group('ProfileDropdownEvent base class', () {
      testWidgets('all events extend ProfileDropdownEvent', (WidgetTester tester) async {
        await tester.pumpWidget(Container());
        final context = tester.element(find.byType(Container));

        final events = [
          ToggleDropdownEvent(),
          CloseDropdownEvent(),
          LogoutRequestedEvent(),
          LogoutConfirmedEvent(),
          LogoutWithEmailRequested('test@example.com', context),
        ];

        for (final event in events) {
          expect(event, isA<ProfileDropdownEvent>());
        }
      });
    });
  });
}
