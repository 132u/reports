import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/report.dart';

class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  addReport(Report reportData) async {
    await _db.collection("reports").add(reportData.toMap());
  }

}