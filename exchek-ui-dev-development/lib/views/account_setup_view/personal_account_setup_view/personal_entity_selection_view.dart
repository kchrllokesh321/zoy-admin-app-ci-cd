import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class PersonalAccountPurposeView extends StatelessWidget {
  const PersonalAccountPurposeView({super.key});

  static final GlobalKey purposeKey = GlobalKey();
  static final GlobalKey professionKey = GlobalKey();
  static final GlobalKey descriptionKey = GlobalKey();
  static final GlobalKey personalSetupDoneKey = GlobalKey();

  List<String> getPurposeList(BuildContext context) => [
    Lang.of(context).lbl_im_a_freelancer,
    Lang.of(context).lbl_its_for_family_and_friends,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20.0) : 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSizedBoxH(20.0),
                  _buildPurposeSelection(context, state),
                  buildSizedBoxH(30.0),
                  if (state.selectedPurpose == Lang.of(context).lbl_im_a_freelancer) ...[
                    FutureBuilder(
                      future: _buildProfessionSelection(context, state),
                      builder: (context, snapshot) {
                        return snapshot.data ?? SizedBox.shrink();
                      },
                    ),
                    buildSizedBoxH(30.0),
                    if (state.isShowServiceDescriptionBox == false && state.selectedProfession != null)
                      _buildNextSelectionButton(context, state),
                    if (state.selectedProfession != null && state.isShowServiceDescriptionBox == true) ...[
                      _buildProductServiceDescription(context, state),
                      buildSizedBoxH(30.0),
                    ],
                  ],
                  if (state.selectedPurpose == Lang.of(context).lbl_its_for_family_and_friends) ...[
                    _buildFamilyAndFriendsDescription(context, state),
                    buildSizedBoxH(30.0),
                  ],
                  if (state.isShowServiceDescriptionBox == true || state.selectedProfession == null)
                    _buildNextButton(context, state),
                  buildSizedBoxH(kIsWeb ? 80.0 : 40.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextSelectionButton(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          state.productServiceDescriptionController,
          state.professionOtherController,
          state.familyAndFriendsDescriptionController,
        ]),
        builder: (context, _) {
          final isPurposeSelected = state.selectedPurpose != null;

          bool isOthersProfessionValid = false;
          if (state.selectedProfession?.contains(Lang.of(context).lbl_others) ?? false) {
            final serviceExportOtherText = state.professionOtherController.text.trim();
            isOthersProfessionValid =
                (serviceExportOtherText.length >= 3 && serviceExportOtherText.length <= 150) &&
                (state.selectedProfession ?? []).isNotEmpty;
          } else {
            isOthersProfessionValid = (state.selectedProfession ?? []).isNotEmpty;
          }

          bool isButtonEnabled = isPurposeSelected && isOthersProfessionValid;

          return CustomElevatedButton(
            text: Lang.of(context).lbl_next,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
            borderRadius: 8.0,
            isDisabled: !isButtonEnabled,
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed:
                isButtonEnabled
                    ? () {
                      final bloc = context.read<PersonalAccountSetupBloc>();
                      bloc.add(PersonalChangeShowDescription(true));
                      bloc.add(PersonalScrollToPosition(descriptionKey));
                    }
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, PersonalAccountSetupState state) {
    return Container(
      key: personalSetupDoneKey,
      child: Align(
        alignment: Alignment.centerRight,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            state.productServiceDescriptionController,
            state.professionOtherController,
            state.familyAndFriendsDescriptionController,
          ]),
          builder: (context, _) {
            final isPurposeSelected = state.selectedPurpose != null;
            bool isButtonEnabled = false;

            if (state.selectedPurpose == Lang.of(context).lbl_its_for_family_and_friends) {
              final familyAndFriendsDescriptionText = state.familyAndFriendsDescriptionController.text.trim();
              final isDescriptionValid =
                  familyAndFriendsDescriptionText.length >= 3 && familyAndFriendsDescriptionText.length <= 250;
              isButtonEnabled = isPurposeSelected && isDescriptionValid;
            } else if (state.selectedPurpose == Lang.of(context).lbl_im_a_freelancer) {
              bool isOthersProfessionValid = false;
              if (state.selectedProfession?.contains(Lang.of(context).lbl_others) ?? false) {
                final serviceExportOtherText = state.professionOtherController.text.trim();
                isOthersProfessionValid =
                    (serviceExportOtherText.length >= 3 && serviceExportOtherText.length <= 150) &&
                    (state.selectedProfession ?? []).isNotEmpty;
              } else {
                isOthersProfessionValid = (state.selectedProfession ?? []).isNotEmpty;
              }
              final descriptionText = state.productServiceDescriptionController.text.trim();
              final isDescriptionValid = descriptionText.length >= 3 && descriptionText.length <= 250;
              isButtonEnabled = isPurposeSelected && isOthersProfessionValid && isDescriptionValid;
            }

            return CustomElevatedButton(
              text: Lang.of(context).lbl_next,
              width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
              borderRadius: 8.0,
              isDisabled: !isButtonEnabled,
              buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed:
                  isButtonEnabled
                      ? () {
                        final bloc = context.read<PersonalAccountSetupBloc>();
                        final index = state.currentStep.index;
                        if (index < PersonalAccountSetupSteps.values.length - 1) {
                          bloc.add(PersonalInfoStepChanged(PersonalAccountSetupSteps.values[index + 1]));
                        }
                      }
                      : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPurposeSelection(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      key: purposeKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_receive_money_question,
          description: Lang.of(context).lbl_receive_money_description,
        ),
        buildSizedBoxH(20.0),
        Column(
          children:
              getPurposeList(context).map((item) {
                return CustomTileWidget(
                  title: item,
                  isSelected: state.selectedPurpose == item,
                  onTap: () {
                    final bloc = BlocProvider.of<PersonalAccountSetupBloc>(context);
                    bloc.add(ChangePurpose(item));

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      BlocProvider.of<PersonalAccountSetupBloc>(context).add(
                        PersonalScrollToPosition(
                          PersonalAccountPurposeView.descriptionKey,
                          scrollController: state.scrollController,
                        ),
                      );
                    });

                    if (item == Lang.of(context).lbl_im_a_freelancer) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        BlocProvider.of<PersonalAccountSetupBloc>(
                          context,
                        ).add(PersonalScrollToPosition(professionKey, scrollController: state.scrollController));
                      });
                    }
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Future<Widget> _buildProfessionSelection(BuildContext context, PersonalAccountSetupState state) async {
    final freelancer = await Prefobj.preferences.get(Prefkeys.freelancer);
    final freelancerList = jsonDecode(freelancer!);
    Logger.info(freelancerList.toString());
    return Column(
      key: professionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_profession_question,
          description: Lang.of(context).lbl_profession_description,
        ),
        buildSizedBoxH(10.0),
        Column(
          children: List.generate(freelancerList.length, (index) {
            final isOthers = freelancerList[index] == Lang.of(context).lbl_others;
            // final isSelected = state.selectedProfession == freelancerList[index];
            final isSelected = state.selectedProfession?.any((profession) => profession == freelancerList[index]);
            return CustomTileWidget(
              title: freelancerList[index],
              showTextField: isOthers && (isSelected ?? false),
              controller: isOthers ? state.professionOtherController : null,
              isSelected: isSelected ?? false,
              showTrailingCheckbox: isOthers ? false : true,
              isShowTrailing: isOthers ? false : true,
              maxlength: 150,
              onTap: () {
                final bloc = BlocProvider.of<PersonalAccountSetupBloc>(context);
                bloc.add(ChangeProfession(freelancerList[index]));
                // bloc.add(PersonalScrollToPosition(descriptionKey));
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductServiceDescription(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      key: descriptionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_description_question,
          description: Lang.of(context).lbl_description_info,
        ),
        buildSizedBoxH(15.0),
        AnimatedBuilder(
          animation: Listenable.merge([state.productServiceDescriptionController]),
          builder: (context, _) {
            return CustomTileWidget(
              title: "",
              isSelected: state.productServiceDescriptionController.text.isNotEmpty,
              onTap: () {},
              showTextField: true,
              controller: state.productServiceDescriptionController,
              maxlength: 250,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFamilyAndFriendsDescription(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      key: descriptionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleAndDescription(
          context: context,
          title: "What is the purpose of receiving payment?",
          description: "Mention the purpose for receiving money from family or friends.",
        ),
        buildSizedBoxH(15.0),
        AnimatedBuilder(
          animation: Listenable.merge([state.familyAndFriendsDescriptionController]),
          builder: (context, _) {
            return CustomTileWidget(
              title: "",
              isSelected: state.familyAndFriendsDescriptionController.text.isNotEmpty,
              onTap: () {},
              showTextField: true,
              controller: state.familyAndFriendsDescriptionController,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitleAndDescription({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 30, desktop: 32),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.32,
          ),
        ),
        buildSizedBoxH(14.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
