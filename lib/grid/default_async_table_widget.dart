import 'package:crm_builder_grid/grid/default_table_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultAsyncTableWidget extends StatelessWidget {
  const DefaultAsyncTableWidget({
    super.key,
    required this.columns,
    this.rows,
    this.onLoaded,
    required this.fetch,
    this.showSearchWidget = true,
  });

  final List<PlutoColumn> columns;
  final List<PlutoRow>? rows;
  final PlutoOnLoadedEventCallback? onLoaded;
  final Future<PlutoLazyPaginationResponse> Function(
      PlutoLazyPaginationRequest, PlutoGridStateManager) fetch;
  final bool showSearchWidget;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PhysicalModel(
      elevation: 8,
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: PlutoGrid(
        columns: columns.map((e) {
          e.enableColumnDrag = false;
          e.enableContextMenu = false;
          e.enableDropToResize = false;
          e.backgroundColor = Colors.grey[300];
          return e;
        }).toList(),
        rows: rows ?? List.empty(growable: true),
        onLoaded: onLoaded,
        mode: PlutoGridMode.readOnly,
        noRowsWidget: const Center(child: Text("Empty!")),
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(
            isAlwaysShown: true,
            scrollbarThickness: 6,
            scrollbarRadius: const Radius.circular(3),
            draggableScrollbar: true,
            scrollBarTrackColor: Colors.grey[300]!,
            enableScrollAfterDragEnd: true,
          ),
          style: PlutoGridStyleConfig(
            activatedColor: color.surface,
            activatedBorderColor: color.primary,
            gridBackgroundColor: color.surface,
            columnAscendingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            columnDescendingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
            iconSize: 24,
            columnTextStyle: textTheme.titleSmall!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
            gridBorderRadius: const BorderRadius.all(Radius.circular(8)),
            gridBorderColor: Colors.transparent,
            borderColor: Colors.grey[300]!,
            enableColumnBorderHorizontal: false,
            enableColumnBorderVertical: false,
            enableGridBorderShadow: true,
            enableCellBorderHorizontal: true,
            enableCellBorderVertical: false,
          ),
          columnSize: const PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.scale,
          ),
        ),
        createFooter: (stateManager) {
          return PlutoLazyPagination(
            fetch: (p0) => fetch(p0, stateManager),
            stateManager: stateManager,
          );
        },
        createHeader: (stateManager) {
          return SizedBox(
            height: 48,
            child: AppBar(
              centerTitle: false,
              title: showSearchWidget
                  ? DefaultTableFilterWidget(stateManager: stateManager)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
