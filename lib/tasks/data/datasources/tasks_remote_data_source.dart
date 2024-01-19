
import 'package:e_telka/tasks/domain/entities/task.dart';

abstract class TasksRemoteDataSource {
  Future<List<Task>> getAllTasks();
  Future<void> updateTask(Task task);
  // Future<Either<Failure, Task>> createTask(Task task);
  // Future<Either<Failure, Task>> updateTask(Task task);
  // Future<Either<Failure, Task>> deleteTask(String id);
}
