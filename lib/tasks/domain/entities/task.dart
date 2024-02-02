import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task extends Equatable {
  final String id;
  final int credit_price_total_amount;
  bool isActive;
  bool isVisible;
  final String operation;
  final num operationOrderNumber;
  final num pieces;
  final List<dynamic> nextId;

  final String spreadsheetSource;
  final String taskId;
  final String workerID;

  DateTime? plannedEndDate;
  DateTime? startedDate;
  DateTime? realizedEndDate;

  Task({
    required this.credit_price_total_amount,
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
    required this.isActive,
    required this.isVisible,
  });

  @override
  List<Object?> get props => [
    credit_price_total_amount,
    id,
    operation,
    operationOrderNumber,
    pieces,
    nextId,
    plannedEndDate,
    spreadsheetSource,
    taskId,
    workerID,
    startedDate,
    realizedEndDate,
    isActive,
    isVisible,
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
      credit_price_total_amount: data['credit_price_total_amount'],
      isActive: data['is_active'],
      isVisible: data['is_visible'],
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
      'credit_price_total_amount': credit_price_total_amount,
      'is_active': isActive,
      'is_visible': isVisible,
    };
  }
}
