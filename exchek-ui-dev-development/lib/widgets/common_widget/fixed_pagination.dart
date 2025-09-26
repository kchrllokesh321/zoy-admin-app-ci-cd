import 'package:exchek/core/utils/exports.dart';

class FixedPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final double height;
  final double width;

  const FixedPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.height = 40,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget seg({
      required Widget child,
      VoidCallback? onTap,
      bool isActive = false,
      bool isEdgeLeft = false,
      bool isEdgeRight = false,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          height: ResponsiveHelper.getWidgetSize(context, desktop: 40, mobile: 30, tablet: 35),
          width: ResponsiveHelper.getWidgetSize(context, desktop: 50, mobile: 30, tablet: 35),
          decoration: BoxDecoration(
            color: isActive ? theme.customColors.primaryColor : theme.customColors.fillColor,
            border: Border.all(color: theme.customColors.greyBorderPaginationColor!),
            borderRadius: BorderRadius.horizontal(
              left: isEdgeLeft ? const Radius.circular(8) : Radius.zero,
              right: isEdgeRight ? const Radius.circular(8) : Radius.zero,
            ),
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isActive ? theme.customColors.fillColor : theme.customColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      );
    }

    return ClipRRect(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          seg(
            child: CustomImageView(
              imagePath: Assets.images.svgs.icons.icDoubleLeftArrow.path,
              onTap: () => onPageChanged(1),
            ),
            onTap: () => onPageChanged(1),
            isEdgeLeft: true,
          ),
          seg(
            child: CustomImageView(
              imagePath: Assets.images.svgs.icons.icLeft.path,
              onTap: () => onPageChanged(currentPage - 1),
            ),
            onTap: () => onPageChanged(currentPage - 1),
          ),
          ..._buildMovingWindow(context, seg),
          seg(
            child: CustomImageView(
              imagePath: Assets.images.svgs.icons.icRight.path,
              onTap: () => onPageChanged(currentPage + 1),
            ),
            onTap: () => onPageChanged(currentPage + 1),
          ),
          seg(
            child: CustomImageView(
              imagePath: Assets.images.svgs.icons.icDoubleRightArrow.path,
              onTap: () => onPageChanged(totalPages),
            ),
            isEdgeRight: true,
            onTap: () => onPageChanged(totalPages),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMovingWindow(
    BuildContext context,
    Widget Function({required Widget child, VoidCallback? onTap, bool isActive, bool isEdgeLeft, bool isEdgeRight}) seg,
  ) {
    final widgets = <Widget>[];
    final total = totalPages;
    final current = currentPage;

    if (total <= 4) {
      for (int p = 1; p <= total; p++) {
        widgets.add(seg(child: Text('$p'), isActive: current == p, onTap: () => onPageChanged(p)));
      }
      return widgets;
    }

    int start = current;
    if (start > total - 2) start = total - 2;
    if (start < 1) start = 1;
    final pages = <int>{start, start + 1, start + 2}.where((p) => p >= 1 && p <= total).toList()..sort();

    for (final p in pages) {
      widgets.add(seg(child: Text('$p'), isActive: current == p, onTap: () => onPageChanged(p)));
    }

    if (pages.last < total - 1) {
      widgets.add(seg(child: const Text('…')));
    }
    if (!pages.contains(total)) {
      widgets.add(seg(child: Text('$total'), isActive: current == total, onTap: () => onPageChanged(total)));
    }

    return widgets;
  }
}
