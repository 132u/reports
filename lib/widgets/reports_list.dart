import 'package:chat_app/screens/avance.dart';
import 'package:chat_app/screens/new_report.dart';
import 'package:chat_app/widgets/navigationDrawer.dart';
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewReportScreen()));
    // showModalBottomSheet(
    //   context: context,
    //   builder: (ctx)=>const NewReportScreen());
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        actions: [
          //IconButton(onPressed: _addReport, icon: const Icon(Icons.add)),
          PopupMenuButton(
              //  onPressed:_addReport(),
              onSelected: (value) {
                if (value == 'Отчет') {
                  //_addReport;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const NewReportScreen()));
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => NewAvanceScreen()));
                }
              },
              itemBuilder: (context) => const [
                    PopupMenuItem(
                      child: Text('Отчет'),
                      value: 'Отчет',
                    ),
                    PopupMenuItem(
                        child: Text('Аванс/Сдал'), value: 'Аванс/сдал'),
                  ]),

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
                  leading: Text(DateFormat('dd-MM-yyyy')
                      .format(Report.fromMap(report).createdAt)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            ReportScreen(Report.fromMap(report))));
                  },
                  trailing: Text(
                      "${Report.fromMap(report).endPrice} ₽ ${Report.fromMap(report).isMoneyWithMe ? " у меня" : "у Виктора"}"),
                );
              });
        },
      ),
    );
  }
}
