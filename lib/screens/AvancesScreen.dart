import 'package:chat_app/models/avance.dart';
import 'package:chat_app/screens/avance.dart';
import 'package:chat_app/screens/new_report.dart';
import 'package:chat_app/widgets/navigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database_service.dart';

class AvancesScreen extends StatefulWidget {
  const AvancesScreen({super.key});

  @override
  State<AvancesScreen> createState() => _AvancesScreenState();
}

class _AvancesScreenState extends State<AvancesScreen> {
  DatabaseService service = DatabaseService();
  
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 'Отчет') {
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
        title: const Text('Мои авансы/сдачи'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('avances')
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
              child: Text('Нет авансов/сдач'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Упс. Что-то пошло не так'),
            );
          }
          final loadedAvances = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              itemCount: loadedAvances.length,
              itemBuilder: (ctx, index) {
                final avance = loadedAvances[index].data();
                return ListTile(
                  title: Text("${Avance.fromMap(avance).amount.toString()}₽"),
                  //subtitle: Text(Avance.fromMap(avance).customer),
                  leading: Text(DateFormat('dd-MM-yyyy')
                      .format(Avance.fromMap(avance).createdAt)),
                  // onTap: () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (ctx) =>
                  //           ReportScreen(Report.fromMap(avance))));
                  // },
                  trailing: Text(
                      "${Avance.fromMap(avance).type}"),
                );
              });
        },
      ),
    );
  }
}

