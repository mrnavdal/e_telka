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
  Future<Either<Failure, List<WorkshopTask>>> getUsersActiveTasks() async {
    try {
      final userID = await coreRemoteDataSource.getCurrentUserID();

      _allTasks = await tasksRemoteDataSource.getAllTasks();

      // determine which tasks are not completed
      List<WorkshopTask> incompleteTasks =
      allTasks.where((element) => element.realizedEndDate == null).toList();

      List<WorkshopTask> usersTasks = incompleteTasks;

      // determine which tasks are user's. If the user is a super user show all
      if (FirebaseAuth.instance.currentUser?.email != 'super@vecicky.cz') {
        usersTasks = incompleteTasks
            .where((element) => element.workerID == userID)
            .toList();
      }

      // show only those which are active
      List<WorkshopTask> tasksShown = usersTasks
          .where((element) => element.isActive == true && element.workerID != null)
          .toList();

      tasksShown.sort((a, b) => a.taskId.compareTo(b.taskId));

      return Right(tasksShown);
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> finishTask(WorkshopTask task) async {
    try {
      // sets task as finished and updates it in the database
      // also sets the following task as active
      task.realizedEndDate = DateTime.now();
      task.isActive = false;
      await tasksRemoteDataSource.updateTask(task);

      final followingTask = getFollowingTask(task);
      if (followingTask != null) {
        followingTask.isActive = true;
        await tasksRemoteDataSource.updateTask(followingTask);
      }

      return Right(null);
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setTaskToStarted(WorkshopTask task) async {
    try {
      task.startedDate = DateTime.now();
      await tasksRemoteDataSource.updateTask(task);

      return Right(null);
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }

  /// Možná implementace pro více tasků, ale zatím nechám takhle
  @override
  WorkshopTask? getPreviousTask(WorkshopTask task) {
    print(task.id);
    return allTasks.firstWhere((element) => element.nextId?.contains(task.id) ?? false);
  }

  /// Možná implementace pro více tasků, ale zatím nechám takhle
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
  void updateTask(WorkshopTask task) {
    tasksRemoteDataSource.updateTask(task);
  }

  Future<Either<Failure, List<WorkshopWorker>>> getWorkers() async {
    try {
      final result = await tasksRemoteDataSource.getWorkers();
      return Right(result);
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }
  @override
  Future<Either<Failure,List<WorkshopTask>>> getAllActiveTasks() async {
    try {
      return Right(await allTasks
          .where(
              (element) => element.isActive == true && element.workerID != null)
          .toList());
    } on Exception catch (failure) {
      return Left(ServerFailure(failure.toString()));
    }
  }


}
