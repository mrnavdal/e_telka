import 'package:flutter/material.dart';

import '../../getx/tasks_logic.dart';

class OperationsFilters extends StatefulWidget {
  const OperationsFilters({super.key, required this.logic});
  final TasksLogic logic;

  @override
  State<OperationsFilters> createState() => _OperationsFiltersState();
}

class _OperationsFiltersState extends State<OperationsFilters> {
  @override
  Widget build(BuildContext context) {
    final logic = widget.logic;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final operations = logic.usersTasks.value.map((e) => e.operation).toSet();
    return Column(
      children: [
        Text('Operace:', style: textTheme.labelMedium),
        Column(
          children: operations
              .map((e) => CheckboxListTile(
            title: Text(e),
            value: logic.filteredOperations.contains(e),
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  logic.filteredOperations.add(e);
                } else {
                  logic.filteredOperations.remove(e);
                }
              });
            },
          ))
              .toList(),
        ),
      ],
    );
  }
}
