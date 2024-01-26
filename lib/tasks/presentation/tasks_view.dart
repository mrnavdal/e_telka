import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:e_telka/tasks/presentation/widgets/sorting_widget.dart';
import 'package:e_telka/tasks/presentation/widgets/task_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'tasks_controller.dart';
import 'widgets/completeness_filter.dart';
import 'widgets/operations_filter.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final logic = Get.put(TasksController());

  final state = Get.find<TasksController>().state;

  @override
  initState() {
    super.initState();
    state.value = TasksMyTasks();
    initTasks();
  }

  initTasks() async {
    await logic.initializeTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final filterIcon = logic.areTasksFiltered
        ? const Icon(Icons.filter_alt)
        : const Icon(Icons.filter_alt_outlined);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Moje úkoly')),
        leading: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.offAllNamed('/sign-in');
          },
          icon: const Icon(Icons.logout),
        ),
        actions: [
          IconButton(
              // onPressed: () {},
              onPressed: () => _showFilterDialog(context).then((value) {
                    if (value == true) {
                      setState(() {
                        logic.areTasksFiltered = true;
                        logic.filterTasks();
                      });
                    } else if (value == false) {
                      setState(() {
                        logic.areTasksFiltered = false;
                        logic.disableFilters();
                      });
                    }
                  }),
              icon: filterIcon),
        ],
      ),
      body: Center(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      logic.refreshTasks();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildDelayedTasksListView(context),
                          buildCurrentTasksListView(context),
                          buildUpcomingTasksListView(context)
                        ],
                      ),
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildDelayedTasksListView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final delayedTasks = logic.delayedTasks;
    if (delayedTasks.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          tasksSublistHeader(
              context,
              'Zpožděné úkoly',
              colorScheme.onSecondaryContainer,
              Icons.error_outline,
              colorScheme.secondaryContainer),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: delayedTasks.length,
            itemBuilder: (context, index) {
              final task = delayedTasks[index];
              return taskCard(context, task);
            },
          ),
        ],
      );
    }
  }

  Widget buildCurrentTasksListView(BuildContext context) {
    final currentTasks = logic.currentWeekTasks;
    final colorScheme = Theme.of(context).colorScheme;
    if (currentTasks.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          tasksSublistHeader(
              context,
              'Tento týden',
              colorScheme.onPrimaryContainer,
              Icons.check_circle_outline,
              colorScheme.primaryContainer),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: currentTasks.length,
            itemBuilder: (context, index) {
              final task = currentTasks[index];
              return taskCard(context, task);
            },
          ),
        ],
      );
    }
  }

  Widget buildUpcomingTasksListView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final upcomingTasks = logic.upcomingTasks;
    if (upcomingTasks.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          tasksSublistHeader(
              context,
              'Nadcházející úkoly',
              colorScheme.onTertiaryContainer,
              Icons.calendar_month,
              colorScheme.tertiaryContainer),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: upcomingTasks.length,
            itemBuilder: (context, index) {
              final task = upcomingTasks[index];
              return taskCard(context, task);
            },
          ),
        ],
      );
    }
  }

  Widget tasksSublistHeader(BuildContext context, String title, Color color,
      IconData iconData, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: Icon(
              iconData,
              color: color,
            ),
          ),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: color, fontFamily: 'Poppins')),
          // draw a line
          Expanded(
              child: Container(
            height: 1,
            color: color,
            margin: const EdgeInsets.only(left: 16, right: 16),
          )),
        ],
      ),
    );
  }

  Widget taskCard(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return TaskDetail(task: task);
            });
      },
      child: Card(
        child: ListTile(
          title: Text('${task.taskId}: ${task.operation}'),
          trailing: _buildConfirmButton(context, task),
        ),
      ),
    );
  }

  ElevatedButton _buildConfirmButton(BuildContext context, Task task) {
    if (task.startedDate == null) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        onPressed: () {
          _confirmTaskDialog(context).then((value) {
            if (value == true) {
              setState(() {
                logic.setTaskToStarted(task);
                Fluttertoast.showToast(
                    msg: 'Úkol byl zahájen.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.yellow,
                    textColor: Colors.black,
                    fontSize: 16.0);
              });
            }
          });
        },
        child: Text(
          'Začít',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      );
    } else if (task.realizedEndDate == null) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        onPressed: () {
          _confirmTaskDialog(context).then((value) {
            if (value == true) {
              setState(() {
                logic.setTaskToDone(task);
                Fluttertoast.showToast(
                    msg: 'Výborně! Úkol byl dokončen.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
            }
          });
        },
        child: Text(
          'Dokončit',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
      );
    }
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Úkol dokončen'),
    );
  }

  Future<bool?> _confirmTaskDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: const Text(
            'Potvrďte akci',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Jste si jisti, že chcete potvrdit akci? Toto nejde vzít zpět.',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(context, false); // Cancel
              },
              child: const Text('Ne', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.pop(context, true); // Proceed
              },
              child: const Text('Ano', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  _showFilterDialog(BuildContext context) {
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
}
