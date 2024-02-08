import 'package:e_telka/tasks/presentation/tasks_controller.dart';
import 'package:e_telka/tasks/presentation/widgets/filters/sorting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'filters/completeness_filter.dart';
import 'filters/operations_filter.dart';

@override
Future<bool?> showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text('Ne', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text('Ano', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      });
}

showFilterDialog(BuildContext context) {
  final logic = Get.find<TasksController>();
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: const Text(
          'Filtrovat úkoly',
          textAlign: TextAlign.center,
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          OperationsFilters(logic: logic),
          CompletenessFilter(logic: logic),
          SortingWidget(logic: logic),
        ]),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              Navigator.pop(context, false); // Cancel
            },
            child: const Text('Zrušit filtry',
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context, true); // Proceed
            },
            child: const Text('Filtrovat',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
