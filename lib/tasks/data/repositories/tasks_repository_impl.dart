import 'package:e_telka/core/data/data_sources/core_data_source.dart';
import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:get/get.dart';

import '../datasources/tasks_remote_data_source.dart';

class TasksRepositoryImpl extends TasksRepository {
  final TasksRemoteDataSource tasksRemoteDataSource = Get.find();
  final CoreRemoteDataSource coreRemoteDataSource = Get.find();
  TasksRepositoryImpl();

  List<Task> _allTasks = [];

  @override
  List<Task> get allTasks => _allTasks;

  @override
  Future<List<Task>> getUsersActiveTasks() async {
    final userID = await coreRemoteDataSource.getCurrentUserID();
    _allTasks = await tasksRemoteDataSource.getAllTasks();
    // determine which tasks are not completed
    List<Task> incompleteTasks =
        allTasks.where((element) => element.realizedEndDate == null).toList();
    // determine which tasks are user's
    final usersTasks =
        incompleteTasks.where((element) => element.workerID == userID).toList();
    // show only those which are active
    List<Task> tasksShown = [];
    tasksShown = usersTasks.where((element) => element.isActive == true).toList();
    tasksShown.sort((a, b) => a.taskId.compareTo(b.taskId));
    return tasksShown;
  }

  @override
  Future<void> finishTask(Task task) {
    // sets task as finished and updates it in the database
    // also sets the following task as active
    task.realizedEndDate = DateTime.now();
    task.isActive = false;
    tasksRemoteDataSource.updateTask(task);
    final followingTask = getFollowingTask(task);
    if (followingTask != null) {
      followingTask.isActive = true;
      tasksRemoteDataSource.updateTask(followingTask);
    }
    return Future.value();
  }

  @override
  Future<void> setTaskToStarted(Task task) {
    task.startedDate = DateTime.now();
    return tasksRemoteDataSource.updateTask(task);
  }

  /// Možná implementace pro více tasků, ale zatím nechám takhle
  @override
  Task? getPreviousTask(Task task) {
    print(task.id);
    return allTasks.firstWhere((element) => element.nextId?.contains(task.id) ?? false);
  }

  /// Možná implementace pro více tasků, ale zatím nechám takhle
  @override
  Task? getFollowingTask(Task task) {
    final nextId = task.nextId?.first;
    if (nextId == null) {
      return null;
    }
    final result = allTasks.firstWhere((element) => element.id == nextId!);
    return result;
  }

  @override
  void updateTask(Task task) {
    tasksRemoteDataSource.updateTask(task);
  }
}
