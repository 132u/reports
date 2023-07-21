import 'package:flutter/material.dart';

import '../models/payment_type.dart';
import '../models/report.dart';


class ReportScreen extends StatelessWidget{
  const ReportScreen(this.report);
String paymentType()
{
  if(report.paymentType == PaymentType.cash.toString().split('.')[1])
  {
    return " наличными ${report.isMoneyWithMe ? " у меня": " у Виктора"}";
  }
    if(report.paymentType == PaymentType.withVAT.toString().split('.')[1])
  {
    return " с НДС у Виктора";
  }
    return " без НДС у Виктора";
}
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
          Text("Деньги ${report.price}₽ ${paymentType()}"),
          
        ],
      ),
    );
  }
}