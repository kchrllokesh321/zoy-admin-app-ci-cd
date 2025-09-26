import 'package:exchek/core/utils/drag_scroll_behaviour.dart';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/views/main_dashboard_view/clients_view/add_client_view.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/upload_invoice.dart';
import 'package:exchek/widgets/dashboard_widget/common_action_card.dart';
import 'package:exchek/models/transfer_calculator_model.dart';
import 'package:exchek/widgets/common_widget/custom_dropdown.dart';
import 'package:exchek/widgets/common_widget/custom_popup_menu_button.dart';
import 'package:exchek/widgets/dashboard_widget/receiveing_menu.dart';

class DashboardContentView extends StatelessWidget {
  const DashboardContentView({super.key});

  double buttonFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 18,
        )
        : ResponsiveHelper.getFontSize(
          context,
          mobile: 16,
          tablet: 16,
          desktop: 18,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return EntranceFader(
          slideDirection: SlideDirection.bottomToTop,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getWidgetSize(
                context,
                desktop: 35,
                tablet: 30,
                mobile: 24,
              ),
              vertical: ResponsiveHelper.getWidgetSize(
                context,
                desktop: 30,
                tablet: 26,
                mobile: 24,
              ),
            ),
            children: [
              buildSizedBoxH(10),
              _buildTotalBalanceDetail(context, state),
              buildSizedBoxH(24),
              if (ResponsiveHelper.getScreenWidth(context) < 950)
                Column(
                  spacing: 24.0,
                  children: [
                    _buildTransferCalculator(context),
                    _buildThingsCanDo(context),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24.0,
                  children: [
                    Expanded(child: _buildTransferCalculator(context)),
                    Expanded(child: _buildThingsCanDo(context)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThingsCanDo(BuildContext context) {
    final horizontalPadding = ResponsiveHelper.getWidgetSize(
      context,
      desktop: 24,
      tablet: 22,
      mobile: 20,
    );
    final verticalPadding = ResponsiveHelper.getWidgetSize(
      context,
      desktop: 16,
      tablet: 14,
      mobile: 12,
    );
    final iconBGSize = ResponsiveHelper.getWidgetHeight(
      context,
      desktop: 50,
      tablet: 45,
      mobile: 40,
    );

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).customColors.blackColor!.withValues(alpha: 0.05),
            blurRadius: 54.0,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.of(context).lbl_things_you_can_do,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).customColors.blackColor,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobile: 18.0,
                tablet: 20.0,
                desktop: 20.0,
              ),
            ),
          ),
          buildSizedBoxH(30),
          CommonActionCard(
            iconSize: 24.0,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            iconBGSize: iconBGSize,
            text: "Add Invoice",
            iconPath: Assets.images.svgs.dashboard.addInvoice.path,
            bgColor: Color(0xFFFFF8C5),
            iconBgColor: Color(0xFFFFE100),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => AddInvoicePage()));
            },
          ),
          buildSizedBoxH(20.0),
          CommonActionCard(
            iconSize: 24.0,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            iconBGSize: iconBGSize,
            text: Lang.of(context).lbl_view_recent_transactions,
            iconPath: Assets.images.svgs.dashboard.viewRecentTransaction.path,
            bgColor: Color(0xFFC7E9F9),
            iconBgColor: Color(0xFF00ADFF),
            onTap: () {
              context.read<DashboardBloc>().add(
                DashboardDrawerIndexChanged(
                  selectedDrawerOption: "Transactions",
                ),
              );
            },
          ),
          buildSizedBoxH(20.0),
          CommonActionCard(
            iconSize: 20.0,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            iconBGSize: iconBGSize,
            text: "Share Account Details",
            iconPath: Assets.images.svgs.dashboard.shareAccountDetails.path,
            bgColor: Color(0xFFCFF3AF),
            iconBgColor: Color(0xFF81DE30),
            onTap: () {},
          ),
          buildSizedBoxH(20.0),
          CommonActionCard(
            iconSize: 20.0,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            iconBGSize: iconBGSize,
            text: "Add Client",
            iconPath: Assets.images.svgs.dashboard.addClient.path,
            bgColor: Color(0xFFE1DAFF),
            iconBgColor: Color(0xFFABA0D9),
            onTap: () async {
              await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AddClientDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransferCalculator(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).customColors.blackColor!.withValues(alpha: 0.05),
                blurRadius: 54.0,
                offset: Offset(6, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Lang.of(context).lbl_transfer_calculator,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).customColors.blackColor,
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 18.0,
                    tablet: 20.0,
                    desktop: 20.0,
                  ),
                ),
              ),
              buildSizedBoxH(20.0),
              _buildSenderPaysSection(context, state),
              buildSizedBoxH(10.0),
              _buildExchangeRateSection(context, state),
              buildSizedBoxH(10.0),
              _buildYouReceiveSection(context, state),
              buildSizedBoxH(20.0),
              requestMoneyButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSenderPaysSection(BuildContext context, DashboardState state) {
    final fromCurrency = state.availableCurrencies.firstWhere(
      (currency) => currency.code == state.transferCalculator.fromCurrency,
      orElse: () => state.availableCurrencies.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_sender_pays,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.drawerIconColor,
            fontSize: ResponsiveHelper.getFontSize(
              context,
              mobile: 14.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
          ),
        ),
        buildSizedBoxH(10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.lightBoxBGColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: state.amountController,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).customColors.blackColor,
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 18.0,
                    ),
                  ),
                  cursorColor: Theme.of(context).customColors.blackColor,
                  decoration: InputDecoration(
                    hintText: Lang.of(context).lbl_enter_amount,
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).customColors.textdarkcolor,
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 16.0,
                        tablet: 18.0,
                        desktop: 18.0,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).customColors.lightBoxBGColor,
                    prefixText: fromCurrency.symbol,
                    prefixStyle: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).customColors.blackColor,
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 16.0,
                        tablet: 18.0,
                        desktop: 18.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical:
                          ResponsiveHelper.isDesktop(context) ? 26.0 : 20.0,
                    ),
                  ),
                  inputFormatters: [AmountFormatter()],
                  onChanged: (value) {
                    // Parse the amount from the text field
                    final amount =
                        double.tryParse(value.replaceAll(',', '')) ?? 0.0;

                    // First, update the amount in the state
                    context.read<DashboardBloc>().add(
                      TransferCalculatorAmountChanged(amount: amount),
                    );

                    // Then trigger the conversion if amount is greater than 0
                    if (amount > 0) {
                      context.read<DashboardBloc>().add(
                        TransferCalculatorConvertRequested(),
                      );
                    }
                    context.read<DashboardBloc>().add(
                      TransferCalculatorAmountChanged(
                        amount: double.parse(state.amountController.text),
                      ),
                    );
                  },
                ),
              ),
              buildSizedboxW(10.0),
              _buildCurrencyDropdown(
                context,
                state.availableCurrencies,
                fromCurrency,
                (currency) => context.read<DashboardBloc>().add(
                  TransferCalculatorFromCurrencyChanged(
                    currency: currency.code,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExchangeRateSection(BuildContext context, DashboardState state) {
    return Row(
      children: [
        buildSizedboxW(12.0),
        Column(
          children: [
            Container(
              width: 1,
              height: 25,
              color: Theme.of(context).customColors.lightDividerColor,
            ),
            state.isCalculating
                ? _buildRotatingIcon(context)
                : CustomImageView(
                  imagePath: Assets.images.svgs.dashboard.icConvert.path,
                  height: 32.0,
                  width: 32.0,
                  onTap: () {
                    context.read<DashboardBloc>().add(
                      TransferCalculatorConvertRequested(),
                    );
                  },
                ),
            Container(
              width: 1,
              height: 25,
              color: Theme.of(context).customColors.lightDividerColor,
            ),
          ],
        ),
        buildSizedboxW(16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1 ${state.transferCalculator.fromCurrency} = ${state.transferCalculator.exchangeRate} ${state.transferCalculator.toCurrency}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).customColors.drawerIconColor,
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
              ),
              buildSizedBoxH(4.0),
              Text(
                "${Lang.of(context).lbl_includes_fees} - ${state.transferCalculator.platformFee} ${state.transferCalculator.toCurrency}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).customColors.drawerIconColor,
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 12.0,
                    tablet: 13.0,
                    desktop: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYouReceiveSection(BuildContext context, DashboardState state) {
    final toCurrency = state.availableCurrencies.firstWhere(
      (currency) => currency.code == state.transferCalculator.toCurrency,
      orElse:
          () => state.availableCurrencies.firstWhere(
            (currency) => currency.code == 'INR',
            orElse: () => state.availableCurrencies.first,
          ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_you_receive,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.drawerIconColor,
            fontSize: ResponsiveHelper.getFontSize(
              context,
              mobile: 14.0,
              tablet: 14.0,
              desktop: 16.0,
            ),
          ),
        ),
        buildSizedBoxH(10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.lightBoxBGColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${toCurrency.symbol}${state.transferCalculator.estimatedAmount.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).customColors.blackColor,
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 18.0,
                    ),
                  ),
                ),
              ),
              buildSizedboxW(10.0),
              _buildCurrencyDropdown(
                context,
                state.availableCurrencies,
                toCurrency,
                (currency) => context.read<DashboardBloc>().add(
                  TransferCalculatorToCurrencyChanged(currency: currency.code),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown(
    BuildContext context,
    List<CurrencyModel> currencies,
    CurrencyModel selectedCurrency,
    Function(CurrencyModel) onChanged,
  ) {
    return CustomDropdown<CurrencyModel>(
      items: currencies,
      selectedItem: selectedCurrency,
      onChanged: onChanged,
      itemTextBuilder: (currency) => currency.code,
      fontSize: ResponsiveHelper.getFontSize(
        context,
        mobile: 14.0,
        tablet: 16.0,
        desktop: 18.0,
      ),
    );
  }

  Widget requestMoneyButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.0,
      width: double.infinity,
      text: Lang.of(context).lbl_request_money,
      onPressed: () {},
      buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: ResponsiveHelper.getFontSize(
          context,
          mobile: 16,
          tablet: 16,
          desktop: 18,
        ),
        color: Theme.of(context).customColors.fillColor,
        letterSpacing: 0.18,
      ),
      buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
    );
  }

  Widget _buildTotalBalanceDetail(BuildContext context, DashboardState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.fillColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).customColors.blackColor!.withValues(alpha: 0.05),
            blurRadius: 54.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Lang.of(context).lbl_total_balance,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).customColors.drawerIconColor,
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            desktop: 16.0,
                            tablet: 15.0,
                            mobile: 14.0,
                          ),
                        ),
                      ),
                      buildSizedBoxH(5.0),
                      Text(
                        "₹0.00 INR",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(
                                context,
                              ).customColors.paginationTextColor,
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            desktop: 28.0,
                            tablet: 26.0,
                            mobile: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAddReceivePopup(context),
              ],
            ),
          ),
          buildSizedBoxH(24.0),
          _buildHorizontalScrollableCards(context, state),
        ],
      ),
    );
  }

  Widget _buildAddReceivePopup(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 70),
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.transparent,
      itemBuilder:
          (context) => [
            PopupMenuItem<String>(
              enabled: false,
              padding: EdgeInsets.zero,
              value: 'receiving_form',
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return ReceivingPopup(
                    currencies: state.currencyOptions,
                    selectedCurrencyCode: state.receivingSelectedCurrencyCode,
                    selectedCountry: state.receivingSelectedCountry,
                    usedCurrencies: state.usedCurrencies,
                  );
                },
              ),
            ),
          ],
      onSelected: (value) {},
      onCanceled: () {
        // Clear selected data when menu is closed without selection
        print('PopupMenuButton onCanceled called');
        context.read<DashboardBloc>().add(ReceivingMenuClosed());
      },
      onOpened: () {
        context.read<DashboardBloc>().add(CurrencyStarted());
      },

      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).customColors.primaryColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).customColors.primaryColor!.withValues(alpha: 0.2),
              blurRadius: 24.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageView(
              imagePath: Assets.images.svgs.icons.icPlus.path,
              height: 15.0,
              width: 15.0,
              color: Theme.of(context).customColors.fillColor,
            ),
            buildSizedboxW(10.0),
            Text(
              "Add Receiving account",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).customColors.fillColor,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  mobile: 16,
                  tablet: 16,
                  desktop: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return CustomPopupMenuButton(
      items: [
        PopupMenuHelper.createHoverMenuItem(
          text: "Withdraw",
          value: "withdraw",
          context: context,
        ),
        PopupMenuHelper.createHoverMenuItem(
          text: "Bank Transfer Details",
          value: "bankTransferDetails",
          context: context,
        ),
        PopupMenuHelper.createHoverMenuItem(
          text: "Download Letter of Authorization",
          value: "downloadLetterOfAuthorization",
          context: context,
        ),
      ],
      onSelected: (value) {},
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).customColors.paginationTextColor,
      ),
    );
  }

  Widget _buildHorizontalScrollableCards(
    BuildContext context,
    DashboardState state,
  ) {
    return Builder(
      builder: (context) {
        final ScrollController scrollController = ScrollController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollConfiguration(
              behavior: DragScrollBehavior(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.0, 15.0, 24.0, 8.0),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: ResponsiveHelper.getScreenWidth(context) * 0.03,
                    children: List.generate(
                      state.balanceResponse?.available.length ?? 0,
                      (index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          width: ResponsiveHelper.getWidgetSize(
                            context,
                            desktop: 280,
                            tablet: 260,
                            mobile: 240,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).customColors.fillColor,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  0xFF0C1A4B,
                                ).withValues(alpha: 0.24),
                                blurRadius: 1,
                              ),
                              BoxShadow(
                                color: Color(
                                  0xFF323247,
                                ).withValues(alpha: 0.05),
                                spreadRadius: -1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
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
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).customColors.fillColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomImageView(
                                      imagePath:
                                          "assets/images/svgs/country/${state.balanceResponse?.available[index].currency}.svg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  buildSizedboxW(
                                    ResponsiveHelper.getWidgetSize(
                                      context,
                                      desktop: 20,
                                      tablet: 18,
                                      mobile: 16,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state
                                                .balanceResponse
                                                ?.available[index]
                                                .currency ??
                                            '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge!.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobile: 12.0,
                                                tablet: 13.0,
                                                desktop: 14.0,
                                              ),
                                          color:
                                              Theme.of(
                                                context,
                                              ).customColors.drawerIconColor,
                                        ),
                                      ),
                                      buildSizedBoxH(4),
                                      Text(
                                        state
                                            .balanceResponse!
                                            .available[index]
                                            .amount,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge!.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobile: 14.0,
                                                tablet: 15.0,
                                                desktop: 16.0,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Theme.of(
                                                context,
                                              ).customColors.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              _buildPopupMenuButton(context),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            _buildScrollNavigationArrows(context, scrollController),
          ],
        );
      },
    );
  }

  Widget _buildScrollNavigationArrows(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomImageView(
            imagePath: Assets.images.svgs.icons.icArrowPageLeft.path,
            height: 20.0,
            width: 20.0,
            onTap: () {
              // Scroll left
              if (scrollController.hasClients) {
                final currentOffset = scrollController.offset;
                final scrollDistance = ResponsiveHelper.getWidgetSize(
                  context,
                  desktop: 300,
                  tablet: 280,
                  mobile: 260,
                );
                final newOffset = (currentOffset - scrollDistance).clamp(
                  0.0,
                  scrollController.position.maxScrollExtent,
                );

                scrollController.animateTo(
                  newOffset,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          buildSizedboxW(
            ResponsiveHelper.getWidgetSize(
              context,
              desktop: 12,
              tablet: 10,
              mobile: 8,
            ),
          ),
          CustomImageView(
            imagePath: Assets.images.svgs.icons.icArrowPageRight.path,
            height: 20.0,
            width: 20.0,
            onTap: () {
              if (scrollController.hasClients) {
                final currentOffset = scrollController.offset;
                final scrollDistance = ResponsiveHelper.getWidgetSize(
                  context,
                  desktop: 300,
                  tablet: 280,
                  mobile: 260,
                );
                final newOffset = (currentOffset + scrollDistance).clamp(
                  0.0,
                  scrollController.position.maxScrollExtent,
                );

                scrollController.animateTo(
                  newOffset,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingIcon(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: CustomImageView(
            imagePath: Assets.images.svgs.dashboard.icConvert.path,
            height: 32.0,
            width: 32.0,
            onTap: null,
          ),
        );
      },
      onEnd: () {
        // Restart the animation when it ends
        if (context.mounted) {
          // This will trigger a rebuild and restart the animation
        }
      },
    );
  }
}
