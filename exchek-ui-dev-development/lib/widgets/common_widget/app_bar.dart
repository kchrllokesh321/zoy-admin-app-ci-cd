import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/profile_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchekAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClose;
  final VoidCallback? onHelp;
  final String? title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Widget? leading;
  final String? mobileTitle;
  final bool showCloseButton;
  final bool centerTitle;
  final double? elevation;
  final bool isShowHelp;
  final BuildContext appBarContext;
  final Widget? titleWidget;

  // New parameters for profile functionality
  final bool showProfile;
  final String? userName;
  final bool isBusinessUser;
  final VoidCallback? onLogout;
  final String? email;

  const ExchekAppBar({
    super.key,
    this.onClose,
    this.onHelp,
    this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.leading,
    this.mobileTitle,
    this.showCloseButton = true,
    this.centerTitle = false,
    this.elevation,
    this.showProfile = false,
    this.userName,
    this.isBusinessUser = false,
    this.onLogout,
    this.email,
    this.isShowHelp = true,
    required this.appBarContext,
    this.titleWidget,
  });

  static double appBarHeight = 99.0;
  static double webAppBarHeight = 99.0;
  static double mobileAppBarHeight = 59.0;

  @override
  Widget build(BuildContext context) {
    appBarHeight = ResponsiveHelper.isWebAndIsNotMobile(context) ? webAppBarHeight : mobileAppBarHeight;
    return ResponsiveHelper.isWebAndIsNotMobile(context) ? _buildWebAppBar(context) : _buildMobileAppBar(context);
  }

  Widget _buildWebAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: webAppBarHeight,
      elevation: elevation ?? 8.0,
      shadowColor: Theme.of(context).customColors.shadowColor?.withValues(alpha: 0.05),
      backgroundColor: Theme.of(context).customColors.fillColor,
      centerTitle: true,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      leading: leading,
      title:
          titleWidget ??
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildLogo(context), isShowHelp ? _buildWebRightSection(context) : SizedBox.shrink()],
            ),
          ),
    );
  }

  Widget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: mobileAppBarHeight,
      elevation: elevation,
      shadowColor: Theme.of(context).customColors.shadowColor?.withValues(alpha: 0.05),
      backgroundColor: Theme.of(context).customColors.fillColor,
      centerTitle: true,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      leading: leading ?? _buildBackButton(context),
      leadingWidth: leading != null ? 120 : null,
      title: titleWidget ?? _buildMobileTitle(context),
      actions: _buildMobileActions(context),
    );
  }

  List<Widget>? _buildMobileActions(BuildContext context) {
    if (showProfile && userName != null) {
      return [
        Row(
          children: [
            ProfileDropdown(
              email: email ?? '',
              userName: userName!,
              isBusinessUser: isBusinessUser,
              onLogout: onLogout,
            ),
          ],
        ),
      ];
    } else if (showCloseButton) {
      return [_buildCloseButton(context), buildSizedboxW(16.0)];
    }
    return null;
  }

  Widget _buildWebRightSection(BuildContext context) {
    List<Widget> rightWidgets = [
      // _buildHelpButton(context), buildSizedboxW(32.0)
    ];

    if (showProfile && userName != null) {
      rightWidgets.addAll([
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ProfileDropdown(
            email: email ?? '',
            userName: userName!,
            isBusinessUser: isBusinessUser,
            onLogout: onLogout,
          ),
        ),
      ]);
    } else if (showCloseButton) {
      rightWidgets.addAll([_buildCloseButton(context), buildSizedboxW(32.0)]);
    }

    return Row(children: rightWidgets);
  }

  Widget? _buildBackButton(BuildContext context) {
    if (!showBackButton) return null;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: IconButton(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: CustomImageView(imagePath: Assets.images.svgs.icons.icArrowLeft.path),
        onPressed: onBackPressed ?? () => GoRouter.of(context).pop(),
      ),
    );
  }

  Widget _buildMobileTitle(BuildContext context) {
    return _buildTitle(context);
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: CustomImageView(
        imagePath: Assets.images.svgs.other.appLogo.path,
        height: ResponsiveHelper.getWidgetHeight(context, mobile: 45.0, tablet: 48.0, desktop: 50.0),
      ),
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return GestureDetector(
      onTap: onHelp,
      child: Text(
        Lang.of(context).lbl_get_help,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 13.0, desktop: 14.0),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return HoverCloseButton(
      iconSize: 42.0,
      onTap: () async {
        try {
          // Clear local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // Navigate to login page
          if (context.mounted) {
            context.go('/signup');
          }
        } catch (e) {
          // Handle any errors during logout
          debugPrint('Error during logout: $e');

          // Still navigate to login even if clearing storage fails
          if (context.mounted) {
            context.go('/signup');
          }
        }
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (title == null) return const SizedBox.shrink();
    return Text(
      title ?? '',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 20.0),
      textAlign: TextAlign.center,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(ResponsiveHelper.isWebAndIsNotMobile(appBarContext) ? webAppBarHeight : mobileAppBarHeight);
}
