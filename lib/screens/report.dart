import 'package:flutter/material.dart';


class ReportScreen extends StatelessWidget{
  const ReportScreen(this.name);

  //final Report report;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Column(
        children: [
          Text(name),
        ],
      ),
    );
  }
}