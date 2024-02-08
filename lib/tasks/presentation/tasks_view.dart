import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks_dialogs.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tasks_controller.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final logic = Get.find<TasksController>();

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
              onPressed: () => showFilterDialog(context).then((value) {
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
                          TasksListView(
                              params: TasksListViewParams(
                                  title: 'Zpožděné úkoly',
                                  tasksToDisplay: logic.delayedTasks,
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  iconData: Icons.error_outline,
                                  textColor: colorScheme.onSecondaryContainer)),
                          TasksListView(
                              params: TasksListViewParams(
                                  title: 'Úkoly pro tento týden',
                                  tasksToDisplay: logic.currentWeekTasks,
                                  backgroundColor: colorScheme.primaryContainer,
                                  iconData: Icons.calendar_today,
                                  textColor: colorScheme.onPrimaryContainer)),
                          TasksListView(
                              params: TasksListViewParams(
                                  title: 'Nadcházející úkoly',
                                  tasksToDisplay: logic.upcomingTasks,
                                  backgroundColor:
                                      colorScheme.tertiaryContainer,
                                  iconData: Icons.calendar_month,
                                  textColor: colorScheme.onTertiaryContainer)),
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
}
