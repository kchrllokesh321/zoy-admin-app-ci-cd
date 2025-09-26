import 'package:exchek/core/responsive_helper/responsive_helper.dart';
import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:flutter/material.dart';

class ExpandableDropdownField extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const ExpandableDropdownField({super.key, required this.items, this.selectedValue, required this.onChanged});

  @override
  State<ExpandableDropdownField> createState() => _ExpandableDropdownFieldState();
}

class _ExpandableDropdownFieldState extends State<ExpandableDropdownField> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExpandableDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {});
    }
  }

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
  }

  void _selectItem(String item) {
    setState(() {
      _expanded = false;
    });
    widget.onChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleExpand,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1.5,
                  color:
                      _expanded
                          ? Theme.of(context).customColors.primaryColor!
                          : Theme.of(context).customColors.boxBorderColor!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1.5,
                  color:
                      _expanded
                          ? Theme.of(context).customColors.primaryColor!
                          : Theme.of(context).customColors.boxBorderColor!,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              suffixIcon: Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Theme.of(context).customColors.iconColor,
              ),
            ),
            child: Text(
              (widget.selectedValue == null || widget.selectedValue == '')
                  ? 'Select'
                  : widget.selectedValue ?? 'Select',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
                color:
                    (widget.selectedValue != null && widget.selectedValue != '')
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : Theme.of(context).customColors.blackColor,
              ),
            ),
          ),
        ),
        if (_expanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).customColors.borderColor!),
            ),
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    hoverColor:
                        Theme.of(context).customColors.blueColor?.withValues(alpha: 0.1) ??
                        Theme.of(context).customColors.blueColor!.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    title: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => _selectItem(item),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
