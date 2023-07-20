import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriversScreen extends StatelessWidget {
  //const DriversScreen({super.key});
  final _fireStore = FirebaseFirestore.instance;
  final ref =
      FirebaseFirestore.instance.collection('drivers').snapshots();
  // Future<void> getData() async {
  //   QuerySnapshot querySnapshot =
  //       await _fireStore.collection('drivers').get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  //   // for (var dataMap in allData) {
  //   //   if (dataMap is Map) {
  //   //     // add a type check to ensure dataMap is a Map
  //   //     for (var key in dataMap.keys) {
  //   //       print('$key: ${dataMap[key]}'); //printing document fields using keys
  //   //     }
  //   //     print('----------------------');
  //   //   }
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drivers')),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final data = document.data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>DriverScreen(driver.name)));
                },
                child: ListTile(
                  title: Text(data['firstName']),
                  subtitle: Text(data['lastName']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}