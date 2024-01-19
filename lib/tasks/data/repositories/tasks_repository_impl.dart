import 'package:e_telka/core/data/data_sources/core_data_source.dart';
import 'package:e_telka/core/data/data_sources/core_data_source_impl.dart';
import 'package:e_telka/tasks/data/datasources/tasks_remote_data_source_impl.dart';
import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:get/get.dart';

import '../datasources/tasks_remote_data_source.dart';

class TasksRepositoryImpl extends TasksRepository {
  final TasksRemoteDataSource tasksRemoteDataSource =
      Get.put<TasksRemoteDataSource>(TasksRemoteDataSourceImpl());
  final CoreRemoteDataSource coreRemoteDataSource =
      Get.put<CoreRemoteDataSource>(CoreRemoteDataSourceImpl());
  TasksRepositoryImpl();

  @override
  Future<List<Task>> getUsersActiveTasks() async {
    final userID = await coreRemoteDataSource.getCurrentUserID();
    List<Task> tasks = await tasksRemoteDataSource.getAllTasks();
    // determine which tasks are active
    List<Task> incompleteTasks =
        tasks.where((element) => element.realizedEndDate == null).toList();
    // determine which tasks are user's
    final usersTasks =
        incompleteTasks.where((element) => element.workerID == userID).toList();
    // loop through incomplete tasks. If the id of the task is in the nextId of any other task, it is not to be shown
    List<Task> tasksShown = [];
    for (Task usersTask in usersTasks) {
      bool isNextIdInUsersTasks = false;
      for (Task incompleteTask in incompleteTasks) {
        if (incompleteTask.nextId!.contains(usersTask.id)) {
          isNextIdInUsersTasks = true;
          break;
        }
      }
      if (!isNextIdInUsersTasks) {
        tasksShown.add(usersTask);
      }
    }
    tasksShown.sort((a, b) => a.taskId.compareTo(b.taskId));
    return tasksShown;
  }

  @override
  Future<void> setTaskToDone(Task task) {
    task.realizedEndDate = DateTime.now();
    return tasksRemoteDataSource.updateTask(task);
  }

  @override
  Future<void> setTaskToStarted(Task task) {
    task.startedDate = DateTime.now();
    return tasksRemoteDataSource.updateTask(task);
  }
}
