import 'package:e_telka/core/error/error_display.dart';
import 'package:e_telka/tasks/presentation/getx/tasks_logic.dart';
import 'package:e_telka/tasks/presentation/getx/tasks_state.dart';
import 'package:e_telka/tasks/presentation/pages/all_tasks.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks_dialogs.dart';
import 'package:e_telka/tasks/presentation/pages/my_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class TasksView extends StatefulWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final logic = Get.find<TasksLogic>();

  @override
  initState() {
    super.initState();
    logic.initializeTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawer(),
        appBar: buildAppBar(context),
        body: buildBody(context));
  }

  Drawer buildDrawer() {
    bool isCurrentUserSuper =
        FirebaseAuth.instance.currentUser?.email == 'vyroba@vecicky.cz';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildDrawerHeader(),
          buildDrawerItem(Icons.task, 'Moje úkoly', () {
            setState(() {
              Get.back();
              logic.index = 0.obs;
              logic.state = TasksMyTasks().obs;
            });
          }),
          if (isCurrentUserSuper)
            buildDrawerItem(Icons.list, 'Všechny úkoly', () {
              setState(() {
                Get.back();
                logic.index = 1.obs;
                logic.state = TasksOverview().obs;
              });
            }),
          buildDrawerItem(Icons.logout, 'Odhlásit se', () {
            FirebaseAuth.instance.signOut();
            Get.offAllNamed('/sign-in');
          }),
        ],
      ),
    );
  }

  DrawerHeader buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(FirebaseAuth.instance.currentUser?.displayName ?? ""),
    );
  }

  ListTile buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final filterIcon = logic.areTasksFiltered
        ? const Icon(Icons.filter_alt)
        : const Icon(Icons.filter_alt_outlined);
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: GetBuilder<TasksLogic>(builder: (logic) {
        final stateTitle = logic.state.value.message;
        return Center(child: Text(stateTitle));
      }),
      actions: [
        if (GetPlatform.isWeb)
          buildIconButton(Icon(Icons.refresh), () async {
            await logic.refreshTasks();
            setState(() {
              logic.filterTasks();
              logic.determineState();
            });
          }),
        buildIconButton(
            filterIcon,
            () => showFilterDialog(context).then((value) {
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
                })),
      ],
    );
  }

  IconButton buildIconButton(Icon icon, AsyncCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: GetBuilder<TasksLogic>(
        builder: (logic) {
          switch (logic.state.value.runtimeType) {
            case TasksError:
              return buildErrorDisplay(logic.state.value.message);
            case TasksLoading:
              return const Center(child: CircularProgressIndicator());
            case TasksMyTasks:
              return buildMyTasks();
            case TasksOverview:
              return AllTasks();
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildErrorDisplay(String message) {
    return Center(
      child: ErrorDisplay(
        message: message,
      ),
    );
  }

  Widget buildMyTasks() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await logic.refreshTasks();
              setState(() {
                logic.filterTasks();
                logic.determineState();
              });
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TasksListView(
                    params: TasksListViewParams(
                      title: 'Zpožděné úkoly',
                      tasksToDisplay: logic.delayedTasks,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      iconData: Icons.error_outline,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  TasksListView(
                    params: TasksListViewParams(
                      title: 'Úkoly pro tento týden',
                      tasksToDisplay: logic.currentWeekTasks,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      iconData: Icons.calendar_today,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  TasksListView(
                    params: TasksListViewParams(
                      title: 'Nadcházející úkoly',
                      tasksToDisplay: logic.upcomingTasks,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      iconData: Icons.calendar_month,
                      textColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
