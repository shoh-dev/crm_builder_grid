import 'package:pluto_grid/pluto_grid.dart';

extension PlutoColumnRendererHelper on PlutoColumnRendererContext {
  T getActionModel<T>() {
    T model;
    if (row.type.isGroup) {
      final childInitialRow = row.type.group.children.firstOrNull;
      model = childInitialRow?.cells['action']?.value as T;
    } else {
      model = row.cells['action']?.value as T;
    }
    return model;
  }
}
