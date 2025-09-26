import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';

/// Utility class to manage KYC step lists for different business types
class KycStepUtils {
  /// Get the list of KYC steps for a given business type
  static List<KycVerificationSteps> getStepsForBusinessType(String businessType, [dynamic state]) {
    switch (businessType) {
      case 'company':
        return [
          KycVerificationSteps.panVerification,
          KycVerificationSteps.companyIncorporationVerification,
          KycVerificationSteps.annualTurnoverDeclaration,
          KycVerificationSteps.iecVerification,
          KycVerificationSteps.aadharPanVerification,
          KycVerificationSteps.beneficialOwnershipVerification,
          KycVerificationSteps.contactInformation,
          KycVerificationSteps.registeredOfficeAddress,
          KycVerificationSteps.bankAccountLinking,
        ];

      case 'limited_liability_partnership':
      case 'partnership':
        return [
          KycVerificationSteps.panVerification,
          KycVerificationSteps.companyIncorporationVerification,
          KycVerificationSteps.annualTurnoverDeclaration,
          KycVerificationSteps.iecVerification,
          KycVerificationSteps.aadharPanVerification,
          KycVerificationSteps.beneficialOwnershipVerification,
          KycVerificationSteps.contactInformation,
          KycVerificationSteps.registeredOfficeAddress,
          KycVerificationSteps.bankAccountLinking,
        ];

      case 'hindu_undivided_family':
        return [
          KycVerificationSteps.panVerification,
          KycVerificationSteps.aadharPanVerification,
          KycVerificationSteps.iecVerification,
          KycVerificationSteps.registeredOfficeAddress,
          KycVerificationSteps.bankAccountLinking,
        ];

      case 'sole_proprietor':
        bool isGstUploaded = false;
        bool isIceUploaded = false;

        if (state != null) {
          isGstUploaded =
              state.gstCertificateFile != null &&
              state.gstNumberController.text.isNotEmpty &&
              state.gstLegalName != null;
          isIceUploaded = state.iceCertificateFile != null && state.iceNumberController.text.isNotEmpty;
        }

        if (isGstUploaded || isIceUploaded) {
          return [
            KycVerificationSteps.panVerification,
            KycVerificationSteps.annualTurnoverDeclaration,
            KycVerificationSteps.iecVerification,
            KycVerificationSteps.aadharPanVerification,
            KycVerificationSteps.registeredOfficeAddress,
            KycVerificationSteps.bankAccountLinking,
          ];
        } else {
          return [
            KycVerificationSteps.panVerification,
            KycVerificationSteps.annualTurnoverDeclaration,
            KycVerificationSteps.iecVerification,
            KycVerificationSteps.businessDocumentsVerification,
            KycVerificationSteps.aadharPanVerification,
            KycVerificationSteps.registeredOfficeAddress,
            KycVerificationSteps.bankAccountLinking,
          ];
        }

      default:
        // Default case for other business types
        return KycVerificationSteps.values
            .where(
              (step) =>
                  step != KycVerificationSteps.companyIncorporationVerification &&
                  step != KycVerificationSteps.contactInformation,
            )
            .toList();
    }
  }

  /// Get the list of KYC steps for a given business type from user details
  static Future<List<KycVerificationSteps>> getStepsForCurrentUser([dynamic state]) async {
    try {
      final userDetailString = await Prefobj.preferences.get(Prefkeys.userKycDetail);

      if (userDetailString != null) {
        final userDetail = jsonDecode(userDetailString);
        final businessDetails = userDetail['business_details'];
        final businessType = businessDetails != null ? businessDetails['business_type'] : null;

        if (businessType != null) {
          return getStepsForBusinessType(businessType, state);
        }
      }

      // Fallback to default steps
      return KycVerificationSteps.values
          .where(
            (step) =>
                step != KycVerificationSteps.companyIncorporationVerification &&
                step != KycVerificationSteps.contactInformation,
          )
          .toList();
    } catch (e) {
      debugPrint('Error getting steps for current user: $e');
      // Fallback to default steps
      return KycVerificationSteps.values
          .where(
            (step) =>
                step != KycVerificationSteps.companyIncorporationVerification &&
                step != KycVerificationSteps.contactInformation,
          )
          .toList();
    }
  }

  /// Get filtered steps based on API response data - shows only remaining incomplete steps
  static Future<List<KycVerificationSteps>> getFilteredStepsFromApiData(Map<String, dynamic> apiData) async {
    try {
      final businessDetails = apiData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      final panDetails = apiData['pan_details'] ?? {};
      final kartaPanDetails = apiData['karta_pan_details'] ?? {};
      final businessIdentity = apiData['business_identity'] ?? {};
      final iecDetails = apiData['iec_details'] ?? {};
      final address = apiData['user_address_documents'] ?? {};
      final gst = apiData['user_gst_details'] ?? {};
      final bankDetails = apiData['user_bank_details'] ?? {};
      final businessDirectorListRaw = apiData['business_director_list'] as List? ?? [];

      // Get all available steps for this business type
      final allSteps = getStepsForBusinessType(businessType);
      final filteredSteps = <KycVerificationSteps>[];

      // Check completion status for each step
      for (final step in allSteps) {
        bool isStepCompleted = false;

        switch (step) {
          case KycVerificationSteps.panVerification:
            // Check if PAN is completed
            isStepCompleted = panDetails['document_number'] != null && panDetails['pan_verify_status'] == 'SUBMITTED';
            break;

          case KycVerificationSteps.aadharPanVerification:
            // Check if Aadhaar is completed
            if (businessType == 'hindu_undivided_family') {
              // For HUF, check Karta Aadhaar
              isStepCompleted =
                  businessIdentity['document_type'] == 'Aadhaar' && businessIdentity['document_number'] != null;
            } else {
              // For other business types, check director Aadhaar
              final authDirectorAadhaar = businessDirectorListRaw.firstWhere(
                (director) => director['director_type'] == 'AUTH_DIRECTOR' && director['document_type'] == 'Aadhaar',
                orElse: () => null,
              );
              isStepCompleted = authDirectorAadhaar != null && authDirectorAadhaar['verify_status'] == 'SUBMITTED';
            }
            break;

          case KycVerificationSteps.registeredOfficeAddress:
            // Check if address is completed
            isStepCompleted = address['front_doc_url'] != null && address['resident_verify_status'] == 'SUBMITTED';
            break;

          case KycVerificationSteps.annualTurnoverDeclaration:
            // Check if turnover is completed
            isStepCompleted =
                gst['estimated_annual_income'] != null &&
                gst['estimated_annual_income'].toString().isNotEmpty &&
                gst['gst_certificate_url'] != null;
            break;

          case KycVerificationSteps.iecVerification:
            // Check if ICE is completed
            isStepCompleted = iecDetails['document_number'] != null && iecDetails['doc_url'] != null;
            break;

          case KycVerificationSteps.companyIncorporationVerification:
            // Check if incorporation document is completed
            if (businessType == 'company') {
              isStepCompleted =
                  businessIdentity['document_type'] == 'CIN' &&
                  businessIdentity['document_number'] != null &&
                  businessIdentity['front_doc_url'] != null;
            } else if (businessType == 'limited_liability_partnership') {
              isStepCompleted =
                  businessIdentity['document_type'] == 'LLPIN' &&
                  businessIdentity['document_number'] != null &&
                  businessIdentity['front_doc_url'] != null &&
                  businessIdentity['back_doc_url'] != null;
            } else if (businessType == 'partnership') {
              isStepCompleted =
                  businessIdentity['document_type'] == 'PARTNERSHIP_DEED' && businessIdentity['front_doc_url'] != null;
            }
            break;

          case KycVerificationSteps.bankAccountLinking:
            // Check if bank details are completed
            isStepCompleted = bankDetails['account_number'] != null && bankDetails['ifsc_code'] != null;
            break;

          case KycVerificationSteps.contactInformation:
            isStepCompleted = false;
            break;

          case KycVerificationSteps.beneficialOwnershipVerification:
            // Check if beneficial ownership is completed
            // This is for company/LLP/partnership with multiple directors
            if (businessType == 'company' ||
                businessType == 'limited_liability_partnership' ||
                businessType == 'partnership') {
              final otherDirectorPan = businessDirectorListRaw.firstWhere(
                (director) => director['director_type'] == 'OTHER_DIRECTOR' && director['document_type'] == 'Pan',
                orElse: () => null,
              );
              isStepCompleted = otherDirectorPan != null && otherDirectorPan['verify_status'] == 'SUBMITTED';
            } else {
              isStepCompleted = true; // Skip for other business types
            }
            break;

          case KycVerificationSteps.businessDocumentsVerification:
            // Check if business documents are completed
            // This is for sole proprietor with GST/ICE
            if (businessType == 'sole_proprietor') {
              isStepCompleted =
                  (gst['gst_number'] != null && gst['gst_certificate_url'] != null) ||
                  (iecDetails['document_number'] != null && iecDetails['doc_url'] != null);
            } else {
              isStepCompleted = true; // Skip for other business types
            }
            break;
        }

        // Only add incomplete steps to the filtered list
        if (!isStepCompleted) {
          filteredSteps.add(step);
        }
      }

      return filteredSteps;
    } catch (e) {
      debugPrint('Error getting filtered steps from API data: $e');
      // Fallback to all steps if there's an error
      final businessDetails = apiData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      return getStepsForBusinessType(businessType);
    }
  }

  /// Get all steps for business type (for display purposes)
  static Future<List<KycVerificationSteps>> getAllStepsForDisplay(Map<String, dynamic> apiData) async {
    try {
      final businessDetails = apiData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      return getStepsForBusinessType(businessType);
    } catch (e) {
      debugPrint('Error getting all steps for display: $e');
      return [];
    }
  }

  /// Get the first incomplete step from API data
  static Future<KycVerificationSteps?> getFirstIncompleteStep(Map<String, dynamic> apiData) async {
    try {
      final filteredSteps = await getFilteredStepsFromApiData(apiData);
      if (filteredSteps.isNotEmpty) {
        return filteredSteps.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting first incomplete step: $e');
      return null;
    }
  }

  /// Get the next step from the current step
  static Future<KycVerificationSteps?> getNextStep(KycVerificationSteps currentStep, [dynamic state]) async {
    try {
      final steps = await getStepsForCurrentUser(state);
      final currentIndex = steps.indexOf(currentStep);

      if (currentIndex >= 0 && currentIndex < steps.length - 1) {
        return steps[currentIndex + 1];
      }

      return null;
    } catch (e) {
      print('Error getting next step: $e');
      return null;
    }
  }

  /// Get the next step from filtered steps list
  static KycVerificationSteps? getNextStepFromFilteredSteps(
    KycVerificationSteps currentStep,
    List<KycVerificationSteps> filteredSteps,
  ) {
    try {
      final currentIndex = filteredSteps.indexOf(currentStep);

      if (currentIndex >= 0 && currentIndex < filteredSteps.length - 1) {
        final nextStep = filteredSteps[currentIndex + 1];
        return nextStep;
      }
      return null;
    } catch (e) {
      print('Error getting next step from filtered steps: $e');
      return null;
    }
  }

  /// Get the previous step from filtered steps list
  static KycVerificationSteps? getPreviousStepFromFilteredSteps(
    KycVerificationSteps currentStep,
    List<KycVerificationSteps> filteredSteps,
  ) {
    try {
      final currentIndex = filteredSteps.indexOf(currentStep);

      if (currentIndex > 0) {
        final previousStep = filteredSteps[currentIndex - 1];
        return previousStep;
      }

      return null;
    } catch (e) {
      print('Error getting previous step from filtered steps: $e');
      return null;
    }
  }

  /// Get the previous step from the current step
  static Future<KycVerificationSteps?> getPreviousStep(KycVerificationSteps currentStep, [dynamic state]) async {
    try {
      final steps = await getStepsForCurrentUser(state);
      final currentIndex = steps.indexOf(currentStep);

      if (currentIndex > 0) {
        return steps[currentIndex - 1];
      }

      return null;
    } catch (e) {
      print('Error getting previous step: $e');
      return null;
    }
  }

  // /// Check if a step is valid for the current business type
  // static Future<bool> isStepValid(KycVerificationSteps step) async {
  //   try {
  //     final steps = await getStepsForCurrentUser();
  //     return steps.contains(step);
  //   } catch (e) {
  //     print('Error checking if step is valid: $e');
  //     return false;
  //   }
  // }

  /// Get the effective current step (handles cases where current step is not in the list)
  // static Future<KycVerificationSteps> getEffectiveCurrentStep(KycVerificationSteps currentStep) async {
  //   try {
  //     final steps = await getStepsForCurrentUser();

  //     if (steps.contains(currentStep)) {
  //       return currentStep;
  //     }

  //     // If current step is not in the list, find the next valid step
  //     final currentIndex = KycVerificationSteps.values.indexOf(currentStep);
  //     final nextStep = steps.firstWhere(
  //       (step) => KycVerificationSteps.values.indexOf(step) > currentIndex,
  //       orElse: () => steps.first,
  //     );

  //     return nextStep;
  //   } catch (e) {
  //     print('Error getting effective current step: $e');
  //     return currentStep;
  //   }
  // }

  // /// Get business type from user details
  static Future<String?> getBusinessType() async {
    try {
      final userDetailString = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userDetailString != null) {
        final userDetail = jsonDecode(userDetailString);
        final businessDetails = userDetail['business_details'];
        return businessDetails != null ? businessDetails['business_type'] : null;
      }
      return null;
    } catch (e) {
      print('Error getting business type: $e');
      return null;
    }
  }

  static Future<String?> getBusinessNature() async {
    try {
      final userDetailString = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userDetailString != null) {
        final userDetail = jsonDecode(userDetailString);
        final businessNature = userDetail['business_details']['business_nature'];
        return businessNature;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future getNextKycStep(KycVerificationSteps currentKycVerificationStep) async {}
}

/// Generic utility for PAN edit attempt/lockout logic
class PanEditLockoutResult {
  final bool isLocked;
  final int attempts;
  final DateTime? lockTime;
  final String errorMessage;
  final bool shouldUnlock;
  final bool showLimitReachedDialog;

  PanEditLockoutResult({
    required this.isLocked,
    required this.attempts,
    required this.lockTime,
    required this.errorMessage,
    required this.shouldUnlock,
    this.showLimitReachedDialog = false,
  });
}

/// Dialog information for PAN edit limit reached
class PanEditLimitDialogInfo {
  final String title;
  final String subtitle;
  final String buttonText;

  PanEditLimitDialogInfo({required this.title, required this.subtitle, required this.buttonText});
}

/// Get dialog information for PAN edit limit reached
PanEditLimitDialogInfo getPanEditLimitDialogInfo({String panType = 'PAN'}) {
  return PanEditLimitDialogInfo(
    title: '$panType Edit Limit reached',
    subtitle: 'Updating $panType is now locked. You can try again after 24 hours.',
    buttonText: 'OK',
  );
}

/// Global dialog service to show dialogs without context
class GlobalDialogService {
  // static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void showPanEditLimitDialog({String panType = 'PAN'}) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(24.0),
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "PAN Edit Limit Reached",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22.0),
                ),
                buildSizedBoxH(10),
                Text(
                  "Updating PAN is now locked. You can try again after 24 hours.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0),
                ),
                buildSizedBoxH(16),
                Row(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.0)),
                    ),
                    CustomElevatedButton(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      borderRadius: 5.0,
                      width: 50.0,
                      height: 35.0,
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      text: "OK",
                      buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                        color: Theme.of(context).customColors.fillColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

PanEditLockoutResult handlePanEditAttempt({
  required bool isLocked,
  required DateTime? lockTime,
  required int attempts,
  int maxAttempts = 3,
  int lockHours = 24,
  String panType = 'PAN',
}) {
  final now = DateTime.now();
  String errorMessage = '';

  if (isLocked) {
    if (lockTime != null) {
      final difference = now.difference(lockTime);
      if (difference.inHours >= lockHours) {
        return PanEditLockoutResult(isLocked: false, attempts: 0, lockTime: null, errorMessage: '', shouldUnlock: true);
      } else {
        // final remainingHours = lockHours - difference.inHours;
        errorMessage = 'This is your last attempt.Please validate your PAN carefully before clicking verify.';

        GlobalDialogService.showPanEditLimitDialog(panType: panType);

        return PanEditLockoutResult(
          isLocked: true,
          attempts: attempts,
          lockTime: lockTime,
          errorMessage: errorMessage,
          shouldUnlock: false,
          showLimitReachedDialog: true,
        );
      }
    }

    return PanEditLockoutResult(
      isLocked: true,
      attempts: attempts,
      lockTime: lockTime,
      errorMessage: errorMessage,
      shouldUnlock: false,
      showLimitReachedDialog: true,
    );
  }

  final newAttempts = attempts + 1;
  if (newAttempts == 1) {
    errorMessage = '';
  } else if (newAttempts == 2) {
    errorMessage = 'You can edit your PAN up to 3 times.';
  } else if (newAttempts == maxAttempts) {
    errorMessage = 'Please double check only 2 attempts remain.';
  } else if (newAttempts > maxAttempts) {
    errorMessage = 'This is your last attempt.Please validate your PAN carefully before clicking verify.';

    // // Show dialog when limit is first reached
    // GlobalDialogService.showPanEditLimitDialog(panType: panType);

    return PanEditLockoutResult(
      isLocked: true,
      attempts: newAttempts,
      lockTime: now,
      errorMessage: errorMessage,
      shouldUnlock: false,
      showLimitReachedDialog: true,
    );
  }
  return PanEditLockoutResult(
    isLocked: false,
    attempts: newAttempts,
    lockTime: lockTime,
    errorMessage: errorMessage,
    shouldUnlock: false,
  );
}
