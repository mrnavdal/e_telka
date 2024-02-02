import 'package:e_telka/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Future<List<Task>> getUsersActiveTasks();
  Future<void> setTaskToDone(Task task);
  Future<void> setTaskToStarted(Task task);
  Task getPreviousTask(Task task);
  Task getFollowingTask(Task task);


  // Future<Either<Failure, Task>> getTask(String id);
  // Future<Either<Failure, Task>> createTask(Task task);
  // Future<Either<Failure, Task>> updateTask(Task task);
  // Future<Either<Failure, Task>> deleteTask(String id);
}
