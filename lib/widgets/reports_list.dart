import 'package:chat_app/widgets/new_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database_service.dart';
import '../models/report.dart';
import '../screens/Report.dart';

class ReportsList extends StatefulWidget {
  const ReportsList({super.key});

  @override
  State<ReportsList> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  DatabaseService service = DatabaseService();
  void _addReport() {
    showModalBottomSheet(
      context: context, 
      builder: (ctx)=>const NewReport());
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _addReport, icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
        title: const Text('Мои отчеты'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('driverId', isEqualTo: authenticatedUser.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No reports here'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final loadedReports = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              itemCount: loadedReports.length,
              itemBuilder: (ctx, index) {
                final report = loadedReports[index].data();
                return ListTile(
                  title: Text(Report.fromMap(report).name),
                  subtitle: Text(Report.fromMap(report).customer),
                  leading: Text(DateFormat('dd-MM-yyyy').format(Report.fromMap(report).createdAt)),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute( builder: (ctx) => ReportScreen(Report.fromMap(report))));
                  },
                  trailing: Text("${Report.fromMap(report).endPrice} ₽ ${Report.fromMap(report).isMoneyWithMe ? " у меня" : "у Виктора"}"),
                ); 
              });
        },
      ),
    );
  }
}
