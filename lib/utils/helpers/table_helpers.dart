import 'package:pluto_grid/pluto_grid.dart';

extension PlutoColumnRendererHelper on PlutoColumnRendererContext {
  T getActionModel<T>() {
    try {
      T model;
      if (row.type.isGroup) {
        final childInitialRow = row.type.group.children.firstOrNull;
        model = childInitialRow?.cells['action']?.value as T;
      } else {
        model = row.cells['action']?.value as T;
      }
      return model;
    } catch (e) {
      throw Exception('${e.toString()}\n||\n[action] column not found!');
    }
  }
}

extension PlutoLazyPaginationHelper on PlutoLazyPaginationRequest {
  String? get filterValue {
    try {
      return filterRows.firstOrNull?.cells['value']?.value;
    } catch (e) {
      return null;
    }
  }
}
