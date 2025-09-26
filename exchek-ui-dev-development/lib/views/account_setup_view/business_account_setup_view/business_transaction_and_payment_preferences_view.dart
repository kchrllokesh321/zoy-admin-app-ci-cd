import 'package:exchek/core/utils/exports.dart';

class CurrencyModel {
  final String currencyName;
  final String currencySymbol;
  final String currencyImagePath;
  final bool isSelected;

  CurrencyModel({
    required this.currencyName,
    required this.currencySymbol,
    required this.currencyImagePath,
    this.isSelected = false,
  });
}

class BusinessTransactionAndPaymentPreferencesView extends StatelessWidget {
  const BusinessTransactionAndPaymentPreferencesView({super.key});

  static final GlobalKey businessRecivePaymentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
                ),
                child:
                    (state.isSignupLoading ?? false)
                        ? Padding(padding: const EdgeInsets.only(top: 40), child: AppLoaderWidget())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSizedBoxH(20.0),
                            _buildBusinessEstimatedMonthlyTransaction(context, state),
                            buildSizedBoxH(60.0),
                            // if (state.curruncyList != null) _buildCurrenciesSelections(context, state),
                            // buildSizedBoxH(40.0),
                            _buildNextButton(),
                            buildSizedBoxH(40.0),
                          ],
                        ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessEstimatedMonthlyTransaction(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_monthly_transaction_volume_title,
          description: Lang.of(context).lbl_approximate_transactions_month,
        ),
        buildSizedBoxH(20.0),
        Column(
          children: List.generate(state.estimatedMonthlyVolumeList?.length ?? 0, (index) {
            return CustomTileWidget(
              title: state.estimatedMonthlyVolumeList?[index] ?? '',
              isSelected: state.selectedEstimatedMonthlyTransaction == state.estimatedMonthlyVolumeList?[index],
              onTap: () {
                context.read<BusinessAccountSetupBloc>().add(
                  ChangeEstimatedMonthlyTransaction(state.estimatedMonthlyVolumeList?[index] ?? ''),
                );
                context.read<BusinessAccountSetupBloc>().add(
                  ScrollToSection(businessRecivePaymentKey, scrollController: state.scrollController),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // Widget _buildCurrenciesSelections(BuildContext context, BusinessAccountSetupState state) {
  //   return Column(
  //     key: businessRecivePaymentKey,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildSelectionTitleAndDescription(
  //         context: context,
  //         title: Lang.of(context).lbl_receive_payments,
  //         description: Lang.of(context).lbl_currencies_receive_payments,
  //       ),
  //       buildSizedBoxH(20.0),
  //       Column(
  //         children:
  //             state.curruncyList!.map((currency) {
  //               final isSelected = state.selectedCurrencies?.any((c) => c.currencySymbol == currency.currencySymbol);
  //               return CustomTileWidget(
  //                 showTrailingCheckbox: true,
  //                 isShowTrailing: true,
  //                 title: currency.currencyName,
  //                 isSelected: isSelected ?? false,
  //                 leadingImagePath: currency.currencyImagePath,
  //                 titleWidget: Text.rich(
  //                   TextSpan(
  //                     text: currency.currencySymbol,
  //                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //                       fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
  //                       fontWeight: FontWeight.w600,
  //                       letterSpacing: 0.16,
  //                       height: 1.16,
  //                     ),
  //                     children: [
  //                       TextSpan(text: "  "),
  //                       TextSpan(
  //                         text: currency.currencyName,
  //                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //                           fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).customColors.secondaryTextColor,
  //                           letterSpacing: 0.16,
  //                           height: 1.16,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   context.read<BusinessAccountSetupBloc>().add(ToggleCurrencySelection(currency));
  //                 },
  //               );
  //             }).toList(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([]),
            builder: (context, _) {
              final isButtonEnabled = state.selectedEstimatedMonthlyTransaction != null;
              return CustomElevatedButton(
                isShowTooltip: true,
                text: Lang.of(context).lbl_next,
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 125,
                isLoading: state.isTranscationDetailLoading ?? false,
                isDisabled: !isButtonEnabled,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed:
                    isButtonEnabled
                        ? () {
                          context.read<BusinessAccountSetupBloc>().add(
                            BusinessTranscationDetailSubmitted(
                              curruncyList: state.selectedCurrencies ?? [],
                              monthlyTranscation: state.selectedEstimatedMonthlyTransaction ?? '',
                            ),
                          );
                        }
                        : null,
              );
            },
          ),
        );
      },
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
