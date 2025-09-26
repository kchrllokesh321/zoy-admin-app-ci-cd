import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/views/main_dashboard_view/clients_view/clients_view.dart';
import 'package:exchek/views/main_dashboard_view/dashboard_view/dashboard_content_view.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/invoice_content_view.dart';
import 'package:exchek/views/main_dashboard_view/transection_view/transection_content_view.dart';
import 'package:exchek/widgets/account_setup_widgets/profile_dropdown.dart';

class DashboardBalance {
  final String currencyName;
  final String transactionAmount;
  final String currencyImage;

  DashboardBalance({
    required this.currencyName,
    required this.transactionAmount,
    required this.currencyImage,
  });
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _wasDesktop = false;
  bool _isClosingDrawer = false;
  // bool _isOnAddInvoicePage = false;
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String userName = authState.userName ?? '';
    String email = authState.email ?? '';

    final theme = Theme.of(context);
    return FutureBuilder<List<String>>(
      future: () async {
        if (userName.isEmpty) {
          userName =
              await Prefobj.preferences.get(Prefkeys.loggedUserName) ?? '';
        }
        if (email.isEmpty) {
          email = await Prefobj.preferences.get(Prefkeys.loggedEmail) ?? '';
        }

        return [userName, email];
      }(),
      builder: (context, snapshot) {
        final userNameVal = snapshot.data?[0] ?? '';
        final emailVal = snapshot.data?[1] ?? '';
        return ResponsiveScaffold(
          drawer: const _DashboardDrawer(),
          body: Builder(
            builder: (scaffoldCtx) {
              return BackgroundImage(
                imagePath: Assets.images.svgs.other.appBg.path,
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    final isDesktop = ResponsiveHelper.isDesktop(context);

                    // Handle drawer closing logic for desktop
                    _handleDrawerForDesktop(scaffoldCtx, isDesktop);

                    return Column(
                      children: [
                        ExchekAppBar(
                          appBarContext: context,
                          title: state.selectedDrawerOption,
                          showBackButton: false,
                          showCloseButton: false,
                          leading:
                              ResponsiveHelper.isDesktop(scaffoldCtx)
                                  ? null
                                  : IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: theme.customColors.blackColor,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Scaffold.of(scaffoldCtx).openDrawer();
                                    },
                                  ),
                          titleWidget: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveHelper.getWidgetSize(
                                context,
                                desktop: 24,
                                tablet: 24,
                                mobile: 20.0,
                              ),
                              right: ResponsiveHelper.getWidgetSize(
                                context,
                                desktop: 20,
                                tablet: 20,
                                mobile: 0.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.selectedDrawerOption,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: ResponsiveHelper.getFontSize(
                                        context,
                                        mobile: 20,
                                        tablet: 24,
                                        desktop: 26,
                                      ),
                                      color: theme.customColors.blackColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: ResponsiveHelper.getWidgetHeight(
                                    context,
                                    desktop: 50,
                                    tablet: 45,
                                    mobile: 40,
                                  ),
                                  width: ResponsiveHelper.getWidgetHeight(
                                    context,
                                    desktop: 50,
                                    tablet: 45,
                                    mobile: 40,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.customColors.darkGreyColor!
                                          .withValues(alpha: 0.6),
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Badge(
                                    alignment: Alignment(0.85, -0.9),
                                    // isLabelVisible: false,
                                    backgroundColor:
                                        theme.customColors.badgeColor,
                                    smallSize: 9.0,
                                    child: CustomImageView(
                                      imagePath:
                                          Assets
                                              .images
                                              .svgs
                                              .dashboard
                                              .icNotification
                                              .path,
                                      height: ResponsiveHelper.getWidgetHeight(
                                        context,
                                        desktop: 24,
                                        tablet: 22,
                                        mobile: 20.0,
                                      ),
                                      width: ResponsiveHelper.getWidgetHeight(
                                        context,
                                        desktop: 24,
                                        tablet: 22,
                                        mobile: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                buildSizedboxW(
                                  ResponsiveHelper.getWidgetSize(
                                    context,
                                    desktop: 14,
                                    tablet: 14,
                                    mobile: 10.0,
                                  ),
                                ),
                                ProfileDropdown(
                                  userName: userNameVal,
                                  email: emailVal,
                                  isBusinessUser: false,
                                  isNameDataVisible:
                                      ResponsiveHelper.isWebAndIsNotMobile(
                                        context,
                                      ),
                                ),
                                // if (_isOnAddInvoicePage)
                                //   IconButton(
                                //     icon: const Icon(Icons.close, color: Colors.black),
                                //     tooltip: "Close Add Invoice",
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //       setState(() {
                                //         _isOnAddInvoicePage = false;
                                //       });
                                //     },
                                //   ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: _buildDashboardContent(context, state)),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleDrawerForDesktop(BuildContext scaffoldCtx, bool isDesktop) {
    // If we're switching to desktop and we're not already closing drawer
    if (isDesktop && !_wasDesktop && !_isClosingDrawer) {
      _closeDrawerIfOpen(scaffoldCtx);
    }
    // If we're switching away from desktop, stop any ongoing drawer closing
    else if (!isDesktop && _wasDesktop) {
      _isClosingDrawer = false;
    }

    _wasDesktop = isDesktop;
  }

  void _closeDrawerIfOpen(BuildContext scaffoldCtx) {
    final sc = Scaffold.maybeOf(scaffoldCtx);
    if (sc?.isDrawerOpen == true && !_isClosingDrawer) {
      _isClosingDrawer = true;
      sc!.closeDrawer();

      // Reset the flag after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _isClosingDrawer = false;
        }
      });
    }
  }

  Widget _buildDashboardContent(BuildContext context, DashboardState state) {
    switch (state.selectedDrawerOption) {
      case "Dashboard":
        return DashboardContentView();
      case "Accounts":
        return Container();
      case "Invoices":
        return InvoiceContentView();
      // if (state.isOnAddInvoicePage) {
      //   return AddInvoicePage();
      // } else {
      //   return InvoiceContentView();
      // }
      case "Clients":
        return ClientsContentView();
      case "Transactions":
        return TransectionContentView();
      case "Reports":
        return Container();
      default:
        return DashboardContentView();
    }
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Material(
          color: theme.colorScheme.surface,
          child: SafeArea(
            child: Container(
              width: ResponsiveHelper.getWidgetSize(
                context,
                mobile: 250,
                tablet: 280,
                desktop: 300,
              ),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildSizedBoxH(15.0),
                  CustomImageView(
                    imagePath: Assets.images.svgs.other.appLogo.path,
                    height: 50.0,
                  ),
                  buildSizedBoxH(50.0),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _NavTile(
                          isSelected: state.selectedDrawerOption == "Dashboard",
                          icon: Assets.images.svgs.dashboard.icDashboard.path,
                          label: 'Dashboard',
                          onTap: () {
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Dashboard",
                              ),
                            );
                            if (!ResponsiveHelper.isDesktop(context)) {
                              Scaffold.of(context).closeDrawer();
                            }
                            context.read<DashboardBloc>().add(
                              CurrencyStarted(),
                            );
                          },
                        ),
                        buildSizedBoxH(5.0),
                        _NavTile(
                          isSelected: state.selectedDrawerOption == "Accounts",
                          icon: Assets.images.svgs.dashboard.icAccount.path,
                          label: 'Accounts',
                          onTap: () {
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Accounts",
                              ),
                            );
                            if (!ResponsiveHelper.isDesktop(context)) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        buildSizedBoxH(5.0),
                        _NavTile(
                          isSelected: state.selectedDrawerOption == "Invoices",
                          icon: Assets.images.svgs.dashboard.icInvoices.path,
                          label: 'Invoices',
                          onTap: () {
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Invoices",
                              ),
                            );
                             context.read<ClientsBloc>().add(CountryClientTypeOptions());
                            // Add this line to trigger invoice loading when user navigates here
                            // context.read<InvoiceBloc>().add(const InvoiceStarted());

                            if (!ResponsiveHelper.isDesktop(context)) {
                              Scaffold.of(context).closeDrawer();
                            }
                          },
                        ),
                        _NavTile(
                          isSelected: state.selectedDrawerOption == "Clients",
                          icon: Assets.images.svgs.dashboard.icClients.path,
                          label: 'Clients',
                          onTap: () {
                            context.read<ClientsBloc>().add(
                              ClearSelectedClient(),
                            );
                            context.read<ClientsBloc>().add(LoadClients());
                            context.read<ClientsBloc>().add(CountryClientTypeOptions());
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Clients",
                              ),
                            );
                            if (!ResponsiveHelper.isDesktop(context)) {
                              Scaffold.of(context).closeDrawer();
                            }
                          },
                          iconSize: 20.0,
                        ),
                        buildSizedBoxH(5.0),
                        _NavTile(
                          isSelected:
                              state.selectedDrawerOption == "Transactions",
                          icon:
                              Assets.images.svgs.dashboard.icTransactions.path,
                          label: 'Transactions',
                          onTap: () {
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Transactions",
                              ),
                            );
                            if (!ResponsiveHelper.isDesktop(context)) {
                              Scaffold.of(context).closeDrawer();
                            }
                          },
                        ),
                        buildSizedBoxH(5.0),
                        _NavTile(
                          isSelected: state.selectedDrawerOption == "Reports",
                          icon: Assets.images.svgs.dashboard.icReports.path,
                          label: 'Reports',
                          onTap: () {
                            context.read<DashboardBloc>().add(
                              DashboardDrawerIndexChanged(
                                selectedDrawerOption: "Reports",
                              ),
                            );
                            if (!ResponsiveHelper.isDesktop(context)) {
                              Scaffold.of(context).closeDrawer();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildReferAndEarnBox(context),
                  buildSizedBoxH(10.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReferAndEarnBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getWidgetSize(
          context,
          mobile: 14,
          tablet: 14,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.lightBoxBGColor,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSizedBoxH(5.0),
          CustomImageView(
            imagePath: Assets.images.svgs.icons.icRewardBox.path,
            height: 50.0,
            width: 50.0,
          ),
          buildSizedBoxH(16.0),
          Text(
            Lang.of(context).lbl_refer_and_earn,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobile: 14,
                tablet: 14,
                desktop: 16,
              ),
              color: Theme.of(context).customColors.blackColor,
            ),
          ),
          buildSizedBoxH(16.0),
          CustomElevatedButton(
            height: 48.0,
            borderRadius: 12.0,
            width: double.maxFinite,
            text: Lang.of(context).lbl_invite_friends,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
    this.iconSize = 24.0,
  });
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      selectedTileColor: theme.customColors.filtercheckboxcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      leading: CustomImageView(
        imagePath: icon,
        height: iconSize,
        width: iconSize,
        color:
            isSelected
                ? theme.customColors.blackColor
                : theme.customColors.drawerIconColor,
      ),
      // Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: ResponsiveHelper.getFontSize(
            context,
            mobile: 16,
            tablet: 16,
            desktop: 18,
          ),
          color:
              isSelected
                  ? theme.customColors.blackColor
                  : theme.customColors.drawerIconColor,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
      horizontalTitleGap: 16,
      dense: true,
      hoverColor: theme.customColors.filtercheckboxcolor?.withValues(
        alpha: 0.4,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      tileColor: isSelected ? theme.customColors.filtercheckboxcolor : null,
    );
  }
}
