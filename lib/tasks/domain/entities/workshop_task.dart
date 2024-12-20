import 'package:e_telka/core/util/date_util.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopTask extends Equatable {
  final String id;
  final num creditPriceTotalAmount;
  final num creditsUnit;
  bool isActive;
  final String operation;
  final num operationOrderNumber;
  final num pieces;
  final List<dynamic>? nextId;

  final String spreadsheetSource;
  final num taskId;
  final String? workerID;

  DateTime? plannedEndDate;
  DateTime? startedDate;
  DateTime? realizedEndDate;

  final String productId;
  final String productMaterialCategory;
  final String productMaterialGroupCategory;
  final String productName;


  WorkshopTask({
    required this.creditPriceTotalAmount,
    required this.creditsUnit,
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
    required this.productId,
    required this.productMaterialCategory,
    required this.productMaterialGroupCategory,
    required this.productName,
  });

  // format planned end date to a human readable format using the DateUtil class

  String get formattedPlannedEndDate => DateUtil.getFormattedDate(plannedEndDate!);
  String get formattedPieces => pieces.toStringAsFixed(0);
  String get formattedCreditsTotal =>
      creditPriceTotalAmount.toStringAsFixed(0);
  String get formattedCreditsUnit =>
      creditsUnit.toStringAsFixed(1);

  @override
  List<Object?> get props => [
        creditPriceTotalAmount,
        creditsUnit,
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

      ];

  factory WorkshopTask.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    var data = snapshot.data()!;
    return WorkshopTask(
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
      creditPriceTotalAmount: data['credit_price_total_amount'],
      creditsUnit: data['credits_unit'] ?? 0.0,
      isActive: data['is_active'],
      productId: data['PRODUCT__id'] ?? "",
      productMaterialCategory: data['PRODUCT__material_category'] ?? "",
      productMaterialGroupCategory: data['PRODUCT__material_group_category'] ?? "",
      productName: data['PRODUCT__name'] ?? "",
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
      'credit_price_total_amount': creditPriceTotalAmount,
      'credits_unit': creditsUnit,
      'is_active': isActive,
      'PRODUCT__id': productId,
      'PRODUCT__material_category': productMaterialCategory,
      'PRODUCT__material_group_category': productMaterialGroupCategory,
      'PRODUCT__name': productName,
    };
  }
}
