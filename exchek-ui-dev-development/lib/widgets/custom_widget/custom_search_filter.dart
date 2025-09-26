import 'package:flutter/material.dart';

// Model class for selection items
class SelectionItem {
  final String id;
  final String title;
  final bool isSelected;
  final IconData? icon;

  SelectionItem({required this.id, required this.title, this.isSelected = false, this.icon});

  SelectionItem copyWith({String? id, String? title, bool? isSelected, IconData? icon}) {
    return SelectionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
    );
  }
}

// Custom Dropdown Field with Popup
class CustomSearchFilter extends StatefulWidget {
  final String title;
  final String optionTitle;
  final String? hintText;
  final List<SelectionItem> items;
  final Function(List<SelectionItem>) onSelectionChanged;
  final bool multiSelect;
  final String? searchHint;
  final double? popupWidth;
  final double? popupMaxHeight;
  final bool searchBarShow;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final bool autoOpen;

  const CustomSearchFilter({
    super.key,
    required this.title,
    required this.optionTitle,
    required this.items,
    required this.onSelectionChanged,
    this.hintText,
    this.multiSelect = true,
    this.searchHint = "Search here",
    this.popupWidth,
    this.popupMaxHeight = 300,
    this.searchBarShow = true,
    this.onOpen,
    this.onClose,
    this.autoOpen = false,
  });

  @override
  State<CustomSearchFilter> createState() => _CustomSearchFilterState();
}

class _CustomSearchFilterState extends State<CustomSearchFilter> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late List<SelectionItem> _workingItems;

  @override
  void initState() {
    super.initState();
    _workingItems = widget.items.map((item) => item).toList();
    if (widget.autoOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isOpen) {
          widget.onOpen?.call();
          _openDropdown();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant CustomSearchFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _workingItems = widget.items.map((item) => item).toList();

    if (widget.autoOpen && !_isOpen) {
      widget.onOpen?.call();
      _openDropdown();
    } else if (!widget.autoOpen && _isOpen) {
      widget.onClose?.call();
      closeDropdown();
    }
  }

  void clearSelections() {
    setState(() {
      _workingItems = _workingItems.map((item) => item.copyWith(isSelected: false)).toList();
    });
    widget.onSelectionChanged(_workingItems);
  }

  void _toggleDropdown() {
    if (_isOpen) {
      widget.onClose?.call();
      closeDropdown();
    } else {
      widget.onOpen?.call();
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!_isOpen) {
          _openDropdown();
        }
      });
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
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              /// Outside tap detector
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    widget.onClose?.call();
                    closeDropdown();
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                width: widget.popupWidth ?? size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 8.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {},
                      child: _DropdownPopup(
                        title: widget.title,
                        optionTitle: widget.optionTitle,
                        items: _workingItems,
                        searchHint: widget.searchHint ?? '',
                        multiSelect: widget.multiSelect,
                        maxHeight: widget.popupMaxHeight ?? 300,
                        searchBarShow: widget.searchBarShow,
                        onApply: (selected) {
                          setState(() {
                            _workingItems = selected;
                          });
                          widget.onSelectionChanged(selected);
                          widget.onClose?.call();
                          closeDropdown();
                        },
                        onSingleSelect: (selected) {
                          setState(() {
                            _workingItems = selected;
                          });
                          widget.onSelectionChanged(selected);
                          widget.onClose?.call();
                          closeDropdown();
                        },
                        onCancel: () {
                          widget.onClose?.call();
                          closeDropdown();
                        },
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
    final selectedItems = _workingItems.where((item) => item.isSelected).toList();
    if (selectedItems.isEmpty) return widget.hintText ?? widget.title;
    if (selectedItems.length == 1) return selectedItems.first.title;
    if (selectedItems.length <= 3) {
      return selectedItems.map((item) => item.title).join(', ');
    }
    final firstThree = selectedItems.take(3).map((item) => item.title).join(', ');
    final remainingCount = selectedItems.length - 3;
    return '$firstThree +$remainingCount';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _isOpen ? theme.primaryColor : Colors.grey, width: _isOpen ? 2 : 1),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _displayText,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black54, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownPopup extends StatefulWidget {
  final String title;
  final String optionTitle;
  final List<SelectionItem> items;
  final String searchHint;
  final bool multiSelect;
  final double maxHeight;
  final bool searchBarShow;
  final Function(List<SelectionItem>) onApply;
  final Function(List<SelectionItem>) onSingleSelect;
  final VoidCallback onCancel;

  const _DropdownPopup({
    required this.title,
    required this.optionTitle,
    required this.items,
    required this.searchHint,
    required this.multiSelect,
    required this.maxHeight,
    required this.searchBarShow,
    required this.onApply,
    required this.onSingleSelect,
    required this.onCancel,
  });

  @override
  State<_DropdownPopup> createState() => _DropdownPopupState();
}

class _DropdownPopupState extends State<_DropdownPopup> {
  late List<SelectionItem> _workingItems;
  late List<SelectionItem> _filteredItems;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _workingItems = widget.items.map((item) => item).toList();
    _filteredItems = List.from(_workingItems);

    if (widget.searchBarShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _workingItems.where((item) => item.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _toggleSelection(int index) {
    int realIndex = _workingItems.indexWhere((e) => e.id == _filteredItems[index].id);
    if (realIndex == -1) return;

    setState(() {
      if (widget.multiSelect) {
        _workingItems[realIndex] = _workingItems[realIndex].copyWith(isSelected: !_workingItems[realIndex].isSelected);
      } else {
        for (int i = 0; i < _workingItems.length; i++) {
          _workingItems[i] = _workingItems[i].copyWith(isSelected: i == realIndex);
        }
      }
      _filteredItems =
          _workingItems
              .where((item) => item.title.toLowerCase().contains(_searchController.text.toLowerCase()))
              .toList();
    });

    if (!widget.multiSelect) {
      widget.onSingleSelect(_workingItems);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              widget.optionTitle,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          if (widget.searchBarShow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8),
                ),
                onChanged: _filterItems,
              ),
            ),
          Flexible(
            child:
                _filteredItems.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('No items found', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = item.isSelected;
                        return InkWell(
                          onTap: () => _toggleSelection(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
                            child: Row(
                              children: [
                                if (widget.multiSelect)
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: isSelected ? theme.primaryColor : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? theme.primaryColor : Colors.grey.shade400,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                  ),
                                if (widget.multiSelect) const SizedBox(width: 8),
                                if (item.icon != null) ...[
                                  Icon(item.icon, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: isSelected ? Colors.black87 : Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          if (widget.multiSelect)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: widget.onCancel,
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => widget.onApply(_workingItems),
                      child: const Text("Apply",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
