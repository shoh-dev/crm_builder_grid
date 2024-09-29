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
      title: 'Name',
      field: 'firstName',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Email',
      field: 'email',
      type: PlutoColumnType.text(),
    ),
  ];

  Future<PlutoLazyPaginationResponse> onFetch(
      PlutoLazyPaginationRequest req, PlutoGridStateManager sm) async {
    final page = req.page;
    final pageSize = sm.pageSize;
    final sortColumn = req.sortColumn;
    final bool isAscending =
        sortColumn != null ? sortColumn.sort.isAscending : true;
    final String? sortColumnField = sortColumn?.field;
    final search = req.filterValue ?? "";

    final queryParams = {
      "skip": search.isNotEmpty
          ? 0
          : page * pageSize, //same as page but in skip format
      "limit": pageSize,
      "q": search,
      "select": sm.columns.map((col) => col.field).join(","),
      "order": isAscending ? "asc" : "desc",
      "sortBy": sortColumnField,
    };

    final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

    final response = await dio.get(
      "/users/search",
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final totalPages = (response.data['total'] as int) ~/ pageSize;
      final data = response.data['users'] as List<dynamic>;
      final users = data.map((e) => UserModel.fromJson(e)).toList();

      return PlutoLazyPaginationResponse(
        rows: users.map((user) => PlutoRow.fromJson(user.toJson())).toList(),
        totalPage: totalPages,
      );
    } else {
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
