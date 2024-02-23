import 'package:e_telka/tasks/presentation/tasks_controller.dart';
import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:e_telka/tasks/presentation/widgets/all_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  final logic = Get.find<TasksController>();

  final state = Get.find<TasksController>().state;

  @override
  initState() {
    super.initState();
    state.value = TasksOverview();
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
                Get.toNamed('/my-tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Všechny úkoly'),
              onTap: () {
                Get.back();
              },
            ),
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
        title: const Center(child: Text('Všechny úkoly')),
        actions: [
          IconButton(
              onPressed: () => Fluttertoast.showToast(
                  msg: 'Teď se nic dít nebude. Ale mohlo by!', toastLength: Toast.LENGTH_SHORT),
              icon: filterIcon),
        ],
      ),
      body: const Center(
        child: SingleChildScrollView(child: AllTasks())
      ),
    );
  }
}
