import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/presentation/getx/tasks_logic.dart';
import 'package:e_telka/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasksListViewParams {
  final RxList<WorkshopTask> tasksToDisplay;
  final String title;
  final Color backgroundColor;
  final IconData iconData;
  final Color textColor;

  const TasksListViewParams(
      {required this.title,
      required this.tasksToDisplay,
      required this.backgroundColor,
      required this.iconData,
      required this.textColor});
}

class TasksListView extends StatefulWidget {
  final TasksListViewParams params;

  const TasksListView({super.key, required this.params});

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  final TasksLogic logic = Get.find<TasksLogic>();
  final List<WorkshopTask> tasks = Get.find<TasksLogic>().usersTasks;

  @override
  Widget build(BuildContext context) {
    final params = widget.params;
    final tasksToDisplay = params.tasksToDisplay;
    if (tasksToDisplay.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return GetX(
          init: logic,
          builder: (TasksLogic logic) {
            return Column(
              children: [
                tasksSublistHeader(context, params),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tasksToDisplay.length,
                  itemBuilder: (context, index) {
                    final task = tasksToDisplay[index];
                    return TaskCard(task);
                  },
                ),
              ],
            );
          });
    }
  }
}

Widget tasksSublistHeader(BuildContext context, TasksListViewParams params) {
  return Container(
    margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
    decoration: BoxDecoration(
      color: params.backgroundColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(
            child: Center(
          child: Text(params.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: params.textColor, fontFamily: 'Poppins')),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: Icon(
            params.iconData,
            color: params.textColor,
          ),
        ),
      ],
    ),
  );
}
