import 'package:exchek/core/utils/drag_scroll_behaviour.dart';
import 'package:exchek/core/utils/exports.dart';
import 'dart:math' as math;

class ResponsiveDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double minTableWidth;
  final ScrollController? horizontalController;
  final BorderRadius borderRadius;
  final BoxDecoration? decoration;
  final DividerThemeData? dividerTheme;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.minTableWidth = 1000,
    this.horizontalController,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.decoration,
    this.dividerTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double dataTableWidth = math.max(minTableWidth, constraints.maxWidth);
        return Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          controller: horizontalController,
          child: ScrollConfiguration(
            behavior: const DragScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: false,
              controller: horizontalController,
              child: SizedBox(
                width: dataTableWidth,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: theme.customColors.tableBorderColor,
                      dividerTheme:
                          dividerTheme ?? DividerThemeData(color: theme.customColors.tableBorderColor, thickness: 0.4),
                    ),
                    child: DataTable(
                      decoration:
                          decoration ??
                          BoxDecoration(
                            color: theme.customColors.fillColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.customColors.blackColor!.withValues(alpha: 0.05),
                                blurRadius: 54.0,
                              ),
                            ],
                          ),
                      sortAscending: true,
                      showCheckboxColumn: false,
                      columns: columns,
                      rows: rows,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
