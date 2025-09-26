import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class AccountSelectionStep extends StatelessWidget {
  const AccountSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: ExchekAppBar(appBarContext: context, onHelp: () {}, showBackButton: false),
      backgroundColor: Theme.of(context).customColors.fillColor,
      body: BackgroundImage(
        imagePath: Assets.images.svgs.other.appBg.path,
        child: BlocBuilder<AccountTypeBloc, AccountTypeState>(
          builder: (context, state) {
            return Center(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxFormWidth(context)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            Lang.of(context).lbl_account_type_title,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                mobile: 24.0,
                                tablet: 28.0,
                                desktop: 32.0,
                              ),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.32,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          buildSizedBoxH(14.0),
                          Text(
                            Lang.of(context).lbl_account_type_subtitle,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                mobile: 14.0,
                                tablet: 15.0,
                                desktop: 16.0,
                              ),
                              color: Theme.of(context).customColors.darkBlueColor,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          buildSizedBoxH(50.0),
                          Wrap(
                            spacing: 24,
                            runSpacing: 24,
                            alignment: WrapAlignment.center,
                            children: [
                              AccountCard(
                                title: Lang.of(context).lbl_personal,
                                subtitle: Lang.of(context).lbl_personal_subtitle,
                                icon: Assets.images.svgs.icons.icPersonalUser.path,
                                isSelected: state.selectedAccountType == AccountType.personal,
                                onTap: () {
                                  context.read<AccountTypeBloc>().add(SelectAccountType(AccountType.personal));
                                  context.read<AccountTypeBloc>().add(GetDropDownOption());
                                  context.read<PersonalAccountSetupBloc>().add(PersonalResetData());
                                  if (kIsWeb) {
                                    context.go(RouteUri.personalAccountSetupRoute);
                                  } else {
                                    context.push(RouteUri.personalAccountSetupRoute);
                                  }
                                },
                              ),
                              AccountCard(
                                title: Lang.of(context).lbl_business,
                                subtitle: Lang.of(context).lbl_business_subtitle,
                                icon: Assets.images.svgs.icons.icBusinessUser.path,
                                isSelected: state.selectedAccountType == AccountType.business,
                                onTap: () {
                                  context.read<AccountTypeBloc>().add(SelectAccountType(AccountType.business));
                                  context.read<AccountTypeBloc>().add(GetDropDownOption());
                                  context.read<BusinessAccountSetupBloc>().add(ResetData());
                                  if (kIsWeb) {
                                    context.go(RouteUri.businessAccountSetupViewRoute);
                                  } else {
                                    context.push(RouteUri.businessAccountSetupViewRoute);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).customColors.primaryColor!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 280,
          height: 180,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: ResponsiveHelper.getWidgetHeight(context, mobile: 50.0, tablet: 50.0, desktop: 45.0),
                width: ResponsiveHelper.getWidgetHeight(context, mobile: 50.0, tablet: 50.0, desktop: 45.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected
                          ? Theme.of(context).customColors.primaryColor
                          : Theme.of(context).customColors.lightUnSelectedBGColor,
                ),
                alignment: Alignment.center,
                child: CustomImageView(
                  imagePath: icon,
                  color:
                      isSelected ? Theme.of(context).customColors.fillColor : Theme.of(context).customColors.blackColor,
                  height: ResponsiveHelper.getWidgetHeight(context, mobile: 20.0, tablet: 20.0, desktop: 20.0),
                ),
              ),
              buildSizedBoxH(12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16.0, tablet: 18.0, desktop: 20.0),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  letterSpacing: 0.2,
                  height: 1.16,
                ),
              ),
              buildSizedBoxH(12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                  color: Theme.of(context).customColors.secondaryTextColor,
                  decoration: TextDecoration.none,
                  height: 1.16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
