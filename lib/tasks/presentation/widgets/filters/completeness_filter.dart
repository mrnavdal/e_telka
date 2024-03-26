import 'package:e_telka/tasks/presentation/getx/tasks_logic.dart';
import 'package:flutter/material.dart';

class CompletenessFilter extends StatefulWidget {
  const CompletenessFilter({super.key, required this.logic});
  final TasksLogic logic;
  @override
  State<CompletenessFilter> createState() => _CompletenessFilterState();
}
const String startedTasksLabel = 'Zahájené úkoly';
const String nonStartedTasksLabel = 'Nezahájené úkoly';
class _CompletenessFilterState extends State<CompletenessFilter> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
        const Divider(),
        Text('Stav úkolů:', style: textTheme.labelMedium),
        CheckboxListTile(
          enabled: true,
          title: const Text(startedTasksLabel),
          value: widget.logic.filteredStates.contains(startedTasksLabel),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                widget.logic.filteredStates.add(startedTasksLabel);
              } else {
                widget.logic.filteredStates.remove(startedTasksLabel);
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text(nonStartedTasksLabel),
          value: widget.logic.filteredStates.contains(nonStartedTasksLabel),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                widget.logic.filteredStates.add(nonStartedTasksLabel);
              } else {
                widget.logic.filteredStates.remove(nonStartedTasksLabel);
              }
            });
          },
        ),
        const Divider(),
      ],
    );
  }
}
