// import 'package:exchek/core/utils/exports.dart';
// import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
// import 'package:exchek/widgets/account_setup_widgets/upload_note.dart';

// class SelfieView extends StatelessWidget {
//   const SelfieView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveScaffold(
//       body: ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: ResponsiveHelper.isWebAndIsNotMobile(context) ? 50 : 20),
//           child: Center(
//             child: Container(
//               constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
//               padding: EdgeInsetsGeometry.symmetric(
//                 horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildSizedBoxH(20),
//                   _buildTitle(context),
//                   buildSizedBoxH(20),
//                   _buildSubtitle(context),
//                   buildSizedBoxH(30),
//                   _buildSmileyIcon(context),
//                   buildSizedBoxH(30),
//                   _buildInstructionsContainer(context),
//                   buildSizedBoxH(30),
//                   _buildDisclaimerText(context),
//                   buildSizedBoxH(60),
//                   _buildContinueButton(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         Lang.of(context).lbl_selfie,
//         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//           fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.32,
//         ),
//       ),
//     );
//   }

//   Widget _buildSubtitle(BuildContext context) {
//     return Text(
//       Lang.of(context).lbl_to_ensure_secure,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 16),
//       ),
//     );
//   }

//   Widget _buildSmileyIcon(BuildContext context) {
//     return CustomImageView(
//       height: ResponsiveHelper.getWidgetHeight(context, mobile: 60, tablet: 60, desktop: 70),
//       width: ResponsiveHelper.getWidgetHeight(context, mobile: 60, tablet: 60, desktop: 70),
//       imagePath: Assets.images.svgs.icons.icSmiley.path,
//     );
//   }

//   Widget _buildInstructionsContainer(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 12, desktop: 22)),
//       decoration: BoxDecoration(
//         color: Theme.of(context).customColors.lightBackgroundColor?.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [_buildInstructionsHeader(context), buildSizedBoxH(14), _buildUploadNotes(context)],
//       ),
//     );
//   }

//   Widget _buildInstructionsHeader(BuildContext context) {
//     return Text(
//       Lang.of(context).lbl_please_ensure_your,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 16),
//         letterSpacing: 0.16,
//       ),
//     );
//   }

//   Widget _buildUploadNotes(BuildContext context) {
//     return CustomUploadNote(
//       nots: [
//         Lang.of(context).lbl_maximize_screen_brightness,
//         Lang.of(context).lbl_well_fit_area,
//         Lang.of(context).lbl_no_glasses_mask_hat,
//       ],
//     );
//   }

//   Widget _buildDisclaimerText(BuildContext context) {
//     return Text(
//       Lang.of(context).lbl_please_be_mindful_that,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 16),
//       ),
//     );
//   }

//   Widget _buildContinueButton(BuildContext context) {
//     return CustomElevatedButton(
//       text: Lang.of(context).lbl_continue,
//       borderRadius: 100,
//       onPressed: () {
//         context.read<PersonalAccountSetupBloc>().add(InitializeSelfieEvent());
//         if (kIsWeb) {
//           GoRouter.of(context).go(RouteUri.cameraView);
//         } else {
//           GoRouter.of(context).push(RouteUri.cameraView);
//         }
//       },
//     );
//   }
// }
