import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultTableWidget extends StatelessWidget {
  const DefaultTableWidget({
    super.key,
    required this.columns,
    this.rows,
    this.onLoaded,
  });

  final List<PlutoColumn> columns;
  final List<PlutoRow>? rows;
  final PlutoOnLoadedEventCallback? onLoaded;

  PlutoGrid getGrid(
    BuildContext context, {
    CreateHeaderCallBack? headerWidget,
    CreateFooterCallBack? footerWidget,
  }) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return PlutoGrid(
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
      createHeader: headerWidget,
      createFooter: footerWidget,
    );
  }

  // PhysicalModel physicalModel(BuildContext context, {required Widget child}) {
  //   return PhysicalModel(
  //     elevation: 8,
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(8),
  //     child: getGrid(context),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return getGrid(context);
    // return physicalModel(
    // context,
    // child: getGrid(context),
    // );
  }
}
