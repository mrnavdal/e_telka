import 'package:dartz/dartz.dart';
import 'package:e_telka/core/data/data_sources/core_data_source.dart';
import 'package:e_telka/core/error/failure.dart';
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/domain/entities/workshop_worker.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../datasources/tasks_remote_data_source.dart';

class TasksRepositoryImpl extends TasksRepository {
  final TasksRemoteDataSource tasksRemoteDataSource = Get.find();
  final CoreRemoteDataSource coreRemoteDataSource = Get.find();
  TasksRepositoryImpl();

  List<WorkshopTask> _allTasks = [];

  @override
  List<WorkshopTask> get allTasks => _allTasks;

  @override
  Future<void> refreshAllTasks() async {
    final result = await tasksRemoteDataSource.getAllTasks();
    _allTasks = result;
  }

  @override
  Future<Either<Failure, List<WorkshopTask>>> getUsersActiveTasks() async {
    return await performOperation(() async {
      final userID = await coreRemoteDataSource.getCurrentUserID();
      List<WorkshopTask> usersTasks = getIncompleteTasksForUser(userID);
      List<WorkshopTask> tasksShown = getActiveTasksForUser(usersTasks);
      tasksShown.sort((a, b) => a.taskId.compareTo(b.taskId));
      return tasksShown;
    });
  }

  List<WorkshopTask> getIncompleteTasksForUser(String userID) {
    List<WorkshopTask> incompleteTasks =
        allTasks.where((element) => element.realizedEndDate == null).toList();
    List<WorkshopTask> usersTasks = incompleteTasks;
    if (FirebaseAuth.instance.currentUser?.email != 'super@vecicky.cz') {
      usersTasks = incompleteTasks
          .where((element) => element.workerID == userID)
          .toList();
    }
    return usersTasks;
  }

  List<WorkshopTask> getActiveTasksForUser(List<WorkshopTask> usersTasks) {
    return usersTasks
        .where(
            (element) => element.isActive == true && element.workerID != null)
        .toList();
  }

  @override
  Future<Either<Failure, void>> finishTask(WorkshopTask task) async {
    return await performOperation(() async {
      task.realizedEndDate = DateTime.now();
      task.isActive = false;
      await tasksRemoteDataSource.updateTask(task);
      final followingTask = getFollowingTask(task);
      if (followingTask != null) {
        followingTask.isActive = true;
        await tasksRemoteDataSource.updateTask(followingTask);
      }
      await refreshAllTasks();
    });
  }

  @override
  Future<Either<Failure, void>> setTaskToStarted(WorkshopTask task) async {
    return await performOperation(() async {
      task.startedDate = DateTime.now();
      await tasksRemoteDataSource.updateTask(task);
    });
  }

  Future<Either<Failure, T>> performOperation<T>(
      Future<T> Function() operation) async {
    try {
      return Right(await operation());
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkshopTask>>> getAllActiveTasks() async {
    return await performOperation(() async {
      return allTasks
          .where(
              (element) => element.isActive == true && element.workerID != null)
          .toList();
    });
  }

  @override
  WorkshopTask? getFollowingTask(WorkshopTask task) {
    final nextId = task.nextId?.first;
    if (nextId == null) {
      return null;
    }
    final result = allTasks.firstWhere((element) => element.id == nextId!);
    return result;
  }

  @override
  WorkshopTask? getPreviousTask(WorkshopTask task) {
    return allTasks
        .firstWhere((element) => element.nextId?.contains(task.id) ?? false);
  }

  @override
  Future<Either<Failure, List<WorkshopWorker>>> getWorkers() async {
    try {
      final result = await tasksRemoteDataSource.getWorkers();
      return Right(result);
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }

  @override
  void updateTask(WorkshopTask task) {
    tasksRemoteDataSource.updateTask(task);
  }
}
