import 'package:exchek/widgets/custom_widget/custom_context_menu_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock EditableTextState
class MockEditableTextState extends Mock implements EditableTextState {
  final List<ContextMenuButtonItem> _buttonItems = [
    ContextMenuButtonItem(onPressed: () {}, label: 'Copy', type: ContextMenuButtonType.copy),
    ContextMenuButtonItem(onPressed: () {}, label: 'Paste', type: ContextMenuButtonType.paste),
    ContextMenuButtonItem(onPressed: () {}, label: 'Cut', type: ContextMenuButtonType.cut),
    ContextMenuButtonItem(onPressed: () {}, label: 'Select All', type: ContextMenuButtonType.selectAll),
  ];

  @override
  TextSelectionToolbarAnchors get contextMenuAnchors =>
      const TextSelectionToolbarAnchors(primaryAnchor: Offset(100, 100), secondaryAnchor: Offset(200, 200));

  @override
  List<ContextMenuButtonItem> get contextMenuButtonItems => _buttonItems;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockEditableTextState';
  }

  // Method to update button items for testing
  void setButtonItems(List<ContextMenuButtonItem> items) {
    _buttonItems.clear();
    _buttonItems.addAll(items);
  }
}

// Mock BuildContext
class MockContext extends Mock implements BuildContext {}

void main() {
  group('customContextMenuBuilder', () {
    late MockEditableTextState mockEditableTextState;
    late BuildContext mockContext;

    setUp(() {
      mockEditableTextState = MockEditableTextState();
      mockContext = MockContext();
    });

    testWidgets('should return AdaptiveTextSelectionToolbar.buttonItems widget', (WidgetTester tester) async {
      // Arrange
      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
    });

    testWidgets('should configure toolbar with correct anchors', (WidgetTester tester) async {
      // Arrange
      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.anchors, equals(mockEditableTextState.contextMenuAnchors));
    });

    testWidgets('should filter out paste button items', (WidgetTester tester) async {
      // Arrange
      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      // Verify that paste items are filtered out
      final buttonItems = mockEditableTextState.contextMenuButtonItems;
      final expectedFilteredItems = buttonItems.where((item) => item.type != ContextMenuButtonType.paste).toList();

      expect(toolbar.buttonItems!.length, equals(expectedFilteredItems.length));

      // Verify specific items are present/absent by checking types
      final toolbarItemTypes = toolbar.buttonItems!.map((item) => item.type).toSet();
      final expectedTypes = expectedFilteredItems.map((item) => item.type).toSet();

      expect(toolbarItemTypes, equals(expectedTypes));

      // Verify paste items are not present
      expect(toolbarItemTypes, isNot(contains(ContextMenuButtonType.paste)));
    });

    testWidgets('should handle empty button items list', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([]);
      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems, isEmpty);
    });

    testWidgets('should handle button items with only paste items', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste', type: ContextMenuButtonType.paste),
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste Special', type: ContextMenuButtonType.paste),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems, isEmpty);
    });

    testWidgets('should handle button items with no paste items', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: () {}, label: 'Copy', type: ContextMenuButtonType.copy),
        ContextMenuButtonItem(onPressed: () {}, label: 'Cut', type: ContextMenuButtonType.cut),
        ContextMenuButtonItem(onPressed: () {}, label: 'Select All', type: ContextMenuButtonType.selectAll),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems!.length, equals(3));
      expect(toolbar.buttonItems!.every((item) => item.type != ContextMenuButtonType.paste), isTrue);
    });

    testWidgets('should preserve button item properties after filtering', (WidgetTester tester) async {
      // Arrange
      customOnPressed() {}
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: customOnPressed, label: 'Custom Action', type: ContextMenuButtonType.copy),
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste', type: ContextMenuButtonType.paste),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems!.length, equals(1));
      expect(toolbar.buttonItems!.first.label, equals('Custom Action'));
      expect(toolbar.buttonItems!.first.type, equals(ContextMenuButtonType.copy));
      expect(toolbar.buttonItems!.first.onPressed, equals(customOnPressed));
    });

    testWidgets('should handle mixed button types correctly', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: () {}, label: 'Copy', type: ContextMenuButtonType.copy),
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste', type: ContextMenuButtonType.paste),
        ContextMenuButtonItem(onPressed: () {}, label: 'Cut', type: ContextMenuButtonType.cut),
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste Special', type: ContextMenuButtonType.paste),
        ContextMenuButtonItem(onPressed: () {}, label: 'Select All', type: ContextMenuButtonType.selectAll),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems!.length, equals(3));
      expect(
        toolbar.buttonItems!.map((item) => item.type).toSet(),
        equals({ContextMenuButtonType.copy, ContextMenuButtonType.cut, ContextMenuButtonType.selectAll}),
      );
    });

    testWidgets('should handle single paste item', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: () {}, label: 'Paste', type: ContextMenuButtonType.paste),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems, isEmpty);
    });

    testWidgets('should handle single non-paste item', (WidgetTester tester) async {
      // Arrange
      mockEditableTextState.setButtonItems([
        ContextMenuButtonItem(onPressed: () {}, label: 'Copy', type: ContextMenuButtonType.copy),
      ]);

      final widget = customContextMenuBuilder(mockContext, mockEditableTextState);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final toolbar = tester.widget<AdaptiveTextSelectionToolbar>(find.byType(AdaptiveTextSelectionToolbar));

      expect(toolbar.buttonItems!.length, equals(1));
      expect(toolbar.buttonItems!.first.type, equals(ContextMenuButtonType.copy));
      expect(toolbar.buttonItems!.first.label, equals('Copy'));
    });
  });
}
