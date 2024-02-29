import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks_dialogs.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks.dart';
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

  @override
  initState() {
    super.initState();
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
    bool isCurrentUserSuper =
        FirebaseAuth.instance.currentUser?.email == 'vyroba@vecicky.cz';
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
              ),
              // TODO: Add user profile information
              child: Text(FirebaseAuth.instance.currentUser?.displayName ?? ""),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Moje úkoly'),
              onTap: () {
                Get.back();
              },
            ),
            isCurrentUserSuper
                ? ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Všechny úkoly'),
                    onTap: () {
                      Get.toNamed('/all-tasks');
                    },
                  )
                : Container(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Odhlásit se'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.offAllNamed('/sign-in');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Moje úkoly')),
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
          switch (logic.state.value.runtimeType) {
            case TasksError:
              return Center(
                  child: Text((logic.state.value as TasksError).message));
            case TasksLoading:
              return const Center(child: CircularProgressIndicator());
            default:
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          logic.refreshTasks();
                        },
                        child: SingleChildScrollView(
                          child: logic.state is TasksError
                              ? Center(
                                  child:
                                      Text((logic.state as TasksError).message))
                              : Column(
                                  children: [
                                    TasksListView(
                                        params: TasksListViewParams(
                                            title: 'Zpožděné úkoly',
                                            tasksToDisplay: logic.delayedTasks,
                                            backgroundColor:
                                                colorScheme.secondaryContainer,
                                            iconData: Icons.error_outline,
                                            textColor: colorScheme
                                                .onSecondaryContainer)),
                                    TasksListView(
                                        params: TasksListViewParams(
                                            title: 'Úkoly pro tento týden',
                                            tasksToDisplay:
                                                logic.currentWeekTasks,
                                            backgroundColor:
                                                colorScheme.primaryContainer,
                                            iconData: Icons.calendar_today,
                                            textColor: colorScheme
                                                .onPrimaryContainer)),
                                    TasksListView(
                                        params: TasksListViewParams(
                                            title: 'Nadcházející úkoly',
                                            tasksToDisplay: logic.upcomingTasks,
                                            backgroundColor:
                                                colorScheme.tertiaryContainer,
                                            iconData: Icons.calendar_month,
                                            textColor: colorScheme
                                                .onTertiaryContainer)),
                                  ],
                                ),
                        )),
                  ),
                ],
              );
          }
        }),
      ),
    );
  }
}
