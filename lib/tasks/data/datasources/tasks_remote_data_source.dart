
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/domain/entities/workshop_worker.dart';

abstract class TasksRemoteDataSource {
  Future<List<WorkshopTask>> getAllTasks();
  Future<List<WorkshopWorker>> getWorkers();
  Future<void> updateTask(WorkshopTask task);
  // Future<Either<Failure, Task>> createTask(Task task);
  // Future<Either<Failure, Task>> updateTask(Task task);
  // Future<Either<Failure, Task>> deleteTask(String id);
}
