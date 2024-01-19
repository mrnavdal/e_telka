import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_telka/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:e_telka/tasks/domain/entities/task.dart';

class TasksRemoteDataSourceImpl extends TasksRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  TasksRemoteDataSourceImpl();
  @override
  Future<List<Task>> getAllTasks() async {
    return await firestore
        .collection('tasks_import')
        .get()
        .then((value) => value.docs
            .map((e) => Task.fromFirestore(e, null))
            .toList());
  }

@override
  Future<void> updateTask(Task task) async {
    await firestore
        .collection('tasks_import')
        .doc(task.id)
        .update(task.toFirestore());
  }
}
