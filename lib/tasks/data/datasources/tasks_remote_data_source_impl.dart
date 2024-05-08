import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_telka/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/domain/entities/workshop_worker.dart';

class TasksRemoteDataSourceImpl extends TasksRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  TasksRemoteDataSourceImpl();
  @override
  Future<List<WorkshopTask>> getAllTasks() async {
    var firestore = FirebaseFirestore.instance;
    var collection = firestore.collection('tasks_import');
    var getDocuments = await collection.get();
    List<WorkshopTask> tasks = [];
    for (var doc in getDocuments.docs) {
      var task = WorkshopTask.fromFirestore(doc, null);
      tasks.add(task);
    }
    return tasks;
  }

  @override
  Future<void> updateTask(WorkshopTask task) async {
    await firestore
        .collection('tasks_import')
        .doc(task.id)
        .update(task.toFirestore());
  }

  @override
  Future<List<WorkshopWorker>> getWorkers() async {
    return await firestore.collection('workers').get().then((value) =>
        value.docs.map((e) => WorkshopWorker.fromFirestore(e, null)).toList());
  }
}
