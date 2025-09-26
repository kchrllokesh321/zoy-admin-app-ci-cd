import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_bloc.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_state.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart' as clients_event;
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_event.dart' as transection_event;

class ProfileDropdown extends StatelessWidget {
  final String userName;
  final bool isBusinessUser;
  final String email;
  final VoidCallback? onManageAccount;
  final VoidCallback? onChangePassword;
  final VoidCallback? onLogout;
  final bool isNameDataVisible;

  const ProfileDropdown({
    super.key,
    required this.userName,
    required this.isBusinessUser,
    required this.email,
    this.onManageAccount,
    this.onChangePassword,
    this.onLogout,
    this.isNameDataVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String userName = authState.userName ?? '';
    String email = authState.email ?? '';
    String phoneNumber = authState.phoneNumber ?? '';

    return FutureBuilder<List<String>>(
      future: () async {
        if (userName.isEmpty) {
          userName = await Prefobj.preferences.get(Prefkeys.loggedUserName) ?? '';
        }
        if (email.isEmpty) {
          email = await Prefobj.preferences.get(Prefkeys.loggedEmail) ?? '';
        }
        if (phoneNumber.isEmpty) {
          phoneNumber = await Prefobj.preferences.get(Prefkeys.loggedPhoneNumber) ?? '';
        }
        return [userName, email, phoneNumber];
      }(),
      builder: (context, snapshot) {
        final userNameVal = snapshot.data?[0] ?? '';
        final emailVal = snapshot.data?[1] ?? '';
        return BlocListener<ProfileDropdownBloc, ProfileDropdownState>(
          listener: (context, state) {
            if (state is ProfileDropdownLogoutSuccess) {
              TokenManager.stopScheduler();
              context.read<BusinessAccountSetupBloc>().cron?.close();
              context.read<PersonalAccountSetupBloc>().cron?.close();

              Prefobj.preferences.deleteAll();
              context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
              // Reset all dashboard blocs to initial state
              // context.read<DashboardBloc>().add(ResetRequested());
              context.read<ClientsBloc>().add(clients_event.ResetRequested());
              context.read<TransectionBloc>().add(transection_event.ResetRequested());
            } else if (state is ProfileDropdownLogoutFailure) {
              AppToast.show(message: state.message, type: ToastificationType.error);
            }
          },
          child: BlocBuilder<ProfileDropdownBloc, ProfileDropdownState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                offset: const Offset(0, kIsWeb ? 90 : 60),
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                elevation: 8,
                color: Colors.grey.shade50,
                shadowColor: Theme.of(context).customColors.shadowColor!.withValues(alpha: 0.25),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding:
                      ResponsiveHelper.isWebAndIsNotMobile(context)
                          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                          : const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  decoration: BoxDecoration(color: Theme.of(context).customColors.fillColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).customColors.primaryColor,
                        child: Text(
                          getInitials(userNameVal),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      if (isNameDataVisible) ...[
                        buildSizedboxW(10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userNameVal,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                                color: Theme.of(context).customColors.blackColor,
                              ),
                            ),
                            FutureBuilder<String>(
                              future: _getUserAccountType(),
                              builder: (context, snapshot) {
                                String accountType = "Account";
                                if (snapshot.hasData) {
                                  accountType = snapshot.data!;
                                }
                                return Text(
                                  accountType,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      mobile: 12,
                                      tablet: 12,
                                      desktop: 12,
                                    ),
                                    color: Theme.of(context).customColors.greyTextColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'view_profile_header':
                    case 'view_profile':
                      break;
                    case 'manage_account':
                      onManageAccount?.call();
                      break;
                    case 'change_password':
                      break;
                    case 'logout':
                      _showLogoutConfirmationDialog(context, emailVal);
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem<String>(
                        padding: EdgeInsets.zero,
                        value: 'view_profile_header',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).customColors.fillColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).customColors.darkShadowColor!.withValues(alpha: 0.03),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          // padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              //   child: CircleAvatar(
                              //     radius: 20,
                              //     backgroundColor: Theme.of(context).customColors.primaryColor,
                              //     child: Text(
                              //       getInitials(userNameVal),
                              //       style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              //     ),
                              //   ),
                              // ),
                              // buildSizedboxW(8.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userNameVal,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).customColors.blackColor,
                                      ),
                                    ),
                                    Text(
                                      emailVal,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).customColors.darktextcolor,
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "+91 ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).customColors.darktextcolor,
                                          ),
                                        ),
                                        Text(
                                          phoneNumber,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).customColors.darktextcolor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: _buildMenuItem(
                          context: context,
                          iconWidget: CustomImageView(
                            imagePath: Assets.images.svgs.icons.profileLogout.path,
                            height: 18.0,
                          ),
                          text: 'Log out',
                        ),
                      ),
                    ],
              );
            },
          ),
        );
      },
    );
  }

  /// -------------------- Logout Confirmation Dialog --------------------
  void _showLogoutConfirmationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(Lang.of(context).profile_confirmLogout),
          content: Text(Lang.of(context).profile_logoutConfirmationMessage),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                TokenManager.stopScheduler();
                context.read<BusinessAccountSetupBloc>().cron?.close();
                context.read<PersonalAccountSetupBloc>().cron?.close();

                Prefobj.preferences.deleteAll();
                context.read<ProfileDropdownBloc>().add(LogoutWithEmailRequested(email, context));
              },
              child: Text('Logout', style: TextStyle(color: Theme.of(context).customColors.redColor)),
            ),
          ],
        );
      },
    );
  }

  /// -------------------- Menu Item Widget --------------------
  Widget _buildMenuItem({required BuildContext context, required Widget iconWidget, String? text, Widget? child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 32, height: 32, child: Center(child: iconWidget)),
          buildSizedboxW(10.0),
          child ??
              Text(
                text ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).customColors.blackColor,
                ),
              ),
        ],
      ),
    );
  }

  Future<String> _getUserAccountType() async {
    try {
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        final userType = userData['user_type'];

        if (userType == 'personal') {
          return 'Personal Account';
        } else if (userType == 'business') {
          return 'Business Account';
        } else {
          return 'Account';
        }
      }
      return 'Account';
    } catch (e) {
      return 'Account';
    }
  }
}
