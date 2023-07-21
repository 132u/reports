import 'package:flutter/material.dart';

import '../models/payment_type.dart';
import '../models/report.dart';


class ReportScreen extends StatelessWidget{
  const ReportScreen(this.report);

  final Report report;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отчет ${report.name}'),
      ),
      body: ListView(
        children: [
          Text(report.name),
          Text("Заказчик ${report.customer}"),
          Text("Цена ${report.price}₽ ${
            report.paymentType == PaymentType.cash.toString().split('.')[1] ? " наличными": " с НДС"}"),
          
        ],
      ),
    );
  }
}