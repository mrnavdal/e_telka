import 'package:e_telka/tasks/presentation/tasks_controller.dart';
import 'package:flutter/material.dart';

class SortingWidget extends StatefulWidget {
  const SortingWidget({super.key, required this.logic});
final TasksController logic;
  @override
  State<SortingWidget> createState() => _SortingWidgetState();
}

class _SortingWidgetState extends State<SortingWidget> {
  Widget build(BuildContext context) {
    final logic = widget.logic;
    String sortOrder = logic.ascendingOrder ? 'Vzestupně' : 'Sestupně';
    String sortFactor = logic.selectedSortingFactor;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
         Text('Seřadit podle: ', style: textTheme.labelMedium,),
        Row(
          children: [
            DropdownButton<String>(
              value: sortFactor,
              onChanged: (String? newValue) {
                setState(() {
                  sortFactor = newValue!;
                  logic.onSortingFactorChange(newValue);
                });
              },
              items: <String>[
                'Počtu ks',
                'Čísla úkolu',
                'Pořadí operace',
                'Plánu \ndokončení'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: sortOrder,
              onChanged: (String? newValue) {
                setState(() {
                  sortOrder = newValue!;
                  logic.onSortingOrderChange(newValue == "Vzestupně");
                });
              },
              items: <String>['Vzestupně', 'Sestupně']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
