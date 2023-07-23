import 'package:chat_app/models/avance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/report.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  addReport(Report reportData) async {
    await _db.collection("reports").add(reportData.toMap());
  }

  getDrivers() async {
    await _db.collection("drivers").get().then(
      (querySnapshot) {
        return querySnapshot.docs;
        // print("Successfully completed");
        // for (var docSnapshot in querySnapshot.docs) {
        //   print('${docSnapshot.id} => ${docSnapshot.data()}');
        // }
      },
      //onError: (e) => print("Error completing: $e"),
    );
  }

  addAvance(Avance avance) async {
    await _db.collection("avances").add(avance.toMap());
  }

  getAvanceList() async {
    await _db.collection("avances").get().then(
      (querySnapshot) {
        return querySnapshot.docs;
      },
    );
  }
}
