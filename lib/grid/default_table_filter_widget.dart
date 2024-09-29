import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultTableFilterWidget extends StatefulWidget {
  const DefaultTableFilterWidget({super.key, required this.stateManager});

  final PlutoGridStateManager stateManager;

  @override
  State<DefaultTableFilterWidget> createState() => _TableFilterWidgetState();
}

class _TableFilterWidgetState extends State<DefaultTableFilterWidget> {
  KeyEventResult _handleOnKey(
      FocusNode node, KeyEvent event, PlutoGridStateManager stateManager) {
    return stateManager.keyManager!.eventResult.skip(
      KeyEventResult.ignored,
    );
  }

  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode(
        onKeyEvent: (node, event) =>
            _handleOnKey(node, event, widget.stateManager));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 42,
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: "Search",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (searchVal) {
          for (var col in [widget.stateManager.columns.first]) {
            widget.stateManager.eventManager!.addEvent(
              PlutoGridChangeColumnFilterEvent(
                column: col,
                filterType: col.defaultFilter,
                filterValue: searchVal,
                debounceMilliseconds: widget.stateManager.configuration
                    .columnFilter.debounceMilliseconds,
              ),
            );
          }
        },
      ),
    );
  }
}
