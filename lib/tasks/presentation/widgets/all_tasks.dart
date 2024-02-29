import 'package:e_telka/core/util/date_util.dart';
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tasks_controller.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final TasksController logic = Get.find<TasksController>();
  final List<WorkshopTask> activeTasks = Get.find<TasksController>().activeTasks;
  @override
  Widget build(BuildContext context) {
    if (activeTasks.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activeTasks.length,
            itemBuilder: (context, index) {
              final task = activeTasks[index];
              return activeTaskTile(task);
            },
          ),
        ],
      );
    }
  }

  Widget activeTaskTile(WorkshopTask task) {
    final workerName = logic.workers.firstWhere((element) => element.id == task.workerID).name;
    bool isLate = task.plannedEndDate != null && DateUtil().isDateBeforeThisWeek(task.plannedEndDate!);
    return Column(
      children: [
        ListTile(
          leading: Icon(
            isLate ? Icons.error_outline : Icons.calendar_today,
            color: isLate ? Colors.red : Colors.green,
          ),
          title: Text('${task.taskId}: ${task.operation}'),
          subtitle: Text('Odpovědná osoba: ${workerName}'),
          trailing: Text('Plánované dokončení \n ${DateUtil.getFormattedDate(task.plannedEndDate!)}', textAlign: TextAlign.end, style: TextStyle(color: isLate ? Colors.red : Colors.black)),
        ),
        const Divider(),
      ],
    );
  }
}
