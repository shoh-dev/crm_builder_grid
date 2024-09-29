import 'dart:convert';

import 'package:crm_builder_grid/crm_builder_grid.dart';
import 'package:dio/dio.dart';
import 'package:example/models/user.dart';
import 'package:example/simple_table_page.dart';
import 'package:flutter/material.dart';

class LazyPaginatedGridPage extends StatefulWidget {
  const LazyPaginatedGridPage({super.key});

  @override
  State<LazyPaginatedGridPage> createState() => _LazyPaginatedGridPageState();
}

class _LazyPaginatedGridPageState extends State<LazyPaginatedGridPage> {
  final columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Servings',
      field: 'servings',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Difficulty',
      field: 'difficulty',
      type: PlutoColumnType.text(),
    ),
  ];

  List<PlutoRow> fakeFetchedRows = [];

  Future<PlutoInfinityScrollRowsResponse> onFetch(
      PlutoInfinityScrollRowsRequest req, PlutoGridStateManager sm) async {
    List<PlutoRow> tempList = fakeFetchedRows;

    final pageSize = sm.pageSize;

    final sortColumn = req.sortColumn;
    final bool isAscending =
        sortColumn != null ? sortColumn.sort.isAscending : true;
    final String? sortColumnField = sortColumn?.field;
    final search = req.filterValue ?? "";

    final queryParams = {
      "skip": 0,
      "limit": pageSize,
      "select": sm.columns.map((col) => col.field).join(","),
      "order": isAscending ? "asc" : "desc",
      "sortBy": sortColumnField,
      "q": search,
    };

    final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

    final response = await dio.get(
      "/recipes/search",
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data['recipes'] as List<dynamic>;

      if (data.isEmpty) {
        return PlutoInfinityScrollRowsResponse(
          rows: [],
          isLast: true,
        );
      }

      // fakeFetchedRows.addAll(data
      //     .map((user) => PlutoRow.fromJson(user).withSearchCell())
      //     .toList());

      //filter
      if (search.isNotEmpty) {
        final filter = FilterHelper.convertRowsToFilter(
          req.filterRows,
          sm.refColumns,
        );

        tempList = fakeFetchedRows.where(filter!).toList();
      }

      //sort
      if (req.sortColumn != null) {
        tempList = [...tempList];

        tempList.sort((a, b) {
          final sortA = req.sortColumn!.sort.isAscending ? a : b;
          final sortB = req.sortColumn!.sort.isAscending ? b : a;

          return req.sortColumn!.type.compare(
            sortA.cells[req.sortColumn!.field]!.valueForSorting,
            sortB.cells[req.sortColumn!.field]!.valueForSorting,
          );
        });
      }

      Iterable<PlutoRow> fetchedRows = tempList.skipWhile(
        (row) => req.lastRow != null && row.key != req.lastRow!.key,
      );
      if (req.lastRow == null) {
        fetchedRows = fetchedRows.take(30);
      } else {
        fetchedRows = fetchedRows.skip(1).take(30);
      }

      // final totalPages = (response.data['total'] as int);
      final bool isLast =
          fetchedRows.isEmpty || tempList.last.key == fetchedRows.last.key;

      print(isLast);

      return PlutoInfinityScrollRowsResponse(
        rows: fetchedRows.toList(),
        // isLast: fetchedRows.length >= totalPages,
        isLast: isLast,
      );
    } else {
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Error fetching data!')),
      //   );
      // }
      return PlutoInfinityScrollRowsResponse(
        rows: [],
        isLast: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRM Builder Lazy Paginated Page'),
        ),
        body: DefaultLazyPaginatedTableWidget(
          columns: columns,
          fetch: onFetch,
        ),
      ),
    );
  }
}
