import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crm_builder_grid/crm_builder_grid.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final columns = <PlutoColumn>[
    PlutoColumn(
      title: 'ID',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Identifier',
      field: 'identifier',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
  ];

  Future<PlutoLazyPaginationResponse> onFetch(
      PlutoLazyPaginationRequest req, PlutoGridStateManager sm) async {
    try {
      final page = req.page;
      final pageSize = sm.pageSize;
      final sortColumn = req.sortColumn;
      final bool isAscending =
          sortColumn != null ? sortColumn.sort.isAscending : true;
      final String? sortColumnField = sortColumn?.field;
      final search = req.filterValue ?? "";

      final queryParams = {
        "page": page - 1,
        "page_size": pageSize,
        "search": search,
        "order": sortColumnField != null
            ? '${isAscending ? "+" : "-"}$sortColumnField'
            : "",
      };

      queryParams.removeWhere((key, value) => value.toString().isEmpty);

      final dio = Dio(BaseOptions(
        baseUrl: "https://timesheet.skillfill.co.uk/api/webadmin",
        headers: {"Authorization": "Bearer [apiKey]"},
      ));

      final response = await dio.get(
        "/quotes/44512171d728eb108bd22a99a8dd2741ae5ebe15277d40285e5097f2a8a17145",
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final totalPages = response.data['max_pages'] as int;
        final data = response.data['quotes'] as List<dynamic>;
        return PlutoLazyPaginationResponse(
          rows: data.map((dat) => PlutoRow.fromJson(dat)).toList(),
          totalPage: totalPages,
        );
      } else {
        return PlutoLazyPaginationResponse(
          rows: [],
          totalPage: 1,
        );
      }
    } catch (e) {
      print(e);
      return PlutoLazyPaginationResponse(
        rows: [],
        totalPage: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRM Builder Grid Example App'),
        ),
        body: DefaultAsyncPaginatedTableWidget(
          columns: columns,
          fetch: onFetch,
        ),
      ),
    );
  }
}

class UserModel {
  final String name;
  final int age;
  final String email;

  const UserModel({
    required this.email,
    required this.name,
    required this.age,
  });

  //fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['firstName'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'firstName': name,
      'age': age,
      'email': email,
    };
  }
}
