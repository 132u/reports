import 'dart:async';

import 'package:chat_app/models/avance.dart';
import 'package:chat_app/models/avanceType.dart';
import 'package:chat_app/screens/AvancesScreen.dart';
import 'package:chat_app/screens/reports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../database_service.dart';

class NewAvanceScreen extends StatefulWidget {
  @override
  State<NewAvanceScreen> createState() {
    return NewAvanceScreenState();
  }
}

List<String> avanceTypes = ["Аванс", "Сдал"];

class NewAvanceScreenState extends State<NewAvanceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredAmount;
  bool _isAvance = false;
  DatabaseService service = DatabaseService();
  
  _addAvance() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    var now = DateTime.now();
    var avance = Avance(_isAvance ? "Аванс":"Сдал", _enteredAmount, now, user.uid.toString());
    service.addAvance(avance);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AvancesScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить аванс/сдал'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: Expanded(
                child: Column(children: [
                  DropdownButtonFormField(
                      items: avanceTypes
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == avanceTypes[0]) {
                          setState(() {
                            _isAvance = true;
                          });
                        }
                      }),
                  TextFormField(
                    onSaved: (value) {
                      _enteredAmount = double.tryParse(value!);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Сумма'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Заполните пожалуйста поле Сумма :)';
                      }
                      return null;
                    },
                  ),
                   Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Очистить форму')),
                      ElevatedButton(
                          onPressed: _addAvance,
                          child: const Text('Добавить аванс/сдал')),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
