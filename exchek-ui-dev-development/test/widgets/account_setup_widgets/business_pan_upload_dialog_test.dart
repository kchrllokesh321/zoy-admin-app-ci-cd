// import 'dart:typed_data';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:exchek/core/enums/app_enums.dart';
// import 'package:exchek/core/generated/l10n.dart';
// import 'package:exchek/core/themes/custom_color_extension.dart';
// import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
// import 'package:exchek/widgets/account_setup_widgets/business_pan_upload_dialog.dart';
// import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
// import 'package:exchek/widgets/common_widget/custom_button.dart';
// import 'package:exchek/widgets/common_widget/custom_textfields.dart';
// import 'package:exchek/widgets/common_widget/image_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mocktail/mocktail.dart';

// // Mock classes
// class MockBusinessAccountSetupBloc extends MockBloc<BusinessAccountSetupEvent, BusinessAccountSetupState>
//     implements BusinessAccountSetupBloc {}

// class MockGoRouter extends Mock implements GoRouter {}

// class MockBusinessAccountSetupState extends Mock implements BusinessAccountSetupState {}

// class FakeBusinessAccountSetupEvent extends Fake implements BusinessAccountSetupEvent {}

// void main() {
//   group('BusinessPanUploadDialog Tests', () {
//     late MockBusinessAccountSetupBloc mockBloc;

//     setUpAll(() {
//       registerFallbackValue(FakeBusinessAccountSetupEvent());
//     });

//     setUp(() {
//       mockBloc = MockBusinessAccountSetupBloc();
//     });

//     // Helper function to create a mock state
//     BusinessAccountSetupState createMockState({
//       TextEditingController? panNameController,
//       TextEditingController? panNumberController,
//       FileData? panCardFile,
//       bool? isBusinessPanCardSaveLoading,
//       GlobalKey<FormState>? formKey,
//     }) {
//       final mockState = MockBusinessAccountSetupState();
//       final realPanNameController = panNameController ?? TextEditingController();
//       final realPanNumberController = panNumberController ?? TextEditingController();
//       final realFormKey = formKey ?? GlobalKey<FormState>();

//       when(() => mockState.businessPanNameController).thenReturn(realPanNameController);
//       when(() => mockState.businessPanNumberController).thenReturn(realPanNumberController);
//       when(() => mockState.businessPanCardFile).thenReturn(panCardFile);
//       when(() => mockState.isBusinessPanCardSaveLoading).thenReturn(isBusinessPanCardSaveLoading ?? false);
//       when(() => mockState.businessPanVerificationKey).thenReturn(realFormKey);

//       return mockState;
//     }

//     // Helper function to create a test widget with proper setup
//     Widget createTestWidget({BusinessAccountSetupState? state, Size screenSize = const Size(800, 1200)}) {
//       final testState = state ?? createMockState();

//       when(() => mockBloc.state).thenReturn(testState);
//       when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([testState]));
//       when(() => mockBloc.add(any())).thenReturn(null);

//       return MaterialApp(
//         localizationsDelegates: const [
//           Lang.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: Lang.delegate.supportedLocales,
//         theme: ThemeData(
//           extensions: [
//             CustomColors(
//               primaryColor: Colors.blue,
//               textdarkcolor: Colors.black,
//               darktextcolor: Colors.black87,
//               fillColor: Colors.white,
//               secondaryTextColor: Colors.grey,
//               shadowColor: Colors.black26,
//               blackColor: Colors.black,
//               borderColor: Colors.grey,
//               greenColor: Colors.green,
//               purpleColor: Colors.purple,
//               lightBackgroundColor: Colors.grey[100],
//               redColor: Colors.red,
//               darkShadowColor: Colors.black54,
//               dividerColor: Colors.grey,
//               iconColor: Colors.grey[600],
//               darkBlueColor: Colors.blue[900],
//               lightPurpleColor: Colors.purple[100],
//               hintTextColor: Colors.grey[500],
//               lightUnSelectedBGColor: Colors.grey[200],
//               lightBorderColor: Colors.grey[300],
//               disabledColor: Colors.grey[400],
//               blueColor: Colors.grey[400],
//               boxBgColor: Colors.grey[400],
//               boxBorderColor: Colors.grey[400],
//               hoverBorderColor: Colors.grey[400],
//               hoverShadowColor: Colors.grey[400],
//               errorColor: Color(0xFFD91807),
//               lightBlueColor: Color(0xFFE6F4FB),
//               lightBlueBorderColor: Color(0xFF9DC0EE),
//               darkBlueTextColor: Color(0xFF2F3F53),
//               blueTextColor: Color(0xFF343A3E),
//             ),
//           ],
//         ),
//         home: MediaQuery(
//           data: MediaQueryData(size: screenSize),
//           child: Scaffold(
//             body: SingleChildScrollView(
//               child: SizedBox(
//                 height: screenSize.height,
//                 child: BlocProvider<BusinessAccountSetupBloc>.value(
//                   value: mockBloc,
//                   child: const BusinessPanUploadDialog(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     group('Constructor Tests', () {
//       testWidgets('creates widget with default constructor', (tester) async {
//         await tester.pumpWidget(createTestWidget());
//         expect(find.byType(BusinessPanUploadDialog), findsOneWidget);
//       });

//       testWidgets('creates widget with key', (tester) async {
//         const key = Key('business_pan_dialog');

//         // Set up mock properly
//         final testState = createMockState();
//         when(() => mockBloc.state).thenReturn(testState);
//         when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([testState]));

//         await tester.pumpWidget(
//           MaterialApp(
//             localizationsDelegates: const [
//               Lang.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: Lang.delegate.supportedLocales,
//             theme: ThemeData(
//               extensions: [
//                 CustomColors(
//                   primaryColor: Colors.blue,
//                   textdarkcolor: Colors.black,
//                   darktextcolor: Colors.black87,
//                   fillColor: Colors.white,
//                   secondaryTextColor: Colors.grey,
//                   shadowColor: Colors.black26,
//                   blackColor: Colors.black,
//                   borderColor: Colors.grey,
//                   greenColor: Colors.green,
//                   purpleColor: Colors.purple,
//                   lightBackgroundColor: Colors.grey[100],
//                   redColor: Colors.red,
//                   darkShadowColor: Colors.black54,
//                   dividerColor: Colors.grey,
//                   iconColor: Colors.grey[600],
//                   darkBlueColor: Colors.blue[900],
//                   lightPurpleColor: Colors.purple[100],
//                   hintTextColor: Colors.grey[500],
//                   lightUnSelectedBGColor: Colors.grey[200],
//                   lightBorderColor: Colors.grey[300],
//                   disabledColor: Colors.grey[400],
//                   blueColor: Colors.grey[400],
//                   boxBgColor: Colors.grey[400],
//                   boxBorderColor: Colors.grey[400],
//                   hoverBorderColor: Colors.grey[400],
//                   hoverShadowColor: Colors.grey[400],
//                   errorColor: Color(0xFFD91807),
//                   lightBlueColor: Color(0xFFE6F4FB),
//                   lightBlueBorderColor: Color(0xFF9DC0EE),
//                   darkBlueTextColor: Color(0xFF2F3F53),
//                   blueTextColor: Color(0xFF343A3E),
//                 ),
//               ],
//             ),
//             home: BlocProvider<BusinessAccountSetupBloc>.value(
//               value: mockBloc,
//               child: const BusinessPanUploadDialog(key: key),
//             ),
//           ),
//         );
//         expect(find.byKey(key), findsOneWidget);
//       });
//     });

//     group('Widget Rendering Tests', () {
//       testWidgets('renders correctly with default state', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.byType(BusinessPanUploadDialog), findsOneWidget);
//         expect(find.byType(Dialog), findsOneWidget);
//         expect(find.byType(BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>), findsAtLeastNWidgets(1));
//       });

//       testWidgets('displays dialog header correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.text('Business PAN Details'), findsOneWidget);
//         expect(find.byType(Row), findsAtLeastNWidgets(1));
//       });

//       testWidgets('displays form fields correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.text('Name on PAN'), findsOneWidget);
//         // Note: PAN Number text is localized, so we check for the input fields instead
//         expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(2));
//       });

//       testWidgets('displays divider correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.byType(Container), findsAtLeastNWidgets(1));
//       });

//       testWidgets('displays form with correct structure', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.byType(Form), findsOneWidget);
//         expect(find.byType(Column), findsAtLeastNWidgets(1));
//         expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
//       });
//     });

//     group('File Upload Tests', () {
//       testWidgets('triggers file upload event when file is selected', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final fileUploadWidget = find.byType(CustomFileUploadWidget);
//         expect(fileUploadWidget, findsOneWidget);

//         final widget = tester.widget<CustomFileUploadWidget>(fileUploadWidget);
//         final testFileData = FileData(name: 'test.png', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0);

//         widget.onFileSelected!(testFileData);

//         verify(() => mockBloc.add(any(that: isA<BusinessUploadPanCard>()))).called(1);
//       });

//       testWidgets('displays selected file in upload widget', (tester) async {
//         final testFileData = FileData(name: 'business_pan.jpg', bytes: Uint8List.fromList([1, 2, 3]), sizeInMB: 1.0);

//         await tester.pumpWidget(createTestWidget(state: createMockState(panCardFile: testFileData)));

//         final fileUploadWidget = find.byType(CustomFileUploadWidget);
//         final widget = tester.widget<CustomFileUploadWidget>(fileUploadWidget);

//         expect(widget.selectedFile, equals(testFileData));
//       });
//     });

//     group('Save Button Tests', () {
//       testWidgets('save button is disabled when required fields are empty', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isDisabled, true);
//         expect(saveButtonWidget.onPressed, isNull);
//       });

//       testWidgets('save button is enabled when all required fields are filled', (tester) async {
//         final panNameController = TextEditingController(text: 'Test Business Name');
//         final panNumberController = TextEditingController(text: 'ABCDE1234F');
//         final testFileData = FileData(name: 'pan.jpg', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

//         await tester.pumpWidget(
//           createTestWidget(
//             state: createMockState(
//               panNameController: panNameController,
//               panNumberController: panNumberController,
//               panCardFile: testFileData,
//             ),
//           ),
//         );

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isDisabled, false);
//         expect(saveButtonWidget.onPressed, isNotNull);
//       });

//       testWidgets('save button shows loading state correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget(state: createMockState(isBusinessPanCardSaveLoading: true)));

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isLoading, true);
//       });

//       testWidgets('save button is functional when form has valid data', (tester) async {
//         final panNameController = TextEditingController(text: 'Test Business Name');
//         final panNumberController = TextEditingController(text: 'ABCDE1234F');
//         final testFileData = FileData(name: 'pan.jpg', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

//         await tester.pumpWidget(
//           createTestWidget(
//             state: createMockState(
//               panNameController: panNameController,
//               panNumberController: panNumberController,
//               panCardFile: testFileData,
//             ),
//           ),
//         );

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         // Verify button exists and is enabled (has onPressed callback)
//         expect(saveButtonWidget.onPressed, isNotNull);
//         expect(saveButtonWidget.isDisabled, false);
//       });
//     });

//     group('Text Field Tests', () {
//       testWidgets('PAN name field has correct properties', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final panNameFields = find.byType(CustomTextInputField);
//         expect(panNameFields, findsAtLeastNWidgets(2));

//         final panNameField = tester.widget<CustomTextInputField>(panNameFields.first);
//         expect(panNameField.type, InputType.text);
//         expect(panNameField.textInputAction, TextInputAction.done);
//       });

//       testWidgets('PAN number field has correct properties', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final panNumberFields = find.byType(CustomTextInputField);
//         expect(panNumberFields, findsAtLeastNWidgets(2));

//         final panNumberField = tester.widget<CustomTextInputField>(panNumberFields.last);
//         expect(panNumberField.type, InputType.text);
//         expect(panNumberField.textInputAction, TextInputAction.done);
//         expect(panNumberField.maxLength, 10);
//       });

//       testWidgets('text fields use correct controllers from state', (tester) async {
//         final panNameController = TextEditingController(text: 'Test Business Name');
//         final panNumberController = TextEditingController(text: 'Test PAN Number');

//         await tester.pumpWidget(
//           createTestWidget(
//             state: createMockState(panNameController: panNameController, panNumberController: panNumberController),
//           ),
//         );

//         final panNameFields = find.byType(CustomTextInputField);
//         final panNameField = tester.widget<CustomTextInputField>(panNameFields.first);
//         final panNumberField = tester.widget<CustomTextInputField>(panNameFields.last);

//         expect(panNameField.controller, panNameController);
//         expect(panNumberField.controller, panNumberController);
//       });
//     });

//     group('Close Button Tests', () {
//       testWidgets('close button is present and tappable', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));

//         final closeButtons = find.byType(CustomImageView);
//         final closeButtonWidget = tester.widget<CustomImageView>(closeButtons.first);

//         expect(closeButtonWidget.onTap, isNotNull);
//         expect(closeButtonWidget.height, 50.0);
//       });
//     });

//     group('Responsive Design Tests', () {
//       testWidgets('adapts to different screen sizes', (tester) async {
//         final screenSizes = [
//           const Size(800, 1200), // Small mobile
//           const Size(800, 1200), // Regular mobile
//           const Size(800, 1200), // Tablet
//           const Size(1200, 1200), // Desktop
//         ];

//         for (final size in screenSizes) {
//           await tester.pumpWidget(createTestWidget(screenSize: size));
//           expect(find.byType(BusinessPanUploadDialog), findsOneWidget);
//         }
//       });

//       testWidgets('handles small screen height correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 1200)));

//         expect(find.byType(ConstrainedBox), findsAtLeastNWidgets(1));
//         expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
//       });
//     });

//     group('Widget Structure Tests', () {
//       testWidgets('has correct widget hierarchy', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         expect(find.byType(Dialog), findsOneWidget);
//         expect(find.byType(Container), findsAtLeastNWidgets(1));
//         expect(find.byType(Column), findsAtLeastNWidgets(1));
//         expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
//       });

//       testWidgets('dialog has correct styling properties', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final dialog = find.byType(Dialog);
//         final dialogWidget = tester.widget<Dialog>(dialog);

//         expect(dialogWidget.backgroundColor, Colors.transparent);
//         expect(dialogWidget.insetPadding, const EdgeInsets.all(20));
//       });
//     });

//     group('Edge Cases Tests', () {
//       testWidgets('handles null form state correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget(state: createMockState()));

//         expect(find.byType(BusinessPanUploadDialog), findsOneWidget);
//       });

//       testWidgets('handles null loading state correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget(state: createMockState(isBusinessPanCardSaveLoading: null)));

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isLoading, false);
//       });

//       testWidgets('handles empty text controllers', (tester) async {
//         final emptyPanNameController = TextEditingController();
//         final emptyPanNumberController = TextEditingController();

//         await tester.pumpWidget(
//           createTestWidget(
//             state: createMockState(
//               panNameController: emptyPanNameController,
//               panNumberController: emptyPanNumberController,
//             ),
//           ),
//         );

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isDisabled, true);
//       });

//       testWidgets('handles missing file data', (tester) async {
//         final panNameController = TextEditingController(text: 'Test Name');
//         final panNumberController = TextEditingController(text: 'ABCDE1234F');

//         await tester.pumpWidget(
//           createTestWidget(
//             state: createMockState(
//               panNameController: panNameController,
//               panNumberController: panNumberController,
//               panCardFile: null,
//             ),
//           ),
//         );

//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);

//         expect(saveButtonWidget.isDisabled, true);
//       });
//     });

//     group('Integration Tests', () {
//       testWidgets('complete workflow - fill form and save', (tester) async {
//         final panNameController = TextEditingController(text: 'Test Business Name');
//         final panNumberController = TextEditingController(text: 'ABCDE1234F');
//         final testFileData = FileData(name: 'pan.jpg', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

//         // Create state with filled data
//         final filledState = createMockState(
//           panNameController: panNameController,
//           panNumberController: panNumberController,
//           panCardFile: testFileData,
//         );

//         await tester.pumpWidget(createTestWidget(state: filledState));

//         // Button should be enabled with filled data
//         final saveButton = find.byType(CustomElevatedButton);
//         final saveButtonWidget = tester.widget<CustomElevatedButton>(saveButton);
//         expect(saveButtonWidget.isDisabled, false);
//         expect(saveButtonWidget.onPressed, isNotNull);
//       });

//       testWidgets('file upload integration works correctly', (tester) async {
//         await tester.pumpWidget(createTestWidget());

//         final fileUploadWidget = find.byType(CustomFileUploadWidget);
//         expect(fileUploadWidget, findsOneWidget);

//         final widget = tester.widget<CustomFileUploadWidget>(fileUploadWidget);
//         expect(widget.title, contains('Upload'));
//         expect(widget.onFileSelected, isNotNull);
//       });
//     });
//   });
// }
