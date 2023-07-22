import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/payment_type.dart';
import '../models/report.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen(this.report);
  String paymentType() {
    if (report.paymentType == PaymentType.cash.toString().split('.')[1]) {
      return " наличными ${report.isMoneyWithMe ? " у меня" : " у Виктора"}";
    }
    if (report.paymentType == PaymentType.withVAT.toString().split('.')[1]) {
      return " с НДС у Виктора";
    }
    return " без НДС у Виктора";
  }

  final Report report;
  Widget _aboutPrice() {
    if (report.isByHours) {
      return Text(
        'Тип заказа: почасовка.\nЦена за час: ${report.hourPrice}₽, количество часов: ${report.hourQuantity?.toInt()}.\n\nОбщая сумма ${report.initialPrice}₽ ${paymentType()}.\nИтоговая суммма ${report.endPrice}₽',
      );
    }
    return Text(
        '\nОбщая сумма: ${report.initialPrice}₽ ${paymentType()}.\nИтоговая суммма: ${report.endPrice}₽');
  }

  Widget _aboutAddress() {
    if (report.onPlace) {
      return Text('Заказ был на месте, по адресу ${report.startAddress}');
    }
    return Text(
        'Погрузка была по адресу: ${report.startAddress}, выгрузка была по адресу: ${report.endAddress}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отчет ${report.name}'),
      ),
      body: ListView(
        children: [
          Text("Дата создания отчета: ${DateFormat('dd-MM-yyyy').format(report.createdAt)}"),
          Text("Дата выполнения заказа: ${DateFormat('dd-MM-yyyy').format(report.startDateTime)}"),
          Text("Коротко о заказе: ${report.name}"),
          Text("Заказчик: ${report.customer}"),
          _aboutPrice(),
        ],
      ),
    );
  }
}
