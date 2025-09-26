import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';

class BusinessEntitySelectionView extends StatelessWidget {
  const BusinessEntitySelectionView({super.key});

  // Global keys for each section
  static final GlobalKey businessActivityKey = GlobalKey();
  static final GlobalKey businessGoodsKey = GlobalKey();
  static final GlobalKey businessServicesKey = GlobalKey();
  static final GlobalKey businessBothKey = GlobalKey();
  static final GlobalKey businessSelectionDoneKey = GlobalKey();

  List<String> getBusinessEntityList(BuildContext context) => [
    Lang.of(context).lbl_company,
    Lang.of(context).lbl_llp,
    Lang.of(context).lbl_sole_proprietorship,
    Lang.of(context).lbl_partnership_firm,
    // Lang.of(context).lbl_huf,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSizedBoxH(20.0),
                _buildBusinessEntityTypes(context, state),
                buildSizedBoxH(30.0),
                if (state.selectedBusinessEntityType != null) ...[
                  _buildBusinessMainActivityType(context, state),
                  buildSizedBoxH(30.0),
                ],
                FutureBuilder(
                  future:
                      state.selectedBusinessMainActivity == BusinessMainActivity.exportGoods
                          ? _buildBusinessGoodsExportSelection(context, state)
                          : state.selectedBusinessMainActivity == BusinessMainActivity.exportService
                          ? _buildBusinessServicesExportSelection(context, state)
                          // : state.selectedBusinessMainActivity == BusinessMainActivity.exportBoth
                          // ? _buildBusinessGoodAndServicesExport(context, state)
                          : Future.value(SizedBox.shrink()),

                  builder: (context, snapshot) {
                    return snapshot.data ?? SizedBox.shrink();
                  },
                ),
                // if (state.selectedBusinessMainActivity == BusinessMainActivity.exportBoth)
                //   _buildBusinessGoodAndServicesExport(context, state),
                // buildSizedBoxH(40.0),
                _buildNextButton(),
                // buildSizedBoxH(kIsWeb ? 80.0 : 40.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return Container(
      key: businessSelectionDoneKey,
      child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
        builder: (context, state) {
          return Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                state.goodsAndServiceExportDescriptionController,
                state.goodsExportOtherController,
                state.serviceExportOtherController,
                state.businessActivityOtherController,
              ]),
              builder: (context, _) {
                final isEntitySelected = state.selectedBusinessEntityType != null;

                final activity = state.selectedBusinessMainActivity;
                final isOthersActivity = activity == BusinessMainActivity.others;

                bool isActivitySelected = false;
                if (activity != null) {
                  final businessActivityOtherText = state.businessActivityOtherController.text.trim();
                  // isExportOptionSelected = state.goodsExportOtherController.text.trim().isNotEmpty;
                  bool isValidate = businessActivityOtherText.length >= 3 && businessActivityOtherText.length <= 250;
                  isActivitySelected = isOthersActivity ? isValidate : true;
                }

                bool isExportOptionSelected = false;

                if (activity == BusinessMainActivity.exportGoods) {
                  if (state.selectedbusinessGoodsExportType?.contains(Lang.of(context).lbl_others) ?? false) {
                    final goodsExportOtherText = state.goodsExportOtherController.text.trim();
                    isExportOptionSelected =
                        (goodsExportOtherText.length >= 3 && goodsExportOtherText.length <= 250) &&
                        (state.selectedbusinessGoodsExportType ?? []).isNotEmpty;
                  } else {
                    isExportOptionSelected = (state.selectedbusinessGoodsExportType ?? []).isNotEmpty;
                  }
                } else if (activity == BusinessMainActivity.exportService) {
                  if (state.selectedbusinessServiceExportType?.contains(Lang.of(context).lbl_others) ?? false) {
                    final serviceExportOtherText = state.serviceExportOtherController.text.trim();
                    isExportOptionSelected =
                        (serviceExportOtherText.length >= 3 && serviceExportOtherText.length <= 250) &&
                        (state.selectedbusinessServiceExportType ?? []).isNotEmpty;
                  } else {
                    isExportOptionSelected = (state.selectedbusinessServiceExportType ?? []).isNotEmpty;
                  }
                  // } else if (activity == BusinessMainActivity.exportBoth) {
                  //   final goodsAndServiceExportDescriptionText =
                  //       state.goodsAndServiceExportDescriptionController.text.trim();
                  //   isExportOptionSelected =
                  //       (goodsAndServiceExportDescriptionText.length >= 3 &&
                  //           goodsAndServiceExportDescriptionText.length <= 250);
                } else if (activity == BusinessMainActivity.others) {
                  // Skip third validation
                  isExportOptionSelected = true;
                }

                final isButtonEnabled = isEntitySelected && isActivitySelected && isExportOptionSelected;

                return CustomElevatedButton(
                  isShowTooltip: true,
                  text: Lang.of(context).lbl_next,
                  borderRadius: 8.0,
                  width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 125,
                  isDisabled: !isButtonEnabled,
                  buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed:
                      isButtonEnabled
                          ? () {
                            final bloc = context.read<BusinessAccountSetupBloc>();
                            final index = state.currentStep.index;
                            if (index < BusinessAccountSetupSteps.values.length - 1) {
                              bloc.add(StepChanged(BusinessAccountSetupSteps.values[index + 1]));
                            }
                          }
                          : null,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBusinessEntityTypes(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_which_type_of_business_entity_do_you_have,
          description: Lang.of(context).lbl_legal_entity_help_text,
        ),
        buildSizedBoxH(20.0),
        Column(
          children: List.generate(getBusinessEntityList(context).length, (index) {
            return CustomTileWidget(
              title: getBusinessEntityList(context)[index],
              isSelected: state.selectedBusinessEntityType == getBusinessEntityList(context)[index],
              onTap: () {
                final bloc = BlocProvider.of<BusinessAccountSetupBloc>(context);
                bloc.add(ChangeBusinessEntityType(getBusinessEntityList(context)[index]));
                bloc.add(ScrollToSection(businessActivityKey, scrollController: state.scrollController));
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBusinessMainActivityType(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      key: businessActivityKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_nature_of_business_question,
          description: Lang.of(context).lbl_nature_of_business_info,
        ),
        buildSizedBoxH(20.0),
        Column(
          children:
              BusinessMainActivity.values.map((activity) {
                final isOthers = activity == BusinessMainActivity.others;
                final isSelected = state.selectedBusinessMainActivity == activity;
                return CustomTileWidget(
                  showTextField: isOthers && isSelected,
                  controller: state.businessActivityOtherController,
                  title: getBusinessMainActivity(context: context, step: activity),
                  isSelected: state.selectedBusinessMainActivity == activity,
                  onTap: () {
                    final bloc = context.read<BusinessAccountSetupBloc>();
                    bloc.add(ChangeBusinessMainActivity(activity));
                    bloc.add(UpdateBusinessNatureString(getBusinessMainActivity(context: context, step: activity)));
                    if (activity == BusinessMainActivity.exportGoods) {
                      bloc.add(ScrollToSection(businessGoodsKey, scrollController: state.scrollController));
                    } else if (activity == BusinessMainActivity.exportService) {
                      bloc.add(ScrollToSection(businessServicesKey, scrollController: state.scrollController));
                      // } else if (activity == BusinessMainActivity.exportBoth) {
                      //   bloc.add(ScrollToSection(businessBothKey, scrollController: state.scrollController));
                    }
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Future<Widget> _buildBusinessGoodsExportSelection(BuildContext context, BusinessAccountSetupState state) async {
    final exportGoods = await Prefobj.preferences.get(Prefkeys.exportsGood);
    final exportGoodsList = jsonDecode(exportGoods!);
    return Column(
      key: businessGoodsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_export_goods_question,
          description: Lang.of(context).lbl_export_goods_info,
        ),
        buildSizedBoxH(20.0),
        Column(
          children: List.generate(exportGoodsList.length, (index) {
            final isOthers = exportGoodsList[index] == Lang.of(context).lbl_others;
            final isSelected = state.selectedbusinessGoodsExportType?.any(
              (exportGoods) => exportGoods == exportGoodsList[index],
            );
            return CustomTileWidget(
              title: exportGoodsList[index],
              showTextField: isOthers && (isSelected ?? false),
              isSelected: isSelected ?? false,
              controller: state.goodsExportOtherController,
              isShowTrailing: isOthers ? false : true,
              showTrailingCheckbox: true,
              onTap: () {
                final bloc = BlocProvider.of<BusinessAccountSetupBloc>(context);
                bloc.add(ChangeBusinessGoodsExport(exportGoodsList[index]));
                // bloc.add(ScrollToSection(businessSelectionDoneKey));
              },
            );
          }),
        ),
      ],
    );
  }

  Future<Widget> _buildBusinessServicesExportSelection(BuildContext context, BusinessAccountSetupState state) async {
    final exportServices = await Prefobj.preferences.get(Prefkeys.exportServices);
    final exportServicesList = jsonDecode(exportServices!);
    return Column(
      key: businessServicesKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_export_services_question,
          description: Lang.of(context).lbl_export_services_info,
        ),
        buildSizedBoxH(20.0),
        Column(
          children: List.generate(exportServicesList.length, (index) {
            final isOthers = exportServicesList[index] == Lang.of(context).lbl_others;
            // final isSelected = state.selectedbusinessServiceExportType == Lang.of(context).lbl_others;
            final isSelected = state.selectedbusinessServiceExportType?.any(
              (profession) => profession == exportServicesList[index],
            );
            return CustomTileWidget(
              showTextField: isOthers && (isSelected ?? false),
              controller: state.serviceExportOtherController,
              title: exportServicesList[index],
              isSelected: isSelected ?? false,
              isShowTrailing: isOthers ? false : true,
              showTrailingCheckbox: true,
              onTap: () {
                final bloc = BlocProvider.of<BusinessAccountSetupBloc>(context);
                bloc.add(ChangeBusinessServicesExport(exportServicesList[index]));
                // bloc.add(ScrollToSection(businessSelectionDoneKey));
              },
            );
          }),
        ),
      ],
    );
  }

  _buildBusinessGoodAndServicesExport(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      key: businessBothKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_export_goods_services_question,
          description: Lang.of(context).lbl_export_goods_services_info,
        ),
        buildSizedBoxH(20.0),
        AnimatedBuilder(
          animation: Listenable.merge([state.goodsAndServiceExportDescriptionController]),
          builder: (context, _) {
            return CustomTileWidget(
              title: "",
              isSelected: state.goodsAndServiceExportDescriptionController.text.isNotEmpty,
              onTap: () {},
              showTextField: true,
              controller: state.goodsAndServiceExportDescriptionController,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectionTitleAndDescription({
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

String getBusinessMainActivity({required BuildContext context, required BusinessMainActivity step}) {
  switch (step) {
    case BusinessMainActivity.exportGoods:
      return Lang.of(context).lbl_export_goods;
    case BusinessMainActivity.exportService:
      return Lang.of(context).lbl_export_services;
    // case BusinessMainActivity.exportBoth:
    //   return Lang.of(context).lbl_export_goods_services;
    case BusinessMainActivity.others:
      return Lang.of(context).lbl_others;
  }
}
