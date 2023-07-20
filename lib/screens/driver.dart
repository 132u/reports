import 'package:chat_app/screens/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DriverScreen extends StatelessWidget{
  const DriverScreen(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver'),
      ),
      body: Column(
        children: [
          Text(name),
          Text('Отчеты:'),
          //foreach loop in reports table searching by driverid
          InkWell(
            child: ReportScreen(name),
          )
        ],
      ),
    );
    
  }
}