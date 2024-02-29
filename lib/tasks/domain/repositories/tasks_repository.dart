import 'package:dartz/dartz.dart';
import 'package:e_telka/core/error/failure.dart';
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/domain/entities/workshop_worker.dart';

abstract class TasksRepository {
  List<WorkshopTask> get allTasks;

  Future<Either<Failure, List<WorkshopTask>>> getUsersActiveTasks();

  Future<Either<Failure, List<WorkshopTask>>> getAllActiveTasks();

  Future<Either<Failure, void>> finishTask(WorkshopTask task);

  Future<Either<Failure, void>> setTaskToStarted(WorkshopTask task);

  WorkshopTask? getPreviousTask(WorkshopTask task);

  WorkshopTask? getFollowingTask(WorkshopTask task);

  void updateTask(WorkshopTask task);

  Future<Either<Failure, List<WorkshopWorker>>> getWorkers();

  // Future<Either<Failure, Task>> getTask(String id);
  //
  // Future<Either<Failure, Task>> createTask(Task task);
  //
  // Future<Either<Failure, Task>> updateTask(Task task);
  //
  // Future<Either<Failure, void>> deleteTask(String id);
}