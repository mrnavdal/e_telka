//implement the CoreDataSource
//
import 'package:e_telka/core/data/data_sources/core_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoreRemoteDataSourceImpl implements CoreRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> getCurrentUserID() async {
    var currentUserEmail = _firebaseAuth.currentUser!.email;
    var firestoreWorkers = await FirebaseFirestore.instance
        .collection('workers')
        .where('email', isEqualTo: currentUserEmail)
        .get();

    final firestoreWorkersList =
        firestoreWorkers.docs.map((e) => e.data()).toList();
    try {
      var currentUserID = firestoreWorkersList[0]['id'];
      return currentUserID;
    } catch (e) {
      return 'error';
    }
  }
}
