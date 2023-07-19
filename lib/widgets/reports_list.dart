import 'package:chat_app/widgets/message_bubble.dart';
import 'package:chat_app/widgets/new_report.dart';
import 'package:chat_app/widgets/report_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import '../models/report.dart';

class ReportsList extends StatefulWidget {
  const ReportsList({super.key});

  @override
  State<ReportsList> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  DatabaseService service = DatabaseService();
  void _addReport() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const NewReport(),
    ));
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
        title: const Text('Your Reports.'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('driverId', isEqualTo: authenticatedUser.uid)
            //.orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: const Text('No reports here'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: const Text('Something went wrong'),
            );
          }
          final loadedReports = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              reverse: true,
              itemCount: loadedReports.length,
              itemBuilder: (ctx, index) {
                final report = loadedReports[index].data();
                return ReportItem(Report.fromMap(report));
              });
        },
      ),
    );
  }
}
