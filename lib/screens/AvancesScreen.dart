import 'package:chat_app/models/avance.dart';
import 'package:chat_app/screens/avance.dart';
import 'package:chat_app/screens/new_report.dart';
import 'package:chat_app/widgets/navigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database_service.dart';
import '../widgets/base_app_bar.dart';
List<Widget> actionButtonInMAInHedaer = [

];
class AvancesScreen extends StatefulWidget {
  const AvancesScreen({super.key});

  @override
  State<AvancesScreen> createState() => _AvancesScreenState();
}

class _AvancesScreenState extends State<AvancesScreen> {
  DatabaseService service = DatabaseService();
   bool _isAdmin = false;
   List<String> adminIds = ["k9y9HZaxjmTUIlonuyxpLd4Aqod2"];
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    Stream<QuerySnapshot<Map<String, dynamic>>> _getAvancesListOfAllDrivers() {
    if(adminIds.contains(authenticatedUser.uid)){
      _isAdmin = true;
    }
    if (!_isAdmin) {
      return FirebaseFirestore.instance
          .collection('avances')
          .where('driverId', isEqualTo: authenticatedUser.uid)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection('reports').snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: const Text('Мои авансы/сдачи'),
      ),
      body: StreamBuilder(
        stream: _getAvancesListOfAllDrivers(),
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
                  title: Text("${Avance.fromMap(avance).amount.toString()} руб."),
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

