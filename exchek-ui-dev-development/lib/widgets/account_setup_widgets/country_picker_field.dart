import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';

class ExpandableCountryDropdownField extends StatefulWidget {
  final Country? selectedCountry;
  final List<Country> countryList;
  final Function(Country) onChanged;
  final bool isDisable;

  const ExpandableCountryDropdownField({
    super.key,
    required this.selectedCountry,
    required this.countryList,
    required this.onChanged,
    this.isDisable = false,
  });

  @override
  State<ExpandableCountryDropdownField> createState() => _ExpandableCountryDropdownFieldState();
}

class _ExpandableCountryDropdownFieldState extends State<ExpandableCountryDropdownField> {
  bool _expanded = false;
  Country? _selectedCountry;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.selectedCountry;
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      _errorText = null; // Clear error when interacted
    });
  }

  void _selectCountry(Country country) {
    setState(() {
      _selectedCountry = country;
      _expanded = false;
      _errorText = null;
    });
    widget.onChanged(country);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _toggleExpand,
          child: InputDecorator(
            decoration: InputDecoration(
              errorText: _errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      widget.isDisable
                          ? Theme.of(context).customColors.lightBorderColor!
                          : Theme.of(context).customColors.borderColor!,
                ),
              ),
              fillColor:
                  widget.isDisable
                      ? Theme.of(context).customColors.disabledColor
                      : Theme.of(context).customColors.fillColor,
              suffixIcon: Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Theme.of(context).customColors.iconColor,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            ),
            child: Text(
              _selectedCountry?.name ?? 'Select',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
                color:
                    _selectedCountry?.name != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).customColors.textdarkcolor,
              ),
            ),
          ),
        ),
        if (_expanded)
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    widget.isDisable
                        ? Theme.of(context).customColors.lightBorderColor!
                        : Theme.of(context).customColors.borderColor!,
              ),
              borderRadius: BorderRadius.circular(12),
              color:
                  widget.isDisable
                      ? Theme.of(context).customColors.disabledColor
                      : Theme.of(context).customColors.fillColor,
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.countryList.length,
              itemBuilder: (context, index) {
                final country = widget.countryList[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text(
                    country.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () => _selectCountry(country),
                );
              },
            ),
          ),
      ],
    );
  }
}
