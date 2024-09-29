import 'package:crm_builder_grid/grid/default_table_filter_widget.dart';
import 'package:crm_builder_grid/grid/default_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultAsyncPaginatedTableWidget extends DefaultTableWidget {
  const DefaultAsyncPaginatedTableWidget({
    super.key,
    required super.columns,
    super.rows,
    super.onLoaded,
    required this.fetch,
    this.showSearchWidget = true,
  });

  final Future<PlutoLazyPaginationResponse> Function(
      PlutoLazyPaginationRequest, PlutoGridStateManager) fetch;
  final bool showSearchWidget;

  @override
  Widget build(BuildContext context) {
    return getGrid(
      context,
      footerWidget: (stateManager) {
        return PlutoLazyPagination(
          fetch: (p0) => fetch(p0, stateManager),
          stateManager: stateManager,
        );
      },
      headerWidget: (stateManager) {
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
    );
  }
}
