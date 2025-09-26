import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

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

class PersonalTransactionAndPaymentPreferencesView extends StatelessWidget {
  const PersonalTransactionAndPaymentPreferencesView({super.key});

  static final GlobalKey personalReceivePaymentKey = GlobalKey();

  bool _isTextInputFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final ctx = focused?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText;
  }

  void _scrollBy(BuildContext context, double delta) {
    final controller = context.read<PersonalAccountSetupBloc>().state.scrollController;
    if (!controller.hasClients) return;
    final position = controller.position;
    final target = (position.pixels + delta).clamp(0.0, position.maxScrollExtent);
    controller.animateTo(target, duration: const Duration(milliseconds: 90), curve: Curves.easeOut);
  }

  KeyEventResult _onKeyEvent(BuildContext context, FocusNode node, KeyEvent event) {
    if (!kIsWeb) return KeyEventResult.ignored;
    if (_isTextInputFocused()) return KeyEventResult.ignored;

    const double lineDelta = 80.0;
    final bool isPressOrRepeat = event is KeyDownEvent || event is KeyRepeatEvent;

    if (isPressOrRepeat &&
        (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      final delta = event.logicalKey == LogicalKeyboardKey.arrowDown ? lineDelta : -lineDelta;
      _scrollBy(context, delta);
      return KeyEventResult.handled;
    }

    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.pageDown || event.logicalKey == LogicalKeyboardKey.pageUp)) {
      final controller = context.read<PersonalAccountSetupBloc>().state.scrollController;
      if (controller.hasClients) {
        final vp = controller.position.viewportDimension;
        _scrollBy(context, event.logicalKey == LogicalKeyboardKey.pageDown ? vp * 0.9 : -vp * 0.9);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Focus(
          autofocus: kIsWeb,
          onKeyEvent: (node, event) => _onKeyEvent(context, node, event),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
                ),
                child:
                    state.isLoading
                        ? Padding(padding: const EdgeInsets.only(top: 40), child: AppLoaderWidget())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSizedBoxH(20),
                            _buildPersonalEstimatedMonthlyTransaction(context, state),
                            buildSizedBoxH(60),
                            // if (state.currencyList != null) _buildCurrenciesSelections(context, state),
                            // buildSizedBoxH(40),
                            _buildNextButton(context, state),
                            buildSizedBoxH(40),
                          ],
                        ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalEstimatedMonthlyTransaction(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_estimatedVolumeTitle,
          description: Lang.of(context).lbl_estimatedVolumeDescription,
        ),
        buildSizedBoxH(20),
        Column(
          children: List.generate(state.estimatedMonthlyVolumeList?.length ?? 0, (index) {
            return CustomTileWidget(
              title: state.estimatedMonthlyVolumeList?[index] ?? '',
              isSelected: state.selectedEstimatedMonthlyTransaction == state.estimatedMonthlyVolumeList?[index],
              onTap: () {
                context.read<PersonalAccountSetupBloc>().add(
                  PersonalChangeEstimatedMonthlyTransaction(state.estimatedMonthlyVolumeList?[index] ?? ''),
                );
                context.read<PersonalAccountSetupBloc>().add(PersonalScrollToPosition(personalReceivePaymentKey));
              },
            );
          }),
        ),
      ],
    );
  }

  // Widget _buildCurrenciesSelections(BuildContext context, PersonalAccountSetupState state) {
  //   return Column(
  //     key: personalReceivePaymentKey,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildSelectionTitleAndDescription(
  //         context: context,
  //         title: Lang.of(context).lbl_transactionScreenTitle,
  //         description: Lang.of(context).lbl_currencyDescription,
  //       ),
  //       buildSizedBoxH(20.0),

  //       // Currency list with grouping
  //       Column(
  //         children:
  //             state.currencyList!.map((currency) {
  //               final isSelected = state.selectedCurrencies?.any((c) => c.currencySymbol == currency.currencySymbol);
  //               return CustomTileWidget(
  //                 showTrailingCheckbox: true,
  //                 isShowTrailing: true,
  //                 title: currency.currencyName,
  //                 isSelected: isSelected ?? false,
  //                 leadingImagePath: currency.currencyImagePath,
  //                 titleWidget: _buildCurrencyTitle(context, currency),
  //                 onTap: () {
  //                   context.read<PersonalAccountSetupBloc>().add(PersonalToggleCurrencySelection(currency));
  //                 },
  //               );
  //             }).toList(),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCurrencyTitle(BuildContext context, CurrencyModel currency) {
  //   return Text.rich(
  //     TextSpan(
  //       text: currency.currencySymbol,
  //       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //         fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
  //         fontWeight: FontWeight.w600,
  //         letterSpacing: 0.16,
  //         height: 1.16,
  //       ),
  //       children: [
  //         const TextSpan(text: "  "),
  //         TextSpan(
  //           text: currency.currencyName,
  //           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //             fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
  //             fontWeight: FontWeight.w400,
  //             color: Theme.of(context).customColors.secondaryTextColor,
  //             letterSpacing: 0.16,
  //             height: 1.16,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNextButton(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomElevatedButton(
        text: Lang.of(context).lbl_next,
        width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 120 : double.maxFinite,
        height: 48,
        borderRadius: 8.0,
        isDisabled: !_isButtonEnabled(state),
        isLoading: state.isTransactionDetailLoading ?? false,
        onPressed: () {
          context.read<PersonalAccountSetupBloc>().add(
            PersonalTransactionDetailSubmitted(
              currencyList: state.selectedCurrencies ?? [],
              monthlyTransaction: state.selectedEstimatedMonthlyTransaction ?? '',
            ),
          );
        },
        buttonTextStyle: TextStyle(
          color: Theme.of(context).customColors.fillColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
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

  bool _isButtonEnabled(PersonalAccountSetupState state) {
    return state.selectedEstimatedMonthlyTransaction != null;
  }
}
