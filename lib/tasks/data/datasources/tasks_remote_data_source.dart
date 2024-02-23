
import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/domain/entities/vecicky_worker.dart';

abstract class TasksRemoteDataSource {
  Future<List<Task>> getAllTasks();
  Future<List<VecickyWorker>> getWorkers();
  Future<void> updateTask(Task task);
  // Future<Either<Failure, Task>> createTask(Task task);
  // Future<Either<Failure, Task>> updateTask(Task task);
  // Future<Either<Failure, Task>> deleteTask(String id);
}
