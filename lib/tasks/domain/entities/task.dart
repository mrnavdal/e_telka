import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task extends Equatable {
  final String id;
  final String operation;
  final num operationOrderNumber;
  final num pieces;
  final List<dynamic>? nextId;

  final String spreadsheetSource;
  final String taskId;
  final String workerID;

  DateTime? plannedEndDate;
  DateTime? startedDate;
  DateTime? realizedEndDate;

  Task({
    required this.id,
    required this.operation,
    required this.operationOrderNumber,
    required this.pieces,
    required this.nextId,
    required this.plannedEndDate,
    required this.spreadsheetSource,
    required this.taskId,
    required this.workerID,
    this.startedDate,
    this.realizedEndDate,
  });

  @override
  List<Object?> get props => [
        id,
        operation,
        operationOrderNumber,
        pieces,
        plannedEndDate,
        spreadsheetSource,
        taskId,
        workerID,
        startedDate,
        realizedEndDate,
      ];

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    var data = snapshot.data()!;
    return Task(
      id: data['id'],
      operation: data['operation'],
      operationOrderNumber: data['operation_order_number'] as num,
      pieces: data['pieces'] as num,
      nextId: data['next_id'],
      spreadsheetSource: data['spreadsheet_source'],
      taskId: data['task_id'],
      workerID: data['worker_id'],
      startedDate: DateTime.tryParse(data['started_date'] ?? ""),
      plannedEndDate: DateTime.tryParse(data['planned_end_date'] ?? ''),
      realizedEndDate: DateTime.tryParse(data['realized_end_date'] ?? ''),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'operation': operation,
      'operation_order_number': operationOrderNumber,
      'pieces': pieces,
      'planned_end_date': plannedEndDate.toString(),
      'spreadsheet_source': spreadsheetSource,
      'task_id': taskId,
      'worker': workerID,
      'started_date': startedDate.toString(),
      'realized_end_date': realizedEndDate.toString(),
    };
  }
}
