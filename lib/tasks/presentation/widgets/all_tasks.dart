import 'package:e_telka/core/util/date_util.dart';
import 'package:e_telka/tasks/domain/entities/task.dart';
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
  final List<Task> activeTasks = Get.find<TasksController>().activeTasks;
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

  Widget activeTaskTile(Task task) {
    return Column(
      children: [
        ListTile(
          title: Text('${task.taskId}: ${task.operation}'),
          subtitle: Text('Odpovědná osoba: ${task.workerID}'),
          trailing: Text('Plánované dokončení \n ${DateUtil.getFormattedDate(task.plannedEndDate!)}', textAlign: TextAlign.end,),
        ),
        const Divider(),
      ],
    );
  }
}
