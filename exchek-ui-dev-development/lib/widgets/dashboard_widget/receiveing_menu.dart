import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';

class ReceivingPopup extends StatefulWidget {
  final List<CurrencyOption> currencies;
  final List<String> usedCurrencies;
  final String? selectedCurrencyCode;
  final Country? selectedCountry;

  const ReceivingPopup({
    super.key,
    required this.currencies,
    required this.usedCurrencies,
    required this.selectedCurrencyCode,
    required this.selectedCountry,
  });

  @override
  State<ReceivingPopup> createState() => _ReceivingPopupState();
}

class _ReceivingPopupState extends State<ReceivingPopup> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedCurrency = widget.selectedCurrencyCode;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardBloc bloc = context.read<DashboardBloc>();

    // Filter currencies based on search query (show all currencies, both used and unused)
    final List<CurrencyOption> filteredCurrencies =
        widget.currencies.where((currency) {
          if (_searchQuery.isEmpty) return true;
          return currency.currencyCode.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              currency.currencyDescription.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

    // Sort all filtered currencies alphabetically (mixed used and unused)
    final List<CurrencyOption> sortedCurrencies =
        filteredCurrencies
          ..sort((a, b) => a.currencyCode.compareTo(b.currencyCode));

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 360,
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).customColors.fillColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).customColors.blackColor!.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Search Bar with placeholder text
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).customColors.fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xffEBEEF9)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Type currency',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff979797),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Color(0xff979797)),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).customColors.blackColor,
                ),
              ),
            ),

            buildSizedBoxH(16),

            /// Section Title
            Text(
              'All available currencies',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).customColors.blackColor?.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),

            buildSizedBoxH(12),

            /// Currency List
            if (sortedCurrencies.isNotEmpty) ...[
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = sortedCurrencies[index];
                      final isUsedCurrency = widget.usedCurrencies.contains(
                        currency.currencyCode,
                      );
                      final isSelected =
                          currency.currencyCode == _selectedCurrency;
                      final isLastItem = index == sortedCurrencies.length - 1;

                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: isLastItem ? 0 : 8),
                            decoration: BoxDecoration(
                              color:
                                  isUsedCurrency
                                      ? Color(0xffEBF3FC)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: Color(0xffEBEEF9),
                                        width: 2,
                                      )
                                      : null,
                            ),
                            child: Tooltip(
                              message:
                                  isUsedCurrency
                                      ? 'Account exists'
                                      : '',
                              showDuration: const Duration(seconds: 2),
                              waitDuration: const Duration(milliseconds: 500),
                              child: ListTile(
                                onTap:
                                    isUsedCurrency
                                        ? null // Disable tap for used currencies
                                        : () {
                                          setState(() {
                                            _selectedCurrency =
                                                currency.currencyCode;
                                          });
                                          bloc.add(
                                            ReceivingCurrencyChanged(
                                              currency: currency.currencyCode,
                                            ),
                                          );
                                        },
                                leading: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/svgs/country/${currency.currencyCode}.svg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: currency.currencyCode,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).customColors.blackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${currency.currencyDescription}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).customColors.blackColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      if (isUsedCurrency)
                                        TextSpan(
                                          text: ' (Account exists)',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context)
                                                .customColors
                                                .blackColor
                                                ?.withOpacity(0.6),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing:
                                    isSelected && !isUsedCurrency
                                        ? Icon(
                                          Icons.check,
                                          color: Color(0xff009957),
                                          size: 20,
                                        )
                                        : null,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          if (!isLastItem) Container(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).customColors.borderColor!,
                  ),
                ),
                child: Center(
                  child: Text(
                    'No currencies found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).customColors.blackColor?.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],

            buildSizedBoxH(20),

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  // Check if there are any unused currencies available
                  final availableUnusedCurrencies =
                      widget.currencies
                          .where(
                            (currency) =>
                                !widget.usedCurrencies.contains(
                                  currency.currencyCode,
                                ),
                          )
                          .toList();

                  final isDisabled =
                      _selectedCurrency == null ||
                      availableUnusedCurrencies.isEmpty ||
                      widget.usedCurrencies.contains(_selectedCurrency);

                  return CustomElevatedButton(
                    height: 48,
                    text:
                        availableUnusedCurrencies.isEmpty
                            ? 'No Currencies Available'
                            : 'Confirm',
                    onPressed:
                        isDisabled
                            ? null
                            : () {
                              bloc.add(const ReceivingAccountConfirm());
                              GoRouter.of(context).pop();

                              debugPrint(
                                'Selected currency: $_selectedCurrency',
                              );

                              context.read<DashboardBloc>().add(
                                GetCreateCurrency(
                                  currency: _selectedCurrency.toString(),
                                ),
                              );
                              context.read<DashboardBloc>().add(
                                CurrencyStarted(),
                              );
                            },
                    isDisabled: isDisabled,
                    buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(
                      context,
                    ),
                    buttonTextStyle: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).customColors.fillColor,
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 16,
                        tablet: 16,
                        desktop: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
