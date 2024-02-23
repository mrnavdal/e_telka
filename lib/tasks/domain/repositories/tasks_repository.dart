import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/domain/entities/vecicky_worker.dart';

abstract class TasksRepository {
  List<Task> get allTasks;
  Future<List<Task>> getUsersActiveTasks();
  Future<List<Task>> getAllActiveTasks();
  Future<void> finishTask(Task task);
  Future<void> setTaskToStarted(Task task);
  Task? getPreviousTask(Task task);
  Task? getFollowingTask(Task task);

  void updateTask(Task task);

  Future<List<VecickyWorker>> getWorkers();


  // Future<Either<Failure, Task>> getTask(String id);
  // Future<Either<Failure, Task>> createTask(Task task);
  // Future<Either<Failure, Task>> updateTask(Task task);
  // Future<Either<Failure, Task>> deleteTask(String id);
}
