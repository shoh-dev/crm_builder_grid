import 'package:crm_builder_grid/crm_builder_grid.dart';
import 'package:flutter/material.dart';

class SimpleTablePage extends StatefulWidget {
  const SimpleTablePage({super.key});

  @override
  State<SimpleTablePage> createState() => _SimpleTablePageState();
}

class _SimpleTablePageState extends State<SimpleTablePage> {
  final columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Product Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Price',
      field: 'price',
      type: PlutoColumnType.currency(
        symbol: "\$",
      ),
    ),
    PlutoColumn(
      title: 'Stock',
      field: 'stock',
      type: PlutoColumnType.number(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM Builder Simple Table Page'),
      ),
      body: DefaultTableWidget(
        columns: columns,
        rows: [
          for (int i = 0; i < 100; i++)
            PlutoRow(cells: {
              'name': PlutoCell(value: 'Product $i'),
              'price': PlutoCell(value: 100.0 + i),
              'stock': PlutoCell(value: i),
            }),
        ],
      ),
    );
  }
}
