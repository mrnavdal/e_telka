import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkshopWorker extends Equatable {
  final String id;
  final String name;
  final String email;

  const WorkshopWorker({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];

  factory WorkshopWorker.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    var data = snapshot.data()!;
    return WorkshopWorker(
      id: data['id'],
      name: data['name'],
      email: data['email'],
    );
  }
}
