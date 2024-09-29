import 'package:flutter/material.dart';
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

extension PlutoAsyncPaginationHelper on PlutoLazyPaginationRequest {
  String? get filterValue {
    try {
      return filterRows.firstOrNull?.cells['value']?.value;
    } catch (e) {
      return null;
    }
  }
}

extension PlutoInfinityScrollHelper on PlutoInfinityScrollRowsRequest {
  String? get filterValue {
    try {
      return filterRows.firstOrNull?.cells['value']?.value;
    } catch (e) {
      return null;
    }
  }
}

PlutoColumn actionColumn() {
  return PlutoColumn(
    title: "Action",
    field: "action",
    minWidth: 60,
    enableSorting: false,
    enableFilterMenuItem: false,
    type: PlutoColumnType.text(),
    renderer: (rendererContext) {
      return IconButton(onPressed: null, icon: Icon(Icons.more_vert));
    },
  );
}

PlutoCell searchCell(Map<String, PlutoCell> cells) {
  return PlutoCell(value: cells.values.map((e) => e.value).join());
}

extension PlutoRowHelper on PlutoRow {
  PlutoRow withSearchCell() {
    cells["searchValues"] = searchCell(cells);
    return this;
  }
}

PlutoColumn searchColumn() => PlutoColumn(
      title: "",
      field: "searchValues",
      type: PlutoColumnType.text(),
      width: 0,
      minWidth: 0,
    );
