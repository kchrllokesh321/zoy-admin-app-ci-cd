import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:exchek/widgets/account_setup_widgets/upload_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomUploadNote Widget Tests', () {
    // Helper function to create a test widget with proper theme setup
    Widget createTestWidget({required List<String> notes, Size screenSize = const Size(400, 800)}) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [
            CustomColors(
              primaryColor: Colors.blue,
              textdarkcolor: Colors.black,
              darktextcolor: Colors.black87,
              fillColor: Colors.white,
              secondaryTextColor: Colors.grey,
              shadowColor: Colors.black26,
              blackColor: Colors.black,
              borderColor: Colors.grey,
              greenColor: Colors.green,
              purpleColor: Colors.purple,
              lightBackgroundColor: Colors.grey[100],
              redColor: Colors.red,
              darkShadowColor: Colors.black54,
              dividerColor: Colors.grey,
              iconColor: Colors.grey[600],
              darkBlueColor: Colors.blue[900],
              lightPurpleColor: Colors.purple[100],
              hintTextColor: Colors.grey[500],
              lightUnSelectedBGColor: Colors.grey[200],
              lightBorderColor: Colors.grey[300],
              disabledColor: Colors.grey[400],
              blueColor: Colors.grey[400],
              boxBgColor: Colors.grey[400],
              boxBorderColor: Colors.grey[400],
              hoverBorderColor: Colors.grey[400],
              hoverShadowColor: Colors.grey[400],
              errorColor: Color(0xFFD91807),
              lightBlueColor: Color(0xFFE6F4FB),
              lightBlueBorderColor: Color(0xFF9DC0EE),
              darkBlueTextColor: Color(0xFF2F3F53),
              blueTextColor: Color(0xFF343A3E),
              drawerIconColor: Color(0xFF4C5259),
              darkGreyColor: Color(0xFF9B9B9B),
              badgeColor: Color(0xFFFF2D55),
              greyTextColor: Color(0xFF666666),
              greyBorderPaginationColor: Color(0xFF4C5259),
              paginationTextColor: Color(0xFF202224),
              tableHeaderColor: Colors.grey[400],
              greentextColor: Colors.green,
              redtextColor: Colors.red,
              tableBorderColor: Colors.grey[400],
              filtercheckboxcolor: Colors.grey[400],
              filtercheckboxunselectedcolor: Colors.grey[400],
              filterbordercolor: Colors.grey[400],
              daterangecolor: Colors.grey[400],
              lightBoxBGColor: Colors.grey[400],
              lightDividerColor: Colors.grey[400],
              lightGreyColor: Color(0xFF6D6D6D),
            ),
          ],
        ),
        home: MediaQuery(data: MediaQueryData(size: screenSize), child: Scaffold(body: CustomUploadNote(nots: notes))),
      );
    }

    group('Widget Creation Tests', () {
      testWidgets('creates widget with required parameters', (tester) async {
        const testNotes = ['Note 1', 'Note 2'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
      });

      testWidgets('creates widget with empty list', (tester) async {
        const testNotes = <String>[];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('creates widget with single note', (tester) async {
        const testNotes = ['Single note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.text('Single note'), findsOneWidget);
        expect(find.text('•'), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        const testNotes = ['Note 1', 'Note 2', 'Note 3'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsNWidgets(3)); // One row per note
        expect(find.byType(Text), findsNWidgets(6)); // 3 bullets + 3 notes
        expect(find.byType(SizedBox), findsNWidgets(3)); // One spacing per note
        expect(find.byType(Expanded), findsNWidgets(3)); // One expanded per note
      });

      testWidgets('displays correct bullet points', (tester) async {
        const testNotes = ['First note', 'Second note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.text('•'), findsNWidgets(2));
      });

      testWidgets('displays all notes correctly', (tester) async {
        const testNotes = ['First note', 'Second note', 'Third note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        for (final note in testNotes) {
          expect(find.text(note), findsOneWidget);
        }
      });
    });

    group('Layout and Styling Tests', () {
      testWidgets('rows have correct cross axis alignment', (tester) async {
        const testNotes = ['Test note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        final rowWidget = tester.widget<Row>(find.byType(Row));
        expect(rowWidget.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('bullet text has correct styling', (tester) async {
        const testNotes = ['Test note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        final bulletText = tester.widget<Text>(find.text('•'));
        final textStyle = bulletText.style!;

        expect(textStyle.color, Colors.black);
        expect(textStyle.fontSize, 15.0); // Mobile size
        expect(textStyle.fontWeight, FontWeight.w400);
      });

      testWidgets('note text has correct styling', (tester) async {
        const testNotes = ['Test note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        final noteText = tester.widget<Text>(find.text('Test note'));
        final textStyle = noteText.style!;

        expect(textStyle.color, Colors.black);
        expect(textStyle.fontSize, 15.0); // Mobile size
        expect(textStyle.fontWeight, FontWeight.w400);
        expect(textStyle.letterSpacing, 0.16);
      });

      testWidgets('has correct spacing between bullet and text', (tester) async {
        const testNotes = ['Test note'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 5.0);
        expect(sizedBox.height, isNull);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('adapts font size for mobile screens', (tester) async {
        const testNotes = ['Mobile test'];

        await tester.pumpWidget(
          createTestWidget(
            notes: testNotes,
            screenSize: const Size(400, 800), // Mobile size
          ),
        );

        final bulletText = tester.widget<Text>(find.text('•'));
        final noteText = tester.widget<Text>(find.text('Mobile test'));

        expect(bulletText.style!.fontSize, 15.0);
        expect(noteText.style!.fontSize, 15.0);
      });

      testWidgets('adapts font size for tablet screens', (tester) async {
        const testNotes = ['Tablet test'];

        await tester.pumpWidget(
          createTestWidget(
            notes: testNotes,
            screenSize: const Size(800, 600), // Tablet size
          ),
        );

        final bulletText = tester.widget<Text>(find.text('•'));
        final noteText = tester.widget<Text>(find.text('Tablet test'));

        expect(bulletText.style!.fontSize, 16.0);
        expect(noteText.style!.fontSize, 16.0);
      });

      testWidgets('adapts font size for desktop screens', (tester) async {
        const testNotes = ['Desktop test'];

        await tester.pumpWidget(
          createTestWidget(
            notes: testNotes,
            screenSize: const Size(1200, 800), // Desktop size
          ),
        );

        final bulletText = tester.widget<Text>(find.text('•'));
        final noteText = tester.widget<Text>(find.text('Desktop test'));

        expect(bulletText.style!.fontSize, 16.0);
        expect(noteText.style!.fontSize, 16.0);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles empty notes list', (tester) async {
        const testNotes = <String>[];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsNothing);
        expect(find.text('•'), findsNothing);
      });

      testWidgets('handles very long notes', (tester) async {
        const longNote =
            'This is a very long note that should wrap to multiple lines and test the Expanded widget behavior to ensure proper text wrapping and layout';
        const testNotes = [longNote];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.text(longNote), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('handles special characters in notes', (tester) async {
        const testNotes = ['Note with émojis 🎉', 'Special chars: @#\$%^&*()'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        for (final note in testNotes) {
          expect(find.text(note), findsOneWidget);
        }
      });

      testWidgets('handles large number of notes', (tester) async {
        final testNotes = List.generate(20, (index) => 'Note ${index + 1}');

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.byType(Row), findsNWidgets(20));
        expect(find.text('•'), findsNWidgets(20));

        // Check first and last notes
        expect(find.text('Note 1'), findsOneWidget);
        expect(find.text('Note 20'), findsOneWidget);
      });
    });

    group('Widget Properties Tests', () {
      test('widget has correct key parameter', () {
        const testKey = Key('test_key');
        const testNotes = ['Test'];

        final widget = CustomUploadNote(key: testKey, nots: testNotes);

        expect(widget.key, testKey);
        expect(widget.nots, testNotes);
      });

      test('widget is StatelessWidget', () {
        const testNotes = ['Test'];
        final widget = CustomUploadNote(nots: testNotes);

        expect(widget, isA<StatelessWidget>());
      });
    });

    group('Integration Tests', () {
      testWidgets('works correctly with different screen orientations', (tester) async {
        const testNotes = ['Portrait test', 'Landscape test'];

        // Portrait
        await tester.pumpWidget(createTestWidget(notes: testNotes, screenSize: const Size(400, 800)));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.text('Portrait test'), findsOneWidget);

        // Landscape
        await tester.pumpWidget(createTestWidget(notes: testNotes, screenSize: const Size(800, 400)));

        expect(find.byType(CustomUploadNote), findsOneWidget);
        expect(find.text('Landscape test'), findsOneWidget);
      });

      testWidgets('maintains state during rebuilds', (tester) async {
        const testNotes = ['Rebuild test'];

        await tester.pumpWidget(createTestWidget(notes: testNotes));

        expect(find.text('Rebuild test'), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        expect(find.text('Rebuild test'), findsOneWidget);
      });
    });
  });
}
