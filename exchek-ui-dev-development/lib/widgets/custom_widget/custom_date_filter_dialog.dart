import 'package:exchek/core/utils/exports.dart';

// Date Range Model
class DateRange {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? presetName;

  DateRange({this.startDate, this.endDate, this.presetName});

  bool get isEmpty => startDate == null && endDate == null;
  bool get isRange => startDate != null && endDate != null;
  bool get isSingleDate => startDate != null && endDate == null;

  DateRange copyWith({DateTime? startDate, DateTime? endDate, String? presetName}) {
    return DateRange(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      presetName: presetName ?? this.presetName,
    );
  }
}

// Custom Date Picker Field
class CustomDatePicker extends StatefulWidget {
  final String title;
  final String? hintText;
  final DateRange? initialDateRange;
  final Function(DateRange) onDateRangeChanged;
  final double? popupWidth;
  final double? popupMaxHeight;
  final bool allowSingleDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const CustomDatePicker({
    super.key,
    required this.title,
    required this.onDateRangeChanged,
    this.hintText,
    this.initialDateRange,
    this.popupWidth,
    this.popupMaxHeight = 500,
    this.allowSingleDate = false,
    this.minDate,
    this.maxDate,
  });

  @override
  State<CustomDatePicker> createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  DateRange _currentDateRange = DateRange();

  void clearSelection() {
    setState(() {
      _currentDateRange = DateRange();
    });
    widget.onDateRangeChanged(_currentDateRange);
  }

  @override
  void initState() {
    super.initState();
    // Do NOT preselect in the field; show hint until user applies.
    // Popup will still default to Today via _initializeDates().
    _currentDateRange = widget.initialDateRange ?? DateRange();
  }

  @override
  void didUpdateWidget(CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDateRange != oldWidget.initialDateRange) {
      _currentDateRange = widget.initialDateRange ?? DateRange();
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Invisible overlay to detect taps outside
              Positioned.fill(
                child: GestureDetector(onTap: closeDropdown, child: Container(color: Colors.transparent)),
              ),
              // Dropdown content
              Positioned(
                width: widget.popupWidth ?? 600,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 8.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {
                        // Prevent closing when tapping inside the dropdown
                      },
                      child: _DatePickerPopup(
                        initialDateRange: _currentDateRange,
                        maxHeight: widget.popupMaxHeight ?? 500,
                        allowSingleDate: widget.allowSingleDate,
                        minDate: widget.minDate,
                        maxDate: widget.maxDate,
                        onDateRangeChanged: (dateRange) {
                          setState(() {
                            _currentDateRange = dateRange;
                          });
                          widget.onDateRangeChanged(dateRange);
                        },
                        onClose: closeDropdown,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  String get _displayText {
    if (_currentDateRange.isEmpty) {
      return widget.hintText ?? widget.title;
    }

    // Always prefer showing actual date(s) so presets display as a concrete range
    if (_currentDateRange.isSingleDate) {
      return _formatDate(_currentDateRange.startDate!);
    }

    if (_currentDateRange.isRange) {
      return '${_formatDate(_currentDateRange.startDate!)} - ${_formatDate(_currentDateRange.endDate!)}';
    }

    // Fallback to preset label if no dates are set for some reason
    if (_currentDateRange.presetName != null) {
      return _currentDateRange.presetName!;
    }

    return widget.hintText ?? widget.title;
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isOpen ? theme.customColors.filtercheckboxcolor! : theme.customColors.filterbordercolor!,
              width: _isOpen ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
            color: theme.customColors.fillColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CustomImageView(
                  //   imagePath: Assets.images.svgs.icons.icCalender.path,
                  //   alignment: Alignment.center,
                  //   onTap: () {},
                  // ),
                  Icon(Icons.calendar_today, size: 20, color: theme.customColors.blackColor),
                  buildSizedboxW(16),
                  Text(
                    _displayText,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              buildSizedboxW(12),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: theme.customColors.blackColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    closeDropdown();
    super.dispose();
  }
}

// Internal Date Picker Popup Widget
class _DatePickerPopup extends StatefulWidget {
  final DateRange initialDateRange;
  final double maxHeight;
  final bool allowSingleDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Function(DateRange) onDateRangeChanged;
  final VoidCallback onClose;

  const _DatePickerPopup({
    required this.initialDateRange,
    required this.maxHeight,
    required this.allowSingleDate,
    required this.onDateRangeChanged,
    required this.onClose,
    this.minDate,
    this.maxDate,
  });

  @override
  State<_DatePickerPopup> createState() => _DatePickerPopupState();
}

class _DatePickerPopupState extends State<_DatePickerPopup> {
  late DateTime _currentMonth1;
  late DateTime _currentMonth2;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? _hoverDate;
  String? _selectedPreset;

  // Horizontal scroll controller for small screens
  final ScrollController _horizontalController = ScrollController();

  final List<Map<String, dynamic>> _presetOptions = [
    {'label': 'Today', 'value': 'today'},
    {'label': 'Last 7 days', 'value': 'last7days'},
    {'label': 'Last 15 days', 'value': 'last15days'},
    {'label': 'Last 30 days', 'value': 'last30days'},
    {'label': 'Last 3 months', 'value': 'last3months'},
    {'label': 'Custom', 'value': 'custom'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  void _initializeDates() {
    // Initialize with current month (left) and next month (right)
    final now = DateTime.now();
    _currentMonth1 = DateTime(now.year, now.month, 1);
    _currentMonth2 = DateTime(now.year, now.month + 1, 1);

    // If no initial range, default to Today
    if (widget.initialDateRange.startDate == null && widget.initialDateRange.endDate == null) {
      _selectedStartDate = DateTime(now.year, now.month, now.day);
      _selectedEndDate = null;
      _selectedPreset = 'today';
    } else {
      _selectedStartDate = widget.initialDateRange.startDate;
      _selectedEndDate = widget.initialDateRange.endDate;
      _selectedPreset = widget.initialDateRange.presetName ?? 'custom';
    }
  }

  void _selectPreset(String preset) {
    setState(() {
      _selectedPreset = preset;
      final now = DateTime.now();

      switch (preset) {
        case 'today':
          // For Today, show a single date (no range)
          _selectedStartDate = DateTime(now.year, now.month, now.day);
          _selectedEndDate = null;
          break;
        case 'last7days':
          final end = DateTime(now.year, now.month, now.day);
          _selectedEndDate = end;
          _selectedStartDate = end.subtract(const Duration(days: 6));
          break;
        case 'last15days':
          final end = DateTime(now.year, now.month, now.day);
          _selectedEndDate = end;
          _selectedStartDate = end.subtract(const Duration(days: 14));
          break;
        case 'last30days':
          final end = DateTime(now.year, now.month, now.day);
          _selectedEndDate = end;
          _selectedStartDate = end.subtract(const Duration(days: 29));
          break;
        case 'last3months':
          final end = DateTime(now.year, now.month, now.day);
          _selectedEndDate = end;
          _selectedStartDate = DateTime(end.year, end.month - 3, end.day);
          break;
        case 'custom':
          // Keep existing selection for custom
          break;
      }
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedPreset = 'custom';

      if (widget.allowSingleDate) {
        _selectedStartDate = date;
        _selectedEndDate = null;
      } else {
        if (_selectedStartDate == null || (_selectedStartDate != null && _selectedEndDate != null)) {
          _selectedStartDate = date;
          _selectedEndDate = null;
        } else if (_selectedEndDate == null) {
          if (date.isBefore(_selectedStartDate!)) {
            _selectedEndDate = _selectedStartDate;
            _selectedStartDate = date;
          } else {
            _selectedEndDate = date;
          }
        }
      }
    });
  }

  void _onDateHover(DateTime? date) {
    setState(() {
      _hoverDate = date;
    });
  }

  void _navigateMonth(bool isNext, bool isFirstCalendar) {
    setState(() {
      if (isFirstCalendar) {
        if (isNext) {
          _currentMonth1 = DateTime(_currentMonth1.year, _currentMonth1.month + 1, 1);
          // Ensure second calendar is always one month ahead
          _currentMonth2 = DateTime(_currentMonth1.year, _currentMonth1.month + 1, 1);
        } else {
          _currentMonth1 = DateTime(_currentMonth1.year, _currentMonth1.month - 1, 1);
          _currentMonth2 = DateTime(_currentMonth1.year, _currentMonth1.month + 1, 1);
        }
      } else {
        if (isNext) {
          _currentMonth2 = DateTime(_currentMonth2.year, _currentMonth2.month + 1, 1);
          // Ensure first calendar is always one month behind
          _currentMonth1 = DateTime(_currentMonth2.year, _currentMonth2.month - 1, 1);
        } else {
          _currentMonth2 = DateTime(_currentMonth2.year, _currentMonth2.month - 1, 1);
          _currentMonth1 = DateTime(_currentMonth2.year, _currentMonth2.month - 1, 1);
        }
      }
    });
  }

  void _applySelection() {
    final dateRange = DateRange(
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
      presetName: _selectedPreset != 'custom' ? _selectedPreset : null,
    );
    widget.onDateRangeChanged(dateRange);
    widget.onClose();
  }

  void _cancel() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.customColors.fillColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0XFFA9A9A9).withValues(alpha: 0.60),
            blurRadius: 61,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left sidebar with presets
            Container(
              width: 150,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SELECT BY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._presetOptions.map((option) {
                    final isSelected = _selectedPreset == option['value'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => _selectPreset(option['value']),
                        child: Text(
                          option['label'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color:
                                isSelected
                                    ? Theme.of(context).customColors.primaryColor!
                                    : Theme.of(context).customColors.blackColor,
                            height: 1.2,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Vertical divider
            Container(width: 1, height: 410, color: const Color(0xFFE5E7EB)),
            // Right section with calendars
            Expanded(
              child: Column(
                children: [
                  // Calendar section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // First Calendar
                        Expanded(child: _buildCalendar(_currentMonth1, true, Theme.of(context))),
                        buildSizedboxW(24),
                        // Second Calendar
                        Expanded(child: _buildCalendar(_currentMonth2, false, Theme.of(context))),
                      ],
                    ),
                  ),
                  // Bottom border
                  Container(height: 1, color: const Color(0xFFE5E7EB)),
                  // Footer Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _cancel,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        CustomElevatedButton(
                          text: 'Apply',
                          onPressed: _applySelection,
                          borderRadius: 12.0,
                          buttonStyle: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(const Color(0xFF059669)),
                            foregroundColor: WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            elevation: WidgetStateProperty.all(0),
                            textStyle: WidgetStateProperty.all(
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: theme.customColors.fillColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // ElevatedButton(

                        //   onPressed: _applySelection,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xFF059669),
                        //     foregroundColor: Colors.white,
                        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        //     elevation: 0,
                        //     textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        //   ),

                        //   child: const Text('Apply'),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime month, bool isFirstCalendar, ThemeData theme) {
    const weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Column(
      children: [
        // Month Header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              if (isFirstCalendar)
                Container(
                  padding: const EdgeInsets.all(4),
                  // child: CustomImageView(
                  //   imagePath: Assets.images.svgs.icons.icLeftCalenderArrow.path,
                  //   alignment: Alignment.center,
                  //   onTap: () {
                  //     _navigateMonth(false, isFirstCalendar);
                  //   },
                  // ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () {
                      _navigateMonth(false, isFirstCalendar);
                    },
                  ),
                ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  '${months[month.month - 1]} ${month.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                ),
              ),
              if (!isFirstCalendar)
                Container(
                  padding: const EdgeInsets.all(4),
                  // child:
                  // CustomImageView(
                  //   imagePath: Assets.images.svgs.icons.icRightCalenderArrow.path,
                  //   alignment: Alignment.center,
                  //   onTap: () {
                  //     _navigateMonth(true, isFirstCalendar);
                  //   },
                  // ),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: () {
                      _navigateMonth(true, isFirstCalendar);
                    },
                  ),
                ),
            ],
          ),
        ),

        // Week Days Header
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children:
                weekDays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.customColors.drawerIconColor,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        // Calendar Grid
        _buildCalendarGrid(month),
      ],
    );
  }

  Widget _buildCalendarGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOfCalendar = firstDay.subtract(Duration(days: (firstDay.weekday - 1) % 7));
    final theme = Theme.of(context);

    return SizedBox(
      height: 220, // Fixed height for 6 rows
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 0.5,
            mainAxisSpacing: 2,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final date = startOfCalendar.add(Duration(days: index));
            final isCurrentMonth = date.month == month.month;
            final isSelected = _isDateSelected(date);
            final isInRange = _isDateInRange(date);

            return MouseRegion(
              onEnter: (_) => _onDateHover(date),
              onExit: (_) => _onDateHover(null),
              child: GestureDetector(
                onTap: isCurrentMonth ? () => _onDateTap(date) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getDateColor(date, isSelected, isInRange, theme),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: _getDateTextColor(date, isSelected, isCurrentMonth, theme),
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

  bool _isDateSelected(DateTime date) {
    return (_selectedStartDate != null && _isSameDay(date, _selectedStartDate!)) ||
        (_selectedEndDate != null && _isSameDay(date, _selectedEndDate!));
  }

  bool _isDateInRange(DateTime date) {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      if (_selectedStartDate != null && _hoverDate != null && !widget.allowSingleDate) {
        final start = _selectedStartDate!.isBefore(_hoverDate!) ? _selectedStartDate! : _hoverDate!;
        final end = _selectedStartDate!.isBefore(_hoverDate!) ? _hoverDate! : _selectedStartDate!;
        return date.isAfter(start) && date.isBefore(end);
      }
      return false;
    }
    return date.isAfter(_selectedStartDate!) && date.isBefore(_selectedEndDate!);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Color? _getDateColor(DateTime date, bool isSelected, bool isInRange, ThemeData theme) {
    if (isSelected) return theme.customColors.blueColor;
    if (isInRange) return theme.customColors.lightBlueColor;
    return null;
  }

  Color _getDateTextColor(DateTime date, bool isSelected, bool isCurrentMonth, ThemeData theme) {
    if (isSelected) return theme.customColors.fillColor!;
    if (!isCurrentMonth) return theme.customColors.darkGreyColor!;
    return theme.customColors.blackColor!;
  }
}
