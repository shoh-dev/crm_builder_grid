import 'package:crm_builder_grid/grid/default_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

@Deprecated("Not ready for production use")
class DefaultLazyPaginatedTableWidget extends DefaultTableWidget {
  const DefaultLazyPaginatedTableWidget({
    super.key,
    required super.columns,
    super.rows,
    super.onLoaded,
    required this.fetch,
    this.showSearchWidget = true,
  });

  final Future<PlutoInfinityScrollRowsResponse> Function(
      PlutoInfinityScrollRowsRequest, PlutoGridStateManager) fetch;
  final bool showSearchWidget;

  @override
  Widget build(BuildContext context) {
    return getGrid(
      context,
      footerWidget: (stateManager) {
        return PlutoInfinityScrollRows(
          fetch: (p0) => fetch(p0, stateManager),
          stateManager: stateManager,
        );
      },
      //todo: uncomment this to enable search
      // headerWidget: (stateManager) {
      //   return SizedBox(
      //     height: 48,
      //     child: AppBar(
      //       centerTitle: false,
      //       title: showSearchWidget
      //           ? DefaultTableFilterWidget(stateManager: stateManager)
      //           : null,
      //     ),
      //   );
      // },
    );
  }
}
