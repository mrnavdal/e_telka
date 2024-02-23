import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VecickyWorker extends Equatable {
  final String id;
  final String name;
  final String email;

  VecickyWorker({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];

  factory VecickyWorker.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    var data = snapshot.data()!;
    return VecickyWorker(
      id: data['id'],
      name: data['name'],
      email: data['email'],
    );
  }
}
