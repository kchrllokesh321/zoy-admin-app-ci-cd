// import 'package:exchek/core/utils/exports.dart';

// class BusinessPanUploadDialog extends StatelessWidget {
//   const BusinessPanUploadDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
//       builder: (context, state) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(20),
//           child: Container(
//             constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
//             decoration: BoxDecoration(
//               color: Theme.of(context).customColors.fillColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 buildSizedBoxH(25.0),
//                 _buildDialogHeader(context),
//                 buildSizedBoxH(10.0),
//                 divider(context),
//                 ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: ResponsiveHelper.getMaxDialogWidth(context),
//                     maxHeight:
//                         MediaQuery.of(context).size.height < 600
//                             ? MediaQuery.of(context).size.height * 0.52
//                             : MediaQuery.of(context).size.height * 0.7,
//                   ),
//                   child: SingleChildScrollView(
//                     padding: ResponsiveHelper.getScreenPadding(context),
//                     child: Column(
//                       children: [
//                         buildSizedBoxH(20.0),
//                         _buildBusinessPanNameField(context, state),
//                         buildSizedBoxH(24.0),
//                         Form(
//                           key: state.businessPanVerificationKey,
//                           child: Column(
//                             children: [
//                               _buildBusinessPanNumberField(context, state),
//                               buildSizedBoxH(24.0),
//                               _buildUploadPanCard(context, state),
//                             ],
//                           ),
//                         ),
//                         buildSizedBoxH(20.0),
//                         _buildBusinessPanSaveButton(),
//                         buildSizedBoxH(ResponsiveHelper.isWebAndIsNotMobile(context) ? 60.0 : 20.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDialogHeader(BuildContext context) {
//     return Center(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
//         padding: ResponsiveHelper.getScreenPadding(context),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 Lang.of(context).lbl_business_PAN_details,
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.24,
//                 ),
//               ),
//             ),
//             buildSizedboxW(15.0),
//             CustomImageView(
//               imagePath: Assets.images.svgs.icons.icClose.path,
//               height: 50.0,
//               onTap: () {
//                 GoRouter.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget divider(BuildContext context) =>
//       Container(height: 1.5, width: double.maxFinite, color: Theme.of(context).customColors.lightBorderColor);

//   Widget _buildBusinessPanNameField(BuildContext context, BusinessAccountSetupState state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Name on PAN",
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
//             fontWeight: FontWeight.w400,
//             height: 1.22,
//           ),
//         ),
//         buildSizedBoxH(8.0),
//         CustomTextInputField(
//           context: context,
//           type: InputType.text,
//           controller: state.businessPanNameController,
//           textInputAction: TextInputAction.done,
//           contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
//           validator: ExchekValidations.validateRequired,
//         ),
//       ],
//     );
//   }

//   Widget _buildBusinessPanNumberField(BuildContext context, BusinessAccountSetupState state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           Lang.of(context).lbl_pan_number,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
//             fontWeight: FontWeight.w400,
//             height: 1.22,
//           ),
//         ),
//         buildSizedBoxH(8.0),
//         CustomTextInputField(
//           context: context,
//           type: InputType.text,
//           controller: state.businessPanNumberController,
//           textInputAction: TextInputAction.done,
//           contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
//           validator: (value) {
//             return ExchekValidations.validatePANByType(value, "COMPANY");
//           },
//           maxLength: 10,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
//           contextMenuBuilder: customContextMenuBuilder,
//         ),
//       ],
//     );
//   }

//   Widget _buildUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
//     return CustomFileUploadWidget(
//       title: Lang.of(context).lbl_upload_business_pan,
//       selectedFile: state.businessPanCardFile,
//       onFileSelected: (fileData) {
//         context.read<BusinessAccountSetupBloc>().add(BusinessUploadPanCard(fileData));
//       },
//     );
//   }

//   Widget _buildBusinessPanSaveButton() {
//     return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
//       builder: (context, state) {
//         final isDisable =
//             !(state.businessPanCardFile != null &&
//                 state.businessPanNameController.text.isNotEmpty &&
//                 state.businessPanNumberController.text.isNotEmpty);
//         return Align(
//           alignment: Alignment.centerRight,
//           child: CustomElevatedButton(
//             isShowTooltip: true,
//             text: Lang.of(context).lbl_save,
//             borderRadius: 8.0,
//             width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
//             buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w500,
//               fontSize: 16.0,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             isLoading: state.isBusinessPanCardSaveLoading ?? false,
//             isDisabled: isDisable,
//             tooltipMessage: Lang.of(context).lbl_tooltip_text,
//             onPressed:
//                 isDisable
//                     ? null
//                     : () {
//                       if (state.businessPanVerificationKey.currentState?.validate() ?? false) {
//                         context.read<BusinessAccountSetupBloc>().add(
//                           SaveBusinessPanDetails(
//                             panName: state.businessPanNameController.text,
//                             panNumber: state.businessPanNumberController.text,
//                             fileData: state.businessPanCardFile,
//                           ),
//                         );
//                       }
//                     },
//           ),
//         );
//       },
//     );
//   }
// }
