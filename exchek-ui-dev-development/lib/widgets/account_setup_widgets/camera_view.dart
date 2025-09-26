//TODO: SELFIE STEP HOLD FOR NOW
// import 'dart:developer';

// import 'package:camera/camera.dart';
// import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
// import 'package:exchek/core/utils/exports.dart';
// import 'package:exchek/widgets/common_widget/app_loader_widget.dart';

// class CameraView extends StatelessWidget {
//   const CameraView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PersonalAccountSetupBloc, PersonalAccountSetupState>(
//       listener: (context, state) {
//         if (state.errorMessage != null && state.errorMessage!.contains('Failed to capture')) {
//           log('>>> Error message: ${state.errorMessage}');
//         }

//         if (state.isImageSubmitted) {
//           log('>>> Image submitted');
//         }
//       },
//       child: ResponsiveScaffold(
//         body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 42.0 : 26.0),
//           child: Center(
//             child: Container(
//               constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
//               padding: EdgeInsetsGeometry.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 30.0 : 0.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
//                     builder: (context, state) {
//                       if (state.isLoading) {
//                         return _buildLoadingView(context);
//                       } else if (state.errorMessage != null) {
//                         return _buildErrorView(context, state);
//                       } else if (state.cameraController != null && state.imageBytes == null) {
//                         return _buildCameraPreview(context, state.cameraController!);
//                       } else if (state.imageBytes != null) {
//                         return _buildCapturedImagePreview(context, state.imageBytes!);
//                       } else if (state.isImageSubmitted) {
//                         return _buildSubmittedView(context);
//                       }
//                       return Container();
//                     },
//                   ),
//                   buildSizedBoxH(64),
//                   BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
//                     builder: (context, state) {
//                       if (state.isLoading) {
//                         return Container();
//                       } else if (state.errorMessage != null) {
//                         return _buildErrorButtons(context, state);
//                       } else if (state.cameraController != null && state.imageBytes == null) {
//                         return _buildCameraButtons(context, state);
//                       } else if (state.imageBytes != null) {
//                         return _buildImageCapturedButtons(context, state);
//                       }
//                       return Container();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCameraPreview(BuildContext context, CameraController controller) {
//     return Container(
//       height: 350,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
//       clipBehavior: Clip.hardEdge,
//       child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: CameraPreview(controller)),
//     );
//   }

//   Widget _buildCapturedImagePreview(BuildContext context, Uint8List imageBytes) {
//     return Container(
//       height: 350,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
//       clipBehavior: Clip.hardEdge,
//       child: Image.memory(imageBytes, fit: BoxFit.cover, width: double.infinity, height: 350),
//     );
//   }

//   Widget _buildCameraButtons(BuildContext context, PersonalAccountSetupState state) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: CustomElevatedButton(
//         width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 123 : double.maxFinite,
//         text: Lang.of(context).lbl_take,
//         borderRadius: 100,
//         isLoading: state.isLoading,
//         isDisabled: state.isLoading,
//         onPressed: () => context.read<PersonalAccountSetupBloc>().add(CaptureImageEvent()),
//       ),
//     );
//   }

//   Widget _buildImageCapturedButtons(BuildContext context, PersonalAccountSetupState state) {
//     return ResponsiveHelper.isWebAndIsNotMobile(context)
//         ? Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [_buildRetakeButton(context, state), buildSizedboxW(10), _buildSubmitButton(context, state)],
//         )
//         : Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(child: _buildRetakeButton(context, state)),
//             buildSizedboxW(10),
//             Expanded(child: _buildSubmitButton(context, state)),
//           ],
//         );
//   }

//   Widget _buildSubmitButton(BuildContext context, PersonalAccountSetupState state) {
//     return CustomElevatedButton(
//       width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 123 : double.maxFinite,
//       text: Lang.of(context).lbl_submit,
//       borderRadius: 100,
//       isLoading: state.isImageSubmitted,
//       isDisabled: state.isImageSubmitted,
//       onPressed: () => context.read<PersonalAccountSetupBloc>().add(SubmitImageEvent()),
//     );
//   }

//   Widget _buildRetakeButton(BuildContext context, PersonalAccountSetupState state) {
//     return CustomElevatedButton(
//       width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 123 : double.maxFinite,
//       text: Lang.of(context).lbl_retake,
//       isLoading: state.isLoading,
//       isDisabled: state.isLoading,
//       buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         color: Theme.of(context).customColors.primaryColor,
//         fontWeight: FontWeight.w600,
//         fontSize: 16.0,
//       ),
//       borderRadius: 100,
//       buttonStyle: ButtonThemeHelper.textButtonStyle(context),
//       onPressed: () {
//         context.read<PersonalAccountSetupBloc>().add(RetakeImageEvent());
//       },
//     );
//   }

//   Widget _buildErrorView(BuildContext context, PersonalAccountSetupState state) {
//     return Container(
//       height: 350,
//       decoration: BoxDecoration(
//         color: Theme.of(context).customColors.lightPurpleColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.camera_alt_outlined, size: 64, color: Theme.of(context).disabledColor),
//             buildSizedBoxH(16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 state.errorMessage!,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorButtons(BuildContext context, PersonalAccountSetupState state) {
//     if (!state.hasPermission) {
//       return CustomElevatedButton(
//         onPressed: () => context.read<PersonalAccountSetupBloc>().add(RequestPermissionEvent()),
//         text: Lang.of(context).lbl_grant_camera_permission,
//       );
//     }
//     return Container();
//   }

//   Widget _buildLoadingView(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 350,
//           decoration: BoxDecoration(
//             color: Theme.of(context).customColors.lightPurpleColor,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Center(child: AppLoaderWidget()),
//         ),
//         buildSizedBoxH(50),
//         Text(
//           Lang.of(context).lbl_loading_please_wait,
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmittedView(BuildContext context) {
//     return Container(
//       height: 350,
//       decoration: BoxDecoration(
//         color: Theme.of(context).customColors.lightPurpleColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
//             buildSizedBoxH(16),
//             Text(
//               Lang.of(context).lbl_image_submitted_successfully,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
