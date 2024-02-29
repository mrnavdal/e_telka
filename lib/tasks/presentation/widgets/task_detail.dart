import 'package:e_telka/core/util/date_util.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/workshop_task.dart';

class TaskDetail extends StatelessWidget {
  final WorkshopTask task;
  const TaskDetail({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedPlannedEndDate =
        DateUtil.getFormattedDate(task.plannedEndDate!);
    final formattedStartedDate = task.startedDate != null
        ? DateUtil.getFormattedDate(task.startedDate!)
        : 'Nezapočato';

    return Dialog(
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Operace: ${task.operation}'),
              Text('Plánované datum dokončení: $formattedPlannedEndDate'),
              Text('Datum začátku plnění: $formattedStartedDate'),
              Text('Zdroj: ${task.spreadsheetSource.toString()}'),
              Text('Počet kusů: ${task.pieces.toString()}'),
              Text('Kreditů za úkol: ${task.creditPriceTotalAmount.toString()}'),
              Text(': ${task.creditPriceTotalAmount.toString()}'),
              ElevatedButton(
                onPressed: Navigator.of(context).pop,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Zavřít',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
    );
  }
}
